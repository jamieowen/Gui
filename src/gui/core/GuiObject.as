package gui.core {
	import gui.errors.AbstractClassError;
	import gui.events.GuiEvent;

	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * Base class for all GuiObjects to inherit from.
	 */
	public class GuiObject extends EventDispatcher
	{
		private var _name:String;
		private var _skin:String;
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		//private var _rotation:Number; // implement later
		//private var _scaleX:Number;
		//private var _scaleY:Number;
		
		private var _visible:Boolean;
		
		private var _parent:GuiObjectContainer;
		
		/**
		 * Gets the x coordinate.
		 */
		public function get x():Number
		{
			return _x;
		}

		/**
		 * Sets the x coordinate.
		 */
		public function set x($x:Number):void
		{
			if( _x == $x ) return;
			_x = $x;
			dispatchEvent( new GuiEvent(GuiEvent.MOVE,this) );
			if( context ) context.invalidation.onMoved(this);
		}
		
		/**
		 * Gets the y coordinate.
		 */
		public function get y():Number
		{
			return _y;
		}
		
		/**
		 * Sets the y coordinate.
		 */
		public function set y($y:Number):void
		{
			if( _y == $y ) return;
			_y = $y;
			dispatchEvent( new GuiEvent(GuiEvent.MOVE,this) );
			if( context ) context.invalidation.onMoved(this);
		}
		
		/**
		 * Gets the GuiObject width.
		 */
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets the GuiObject width.
		 */
		public function set width($width:Number):void
		{
			if( _width == $width ) return;
			_width = $width;
			dispatchEvent( new GuiEvent(GuiEvent.RESIZE,this) );
			if( context ) context.invalidation.onResized(this);
		}
		
		/**
		 * Gets the GuiObject's height
		 */
		public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Sets the GuiObject's height
		 */
		public function set height($height:Number):void
		{
			if( _height == $height ) return;
			_height = $height;
			dispatchEvent( new GuiEvent(GuiEvent.RESIZE,this) );
			if( context ) context.invalidation.onResized(this);
		}
		
		/**
		 * Returns the GuiObject's name
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * Sets the GuiObject's name.
		 */
		public function set name($name:String):void
		{
			_name = $name;
		}
		
		/**
		 * Returns the GuiObject's skin name.
		 */
		public function get skin():String
		{
			return _skin;
		}

		/**
		 * Sets the GuiObject's skin.
		 */
		public function set skin($skin:String):void
		{
			if( _skin == $skin ) return;
			_skin = $skin;
			dispatchEvent( new GuiEvent(GuiEvent.SKIN_CHANGE,this) );
			if( context ) context.invalidation.onSkinChanged(this);
		}
		
		/**
		 * Returns the GuiObject's parent.
		 */
		public function get parent():GuiObjectContainer
		{
			return _parent;
		}
		
		/**
		 * Returns the root Context
		 */
		public function get context():GuiContext
		{
			if( _context ) return _context;
			else if( parent ) return parent.context;
			else return null;
		}
		
		private var _context:GuiContext;
		internal function setContext( $guiContext:GuiContext ):void
		{
			_context = $guiContext;
		}

		/**
		 * Returns the objects current transformation as a matrix.
		 */
		public function get transformationMatrix():Matrix
		{
			var m:Matrix = new Matrix();
			//if( _scaleX != 0.0 || _scaleY != 0.0 ) m.scale(_scaleX,_scaleY);
			//if( _rotation != 0.0 ) m.rotate(_rotation);
			if( _x != 0.0 || _y != 0.0 ) m.translate(_x,_y);
			
			if( parent is IScrollable && ( parent as IScrollable ).scrollMatrix ) m.concat( ( parent as IScrollable ).scrollMatrix );
			return m;
		}
		
		/**
		 * Creates a new GuiObject
		 */
		public function GuiObject()
		{
			if (getQualifiedClassName(this) == "gui.core::GuiObject")
				throw new AbstractClassError();
				
			_x = _y = _width = _height = 0.0;
			//_rotation = 0.0;
			//_scaleX = _scaleY = 1.0;
			_name = _skin = "";
			_visible = true;
		}
		
		// Methods
		
		/**
		 * Returns the objects position in global coordinates.
		 */
		public function localToGlobal(localPoint:Point):Point
		{
			var transform:Matrix = new Matrix();
			var current:GuiObject = this;
			while( current )
			{
				transform.concat(current.transformationMatrix);
				current = current.parent;
			}
			return transform.transformPoint(localPoint);
		}
		
		/**
		 * Basic bounds function not taking into account any other scaling or rotation
		 * transformations that may create later.
		 */
		public function getGlobalBounds():Rectangle
		{
			var point:Point = localToGlobal(new Point(0,0));
			return new Rectangle(point.x,point.y,width,height);
		}
	
		
		internal function setParent($value:GuiObjectContainer):void 
		{ 
			// events/notifications sent by container.
			_parent = $value;
		}
	}
}