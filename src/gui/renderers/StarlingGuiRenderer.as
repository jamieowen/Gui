package gui.renderers {
	import gui.core.GuiContext;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.utils.Factory;
	import gui.utils.FactoryMap;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	import flash.display.BitmapData;


	
	/**
	 * Renders a GuiContext using Starling based GPU renderers.
	 */
	public class StarlingGuiRenderer extends GuiRenderer
	{
		private var factory:Factory;
		
		private var _root:DisplayObjectContainer;
		
		public var texture:Texture;
		
		public function StarlingGuiRenderer($context:GuiContext, $root:DisplayObjectContainer)
		{
			factory 	= new Factory( new FactoryMap(Image) );
			_root 		= $root;
			
			texture 	= Texture.fromBitmapData( new BitmapData(100,100,false,0xFF000000) );
			
			super($context);
		}
		
		
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
				
				var root:DisplayObjectContainer = _root;
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

					
					_root.addChild( image );
					
				}
			}
			 
		}	
	}
}