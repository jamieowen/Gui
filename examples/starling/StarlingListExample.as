package starling
{
	import starling.textures.Texture;
	import flash.display.BitmapData;
	import gui.display.GuiList;
	import gui.renderers.starling.StarlingGuiBitmap;
	import starling.base.StarlingExampleBase;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class StarlingListExample extends StarlingExampleBase
	{
		/**
		* Class Constructor Description
		*/
		public function StarlingListExample()
		{
			super();
		}
		
		override protected function registerSkins():void
		{
			// textures
			var texture:Texture = Texture.fromBitmapData( new BitmapData(100,100,true,0x77FF0000) );	
			renderer.skins.register( "*", StarlingGuiBitmap, {texture:texture}, [texture] );
		}
		
		override protected function createExample():void
		{
			var list:GuiList = new GuiList();
			list.x = list.y = 0;
			list.width = list.height = 200;
			
			
			
			container.addChild( list );
		}
	}
}