package tests.gui.core {
	import gui.core.context.GuiContextOld;
	import tests.helpers.TestGuiObject;
	import tests.helpers.TestGuiObjectContainer;


	/**
	 * @author jamieowen
	 */
	public class GuiObjectContainerTest extends CoreGuiObjectTestBase
	{
		[BeforeClass]
		public static function initialise():void
		{
			guiObjectClass = TestGuiObject;
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