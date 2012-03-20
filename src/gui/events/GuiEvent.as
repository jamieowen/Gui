package gui.events
{
	import flash.events.Event;
	import gui.core.objects.GuiObject;
	
	
	public class GuiEvent extends Event
	{
		public static const ADDED_TO_CONTEXT:String 			= "guiAddedToContext";
		public static const REMOVED_FROM_CONTEXT:String 		= "guiRemovedFromContext";
		public static const ADDED:String						= "guiAdded";
		public static const REMOVED:String						= "guiRemoved";
		public static const RESIZE:String						= "guiResize";
		public static const MOVE:String							= "guiMove";
		public static const SCROLL:String						= "guiScroll";
		public static const SKIN_CHANGE:String					= "guiSkinChange";
		
		public var guiObject:GuiObject;
		
		public function GuiEvent($type:String, $guiObject:GuiObject)
		{
			super($type);
			
			guiObject = $guiObject;
		}
	}
}