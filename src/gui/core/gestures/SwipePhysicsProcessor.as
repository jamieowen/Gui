package gui.core.gestures
{
	import flash.geom.Rectangle;
	import gui.core.objects.GuiObject;
	import flash.geom.Vector3D;
	import gui.gestures.ISwipePhysics;
	import gui.core.gestures.IGestureProcessor;
	import gui.core.gestures.IGestureDelegate;

	/**
	 * 
	 * The SwipePhysicsProcessor manages mobile/iOS style swipe physics. 
	 * 
	 * This includes the swipe/throw style physics on the x and y axis.
	 * It also provides smooth snapping to constraints when a swipe area ( like a scrolling menu ) reaches it's min and max limits.
	 * 
	 * Event methods are also triggered when the constraints are "overshot". 
	 * This is to allow a delegate to implement a "pull to refresh" style list menu.
	 * 
	 * @author jamieowen
	 */
	public class SwipePhysicsProcessor implements IGestureProcessor
	{
		private var _delegates:Vector.<ISwipePhysics>;
		
		// mouse/touch properties
		private var _velocity:Vector3D;
		
		// position at _start of interaction ( mouse/touch down )
		private var _down:Vector3D;
		// offset from down position
		private var _offset:Vector3D;
		// position
		private var _position:Vector3D;
		
		
		private var _processes:Vector.<SwipePhysicsProcess>;
		
		public function SwipePhysicsProcessor()
		{
			_delegates = new Vector.<ISwipePhysics>();
			_processes = new Vector.<SwipePhysicsProcess>();
			
			_velocity 		= new Vector3D();
			_down			= new Vector3D();
			_offset			= new Vector3D();
			_position		= new Vector3D();
		}
		
		public function delegateAdded($delegate : IGestureDelegate) : void
		{
			if( $delegate is ISwipePhysics )
			{
				_delegates.push( $delegate );
			}
		}

		public function delegateRemoved($delegate : IGestureDelegate) : void
		{
			if( $delegate is ISwipePhysics )
			{
				var idx:int = _delegates.indexOf($delegate);
				if( idx != -1 )
					_delegates.splice(idx,1);
					
				// remove from processes.
				removeProcessFor($delegate as ISwipePhysics);
			}
		}
		
		private function removeProcessFor( $delegate:ISwipePhysics ):void
		{
			var process:SwipePhysicsProcess = findProcessFor($delegate as ISwipePhysics);
			
			if( process ){
				process.dispose();
				_processes.splice(_processes.indexOf(process),1);
			}
		}
		
		private function findProcessFor( $delegate:ISwipePhysics ):SwipePhysicsProcess
		{
			var l:int = _processes.length;
			var process:SwipePhysicsProcess;
			for( var i:int = 0; i<l; i++ ){
				process = _processes[i];
				if( process.delegate == $delegate ){
					i = l;
				}else
					process = null;
			}
			return process;
		}

		public function update() : void
		{
			var process:SwipePhysicsProcess;
			var l:uint = _processes.length;
			for( var i:uint = 0; i<l; i++ )
			{
				process = _processes[i];
				process.update(_offset);
			}
		}
		
		/** Creates any new processes and sets the input/tpuch start position **/ 
		public function inputDown($x : Number, $y : Number) : void
		{
			// get delegates containing input position
			var process:SwipePhysicsProcess;
			for( var i:uint = 0; i<_delegates.length; i++ )
			{
				var obj:GuiObject = _delegates[i] as GuiObject;
				var rect:Rectangle = obj.getGlobalBounds();
				
				if( rect.contains($x, $y) )
				{
					// we may already have a swipe process running from a previous interaction
					process = findProcessFor(obj as ISwipePhysics);
					if( process == null ) 
					{
						process = new SwipePhysicsProcess(obj as ISwipePhysics);
						_processes.push(process);
					}
					
					process.inputDown();
				}
			}
			_offset.setTo(0, 0, 0);
			_down.setTo($x,$y,0);
		}
		
		/** Set all processes to idle. The update() method will carry on calculating positions and dispose of when not moving. **/
		public function inputUp($x : Number, $y : Number) : void
		{
			// set all processes to idle. - the update() method will continue
			var process:SwipePhysicsProcess;
			var l:uint = _processes.length;
			for( var i:int = 0; i<l; i++ )
			{
				process = _processes[i];
				// pass input velocity to process
				process.inputUp(_velocity);
			}
		}

		public function inputMove($x : Number, $y : Number) : void
		{
			_offset.setTo($x-_down.x, $y-_down.y, 0);
			
			// mouse velocity
			_velocity.x = $x-_position.x;
			_velocity.y = $y-_position.y;
			
			_position.setTo( $x, $y, 0);
			//trace( "vel : " + _velocity );
		}

		public function dispose() : void
		{
			
		}
	}
}
import flash.geom.Vector3D;
import gui.gestures.ISwipePhysics;

internal class SwipePhysicsProcess
{
	/** If interact is true the object is dragged, if false the object has the velocity&damping applied to it. **/
	public var interact:Boolean;
	public var delegate:ISwipePhysics;
	
	/** indicates that this should be disposed of. ( interaction and physics have stopped ) **/
	public var disposable:Boolean;
	
	// store start position of delegate
	private var _start:Vector3D;
	
	// physics
	private var _position:Vector3D;
	private var _velocity:Vector3D;
	
	// flags for if we have triggered overshoot event
	private var _overshotX:Boolean;
	private var _overshotY:Boolean;

	
	public function SwipePhysicsProcess( $delegate:ISwipePhysics)
	{
		delegate 	= $delegate;
		
		_start 		= new Vector3D();
		_position	= new Vector3D();
		_velocity	= new Vector3D();
		
		_overshotX	= false;
		_overshotY	= false;
	}
	
	public function inputDown():void
	{
		interact = true;
		
		_start.x = delegate.gesture_swipePhysics_x;
		_start.y = delegate.gesture_swipePhysics_y;
	}
	
	/** Apply velocity when interaction up **/
	public function inputUp($mouseVel:Vector3D):void
	{
		interact = false;
		_velocity.setTo( $mouseVel.x,$mouseVel.y,0);
		
		// reset overshoot flasgs - to retrigger overshoot events on delegates
		_overshotX = false;
		_overshotY = false;
		
		_position.x = delegate.gesture_swipePhysics_x;
		_position.y = delegate.gesture_swipePhysics_y;
	}
	
	public function update($offset:Vector3D):void
	{
		var easing:Number = delegate.gesture_swipePhysics_easing;
		
		if( interact )
		{
			var maxpull:Number = delegate.gesture_swipePhysics_maxpull;
			var normalized:Number;
			// offset whist dragging
			_position.x = _start.x + $offset.x;
			_position.y = _start.y + $offset.y;
			
			var overshoot:Number;	
			// check we are passed constraint and if we are, apply damping to affect how much the user can drag past the constraint point.
			if( delegate.gesture_swipePhysics_constrainX )
			{
				if( _position.x < delegate.gesture_swipePhysics_minX )
				{
					if( !_overshotX ){
						_overshotX = true;
						delegate.gesture_swipePhysics_onMinXOvershoot();
					}
					overshoot 	= Math.abs(delegate.gesture_swipePhysics_minX-_position.x);
					normalized 	= Math.min(overshoot/maxpull,1);
					_position.x = delegate.gesture_swipePhysics_minX - (overshoot*(normalized*easing));
				}else
				if( _position.x > delegate.gesture_swipePhysics_maxX )
				{
					if( !_overshotX ){
						_overshotX = true;
						delegate.gesture_swipePhysics_onMaxXOvershoot();
					}
					overshoot 	= Math.abs(delegate.gesture_swipePhysics_maxX-_position.x);
					normalized 	= Math.min(overshoot/maxpull,1);
					_position.x = delegate.gesture_swipePhysics_maxX + (overshoot*(normalized*easing));
				}else
					_overshotY = false;
			}
			if( delegate.gesture_swipePhysics_constrainY )
			{
				if( _position.y < delegate.gesture_swipePhysics_minY )
				{
					if( !_overshotY ){
						_overshotY = true;
						delegate.gesture_swipePhysics_onMinYOvershoot();
					}
					overshoot 	= Math.abs(delegate.gesture_swipePhysics_minY-_position.y);
					normalized 	= Math.min(overshoot/maxpull,1);
					_position.y = delegate.gesture_swipePhysics_minY - (overshoot*(normalized*easing));
				}else
				if( _position.y > delegate.gesture_swipePhysics_maxY )
				{
					if( !_overshotY ){
						_overshotY = true;
						delegate.gesture_swipePhysics_onMaxYOvershoot();
					}
					overshoot 	= Math.abs(delegate.gesture_swipePhysics_maxY-_position.y);
					normalized 	= Math.min(overshoot/maxpull,1);
					_position.y = delegate.gesture_swipePhysics_maxY + (overshoot*(normalized*easing));
				}else
					_overshotY = false;			
			}

			delegate.gesture_swipePhysics_x = _position.x;
			delegate.gesture_swipePhysics_y = _position.y;
		}else
		{
			var damping:Number = delegate.gesture_swipePhysics_damping;
			
			// physics whilst no interaction.
			_velocity.x*=damping;
			_velocity.y*=damping;
			
			_position.x += _velocity.x;
			_position.y += _velocity.y;
			
			// constrain
			if(delegate.gesture_swipePhysics_constrainX){
				if( _position.x < delegate.gesture_swipePhysics_minX )
					_position.x += (delegate.gesture_swipePhysics_minX-_position.x)*easing;
				else
				if( _position.x > delegate.gesture_swipePhysics_maxX )
					_position.x += (delegate.gesture_swipePhysics_maxX-_position.x)*easing;
			}
			
			if(delegate.gesture_swipePhysics_constrainY){
				if( _position.y < delegate.gesture_swipePhysics_minY )
					_position.y += (delegate.gesture_swipePhysics_minY-_position.y)*easing;
				else
				if( _position.y > delegate.gesture_swipePhysics_maxY )
					_position.y += (delegate.gesture_swipePhysics_maxY-_position.y)*easing;
			}
			
			delegate.gesture_swipePhysics_x = _position.x;
			delegate.gesture_swipePhysics_y = _position.y;
		}
	}
	
	public function dispose():void
	{
		delegate 	= null;
		_start 		= null;
		_position	= null;
		_velocity	= null;
	}
}
