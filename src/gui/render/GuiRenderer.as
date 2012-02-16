package gui.render
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import gui.core.GuiContext;
	import gui.errors.AbstractClassError;
	import gui.errors.AbstractMethodError;
	import gui.events.GuiRenderEvent;
	
	
	[Event(name="guiRendererStartupComplete", type="gui.events.GuiRenderEvent")]
	/**
	 * Renders
	 */
	public class GuiRenderer extends EventDispatcher
	{
		protected var requiresRender:Boolean = false;
		
		private var _renderTarget:*;
		private var _context:GuiContext;
		
		public function GuiRenderer($context:GuiContext, $renderTarget:*)
		{
			if (getQualifiedClassName(this) == "gui.render::GuiRenderer")
				throw new AbstractClassError();
			
			_context 	  = $context;
			_renderTarget = $renderTarget;
			
			_context.addEventListener(GuiRenderEvent.RENDER, onRender );
		}
		
		public function get context():GuiContext
		{
			return _context;
		}
		
		/**
		 * Should be called by the subclass when the to incid
		 */
		protected function startupComplete():void
		{
			dispatchEvent( new GuiRenderEvent( GuiRenderEvent.RENDERER_STARTUP_COMPLETE ) );
		}
		
		/**
		 * Shold be called externally each frame.  Subclasses should implement their render method accordingly. 
		 */
		public function render( $queue:Vector.<GuiRenderRequest> ):void
		{
			throw new AbstractMethodError();
		}
		
		// handlers
		protected function onRender( $event:GuiRenderEvent ):void
		{
			requiresRender = true;
			render($event.queue);
		}
	}
}