package gui.render {
	import gui.core.GuiContext;
	import gui.errors.AbstractClassError;
	import gui.errors.AbstractMethodError;
	import gui.events.GuiRenderEvent;

	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Simple base class for renderers.
	 */
	public class GuiRenderer extends EventDispatcher
	{
		protected var requiresRender:Boolean = false;
		private var _context:GuiContext;
		
		public function GuiRenderer($context:GuiContext)
		{
			if (getQualifiedClassName(this) == "gui.render::GuiRenderer")
				throw new AbstractClassError();
			
			_context 	  = $context;
			_context.addEventListener(GuiRenderEvent.RENDER, onRender );
		}
		
		public function get context():GuiContext
		{
			return _context;
		}
		
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