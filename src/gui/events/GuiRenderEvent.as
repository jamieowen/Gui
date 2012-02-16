package gui.events
{
	import flash.events.Event;
	
	import gui.render.GuiRenderRequest;
	
	public class GuiRenderEvent extends Event
	{
		public static const RENDER:String 						= "guiRender"
			
		/**
		 * Dispatched by GuiRenderer objects to indicate that the renderer can receive events from the GuiContext.
		 * This is needed to allow for any delay needed from Context3D instances with engines like Starling, Away3D, etc.
		 */
		public static const RENDERER_STARTUP_COMPLETE:String 	= "guiRendererStartupComplete";
		
		public var queue:Vector.<GuiRenderRequest>;
		
		public function GuiRenderEvent(type:String, $queue:Vector.<GuiRenderRequest> = null)
		{
			super(type);
			
			queue = $queue;
		}
	}
}