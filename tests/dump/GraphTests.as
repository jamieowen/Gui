package dump {
	import gui.core.context.GuiContext;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import gui.core.context.GuiContextOld;
	import gui.core.objects.GuiObjectContainer;
	import gui.core.traverser.RenderCollector;
	import gui.display.GuiContainer;
	import gui.display.GuiList;
	import gui.renderers.DisplayListRenderer;
	import gui.renderers.displaylist.DisplayListGuiBitmap;
	import org.osmf.display.ScaleMode;
	import tests.helpers.IndexerTestDataHelper;




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
			
			var list:GuiList = new GuiList();
			list.x = list.y = 0;
			list.width = list.height = 200;
			
			toRender.addChild( list );
			
			renderer = new RenderCollector(toRender);
			
			var bitmap:BitmapData = new BitmapData(100, 100,true,0x55FF0000);
			var bitmapClip:BitmapData = new BitmapData(100, 100,true,0x99000000);
			
			display 	= new DisplayListRenderer(new GuiContext(GuiContainer), this);
			
			display.skins.register("*", DisplayListGuiBitmap, {bitmapData:bitmap});
			display.skins.register("square", DisplayListGuiBitmap, {bitmapData:bitmap});
			display.skins.register("squareClip", DisplayListGuiBitmap, {bitmapData:bitmapClip});
			
			graphics.clear();
			graphics.lineStyle(1,0x0000FF);
			graphics.drawRect(0, 0, renderer.viewRect.width, renderer.viewRect.height);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		protected function onEnterFrame( $event:Event ):void
		{
			var time:Number = getTimer();
			renderer.render();
			time = getTimer()-time;
			//trace( "Render time : " + (time/1000) );
			
			// TODO display.render( renderer.renderList );
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}
