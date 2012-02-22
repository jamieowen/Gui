package tests.gui.indexing
{
	import flash.geom.Rectangle;
	import tests.helpers.IndexerTestDataHelper;
	import gui.core.GuiObjectContainer;
	import gui.indexing.QTree;
	
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
			container 			= new GuiObjectContainer();
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