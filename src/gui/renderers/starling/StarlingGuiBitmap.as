package gui.renderers.starling
{
	import gui.render.IGuiObjectRenderer;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class StarlingGuiBitmap extends Image implements IGuiObjectRenderer
	{
		public function StarlingGuiBitmap(texture:Texture)
		{
			super(texture);
		}
	}
}