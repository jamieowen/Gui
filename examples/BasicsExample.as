package {
	import gui.renderers.starling.display.Scale3;
	import gui.renderers.starling.display.ScaleImage;
	import flash.geom.Point;
	import starling.display.Button;
	import gui.renderers.starling.display.ImageScale3;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.display.DisplayObjectContainer;
	import fr.kouma.starling.utils.Stats;

	import gui.core.GuiContext;
	import gui.display.GuiBitmap;
	import gui.renderers.StarlingGuiRenderer;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(width=740,height=1060,frameRate=60)]
	public class BasicsExample extends Sprite
	{
		// font sources
		[Embed(source="assets/arial-black-20pt.png")]
		private static var ArialBlackPNG:Class;
		
		[Embed(source="assets/arial-black-20pt.fnt",mimeType="application/octet-stream")]
		private static var ArialBlackXML:Class;
		
		[Embed(source="assets/picons.png")]
		private static var PiconsPNG:Class;
		
		[Embed(source="assets/picons.fnt", mimeType="application/octet-stream")]
		private static var PiconsXML:Class;
		
		// textures
		[Embed(source="assets/gui.png")]
		private static var GuiSkinsPNG : Class;
		
		[Embed(source="assets/gui.xml", mimeType="application/octet-stream")]
		private static var GuiSkinsXML : Class;
		
		// gui context.
		public var gui:GuiContext;
		
		// gui starling renderer
		public var starlingGui:StarlingGuiRenderer;
		
		// starling instance. 
		public var starling:Starling;
		
		
		public function BasicsExample()
		{
			stage.align 	= StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
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
			
			// add 50 padding to show clipping effect
			gui.x = gui.y 	= 50; 
			
			// renderer output
			var root:DisplayObjectContainer = (starling.stage.root as DisplayObjectContainer).getChildAt(0) as DisplayObjectContainer;
			// renderer
			starlingGui 	= new StarlingGuiRenderer(gui,root,Texture.fromBitmapData( new BitmapData(640, 88,false,0xFF444444) ) as starling.textures.Texture );
			
			// doob stats
			//var stats:Stats = new Stats();
			//starling.stage.addChild( stats );
			
			customizeSkins();
			addContent();
			
			// render
			addEventListener( flash.events.Event.ENTER_FRAME, guiUpdate );
		}
		
		protected function customizeSkins():void
		{
			// renderer would need to be configured with skins to display when it encounters each GuiObject
			// renderer.skinMap.mapSkin( GuiBitmap, "logo", BitmapData );
			
			// new BitmapSkin( "logo", LogoBitmap, scale9Rect );
			// new BitmapSkin( "backButton.up", BackButtonUp, scale9Rect );
			// new BitmapSkin( "backButton.press", BackButtonPress, scale9Rect );
			// new BitmapSkin( "backButton.down", BackButtonDown, scale9Rect );
			
			// new BitmapSkin( "myList.listItemBG", ListItemBG, scale9Rect );
			
			// Need some introduction of a TextureAtlas / BitmapSpriteSheet.
			
			// black-button
			// list-item
			// header-item
			// nav-bar
			
			// font
			var ArialBlackT:Texture = Texture.fromBitmap( new ArialBlackPNG() as Bitmap ) as starling.textures.Texture; // FDT giving an error on Texture for some reason.. ( hence the long package ref )
			var ArialBlackX:XML 	= XML( new ArialBlackXML() );
			
			TextField.registerBitmapFont(new BitmapFont(ArialBlackT, ArialBlackX)); // "Arial-Black"
			
			var uiAtlasT:Texture 		= Texture.fromBitmap( new GuiSkinsPNG() as Bitmap ) as starling.textures.Texture;
			var uiAtlasX:XML 	 		= XML( new GuiSkinsXML() );
			var uiAtlas:TextureAtlas 	= new TextureAtlas(uiAtlasT,uiAtlasX);
			
			var buttonTexture:Texture = uiAtlas.getTexture("black-button");
			
			var image:Image = new Image(buttonTexture);
			
			var container:DisplayObjectContainer = starling.stage.root as DisplayObjectContainer;
			//container.addChild( image );
			
			trace( "w" + image.width + " " + image.scaleX );
			image.scaleX = 1.7;
			trace( "w" + image.width + " " + image.scaleX );
			image.scaleX = 1;
			trace( "w" + image.width + " " + image.scaleX );
			
			
			var text:TextField = new TextField(100, 100, "Testing", "Arial-Black", BitmapFont.NATIVE_SIZE, 0xFFFFFF );
			text.vAlign = VAlign.TOP;
			text.hAlign = HAlign.LEFT;
			text.x = 30;
			text.y = 415;
			
			var scale3:Scale3 = new Scale3(buttonTexture,19,41);
			container.addChild( scale3 );
			scale3.x = 0;
			scale3.y = 400;
			scale3.width = 400;
			
			var scale32:Scale3 = new Scale3(buttonTexture,35,41,Scale3.SCALE_VERTICAL);
			container.addChild( scale32 );
			scale32.x = 0;
			scale32.y = 461;
			scale32.height = 400;
			
			container.addChild( text );
		}

		
		protected function addContent():void
		{
			var bitmap:GuiBitmap = new GuiBitmap();
			bitmap.width 	= 640;
			bitmap.height   = 88;
			bitmap.skin 	= "logo";
			
			var bitmap2:GuiBitmap = new GuiBitmap();
			bitmap2.width = bitmap2.height = 100;
			bitmap2.skin = "background";
			
			bitmap2.x = bitmap2.y = 600;
			
			gui.addChild( bitmap );
			gui.addChild( bitmap2 );

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
