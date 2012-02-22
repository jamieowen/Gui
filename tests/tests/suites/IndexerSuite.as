package tests.suites {
	import tests.gui.indexing.RectangleTest;
	import tests.gui.indexing.QTreeTest;
	import tests.gui.indexing.NoIndexerTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class IndexerSuite
	{
		[Test]
		public var rectTest:RectangleTest;
		
		[Test]
		public var noIndexerTest:NoIndexerTest;
		
		[Test]
		public var qTreeTest:QTreeTest;
	}
}
