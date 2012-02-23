package tests.gui.renderers {
	import gui.core.GuiContext;
	import gui.core.GuiObjectContainer;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.render.IGuiObjectSkin;

	import flash.utils.Dictionary;
	
	/**
	* A test renderer implementation for GuiContext/GuiRenderer tests.
	*
	* @author jamieowen
	*/
	public class GuiRendererTestImpl extends GuiRenderer
	{
		// a container to hold skins - not present them to screen.
		private var _container:Vector.<IGuiObjectSkin>;
		
		private var _skinHold:Vector.<IGuiObjectSkin>;
		
		private var _guiToSkinMap:Dictionary;
		
		
		/**
		* Class Constructor Description
		*/
		public function GuiRendererTestImpl($context:GuiContext)
		{
			super($context);
			
			_container 		= new Vector.<IGuiObjectSkin>();
			_skinHold  		= new Vector.<IGuiObjectSkin>();
			_guiToSkinMap	= new Dictionary();
		}
		
		override protected function render( $queue:Vector.<GuiRenderRequest> ):void
		{
			var i:uint;
			var l:uint;
			
			var req:GuiRenderRequest;
			var skin:IGuiObjectSkin;
			
			// check container
			l = _container.length;
			while( i<l )
			{			
				skin = _container[i++];
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
						_container.push( skin ); // TODO offload to subclass for add()... Flash.addChild() Starling.addChild(), etc
						
						skin.attach(req.gui, this);
						skin.renderRequest(req, this);
					}
				}
			}
			
			// remove skins left in hold - this will free for cache/reuse or actual dispose
			l = _skinHold.length;
			i = 0;
			while( i++<l )
			{
				skin = _skinHold.pop();
				_container.splice(_container.indexOf(skin),1);  // TODO  offload to subclass for remove()... Flash.removeChild() Starling.removeChild(), etc
				skins.dispose(skin);
			}
		}
	}
}