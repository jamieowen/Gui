package gui.events
{
	import flash.events.Event;
	
	import gui.render.GuiRenderRequest;
	
	public class GuiRenderEvent extends Event
	{
		public static const RENDER:String 						= "guiRender"
		
		public var queue:Vector.<GuiRenderRequest>;
		
		public function GuiRenderEvent(type:String, $queue:Vector.<GuiRenderRequest> = null)
		{
			super(type);
			
			queue = $queue;
		}
	}
}