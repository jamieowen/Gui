package gui.render {
	import gui.events.GuiEvent;
	import gui.core.context.GuiContext;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import gui.core.objects.GuiObject;
	import gui.core.objects.GuiObjectContainer;
	import gui.errors.AbstractClassError;
	import gui.errors.AbstractMethodError;
	import gui.utils.SkinFactory;

	
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
		
		private var _skinHold:Vector.<IGuiObjectSkin>;
		
		private var _guiToSkinMap:Dictionary;
		
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
			
			_context 	  		= $context;
			
			
			
			_skinHold  		= new Vector.<IGuiObjectSkin>();
			_guiToSkinMap	= new Dictionary();
		}
		
		protected function onRender( $event:GuiEvent ):void
		{
			
		}
		
		/**
		 * Generic render implementation - most renderers can use this and override the addSkin() and removeSkin() methods.
		 */
		public function render( $queue:Vector.<GuiRenderRequest> ):void
		{
			var i:uint;
			var l:uint;
			
			var req:GuiRenderRequest;
			var skin:IGuiObjectSkin;
			
			// check container
			l = numSkins;
			while( i<l )
			{			
				skin = getSkinAt(i++);
				_skinHold.push(skin);
			}
			i = 0;
			l = $queue.length;
			stats.reset();
			stats.total = l;
			while( i<l )
			{
				// generate stats/
				// the total number of skins requested. stats.total++
				// the total number of skins already existing in the container. stats.existing++
				// the total number clipped - removed from screen that were present before. stats.clipped++
				// the total number unclipped - presented for the first time. stats.unclipped++
				
				req = $queue[i++];
				if( req.gui is GuiObjectContainer )
				{
					// do nothing with containers.
					stats.numContainers++;
				}else
				{
					// check for existence first
					skin = _guiToSkinMap[ req.gui ];
					if(skin)
					{
						stats.existing++;
						skin.renderRequest(req, this);
						// remove skin from hold
						_skinHold.splice(_skinHold.indexOf(skin),1);
					}else
					{
						// not currently on screen
						stats.attached++;
						skin = skins.create( req.gui.skin );
						_guiToSkinMap[ req.gui ] = skin;
						addSkin(skin);
						
						skin.attach(req.gui, this);
						skin.renderRequest(req, this);
					}
				}
			}
			
			// remove skins left in hold - this will free for cache/reuse or actual dispose
			l = _skinHold.length;
			i = 0;
			var key:Object;
			while( i++<l )
			{
				skin = _skinHold.pop();
				
				// find skin in skin map
				for( key in _guiToSkinMap )
				{
					if( _guiToSkinMap[key] == skin )
					{
						skin.release(key as GuiObject, this);
						_guiToSkinMap[key] = null;
						delete _guiToSkinMap[key];
						break;
					}
				}
				
				removeSkin(skin);
				skins.dispose(skin);
			}
		}
		
		/**
		 * Should be override by the subclass to retrieve the current number of skins rendered in the container.
		 */
		protected function get numSkins():uint
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * Should be override by the subclass to retrieve a skin from the container at the given index.
		 */
		protected function getSkinAt($idx:uint):IGuiObjectSkin
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * Should be overriden by subclass to add a skin to the target container.
		 */
		protected function addSkin( $skin:IGuiObjectSkin ):void
		{
			throw new AbstractMethodError();
		}
		
		/**
		* Should be overriden by subclass to remove a skin from the target container.
		*/
		protected function removeSkin( $skin:IGuiObjectSkin ):void
		{
			throw new AbstractMethodError();
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
	
	public function toString():String
	{
		return "[GuiRenderer] total:" + total + " existing:" + existing + " attached:" + attached + " released:" + released + " containers:" + numContainers;
	}
}