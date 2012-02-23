package tests.helpers
{
	import gui.core.GuiObject;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class TestGuiObject extends GuiObject
	{
		public static const DEFAULT_SKIN_NAME:String = "testGuiObject";
		
		/**
		* Class Constructor Description
		*/
		public function TestGuiObject()
		{
			super();
			
			skin = DEFAULT_SKIN_NAME;
		}
	}
}