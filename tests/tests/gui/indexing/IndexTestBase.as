package tests.gui.indexing {
	import gui.core.GuiObject;
	import gui.core.GuiObjectContainer;
	import gui.errors.AbstractClassError;
	import gui.indexing.IGuiIndexer;
	import gui.render.GuiRenderRequest;

	import tests.helpers.IndexerTestDataHelper;
	import flash.utils.getQualifiedClassName;
	
	import org.flexunit.asserts.assertTrue;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class IndexTestBase 
	{
		public static var indexer:IGuiIndexer;
		public static var container:GuiObjectContainer; // container to use to populate objects.
		public static var totalItems:uint; // total items added.
		
		public function IndexTestBase()
		{
			if (getQualifiedClassName(this) == "tests.gui.indexing::IndexTestBase")
				throw new AbstractClassError();			
		}
		
		/**
		 * 
		 */
		[Before]
		public  function pre() : void
		{
			
		}
		
		/**
		 * 
		 */
		[After]
		public function post():void
		{

		}
		
		/**
		 * Adds objects to the indexer.
		 */
		[Test(order=1)]
		public function testAdd():void
		{ 
			var count:Point = new Point();
			var depth:uint = IndexerTestDataHelper.SQUARE_SMALL_DEPTH;
			
			IndexerTestDataHelper.create4Square(container, IndexerTestDataHelper.SQUARE_SMALL_SIZE, IndexerTestDataHelper.SQUARE_SMALL_PADDING, 0, depth, count);
			IndexerTestDataHelper.addToIndexer( container, indexer );
			
			totalItems = count.x + count.y;
			trace( "Added :" + totalItems + ", Indexer shows:" + indexer.numItems );
			
			assertTrue( indexer.numItems == totalItems );
		}
		
		/**
		 * Queries the top left of the square for items. Items should amount to the amount calculated by IndexerTestDataHelper.calculateCountsForBox() at
		 * the depth of the box-1.
		 */
		[Test(order=2)]
		public function testFind():void
		{ 
			var findRect:Rectangle = IndexerTestDataHelper.SQUARE_SMALL_TOP_LEFT_RECT;
			var oneBox:Number = IndexerTestDataHelper.calculateFindResultFor1(IndexerTestDataHelper.SQUARE_SMALL_DEPTH);
			var expected:Number = oneBox+1; // add one for root container that will also be intersected.
			var results:Vector.<GuiRenderRequest> = indexer.find(findRect);
			
			trace( "Find :" + findRect + ", Expected:" + expected + ", Indexer shows:" + results.length );
			
			assertTrue( results.length == expected );
		}
		
		/**
		 * Updates and confirms that the objects have been moved by performing another query.
		 * Moves each box in the root container to the top left corner in succession. Querying after each update.
		 */
		[Test(order=3)]
		public function testUpdateAndFind():void
		{ 
			var findRect:Rectangle = IndexerTestDataHelper.SQUARE_SMALL_TOP_LEFT_RECT;
			var oneBox:Number = IndexerTestDataHelper.calculateFindResultFor1(IndexerTestDataHelper.SQUARE_SMALL_DEPTH);
			var expected:Number = oneBox+1; // add one for root container that will also be intersected.
			
			var padding:Number = IndexerTestDataHelper.SQUARE_SMALL_PADDING; // move objects to this position.
			var results:Vector.<GuiRenderRequest>;
			
			
			var childContainer:GuiObject;
			var childObject:GuiObject;
			
			// ( see IndexerTestDataHelper.create4SquareBox() for info on what is contained in each box )
			// move top right
			childObject 		= container.getChildAt(2); // object  
			childContainer 		= container.getChildAt(3); // container
			
			childObject.x = childObject.y = childContainer.x = childContainer.y = padding;
			IndexerTestDataHelper.updateInIndexer( childContainer as GuiObjectContainer, indexer);
			indexer.update(childObject, childObject.getGlobalBounds()); // update child manually.
			results = indexer.find(findRect);
			
			expected = ( oneBox*2 ) + 1;
			trace( "Update 1 :" + findRect + ", Expected:" + expected + ", Indexer shows:" + results.length );			
			assertTrue( results.length == expected );
			assertTrue( indexer.numItems == totalItems );
			
			// move bottom left
			childObject 		= container.getChildAt(4); // object  
			childContainer 		= container.getChildAt(5); // container
			
			childObject.x = childObject.y = childContainer.x = childContainer.y = padding;
			IndexerTestDataHelper.updateInIndexer( childContainer as GuiObjectContainer, indexer);
			indexer.update(childObject, childObject.getGlobalBounds()); // update child manually.
			results = indexer.find(findRect);
			
			expected = ( oneBox*3 ) + 1;
			trace( "Update 2 :" + findRect + ", Expected:" + expected + ", Indexer shows:" + results.length );			
			assertTrue( results.length == expected );
			assertTrue( indexer.numItems == totalItems );
			
			// move bottom right
			childObject 		= container.getChildAt(6); // object  
			childContainer 		= container.getChildAt(7); // container
			
			childObject.x = childObject.y = childContainer.x = childContainer.y = padding;
			IndexerTestDataHelper.updateInIndexer( childContainer as GuiObjectContainer, indexer);
			indexer.update(childObject, childObject.getGlobalBounds()); // update child manually.
			results = indexer.find(findRect);
			
			expected = ( oneBox*4 ) + 1;
			trace( "Update 3 :" + findRect + ", Expected:" + expected + ", Indexer shows:" + results.length );			
			assertTrue( results.length == expected );
			assertTrue( indexer.numItems == totalItems );
			
			assertTrue( results.length == totalItems );
		}		
		
		/**
		 * Removes each first child box one by one checking the indexer count each time and querying the same area as above.
		 */
		[Test(order=4)]
		public function testRemove():void
		{ 
			var findRect:Rectangle = IndexerTestDataHelper.SQUARE_SMALL_TOP_LEFT_RECT;
			var oneBox:Number = IndexerTestDataHelper.calculateFindResultFor1(IndexerTestDataHelper.SQUARE_SMALL_DEPTH);
			
			var results:Vector.<GuiRenderRequest>;
			
			var childContainer:GuiObject;
			var childObject:GuiObject;
			
			// remove 1st box
			childObject 		= container.getChildAt(0); // object  
			childContainer 		= container.getChildAt(1); // container
			
			IndexerTestDataHelper.removeFromIndexer( childContainer as GuiObjectContainer, indexer);
			indexer.remove(childObject); // update child manually.
			totalItems-=oneBox;
			
			results = indexer.find(findRect); 
			trace( "Remove 1 :" + ", Expected new size:" + totalItems + ", Indexer size shows:" + indexer.numItems + ", Query shows " + results.length );
			assertTrue( indexer.numItems == totalItems && results.length == totalItems );
			
			// remove 2nd box
			childObject 		= container.getChildAt(2); // object  
			childContainer 		= container.getChildAt(3); // container
			
			IndexerTestDataHelper.removeFromIndexer( childContainer as GuiObjectContainer, indexer);
			indexer.remove(childObject); // update child manually.
			totalItems-=oneBox;
			
			results = indexer.find(findRect); 
			trace( "Remove 2 :" + ", Expected new size:" + totalItems + ", Indexer size shows:" + indexer.numItems + ", Query shows " + results.length );
			assertTrue( indexer.numItems == totalItems && results.length == totalItems );
			
			// remove 3rd box
			childObject 		= container.getChildAt(4); // object  
			childContainer 		= container.getChildAt(5); // container
			
			IndexerTestDataHelper.removeFromIndexer( childContainer as GuiObjectContainer, indexer);
			indexer.remove(childObject); // update child manually.
			totalItems-=oneBox;
			
			results = indexer.find(findRect); 
			trace( "Remove 3 :" + ", Expected new size:" + totalItems + ", Indexer size shows:" + indexer.numItems + ", Query shows " + results.length );
			assertTrue( indexer.numItems == totalItems && results.length == totalItems );
			
			// remove 4th box
			childObject 		= container.getChildAt(6); // object  
			childContainer 		= container.getChildAt(7); // container
			
			IndexerTestDataHelper.removeFromIndexer( childContainer as GuiObjectContainer, indexer);
			indexer.remove(childObject); // update child manually.
			totalItems-=oneBox;
			
			results = indexer.find(findRect); 
			trace( "Remove 4 :" + ", Expected new size:" + totalItems + ", Indexer size shows:" + indexer.numItems + ", Query shows " + results.length );
			assertTrue( indexer.numItems == totalItems && results.length == totalItems );
			
			
			// remove last
			indexer.remove(container); // update child manually.
			totalItems-=1;
			
			results = indexer.find(findRect); 
			trace( "Remove 5 :" + ", Expected new size:" + totalItems + ", Indexer size shows:" + indexer.numItems + ", Query shows " + results.length );
			assertTrue( indexer.numItems == totalItems && results.length == totalItems );
			assertTrue( indexer.numItems == 0 && results.length == 0 );
			
	
		}	
	}
}