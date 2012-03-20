package gui.core.managers
{
	import gui.core.gestures.IGesture;
	import gui.core.context.nsGuiInternal;
	import gui.core.gestures.IGestureDelegate;
	import gui.core.objects.GuiObject;
	import gui.events.GuiEvent;
	import gui.core.context.GuiContext;
	import gui.core.gestures.TapGesture;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class GestureManager
	{
		/** Gesture Delegators **/
		private var _gestures:Vector.<IGesture>;
		
		private var _context:GuiContext;
		
		/** All objects in the context implementing an IGestureDelegate interface **/
		private var _delegates:Vector;
		
		/**
		* Class Constructor Description
		*/
		public function GestureManager($context:GuiContext) 
		{
			_context = $context;
			_gestures = new Vector.<IGesture>();
			_delegates = new Vector.<IGestureDelegate>();
			
			// listen for objects added to context root
			_context.root.addEventListener(GuiEvent.ADDED_TO_CONTEXT, onContextEvent );
			_context.root.addEventListener(GuiEvent.REMOVED_FROM_CONTEXT, onContextEvent );
			
			// add default gestures.
			
			addGesture( new TapGesture() );
		}
		
		/** Adds a gesture to process gui objects **/
		public function addGesture( $gesture:IGesture ):void
		{
			if( _gestures.indexOf( $gesture ) == -1 )
				_gestures.push( $gesture );
		}
		
		/** Removes an active gesture **/
		public function removeGesture( $gesture:IGesture ):void
		{
			var idx:int = _gestures.indexOf($gesture);
			if( idx >= 0 )
				_gestures.splice(idx, 1);
		}
		
		private function addObject( $object:GuiObject ):void
		{
			if( $object is IGestureDelegate )
			{
				for( var i:int = 0; i<_gestures.length; i++ )
					_gestures[i].delegateAdded($object as IGestureDelegate);
				
			}
		}
		
		private function removeObject( $object:GuiObject ):void
		{
			if( $object is IGestureDelegate )
			{
				for( var i:int = 0; i<_gestures.length; i++ )
					_gestures[i].delegateRemoved($object as IGestureDelegate);
			}
		}
		
		// --------------
		// Input
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		nsGuiInternal function inputDown():void
		{
			for( var i:int = 0; i<_gestures.length; i++ )
				_gestures[i].inputDown();
		}
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		nsGuiInternal function inputUp():void
		{
			for( var i:int = 0; i<_gestures.length; i++ )
				_gestures[i].inputUp();			
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