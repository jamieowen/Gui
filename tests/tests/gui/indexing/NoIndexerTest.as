package tests.gui.indexing {
	import gui.indexing.NoIndexer;

	import tests.helpers.TestGuiObjectContainer;
	
	/**
	* Test Description
	*
	* @author jamieowen
	*/
	public class NoIndexerTest extends IndexTestBase
	{
		/**
		 * Initialises the base class with the indexer.
		 */
		[BeforeClass]
		public static function initialise():void
		{
			indexer 		= new NoIndexer();
			container 		= new TestGuiObjectContainer();
		}

		/**
		 * Disposes of the indexer
		 */	
		[AfterClass]
		public static function dispose():void
		{
			indexer.removeAll();
			indexer = null;
		}
	}
}