package tests.gui.core {
	import gui.core.GuiContext;
	import tests.gui.core.GuiObjectTestBase;

	/**
	 * @author jamieowen
	 */
	public class GuiObjectTest extends GuiObjectTestBase
	{
		
		/**
		 * 
		 */
		[BeforeClass]
		public static function initialise():void
		{
			// override and place own test GuiObject here.
			guiObject = new GuiObjTest(); 
			
			guiObjectContainer = new GuiObjContTest();
			guiContext = new GuiContext(guiObjectContainer);
		}

		/**
		 * 
		 */	
		[AfterClass]
		public static function dispose():void
		{
			guiObject = null;
			guiObjectContainer = null;
			guiContext.dispose();
			guiContext = null;
		}

	}
}

import gui.core.GuiObjectContainer;
import gui.core.GuiObject;

internal class GuiObjTest extends GuiObject
{
	
}

internal class GuiObjContTest extends GuiObjectContainer
{
	
}