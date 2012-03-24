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
		private var _acceleration:Vector3D;
		
		// _start of interaction ( mouse/touch down )
		private var _start:Vector3D;
		private var _offset:Vector3D; 
		
		private var _processes:Vector.<SwipePhysicsProcess>;
		
		public function SwipePhysicsProcessor()
		{
			_delegates = new Vector.<ISwipePhysics>();
			_processes = new Vector.<SwipePhysicsProcess>();
			
			_velocity 		= new Vector3D();
			_acceleration 	= new Vector3D();
			_start			= new Vector3D();
			_offset			= new Vector3D();
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
					// we may already have a swipe process running froma previous interaction
					process = findProcessFor(obj as ISwipePhysics);
					if( process == null ) 
					{
						process = new SwipePhysicsProcess(obj as ISwipePhysics);
						_processes.push(process);						
					}
					
					process.inputDown();
				}
			}
			
			_start.setTo($x,$y,0);
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
				process.inputUp();
			}
		}

		public function inputMove($x : Number, $y : Number) : void
		{
			_offset.setTo($x-_start.x, $y-_start.y, 0);
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
	
	public function SwipePhysicsProcess( $delegate:ISwipePhysics)
	{
		delegate 	= $delegate;
		_start 		= new Vector3D();
	}
	
	public function inputDown():void
	{
		idle = false;
		_start.x = delegate.gesture_swipePhysics_x;
		_start.y = delegate.gesture_swipePhysics_y;
	}
	
	public function inputUp():void
	{
		idle = true;
	}
	
	public function update($offset:Vector3D):void
	{
		if( idle )
		{
			
		}else
		{
			// add offset.
			delegate.gesture_swipePhysics_x = _start.x + $offset.x;
			delegate.gesture_swipePhysics_y = _start.y + $offset.y;
		}
	}
	
	public function dispose():void
	{
		delegate 	= null;
		_start 		= null;
	}
}
