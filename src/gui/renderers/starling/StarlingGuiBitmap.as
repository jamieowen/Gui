package gui.renderers.starling
{
	import starling.textures.TextureSmoothing;
	import gui.core.GuiObject;
	import gui.render.GuiRenderer;
	import gui.render.GuiRenderRequest;
	import gui.render.IGuiObjectSkin;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class StarlingGuiBitmap extends Image implements IGuiObjectSkin
	{
		public function StarlingGuiBitmap(texture:Texture)
		{
			super(texture);
		}
		
		/**
		 * Called when the renderer is removed from screen. After this is called it is likely it is cached in the Renderer Factory object
		 * to be reused later.
		 * 
		 * If the renderer required any dependencies it should clean itself up here. 
		 */
		public function clip():void
		{
		
		}
		
		/**
		 * Called when a renderer is added to the screen for the first time.
		 * Called once during this renderers usage on screen. Clip is called after.
		 */
		public function unclip($request:GuiRenderRequest,$renderer:GuiRenderer):void
		{
			
		}
		
		/**
		 * Called when the GuiObject it is rendering changes for any reason.
		 */
		public function renderRequest( $request:GuiRenderRequest, $renderer:GuiRenderer ):void
		{
			smoothing	= TextureSmoothing.NONE;
			
			var item:GuiRenderRequest = $request;
			
			trace( "Render : " + item.guiRect  );
			
			if( item.clipRect )
			{
				
				this.x 		= item.clipRect.x;
				this.y 		= item.clipRect.y;
				this.width 	= item.clipRect.width;
				this.height = item.clipRect.height;
			}else
			{
				this.x 		= item.guiRect.x;
				this.y 		= item.guiRect.y;
				this.width 	= item.guiRect.width;
				this.height = item.guiRect.height;
			}
					
			this.readjustSize();
		}
	}
}