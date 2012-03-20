package gui.renderers.displaylist 
{
	import flash.display.Bitmap;
	import gui.core.objects.GuiObject;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.render.IGuiObjectSkin;


	/**
	 * @author jamieowen
	 */
	public class DisplayListGuiBitmap extends Bitmap implements IGuiObjectSkin
	{
		public function DisplayListGuiBitmap()
		{
			super();
		}

		public function renderRequest($request : GuiRenderRequest, $renderer : GuiRenderer) : void
		{
			this.x 		= $request.guiRect.x;
			this.y 		= $request.guiRect.y;
			this.width 	= $request.guiRect.width;
			this.height = $request.guiRect.height;
		}

		public function dispose() : void
		{
			
		}

		public function attach($newGui : GuiObject, $renderer : GuiRenderer) : void 
		{
			
		}

		public function release($previousGui : GuiObject, $renderer : GuiRenderer) : void
		{
			
		}
	}
}
