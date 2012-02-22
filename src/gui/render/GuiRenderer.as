package gui.render {
	import gui.utils.SkinFactory;
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
		// indicates to the subclass if a render event has been called.
		protected var requiresRender:Boolean = false;
		
		private var _context:GuiContext;
		
		private var _skinFactory:SkinFactory;
		
		private var _stats:RendererStats;
		
		/**
		 * Returns the current rendered <code>GuiContext</code> instance.
		 */
		public function get context():GuiContext
		{
			return _context;
		}
		
		/**
		 * Returns the <code>SkinFactory</code> instance.
		 */
		public function get skins():SkinFactory
		{
			return _skinFactory;	
		}
		
		/**
		 * Returns some common stats on the last render call.
		 */
		public function get stats():RendererStats
		{
			return _stats;
		}
		
		/**
		 * @param The <code>GuiContext</code> to listen to for render events.
		 * @param An optional custom <code>SkinFactory</code> class.
		 */
		public function GuiRenderer($context:GuiContext, $skinFactory:Class = null )
		{
			if (getQualifiedClassName(this) == "gui.render::GuiRendererBase")
				throw new AbstractClassError();
			
			_skinFactory = $skinFactory == null ? new SkinFactory() : new $skinFactory();
			
			_context 	  = $context;
			_context.addEventListener(GuiRenderEvent.RENDER, onRender );
		}
		
		/**
		 * Subclasses should override this method.
		 * 
		 * @param $queue The GuiRenderRequest items to be rendered. 
		 */
		public function render( $queue:Vector.<GuiRenderRequest> ):void
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * Listens to the supplied <code>context</code> for render events
		 * and triggers the <code>render()</code>
		 */
		protected function onRender( $event:GuiRenderEvent ):void
		{
			requiresRender = true;
			render($event.queue);
		}
	}
}

/**
 * Internal class to hold 
 */
internal class RendererStats
{
	// the total items passed to the renderer
	public var total:uint;
	// the total items already present on the screen
	public var existing:uint;
	// the total items present from the last render that have now been removed 
	public var clipped:uint;
	// the total items added that weren't present last render
	public var unclipped:uint;
	
	internal function reset():void
	{
		total = existing = clipped = unclipped = 0;
	}
}