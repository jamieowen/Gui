package gui.core.context
{
	import gui.core.objects.GuiEventDispatcher;
	import gui.core.managers.GestureManager;
	import gui.errors.ArgumentError;
	import gui.core.objects.GuiObjectContainer;
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
			// create / ref root container.
			if( $root is Class )
				_root = new $root();
			else if( $root is GuiObjectContainer )
				_root = $root;
			else
				throw new ArgumentError( "Root cannot be null." );
				
			// managers
			_gestures = new GestureManager(this);
			// invalidation manager
			// measurement manager
			
			// set the context which will cause addedToContext events to be dispatched
			_root.setContext(this);
		}

		
		
	}
}