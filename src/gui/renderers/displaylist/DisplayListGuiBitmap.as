package gui.renderers.displaylist 
{
	import gui.core.GuiObject;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.render.IGuiObjectSkin;

	import flash.display.Bitmap;

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
