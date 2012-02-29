package dump {
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import org.osmf.display.ScaleMode;
	import gui.renderers.displaylist.DisplayListGuiBitmap;
	import flash.display.BitmapData;
	import gui.core.GuiContext;
	import gui.renderers.DisplayListRenderer;
	import flash.utils.getTimer;
	import dump.traverser.RenderCollector;

	import gui.core.GuiObjectContainer;
	import gui.display.GuiContainer;

	import tests.helpers.IndexerTestDataHelper;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * @author jamieowen
	 */
	[SWF(width=1000,height=1000,frameRate=60)]
	public class GraphTests extends Sprite
	{
		private var renderer:RenderCollector;
		private var display:DisplayListRenderer;
		
		public function GraphTests()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var toRender:GuiObjectContainer = new GuiContainer();
			var count:Point = new Point();
			
			IndexerTestDataHelper.createClippedScrolling4Square(toRender, 800, 7, 0, 2, count );
			//IndexerTestDataHelper.createClipped4Square(toRender, 800, 7, 0, 4, count );
			//IndexerTestDataHelper.create4Square(toRender, 800, 5, 0, 5, count );
			trace( count );
			
			renderer = new RenderCollector(toRender);
			

			
			var bitmap:BitmapData = new BitmapData(100, 100,true,0x55FF0000);
			var bitmapClip:BitmapData = new BitmapData(100, 100,true,0x99000000);
			
			display 	= new DisplayListRenderer(new GuiContext(GuiContainer), this);
			display.skins.register("square", DisplayListGuiBitmap, {bitmapData:bitmap});
			display.skins.register("squareClip", DisplayListGuiBitmap, {bitmapData:bitmapClip});
			
			
			var test:GuiContainer = new GuiContainer();
			var contain:GuiContainer = new GuiContainer();
			var test2:GuiContainer = new GuiContainer();
			test2.addChild( test );
			contain.addChild( test2 );
			
			contain.addEventListener( Event.COMPLETE, onTest);
			
			test.dispatchEvent( new Event(Event.COMPLETE,true) );
			
			graphics.clear();
			graphics.lineStyle(1,0x0000FF);
			graphics.drawRect(0, 0, renderer.viewRect.width, renderer.viewRect.height);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
		}
		
		protected function onTest($event:Event):void
		{
			trace( "TESTSTST");
		}
		
		protected function onEnterFrame( $event:Event ):void
		{
			var time:Number = getTimer();
			renderer.render();
			time = getTimer()-time;
			//trace( "Render time : " + (time/1000) );
			display.render( renderer.renderList );
		}
	}
}
