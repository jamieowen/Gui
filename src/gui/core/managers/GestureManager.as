package gui.core.managers
{
	import gui.core.gestures.SwipePhysicsProcessor;
	import gui.core.gestures.SwipeProcessor;
	import gui.core.gestures.IGestureProcessor;
	import gui.core.context.nsGuiInternal;
	import gui.core.gestures.IGestureDelegate;
	import gui.core.objects.GuiObject;
	import gui.events.GuiEvent;
	import gui.core.context.GuiContext;
	import gui.core.gestures.TapProcessor;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class GestureManager
	{
		/** Gesture Delegators **/
		private var _gestures:Vector.<IGestureProcessor>;
		
		private var _context:GuiContext;
		
		/** All objects in the context implementing an IGestureDelegate interface **/
		private var _delegates:Vector.<IGestureDelegate>;
		
		/**
		* Class Constructor Description
		*/
		public function GestureManager($context:GuiContext) 
		{
			_context = $context;
			_gestures = new Vector.<IGestureProcessor>();
			_delegates = new Vector.<IGestureDelegate>();
			
			// listen for objects added to context root
			_context.root.addEventListener(GuiEvent.ADDED_TO_CONTEXT, onContextEvent );
			_context.root.addEventListener(GuiEvent.REMOVED_FROM_CONTEXT, onContextEvent );
			
			// TODO add and remove gesture processors as and when objects appear that use them. rather than instantiate from start.
			// add default gestures.
			addGesture( new TapProcessor() );
			addGesture( new SwipeProcessor() );
			addGesture( new SwipePhysicsProcessor() );
		}
		
		public function dispose():void
		{
			for( var i:int = 0; i<_gestures.length; i++ )
				_gestures[i].dispose();	
				
			_gestures.splice(0, uint.MAX_VALUE);
		}
		
		/** Adds a gesture to process gui objects **/
		public function addGesture( $gesture:IGestureProcessor ):void
		{
			if( _gestures.indexOf( $gesture ) == -1 )
				_gestures.push( $gesture );
		}
		
		/** Removes an active gesture **/
		public function removeGesture( $gesture:IGestureProcessor ):void
		{
			var idx:int = _gestures.indexOf($gesture);
			if( idx >= 0 )
			{
				_gestures.splice(idx, 1);
				$gesture.dispose();
			}
		}
		
		private function addObject( $object:GuiObject ):void
		{
			// TODO : needs to add existing delegates - or traverse the context
			if( $object is IGestureDelegate )
			{
				_delegates.push( $object );
				
				for( var i:int = 0; i<_gestures.length; i++ )
					_gestures[i].delegateAdded($object as IGestureDelegate);
			}
		}
		
		private function removeObject( $object:GuiObject ):void
		{
			if( $object is IGestureDelegate )
			{
				_delegates.splice( _delegates.indexOf($object), 1 );
				
				for( var i:int = 0; i<_gestures.length; i++ )
					_gestures[i].delegateRemoved($object as IGestureDelegate);
			}
		}
		
		/** Updates the Gestures each frame **/
		public function update():void
		{
			for( var i:int = 0; i<_gestures.length; i++ )
				_gestures[i].update();		
		}
		
		// --------------
		// Input
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		nsGuiInternal function inputDown($x : Number, $y : Number):void
		{
			for( var i:int = 0; i<_gestures.length; i++ )
				_gestures[i].inputDown($x,$y);
		}
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		nsGuiInternal function inputUp($x : Number, $y : Number):void
		{
			for( var i:int = 0; i<_gestures.length; i++ )
				_gestures[i].inputUp($x,$y);			
		}
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		nsGuiInternal function inputMove($x : Number, $y : Number) : void
		{
			for( var i:int = 0; i<_gestures.length; i++ )
				_gestures[i].inputMove($x,$y);
		}

		// --------------
		// Event Handlers
		
		private function onContextEvent( $event:GuiEvent ):void
		{
			if( $event.type == GuiEvent.ADDED_TO_CONTEXT )
			{
				addObject( $event.target as GuiObject ); 
			}else
			if( $event.type == GuiEvent.REMOVED_FROM_CONTEXT )
			{
				removeObject( $event.target as GuiObject );
			}
		}
		
		
	}
}