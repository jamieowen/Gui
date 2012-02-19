package gui.renderers.starling.display {
	import starling.display.Image;
	import flash.geom.Point;
	import starling.core.RenderSupport;
	import starling.display.DisplayObjectContainer;
	import starling.textures.Texture;

	import flash.geom.Rectangle;

	/**
	 * @author jamieowen
	 */
	public class Scale3 extends DisplayObjectContainer
	{
		public static const SCALE_HORIZONTAL:uint 	= 0;
		public static const SCALE_VERTICAL:uint 	= 1;
		
		private var _images:Vector.<Image>;
		private var _texture:Texture;
		
		// scale properties
		private var _scale3_1:Number;
		private var _scale3_2:Number;
		private var _scaleDirection:Number;
		
		protected var requiresSizeUpdate:Boolean;
		protected var requiresUvUpdate:Boolean;
		
		private var _scaleX:Number;
		private var _scaleY:Number;
		
		// override width,height,scaleX,scaleY settings - otherwise
		// scale properties are applied to this object during the parent's render() process.
		// which affect the child images.
		override public function set width( $width:Number ):void
		{
			// set scale props 
			scaleX = $width/textureWidth;
		}
		
		override public function set height( $height:Number ):void
		{
			scaleY = $height/textureHeight;
		}
		
		// just override scaleX and scaleY - they will always return 1.0
		override public function set scaleX( $scaleX:Number ):void
		{
			if( _scaleX == $scaleX ) return;
			_scaleX = $scaleX;
			requiresSizeUpdate = true;
		}
		
		override public function set scaleY( $scaleY:Number ):void
		{
			if( _scaleY == $scaleY ) return;
			_scaleY = $scaleY;
			requiresSizeUpdate = true;
		}
		
        public function get texture():Texture { return _images[0].texture; }
        public function set texture(value:Texture):void 
        { 
            if (value == null)
            {
                throw new ArgumentError("Texture cannot be null");
            }
            else if (value != _images[0].texture)
            {
                var i:uint = 0;
				while( i<3 )
					_images[i++].texture = value;
					
				requiresUvUpdate   = true;
				requiresSizeUpdate = true;
            }
        }
		
		/**
		 * Return the texture size to calculate the actual size.
		 */
		private function get textureWidth():Number
		{
            var frame:Rectangle = texture.frame;
            return frame ? frame.width  : texture.width;
		}
		
		private function get textureHeight():Number
		{
            var frame:Rectangle = texture.frame;
           	return frame ? frame.height : texture.height;
		}
		
		
		public function Scale3($texture:Texture, $scale3_1:Number,$scale3_2:Number, $scaleDirection:uint = 0)
		{
			if( $texture == null ) throw new ArgumentError("Texture must not be null");
			
			_texture = $texture;
			_images = new Vector.<Image>(3,true);
			
			var i:uint = 0;
			while( i<3 )
			{
				_images[i] = new Image(_texture);
				addChild(_images[i++]);
			}
				
			_scale3_1 = $scale3_1;
			_scale3_2 = $scale3_2;
			_scaleDirection = $scaleDirection;
			
			_scaleX = _scaleY = 1.0;
			
			// size the images vertex data positions and uvs next render()
			requiresUvUpdate   = true;
			requiresSizeUpdate = true;									
		}
		
		/**
		 * Call whenever the scale3 grid or texture changes
		 * Readjusts VertexData positions.
		 */
		private function readjustSize():void
		{
            var frame:Rectangle = texture.frame;
            var width:Number  = frame ? frame.width  : texture.width;
            var height:Number = frame ? frame.height : texture.height;
			
			// get lengths and positions without any scaling.
			var len1:Number = _scale3_1;
			var len3:Number = _scaleDirection == SCALE_HORIZONTAL ? width-_scale3_2 : height-_scale3_2;
			
			var pos2:Number = len1;
			
			var uv1:Number = _scale3_1/(_scaleDirection == SCALE_HORIZONTAL ? width : height);
			var uv2:Number = _scale3_2/(_scaleDirection == SCALE_HORIZONTAL ? width : height); 
			
			trace( "scale 3 : " + width + " " + height + " " + (width*_scaleX) + " " + (height*_scaleY) );
			if( _scaleDirection == SCALE_HORIZONTAL )
			{
				_images[0].y = _images[1].y = _images[2].y = 0.0;
				_images[0].x = 0.0;
				_images[1].x = pos2;
				_images[2].x = (width*_scaleX)-len3;//pos3*_scaleX;
				
				
				_images[0].height = _images[1].height = _images[2].height = height*_scaleY;
				
				_images[0].width = len1; // no scaling for left or right images
				_images[1].width = (width*_scaleX)-len1-len3;
				_images[2].width = len3;
				
				// set uvs.
				if( requiresUvUpdate )
				{
					requiresUvUpdate = false;
					
					_images[0].setTexCoords(0,new Point(0.0,0.0));
					_images[0].setTexCoords(1,new Point(uv1,0.0));
					_images[0].setTexCoords(2,new Point(0.0,1.0));
					_images[0].setTexCoords(3,new Point(uv1,1.0));
	
					_images[1].setTexCoords(0,new Point(uv1,0.0));
					_images[1].setTexCoords(1,new Point(uv2,0.0));
					_images[1].setTexCoords(2,new Point(uv1,1.0));
					_images[1].setTexCoords(3,new Point(uv2,1.0));
					
					_images[2].setTexCoords(0,new Point(uv2,0.0));
					_images[2].setTexCoords(1,new Point(1.0,0.0));
					_images[2].setTexCoords(2,new Point(uv2,1.0));
					_images[2].setTexCoords(3,new Point(1.0,1.0));
				}
				
			}else
			if( _scaleDirection == SCALE_VERTICAL )
			{
				_images[0].x = _images[1].x = _images[2].x = 0.0;
				_images[0].y = 0.0;
				_images[1].y = pos2;
				_images[2].y = (height*_scaleY)-len3;

				_images[0].width = _images[1].width = _images[2].width = width*_scaleX;
				
				_images[0].height = len1; // no scaling for top or bottom images
				_images[1].height = (height*_scaleY)-len1-len3;
				_images[2].height = len3;
				
				_images[0].setTexCoords(0,new Point(0.0,0.0));
				_images[0].setTexCoords(1,new Point(1.0,0.0));
				_images[0].setTexCoords(2,new Point(0.0,uv1));
				_images[0].setTexCoords(3,new Point(1.0,uv1));
	
				_images[1].setTexCoords(0,new Point(0.0,uv1));
				_images[1].setTexCoords(1,new Point(1.0,uv1));
				_images[1].setTexCoords(2,new Point(0.0,uv2));
				_images[1].setTexCoords(3,new Point(1.0,uv2));
					
				_images[2].setTexCoords(0,new Point(0.0,uv2));
				_images[2].setTexCoords(1,new Point(1.0,uv2));
				_images[2].setTexCoords(2,new Point(0.0,1.0));
				_images[2].setTexCoords(3,new Point(1.0,1.0));
			}
		}
		
        override public function render(support:RenderSupport, alpha:Number):void
        {
			if( requiresSizeUpdate )
			{
				requiresSizeUpdate = false;
				readjustSize();
			}
			
			super.render(support, alpha);
        }
	}
}
