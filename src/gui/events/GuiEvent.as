package gui.events
{
	import gui.core.context.nsGuiInternal;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import gui.core.objects.GuiObject;
	
	
	public class GuiEvent extends Event
	{
		use namespace nsGuiInternal;
		
		public static const ADDED_TO_CONTEXT:String 			= "guiAddedToContext";
		public static const REMOVED_FROM_CONTEXT:String 		= "guiRemovedFromContext";
		public static const ADDED:String						= "guiAdded";
		public static const REMOVED:String						= "guiRemoved";
		public static const RESIZE:String						= "guiResize";
		public static const MOVE:String							= "guiMove";
		public static const SCROLL:String						= "guiScroll";
		public static const SKIN_CHANGE:String					= "guiSkinChange";
		
		/** Notifies renderers to update **/
		public static const CONTEXT_UPDATED:String				= "guiContextUpdated";
		
		/** Buttons **/
		public static const CLICK:String						= "guiClick";
		
		public var guiObject:GuiObject;
		
		public function GuiEvent($type:String, $guiObject:GuiObject, $bubbles:Boolean = false )
		{
			super($type,$bubbles);
			
			guiObject = $guiObject;
		}
		
		override public function clone():Event
		{
			var ev:GuiEvent = new GuiEvent(type, guiObject);
			if( _target )
				ev.setBubbleTarget(_target);
			return ev;
		}
		
		/**
		 * TODO Look at custom event delegation implementation, Override target - we need to be able to set target on the GuiEventDispatcher for bubbling.
		 */
		override public function get target():Object
		{
			if( _target )
				return _target;
			else
				return super.target;
		}
		
		private var _target:Object;
		nsGuiInternal function setBubbleTarget( $target:Object ):void
		{
			if( _target == null )
				_target = $target;
		}
	}
}