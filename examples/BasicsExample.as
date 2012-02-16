package {
	import starling.events.Event;
	import flash.events.Event;
	import gui.display.GuiBitmap;
	import starling.display.DisplayObjectContainer;
	import gui.renderers.StarlingGuiRenderer;
	import starling.core.Starling;
	import gui.core.GuiContext;
	import flash.display.Sprite;

	[SWF(width=740,height=1060,frameRate=60)]
	public class BasicsExample extends Sprite
	{
		// gui context.
		public var gui:GuiContext;
		
		// gui starling renderer
		public var starlingGui:StarlingGuiRenderer;
		
		// starling instance. 
		public var starling:Starling;
		
		
		public function BasicsExample()
		{
			// wait for starling to startup before initing GuiContext
			setupStarling();
		}
		
		private function setupStarling():void
		{
			starling = new Starling(StarlingView,stage);
			starling.addEventListener( starling.events.Event.CONTEXT3D_CREATE, setupGui);
			starling.start();
		}
		
		private function setupGui($e:starling.events.Event):void
		{
			$e.target.removeEventListener(starling.events.Event.CONTEXT3D_CREATE, setupGui);
			
			// gui startup
			gui 			= new GuiContext();
			gui.width 		= 640;
			gui.height		= 960;
			
			// turn off clipping on root.
			gui.clipChildren = false;
			
			// add 50 padding to check clipping
			gui.x = gui.y 	= 50; 
			
			// renderer
			starlingGui 	= new StarlingGuiRenderer(gui, (starling.stage.root as DisplayObjectContainer).getChildAt(0) as DisplayObjectContainer);
			
			addContent();
			
			// render
			addEventListener( flash.events.Event.ENTER_FRAME, guiUpdate );
		}
		
		protected function addContent():void
		{
			var bitmap:GuiBitmap = new GuiBitmap();
			bitmap.width 	= bitmap.height = 100;
			bitmap.skin 	= "logo";
			
			var bitmap2:GuiBitmap = new GuiBitmap();
			bitmap2.width = bitmap2.height = 100;
			bitmap2.skin = "background";
			bitmap2.x = bitmap2.y = 600;
			
			gui.addChild( bitmap );
			gui.addChild( bitmap2 );
			
			// renderer would need to be configured with skins to display when it encounters each GuiObject
			// renderer.skinMap.mapSkin( GuiBitmap, "logo", BitmapData );
		}
		
		// handlers
		protected function guiUpdate($event:flash.events.Event):void
		{
			gui.update();
		}
		
				
	}
}
import starling.display.DisplayObjectContainer;

internal class StarlingView extends DisplayObjectContainer
{
}
