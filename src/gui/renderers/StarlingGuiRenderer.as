package gui.renderers
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import gui.core.GuiContext;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.utils.Factory;
	import gui.utils.FactoryMap;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;


	
	/**
	 * Renders a GuiContext using Starling based GPU renderers.
	 */
	public class StarlingGuiRenderer extends GuiRenderer
	{
		private var _starling:Starling;
		
		private var factory:Factory;
		
		/**
		 * Provides access to the Starling object.
		 */
		public function get starling():Starling
		{
			return _starling;
		}
		
		
		/**
		 * Creates a Starling G
		 */
		public function StarlingGuiRenderer($context:GuiContext, $stage:Stage)
		{
			// Possibly pass a starling DisplayObjectContainer to the Renderer instead.
			// The setup is too complicated and wrapping up a Starling instance prevents the GUI Renderer
			// being used more easily by existing setups.
			
			_starling = new Starling(DisplayObjectContainer,$stage);
			_starling.addEventListener( Event.CONTEXT3D_CREATE, _onStarlingStartupComplete );
			_starling.start();
			_starling.stage.addEventListener( TouchEvent.TOUCH, onTouchEvent );
			factory = new Factory( new FactoryMap(Image) );
			
			super($context,_starling);
		}
		
		override protected function startupComplete():void
		{
			// TEMP BITMAP.
			texture 	= Texture.fromBitmapData( new BitmapData(100,100,false,0xFF000000) );
			
			super.startupComplete();
		}
		
		public var texture:Texture;
		
		override public function render($queue:Vector.<GuiRenderRequest>):void
		{
			if( requiresRender )
			{
				requiresRender = false;
				//trace( "Render Starling :" + $queue.length );
				
				var i:uint = 0;
				var l:uint = $queue.length;
				var item:GuiRenderRequest;
				var image:Image;
				
				var root:DisplayObjectContainer = _starling.stage;
				var display:DisplayObject;
				
				while( root.numChildren )
				{
					display = root.getChildAt(0);
					root.removeChildAt(0);
					factory.dispose(display);
				}
				
				while( i<l )
				{
					item = $queue[i++];
					
					// instantiate here - but call guiRenderer.render( request ) to position
					image 			= factory.create(item, {texture:texture}, [texture]);
					
					
					if( item.clipRect )
					{
						//trace( "Clip : " + item.clipRect + " " + item.guiRect );
						image.x 		= item.clipRect.x;
						image.y 		= item.clipRect.y;
						image.width 	= item.clipRect.width;
						image.height 	= item.clipRect.height;						
					}else
					{
						image.x 		= item.guiRect.x;
						image.y 		= item.guiRect.y;
						image.width 	= item.guiRect.width;
						image.height 	= item.guiRect.height;
					}

					
					_starling.stage.addChild( image );
					
				}
			}
			 
		}
		
		protected function onTouchEvent( $event:TouchEvent ):void
		{
			//trace( $event  + " " + $event.target );
		}
		
		// handlers
		private function _onStarlingStartupComplete($event:Event):void
		{
			_starling.removeEventListener( Event.CONTEXT3D_CREATE, _onStarlingStartupComplete );
			startupComplete();
		}
			
			
	}
}