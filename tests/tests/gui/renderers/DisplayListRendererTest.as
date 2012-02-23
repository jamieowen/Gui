package tests.gui.renderers {
	import gui.core.GuiContext;
	import gui.renderers.DisplayListRenderer;
	import gui.renderers.displaylist.DisplayListGuiBitmap;

	import tests.helpers.IndexerTestDataHelper;
	import tests.helpers.TestGuiObject;

	import org.flexunit.asserts.assertTrue;
	import org.fluint.uiImpersonation.UIImpersonator;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	/**
	* Test Description
	*
	* @author jamieowen
	*/
	public class DisplayListRendererTest 
	{
		public static var context:GuiContext;
		public static var renderer:DisplayListRenderer;
		
		// THE TESTING FUNCTIONS CAN REALLY BE MOVED TO A BASE CLASS - AS WE DID WITH INDEXER TESTS.
		// WE ONLY HAVE TO DEFINE THE RENDERER AND CONTEXT IN THE STATIC METHODS BELOW.
		
		/**
		 * 
		 */
		[BeforeClass]
		public static function initialise():void
		{
			var sprite:Sprite = new Sprite();
			UIImpersonator.addChild(sprite);
			
			context  = new GuiContext();
			renderer = new DisplayListRenderer(context, sprite);
			
			var bitmap:BitmapData = new BitmapData(100, 100,true,0x55FF0000);
			
			renderer.skins.register(TestGuiObject.DEFAULT_SKIN_NAME, DisplayListGuiBitmap, {bitmapData:bitmap});
		}

		/**
		 * 
		 */	
		[AfterClass]
		public static function dispose():void
		{
			renderer.dispose();
			context.dispose();
			
			context  = null; 
			renderer = null;
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
		 * Test adding objects and assert if renderer picks up changes.
		 */
		[Test(order=1)]
		public function addObjectsToContext():void
		{ 
			var count:Point = new Point();
			var depth:uint = 4;
			// renderer should pick up changes.
			IndexerTestDataHelper.create4Square(context, IndexerTestDataHelper.SQUARE_SMALL_SIZE, IndexerTestDataHelper.SQUARE_SMALL_PADDING, 0, depth, count);
			var total:uint = count.x + count.y;
			
			var time:Number = getTimer();
			// trigger update to trigger invalidatiSton.
			context.update();
			
			time = ( getTimer() - time )/1000;
			trace( "Render time : " + total + " " + time + " secs" );
			
			// assertions on renderer stats
			assertTrue( "render totals do not match :" + total + " " + renderer.stats.total,total == renderer.stats.total );
			assertTrue( "container counts do not match",count.x == renderer.stats.numContainers ); // containers are not rendererd i.e. no skin created.
			assertTrue( "attached do not match", count.y == renderer.stats.attached );
			assertTrue( "existing do not match", 0 == renderer.stats.existing ); 
			assertTrue( "released do not match",0 == renderer.stats.released );
		}
		
		[Test(order=2)]
		public function removeObjectsFromContext():void
		{
			
		}
			
	}
}