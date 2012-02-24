package tests.suites {
	import tests.gui.core.GuiContextTest;
	import tests.gui.core.GuiObjectContainerTest;
	import tests.gui.core.GuiObjectTest;

	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class CoreSuite
	{
		[Test(order=1)]
		public var guiObject:GuiObjectTest;
		
		[Test(order=2)]
		public var guiObjectContainer:GuiObjectContainerTest;
		
		[Test(order=3)]
		public var guiContext:GuiContextTest;
	}
}

