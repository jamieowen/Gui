package gui.renderers.starling
{
	import gui.core.objects.GuiObject;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.render.IGuiObjectSkin;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	
	public class StarlingGuiBitmap extends Image implements IGuiObjectSkin
	{
		public function StarlingGuiBitmap(texture:Texture)
		{
			super(texture);
		}
		

		
		/**
		 * Called when the GuiObject it is rendering changes for any reason.
		 */
		public function renderRequest( $request:GuiRenderRequest, $renderer:GuiRenderer ):void
		{
			smoothing	= TextureSmoothing.NONE;
			
			var item:GuiRenderRequest = $request;
			
			//trace( "Render : " + item.guiRect  );
			
			this.x 		= item.guiRect.x;
			this.y 		= item.guiRect.y;
			this.width 	= item.guiRect.width;
			this.height = item.guiRect.height;
				
			/**if( item.clipRect )
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
			}**/
					
			this.readjustSize();
		}
		
		public function attach($newGui:GuiObject,$renderer:GuiRenderer):void
		{
			
		}
		

		public function release($previousGui:GuiObject,$renderer:GuiRenderer):void
		{
			
		}
	}
}