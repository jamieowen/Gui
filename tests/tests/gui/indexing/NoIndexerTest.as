package tests.gui.indexing {
	import gui.core.GuiObjectContainer;
	import gui.indexing.NoIndexer;
	
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
			container 		= new GuiObjectContainer();
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