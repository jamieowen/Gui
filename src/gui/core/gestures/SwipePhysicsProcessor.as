package gui.core.gestures
{
	import flash.utils.getTimer;
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
		
		// time for euler integration
		private var _elapsed:Number;
		// time for mouse/touch input.
		private var _elapsedIn:Number;
		
		
		private var _processes:Vector.<SwipePhysicsProcess>;
		
		public function SwipePhysicsProcessor()
		{
			_delegates = new Vector.<ISwipePhysics>();
			_processes = new Vector.<SwipePhysicsProcess>();
			
			_velocity 		= new Vector3D();
			_down			= new Vector3D();
			_offset			= new Vector3D();
			_position		= new Vector3D();
			
			_elapsed		= getTimer();
			_elapsedIn		= getTimer();
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
			var time:Number = getTimer();
			var elapsed:Number = (time-_elapsed)*.001;
			_elapsed = time;
			
			var process:SwipePhysicsProcess;
			var l:uint = _processes.length;
			for( var i:uint = 0; i<l; i++ )
			{
				process = _processes[i];
				process.update(elapsed,_offset);
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
			
			var time:Number = getTimer();
			var elapsed:Number = (time - _elapsedIn)/1000;
			_elapsedIn = time;
			
			// mouse velocity
			_velocity.x = ($x-_position.x)/elapsed;
			_velocity.y = ($y-_position.y)/elapsed;
			
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
	/** idle is false when the user is interacting with the delegate.  when true the physics calculations continue until the object comes to a stand still **/
	public var idle:Boolean;
	public var delegate:ISwipePhysics;
	
	// store start position
	private var _start:Vector3D;
	
	// physics
	private var _position:Vector3D;
	private var _velocity:Vector3D;
	
	public function SwipePhysicsProcess( $delegate:ISwipePhysics)
	{
		delegate 	= $delegate;
		
		_start 		= new Vector3D();
		_position	= new Vector3D();
		_velocity	= new Vector3D();
	}
	
	public function inputDown():void
	{
		idle = false;
		
		_start.x = delegate.gesture_swipePhysics_x;
		_start.y = delegate.gesture_swipePhysics_y;
	}
	
	/** Apply interation velocity when up **/
	public function inputUp($mouseVel:Vector3D):void
	{
		idle = true;
		_velocity.setTo( $mouseVel.x*10,$mouseVel.y*10,0);
		trace( "INPUT UP : " + _velocity );
	}
	
	public function update($elapsed:Number, $offset:Vector3D):void
	{
		if( idle )
		{
			var damping:Number = 1;
			// physics whilst no interaction.
			
			var vel:Vector3D = new Vector3D();
			var pos:Vector3D = new Vector3D();
			
			vel.x = $elapsed*(_velocity.x*damping);
			vel.y = $elapsed*(_velocity.y*damping);
			
			//trace( $elapsed*_velocity.y );
			_position.x = $elapsed*vel.x+delegate.gesture_swipePhysics_x;
			_position.y = $elapsed*vel.y+delegate.gesture_swipePhysics_y;
			
			delegate.gesture_swipePhysics_x = _position.x; 
			delegate.gesture_swipePhysics_y = _position.y;
			
			//trace( _position );
		}else
		{
			// just handle offsetting object whist dragging
			_position.x = _start.x + $offset.x;
			_position.y = _start.y + $offset.y;
			
			delegate.gesture_swipePhysics_x = _position.x; 
			delegate.gesture_swipePhysics_y = _position.y;
		}
	}
	
	public function dispose():void
	{
		delegate 	= null;
		_start 		= null;
	}
}
