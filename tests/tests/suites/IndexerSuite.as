package tests.suites {
	import tests.gui.indexing.NoIndexerTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class IndexerSuite
	{
		[Test]
		public var noIndexerTest:NoIndexerTest;
	}
}
