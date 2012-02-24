package tests.gui.core {
	import tests.helpers.TestGuiObjectContainer;
	import tests.helpers.TestGuiObject;
	import gui.core.GuiContext;
	import tests.gui.core.CoreGuiObjectTestBase;

	/**
	 * @author jamieowen
	 */
	public class GuiObjectTest extends CoreGuiObjectTestBase
	{
		[BeforeClass]
		public static function initialise():void
		{
			guiObjectClass = TestGuiObject;
			guiObjectContainerClass = TestGuiObjectContainer;
			
			// override and place own test GuiObject here.
			guiObject = new guiObjectClass();
			
			guiObjectContainer = new guiObjectContainerClass();
			guiContext = new GuiContext(guiObjectContainer);
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