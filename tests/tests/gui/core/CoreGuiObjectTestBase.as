package tests.gui.core {
	import org.flexunit.asserts.assertEquals;
	import gui.errors.AbstractClassError;
	import flash.utils.getQualifiedClassName;
	import gui.core.GuiContext;
	import gui.core.GuiObjectContainer;
	import gui.events.GuiEvent;
	import org.flexunit.async.Async;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import org.flexunit.asserts.assertTrue;
	import gui.core.GuiObject;
	
	/**
	* Base abstract class that enables the subclass to test a GuiObject's common
	* methods and usage.
	* 
	* This can be any object that extends GuiObject - so use it for custom classes, etc.
	* 
	* To use, the subclass must specify a gui object and container class. This class will be used
	* in any tests below where a new instance is required.  Usage such as adding and removing from 
	* containers, setting width & heights, listening for expected events etc. 
	* 
	* The guiObject, guiObjectContainer and guiContext properties also need specifying to test any context
	* related usage/events as well.
	*
	* This also tests the GuiContext indirectly - by checking all objects and containers are triggering the correct invalidation on the GuiContext.
	*
	* @author jamieowen
	*/
	public class CoreGuiObjectTestBase 
	{
		public static var guiObjectClass:Class;
		public static var guiObjectContainerClass:Class;
		
		public static var guiContext:GuiContext;
		public static var guiObject:GuiObject;
		public static var guiObjectContainer:GuiObjectContainer;
		
		public function CoreGuiObjectTestBase()
		{
			if (getQualifiedClassName(this) == "tests.gui.core::GuiObjectTestBase")
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
		 * Test description.
		 */
		[Test(order=1)]
		public function testPropertySetGet():void
		{ 
			
			guiObject.x = 10;
			assertEquals( "Set x to 10", 10, guiObject.x );
			guiObject.y = 25;
			assertEquals( "Set y to 25", 25, guiObject.y );
			guiObject.width = 100;
			assertEquals( "Set width to 100", 100, guiObject.width );
			guiObject.height = 150;
			assertEquals( "Set height to 150", 150, guiObject.height );
			
			var local:Point = guiObject.localToGlobal( new Point(0,0) );
			assertTrue( "Check localToGlobal", local.equals(new Point(10,25) ) );
			
			var rect:Rectangle = guiObject.getGlobalBounds();
			assertTrue( "Check getGlobalBounds", rect.equals(new Rectangle(10,25,100,150)) );
			
			guiObject.skin = "skinName";
			assertEquals( "Set skin name", "skinName", guiObject.skin );
			
			guiObject.name = "guiName";
			assertEquals( "Set gui name", "guiName", guiObject.name );
			
			assertEquals( "Parent is null", null, guiObject.parent );
			
			assertEquals( "Context is null", null, guiObject.context );
			
			var matrix:Matrix = guiObject.transformationMatrix;
			
			assertEquals( "matrix.tx is 10", 10, matrix.tx );
			assertTrue( "matrix.tx is 25", 25, matrix.ty );
		}
		
		[Test(order=2,async)]
		public function testMoveXDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.MOVE);
			guiObject.x = 230;
		}
		
		[Test(order=3,async)]
		public function testMoveYDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.MOVE);
			guiObject.y = 123;			 
		}
		
		[Test(order=4,async)]
		public function testResizeWDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.RESIZE);
			guiObject.width = 230;
		}
		
		[Test(order=5,async)]
		public function testResizeHDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.RESIZE);
			guiObject.height = 50;			 
		}
		
		[Test(order=6,async)]
		public function testSkinChangeDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.SKIN_CHANGE);
			guiObject.skin = "skinChange";
		}
		
		[Test(order=7,async)]
		public function testAddedDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.ADDED);
			Async.proceedOnEvent(this, guiObject, GuiEvent.ADDED_TO_CONTEXT);
			
			guiObjectContainer.addChild( guiObject );
			
			assertEquals( "check parent", guiObjectContainer, guiObject.parent );
			assertEquals( "Test 'added' invalidation stats", 2, guiContext.invalidation.stats.added );
		}
		
		[Test(order=8,async)]
		public function testRemovedDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.REMOVED);
			Async.proceedOnEvent(this, guiObject, GuiEvent.REMOVED_FROM_CONTEXT);
			
			guiObjectContainer.removeChild( guiObject );
			
			assertEquals( "check parent", null, guiObject.parent );
			assertTrue( "Test 'removed' invalidation stats", guiContext.invalidation.stats.removed == 1 );
		}
		
		[Test(order=9)]
		public function testAddRemoveChildren():void
		{
			var child1:GuiObject = new guiObjectClass();
			var child2:GuiObject = new guiObjectClass();
			var child3:GuiObject = new guiObjectClass();
			
			child1.name = "child1";
			child2.name = "child2";
			child3.name = "child3";
			
			guiObjectContainer.addChild( child1 );
			assertEquals( "numChildren 1", 1, guiObjectContainer.numChildren );
			
			guiObjectContainer.addChild( child2 );
			assertEquals( "numChildren 2", 2, guiObjectContainer.numChildren );
			
			guiObjectContainer.addChild( child3 );
			assertEquals( "numChildren 3", 3, guiObjectContainer.numChildren );
			
			assertEquals( "Test 'added' invalidation stats 1", 5, guiContext.invalidation.stats.added ); // including first add in testAddedDispatch()
			
			// re-add same child - causes a REMOVE AND ADD of the same object
			guiObjectContainer.addChild( child3 );
			
			assertEquals( "Test 'added' invalidation stats 2", 6, guiContext.invalidation.stats.added );
			assertEquals( "Test 'removed' invalidation stats 3", 2, guiContext.invalidation.stats.removed );
			
			assertEquals( "numChildren 3 after re-add same", 3, guiObjectContainer.numChildren );
			
			assertEquals( "getChildAt 1", child1, guiObjectContainer.getChildAt(0) );
			assertEquals( "getChildAt 2", child2, guiObjectContainer.getChildAt(1) );
			assertEquals( "getChildAt 3", child3, guiObjectContainer.getChildAt(2) );
			
			guiObjectContainer.swapChildren( child1, child2);
			assertTrue( "swapChildrenCheck 1", guiObjectContainer.getChildAt(0) == child2 && guiObjectContainer.getChildAt(1) == child1 );
			guiObjectContainer.swapChildren( child1, child2);
			assertTrue( "swapChildrenCheck 2", guiObjectContainer.getChildAt(0) == child1 && guiObjectContainer.getChildAt(1) == child2 );

			assertEquals( "getChildIndex 1", 0, guiObjectContainer.getChildIndex(child1) );
			assertEquals( "getChildIndex 2", 1, guiObjectContainer.getChildIndex(child2) );
			assertEquals( "getChildIndex 3", 2, guiObjectContainer.getChildIndex(child3) );
			
			assertTrue( "contains 1", guiObjectContainer.contains(child1) );
			assertTrue( "contains 2", guiObjectContainer.contains(child2) );
			assertTrue( "contains 3", guiObjectContainer.contains(child3) );
			
			guiObjectContainer.removeChild(child1);
			
			assertEquals( "numChildren before Add At", 2, guiObjectContainer.numChildren );
			
			guiObjectContainer.addChildAt(child1, 2);
			
			assertEquals( "Test 'added' invalidation stats 4", 7, guiContext.invalidation.stats.added );
			assertEquals( "Test 'removed' invalidation stats 5", 3, guiContext.invalidation.stats.removed );
			
			assertEquals( "addChildAt", guiObjectContainer.getChildIndex(child1),2);
			
			guiObjectContainer.setChildIndex(child1, 0);
			guiObjectContainer.setChildIndex(child2, 2);
			
			assertEquals( "setChildIndexCheck 1", 0, guiObjectContainer.getChildIndex(child1) );
			assertEquals( "setChildIndexCheck 2", 2, guiObjectContainer.getChildIndex(child2) );
			assertEquals( "setChildIndexCheck 3", 1, guiObjectContainer.getChildIndex(child3) );
			
			// set back to normal - should shift child2 down
			guiObjectContainer.setChildIndex(child3, 2);
			
			assertEquals( "getChildByName 1", child1, guiObjectContainer.getChildByName("child1") );
			assertEquals( "getChildByName 2", child2, guiObjectContainer.getChildByName("child2") );
			assertEquals( "getChildByName 3", child3, guiObjectContainer.getChildByName("child3") );
			
			guiObjectContainer.removeChild(child1);
			assertEquals( "removeChildCheck 1", 2, guiObjectContainer.numChildren );
			assertEquals( "removeChildCheck 2", child2, guiObjectContainer.getChildAt(0) );
			
			guiObjectContainer.removeChildAt(0);
			assertEquals( "removeChildCheck 3", child3, guiObjectContainer.getChildAt(0) );
			assertEquals( "removeChildCheck 4", 1, guiObjectContainer.numChildren );
			
			guiObjectContainer.removeChildAt( guiObjectContainer.getChildIndex(child3));
			
			assertEquals( "removeChildCheck 5", 0, guiObjectContainer.numChildren );
			
			assertEquals( "Test 'removed' invalidation stats 6", 6, guiContext.invalidation.stats.removed );
			
			// removed items will all still be in the invalidation list.. - the GuiContainer root class is also added to first stage of invalidation
			assertEquals( "Check invalidation list size", 5, guiContext.invalidation.invalidated.length );
			
			// check Indexer - Should be 1 - The GuiContainer root.
			assertEquals( "Check Indexer", 1, guiContext.indexer.numItems );
			
			// check all other invalidation stats are not changed 
			assertEquals( "Check invalidation : 'data' ", 0, guiContext.invalidation.stats.dataChanged );
			assertEquals( "Check invalidation : 'moved' ", 0, guiContext.invalidation.stats.moved);
			assertEquals( "Check invalidation : 'resize' ", 0, guiContext.invalidation.stats.resized );
			assertEquals( "Check invalidation : 'scroll' ", 0, guiContext.invalidation.stats.scrolled );
			assertEquals( "Check invalidation : 'skin' ", 0, guiContext.invalidation.stats.skinChanged );
			
			// clear context by calling update() ( as if an enter frame were triggered )
			guiContext.update();
			assertEquals( "after guiContext.update() check 'added' ", 0, guiContext.invalidation.stats.added );
			assertEquals( "after guiContext.update() check 'removed' ", 0, guiContext.invalidation.stats.removed );
			assertEquals( "Check invalidation list size ", 0, guiContext.invalidation.invalidated.length );
			
			assertEquals( "Check Indexer", 1, guiContext.indexer.numItems );
		}
		
		/**
		 * Creates a nested groups of objects and containers and tests add remove across non-same depth children 
		 * and removing entire branches of registered objects.
		 * 
		 * Makes sure the context is handling this correctly and removing registered items from the Indexer.
		 */
		[Test(order=10)]
		public function testAddRemoveNested():void
		{
			var createCount:uint = 0;
			
			// create a branch with 2 containers and x children.
			var createBranch:Function = function( $container:GuiObjectContainer,$numChildren:uint, $depth:uint, $maxDepth:uint ):void
			{
				var newContainer:GuiObjectContainer;
				for( var i:int = 0; i<$numChildren; i++ )
				{
					createCount++;
					$container.addChild( new guiObjectClass() );
				}
				if( $depth<$maxDepth)
				{
					newContainer = new guiObjectContainerClass();
					$container.addChild( newContainer );
					createBranch( newContainer,$numChildren,$depth+1, $maxDepth );
					newContainer = new guiObjectContainerClass();
					$container.addChild( newContainer );
					createBranch( newContainer,$numChildren,$depth+1, $maxDepth );
					createCount+=2;
				}
			};
			
			// create a branch of objects - this will be removed to test large tree removal.
			var root1:GuiObjectContainer = new guiObjectContainerClass();
			createCount++; // total = 3066 for  : createBranch( root1, 5, 0, 8);
			createBranch( root1, 5, 0, 8);
			guiObjectContainer.addChild( root1 );
			
			assertEquals( "Check invalidation list size 1", createCount, guiContext.invalidation.invalidated.length );
			assertEquals( "Test 'added' invalidation stats 1", createCount, guiContext.invalidation.stats.added );
			
			assertEquals( "Indexer size 1", createCount+1, guiContext.indexer.numItems ); // +1 in indexer to include the root GuiContext container already indexed.
			
			// create another branch for easier updating
			
			var root2:GuiObjectContainer = new guiObjectContainerClass();
			var branch1:GuiObjectContainer = new  guiObjectContainerClass();
			
			root2.addChild( branch1 );
			
			var child1:GuiObject = new guiObjectClass();
			var child2:GuiObject = new guiObjectClass();
			var child3:GuiObject = new guiObjectClass();
			
			branch1.addChild(child1);
			branch1.addChild(child2);
			branch1.addChild(child3);
		
			guiObjectContainer.addChild( root2 ); // should add 5 on
			
			assertEquals( "Check invalidation list size 2", createCount+5, guiContext.invalidation.invalidated.length );
			assertEquals( "Test 'added' invalidation stats 2", createCount+5, guiContext.invalidation.stats.added );
			assertEquals( "Indexer size 2", createCount+6, guiContext.indexer.numItems ); // +1 in indexer to include the root GuiContext container

			assertEquals( "1 child1 parent =", branch1, child1.parent );
			assertEquals( "1 child2 parent =", branch1, child2.parent );
			assertEquals( "1 child3 parent =", branch1, child3.parent );
			
			// re-parent some children.
			root2.addChild( child1 );
			root2.addChildAt(child3, 0);
			
			assertEquals( "2 child1 parent =", root2, child1.parent );
			assertEquals( "2 child2 parent =", branch1, child2.parent );
			assertEquals( "2 child3 parent =", root2, child3.parent );
			
			assertEquals( "branch 1 child =", child2, branch1.getChildAt(0) );
			assertEquals( "branch 1 numChildren", 1, branch1.numChildren );
			
			assertEquals( "root2 numChildren", 3, root2.numChildren );
			assertEquals( "root2 child1 =", child3, root2.getChildAt(0) );
			assertEquals( "root2 child2 =", branch1, root2.getChildAt(1) ); // position after branch1
			assertEquals( "root2 child3 =", child1, root2.getChildAt(2) ); // position after branch1
			
			// assert sizes again
			assertEquals( "Check invalidation list size 3", createCount+5, guiContext.invalidation.invalidated.length ); // same as last time
			assertEquals( "Test 'added' invalidation stats 3", createCount+7, guiContext.invalidation.stats.added ); // +2 for re-parent action
			assertEquals( "Test 'removed' invalidation stats 3", 2, guiContext.invalidation.stats.removed ); // just 2 for re-parent action
			
			assertEquals( "Indexer size 3", createCount+6, guiContext.indexer.numItems ); // should be the same size // +1 in indexer to include the root GuiContext container
			
			// now remove small branch. should remove 5.
			guiObjectContainer.removeChild( root2 );
			assertEquals( "Check invalidation list size 4", createCount+5, guiContext.invalidation.invalidated.length ); // same as last time
			assertEquals( "Test 'added' invalidation stats 4", createCount+7, guiContext.invalidation.stats.added ); // same as last time.
			assertEquals( "Test 'removed' invalidation stats 4", 7, guiContext.invalidation.stats.removed ); // should increase to 7.
			
			assertEquals( "Indexer size 4", createCount+1, guiContext.indexer.numItems ); // should have removed 5
			
			// now remove large branch
			guiObjectContainer.removeChild( root1 );
			assertEquals( "Check invalidation list size 5", createCount+5, guiContext.invalidation.invalidated.length ); // same as last time
			assertEquals( "Test 'added' invalidation stats 5", createCount+7, guiContext.invalidation.stats.added ); // same as last time.
			assertEquals( "Test 'removed' invalidation stats 5", createCount+7, guiContext.invalidation.stats.removed ); // should increase to 7 + createCount
			
			assertEquals( "Indexer size 5", 1, guiContext.indexer.numItems ); // should be back to just 1. ( the root container )		
			
			// check all other invalidation stats are not changed
			assertEquals( "Check invalidation : 'data' ", 0, guiContext.invalidation.stats.dataChanged );
			assertEquals( "Check invalidation : 'moved' ", 0, guiContext.invalidation.stats.moved);
			assertEquals( "Check invalidation : 'resize' ", 0, guiContext.invalidation.stats.resized );
			assertEquals( "Check invalidation : 'scroll' ", 0, guiContext.invalidation.stats.scrolled );
			assertEquals( "Check invalidation : 'skin' ", 0, guiContext.invalidation.stats.skinChanged );
			
			// clear context by calling update() ( as if an enter frame were triggered )
			guiContext.update();
			assertEquals( "after guiContext.update() check 'added' ", 0, guiContext.invalidation.stats.added );
			assertEquals( "after guiContext.update() check 'removed' ", 0, guiContext.invalidation.stats.removed );
			assertEquals( "Check invalidation list size ", 0, guiContext.invalidation.invalidated.length );
			
			assertEquals( "Indexer size 6", 1, guiContext.indexer.numItems );
		}
	}
}
