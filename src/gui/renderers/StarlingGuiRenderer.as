package gui.renderers 
{
	import gui.core.GuiContext;
	import gui.render.GuiRenderRequest;
	import gui.render.GuiRenderer;
	import gui.renderers.starling.StarlingGuiBitmap;
	import gui.utils.Factory;
	import gui.utils.FactoryMap;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;



	
	/**
	 * Renders a GuiContext using Starling compatible IGuiObjectRenderers.
	 */
	public class StarlingGuiRenderer extends GuiRenderer
	{
		private var factory:Factory;
		
		private var _starling:DisplayObjectContainer;
		
		// default texture to provide Starling Display Objects with
		private var _defaultTexture:Texture;
		
		public function get defaultTexture():Texture
		{
			return _defaultTexture;
		}
		
		/**
		 * The StarlingGuiRenderer renders a GuiContext to a Starling DisplayObjectContainer mapping
		 * each GuiObject to a specific Starling compatible DisplayObject.
		 * 
		 * A default texture has to be passed to this class due to the way Starling expects a Texture
		 * in some Starling DisplayObject's constructor.  This isn't ideal but is an easy workaround.
		 * 
		 * @param $context The GuiContext to render
		 * @param $starling The root Starling DisplayObjectContainer to render to.
		 * @param $defaultTexture Default texure to Starling DisplayObjects that require textures.
		 */
		public function StarlingGuiRenderer($context:GuiContext, $starling:DisplayObjectContainer, $defaultTexture:Texture)
		{
			factory 	= new Factory( new FactoryMap(StarlingGuiBitmap) );
			_starling 		= $starling;
			_defaultTexture = $defaultTexture;
			
			super($context);
		}
		
		/**
		 * Render implementation for Starling container.
		 */
		override public function render($queue:Vector.<GuiRenderRequest>):void
		{
			if( requiresRender )
			{
				requiresRender = false;
				//trace( "Render Starling :" + $queue.length );
				
				var i:uint = 0;
				var l:uint = $queue.length;
				var item:GuiRenderRequest;
				var image:StarlingGuiBitmap;
				
				var root:DisplayObjectContainer = _starling;
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
					
					image 			= factory.create(item, {texture:_defaultTexture}, [_defaultTexture]);
					
					// passes control to renderer for positioning.
					image.renderRequest(item, this);
					root.addChild( image );
				}
			}
			 
		}	
	}
}