package tests.suites {
	import tests.gui.display.GuiBitmapTest;

	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class ComponentSuite
	{
		[Test(order=1)]
		public var guiObject:GuiBitmapTest;
	}
}

