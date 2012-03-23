package gui.core.context
{
	import gui.events.GuiEvent;
	import gui.core.objects.GuiEventDispatcher;
	import gui.core.managers.GestureManager;
	import gui.errors.GuiArgumentError;
	import gui.core.objects.GuiObjectContainer;
	
	[Event(name="guiContextUpdated", type="gui.events.GuiEvent")]
	
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class GuiContext extends GuiEventDispatcher
	{
		use namespace nsGuiInternal;
		
		private var _root:GuiObjectContainer;
		
		private var _gestures:GestureManager;
		
		
		/** Returns the root container **/
		public function get root():GuiObjectContainer
		{
			return _root;
		}
		
		/**
		* Creates a new context to add ui objects into.
		*/
		public function GuiContext($root:*)
		{
			super(this);
			
			// create / ref root container.
			if( $root is Class )
				_root = new $root();
			else if( $root is GuiObjectContainer )
				_root = $root;
			else
				throw new GuiArgumentError( "Root cannot be null." );
				
			// managers
			_gestures = new GestureManager(this);
			// invalidation manager
			// measurement manager
			
			// set the context which will cause addedToContext events to be dispatched
			_root.setContext(this);
		}
		
		/** Updates the context each frame **/
		public function update():void
		{
			_gestures.update();
			
			// invalidation.
			
			// dispatch update event.
			// dispatchEvent( new GuiEvent(GuiEvent.CONTEXT_UPDATED, null) );
		}
		
		public function dispose():void
		{
			_gestures.dispose();
		}
		
		nsGuiInternal function inputDown($x : Number, $y : Number):void
		{
			_gestures.inputDown($x, $y);
		}
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		nsGuiInternal function inputUp($x : Number, $y : Number):void
		{
			_gestures.inputUp($x, $y);	
		}
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		nsGuiInternal function inputMove($x : Number, $y : Number) : void
		{
			_gestures.inputMove($x,$y);
		}

		
		
	}
}