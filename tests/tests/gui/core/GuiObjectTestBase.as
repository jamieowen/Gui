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
	* Test Description
	*
	* @author jamieowen
	*/
	public class GuiObjectTestBase 
	{
		public static var guiContext:GuiContext;
		public static var guiObject:GuiObject;
		public static var guiObjectContainer:GuiObjectContainer;
		
		public function GuiObjectTestBase()
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
	}
}
