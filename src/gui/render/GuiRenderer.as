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
			
			_stats		 = new RendererStats();
			_skinFactory = $skinFactory == null ? new SkinFactory() : new $skinFactory();
			
			_context 	  = $context;
			_context.addEventListener(GuiRenderEvent.RENDER, onRender );
		}
		
		/**
		 * Subclasses should override this method.
		 * 
		 * @param $queue The GuiRenderRequest items to be rendered. 
		 */
		protected function render( $queue:Vector.<GuiRenderRequest> ):void
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
		
		/**
		 * Disposes of the Renderer.
		 */
		public function dispose():void
		{
			_skinFactory.disposeAllCache();
			_skinFactory = null;
			_context = null;
			_stats = null;
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
	// number of items already on screen.
	public var existing:uint;
	// new items that weren't on screen before
	public var attached:uint;
	// items that have now been removed
	public var released:uint;
	// the number of containers 
	public var numContainers:uint;
	
	public function reset():void
	{
		total = existing = attached = released = numContainers = 0;
	}
}