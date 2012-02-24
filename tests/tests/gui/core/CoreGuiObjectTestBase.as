package tests.gui.core {
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
			assertTrue( "Set x to 10", guiObject.x == 10 );
			guiObject.y = 25;
			assertTrue( "Set y to 25", guiObject.y == 25 );
			guiObject.width = 100;
			assertTrue( "Set width to 100", guiObject.width == 100 );
			guiObject.height = 150;
			assertTrue( "Set height to 150", guiObject.height == 150 );
			
			var local:Point = guiObject.localToGlobal( new Point(0,0) );
			assertTrue( "Check localToGlobal", local.equals(new Point(10,25) ) );
			
			var rect:Rectangle = guiObject.getGlobalBounds();
			assertTrue( "Check getGlobalBounds", rect.equals(new Rectangle(10,25,100,150)) );
			
			guiObject.skin = "skinName";
			assertTrue( "Set skin name", guiObject.skin == "skinName" );
			
			guiObject.name = "guiName";
			assertTrue( "Set gui name", guiObject.name == "guiName" );
			
			assertTrue( "Parent is null", guiObject.parent == null );
			
			assertTrue( "Context is null", guiObject.context == null );
			
			var matrix:Matrix = guiObject.transformationMatrix;
			
			assertTrue( "matrix.tx is 10", matrix.tx == 10 );
			assertTrue( "matrix.tx is 25", matrix.ty == 25 );
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
		}
		
		[Test(order=8,async)]
		public function testRemovedDispatch():void
		{
			Async.proceedOnEvent(this, guiObject, GuiEvent.REMOVED);
			Async.proceedOnEvent(this, guiObject, GuiEvent.REMOVED_FROM_CONTEXT);
			
			guiObjectContainer.removeChild( guiObject );
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
			assertTrue( "numChildren 1", guiObjectContainer.numChildren == 1 );
			
			guiObjectContainer.addChild( child2 );
			assertTrue( "numChildren 2", guiObjectContainer.numChildren == 2 );
			
			guiObjectContainer.addChild( child3 );
			assertTrue( "numChildren 3", guiObjectContainer.numChildren == 3 );
			
			// re-add same child
			guiObjectContainer.addChild( child3 );
			assertTrue( "numChildren 3 after re-add same", guiObjectContainer.numChildren == 3 );
			
			assertTrue( "getChildAt 1", guiObjectContainer.getChildAt(0) == child1 );
			assertTrue( "getChildAt 2", guiObjectContainer.getChildAt(1) == child2 );
			assertTrue( "getChildAt 3", guiObjectContainer.getChildAt(2) == child3 );
			
			guiObjectContainer.swapChildren( child1, child2);
			assertTrue( "swapChildrenCheck 1", guiObjectContainer.getChildAt(0) == child2 && guiObjectContainer.getChildAt(1) == child1 );
			guiObjectContainer.swapChildren( child1, child2);
			assertTrue( "swapChildrenCheck 2", guiObjectContainer.getChildAt(0) == child1 && guiObjectContainer.getChildAt(1) == child2 );

			assertTrue( "getChildIndex 1", guiObjectContainer.getChildIndex(child1) == 0 );
			assertTrue( "getChildIndex 2", guiObjectContainer.getChildIndex(child2) == 1 );
			assertTrue( "getChildIndex 3", guiObjectContainer.getChildIndex(child3) == 2 );
			
			assertTrue( "contains 1", guiObjectContainer.contains(child1) );
			assertTrue( "contains 2", guiObjectContainer.contains(child2) );
			assertTrue( "contains 3", guiObjectContainer.contains(child3) );
			
			guiObjectContainer.removeChild(child1);
			
			assertTrue( "numChildren before Add At", guiObjectContainer.numChildren == 2 );
			
			guiObjectContainer.addChildAt(child1, 2);
			
			assertTrue( "addChildAt", guiObjectContainer.getChildIndex(child1) == 2 );
			
			guiObjectContainer.setChildIndex(child1, 0);
			guiObjectContainer.setChildIndex(child2, 2);
			
			assertTrue( "setChildIndexCheck 1", guiObjectContainer.getChildIndex(child1) == 0 );
			assertTrue( "setChildIndexCheck 1", guiObjectContainer.getChildIndex(child2) == 2 );
			assertTrue( "setChildIndexCheck 1", guiObjectContainer.getChildIndex(child3) == 1 );
			
			// set back to normal - should shift child2 down
			guiObjectContainer.setChildIndex(child3, 2);
			
			assertTrue( "getChildByName 1", guiObjectContainer.getChildByName("child1") == child1 );
			assertTrue( "getChildByName 2", guiObjectContainer.getChildByName("child2") == child2 );
			assertTrue( "getChildByName 3", guiObjectContainer.getChildByName("child3") == child3 );
			
			guiObjectContainer.removeChild(child1);
			assertTrue( "removeChildCheck 1", guiObjectContainer.numChildren == 2 );
			assertTrue( "removeChildCheck 2", guiObjectContainer.getChildAt(0) == child2 );
			
			guiObjectContainer.removeChildAt(0);
			assertTrue( "removeChildCheck 3", guiObjectContainer.getChildAt(0) == child3 );
			assertTrue( "removeChildCheck 4", guiObjectContainer.numChildren == 1 );
			
			guiObjectContainer.removeChildAt( guiObjectContainer.getChildIndex(child3));
			
			assertTrue( "removeChildCheck 5", guiObjectContainer.numChildren == 0 );
			
			trace( guiContext.invalidation.stats );
			
		}
		
		[Test(order=10)]
		public function testAddRemoveNested():void
		{
			
		}
	}
}
