package tests.gui.display
{
	import gui.core.context.GuiContextOld;
	import gui.display.GuiBitmap;
	import tests.gui.core.CoreGuiObjectTestBase;
	import tests.helpers.TestGuiObjectContainer;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class GuiBitmapTest extends CoreGuiObjectTestBase
	{
		[BeforeClass]
		public static function initialise():void
		{
			guiObjectClass = GuiBitmap;
			guiObjectContainerClass = TestGuiObjectContainer;
			
			// override and place own test GuiObject here.
			guiObject = new guiObjectClass();
			
			guiObjectContainer = new guiObjectContainerClass();
			guiContext = new GuiContextOld(guiObjectContainer);
		}
		
		[AfterClass]
		public static function dispose():void
		{
			guiObjectClass = null;
			guiObjectContainerClass = null;
			
			guiObject = null;
			guiObjectContainer = null;
			guiContext.dispose();
			guiContext = null;
		}
	}
}