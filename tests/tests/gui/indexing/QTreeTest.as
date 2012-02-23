package tests.gui.indexing
{
	import tests.helpers.TestGuiObjectContainer;
	import flash.geom.Rectangle;
	import gui.core.GuiObjectContainer;
	import gui.indexing.QTree;
	import tests.helpers.IndexerTestDataHelper;
	
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class QTreeTest extends IndexTestBase
	{
		/**
		 * Initialises the base class with the indexer.
		 */
		[BeforeClass]
		public static function initialise():void
		{
			var rect:Rectangle 	= new Rectangle(0,0,IndexerTestDataHelper.SQUARE_SMALL_SIZE,IndexerTestDataHelper.SQUARE_SMALL_SIZE); 
			indexer 			= new QTree(rect,100);
			container 			= new TestGuiObjectContainer();
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