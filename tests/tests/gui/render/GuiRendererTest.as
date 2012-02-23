package tests.gui.render
{
	import flash.utils.getTimer;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import tests.helpers.IndexerTestDataHelper;
	import flash.geom.Point;
	import tests.helpers.TestGuiObject;
	import tests.gui.renderers.GuiRendererTestImplSkin;
	import gui.core.GuiContext;
	import tests.gui.renderers.GuiRendererTestImpl;
	/**
	* Test Description
	*
	* @author jamieowen
	*/
	public class GuiRendererTest 
	{
		public static var context:GuiContext;
		public static var renderer:GuiRendererTestImpl;
		
		/**
		 * 
		 */
		[BeforeClass]
		public static function initialise():void
		{
			context  = new GuiContext();
			renderer = new GuiRendererTestImpl(context);
			
			renderer.skins.register(TestGuiObject.DEFAULT_SKIN_NAME, GuiRendererTestImplSkin);
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
			var depth:uint = 6;
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
			
	}
}