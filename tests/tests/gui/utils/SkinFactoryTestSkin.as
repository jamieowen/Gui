package tests.gui.utils {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import gui.core.objects.GuiObject;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.render.IGuiObjectSkin;

	/**
	 * Test class for a skin..
	 * 
	 * @author jamieowen
	 */
	public class SkinFactoryTestSkin extends Sprite implements IGuiObjectSkin
	{
		// add some extra props.
		public var vec:Vector.<Number>;
		
		// passed in args
		public var test1:String;
		public var test2:Number;
		public var testBitmap:BitmapData;
		 
		public function SkinFactoryTestSkin()
		{
			vec = new Vector.<Number>(20,true);
		}
		
		
		public function renderRequest($request : GuiRenderRequest, $renderer : GuiRenderer) : void
		{
			
		}

		public function dispose() : void
		{
			testBitmap = null;
			vec.splice(0, uint.MAX_VALUE);
			vec = null;
		}
		
		public function attach($newGui:GuiObject,$renderer:GuiRenderer):void
		{
		}
		

		public function release($previousGui:GuiObject,$renderer:GuiRenderer):void
		{
			
		}
	}
}
