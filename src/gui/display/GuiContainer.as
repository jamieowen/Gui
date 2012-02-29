package gui.display
{
	import flash.geom.Matrix;
	import gui.events.GuiEvent;
	import gui.core.IScrollable;
	import gui.core.GuiObjectContainer;
	
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class GuiContainer extends GuiObjectContainer implements  IScrollable
	{
		private var _scrollPositionX:Number;
		
		private var _scrollPositionY:Number;
		
		public function get scrollPositionX():Number
		{
			return _scrollPositionX;
		}
		
		public function set scrollPositionX($position:Number):void
		{
			if( _scrollPositionX == $position ) return;
			_scrollPositionX = $position;
			dispatchEvent( new GuiEvent(GuiEvent.SCROLL,this));
			if( context ) context.invalidation.onScrolled(this);
		}
		
		public function get scrollPositionY():Number
		{
			return _scrollPositionY;
		}
		
		public function set scrollPositionY($position:Number):void
		{
			if( _scrollPositionY == $position ) return;
			_scrollPositionY = $position;
			dispatchEvent( new GuiEvent(GuiEvent.SCROLL,this));
			if( context ) context.invalidation.onScrolled(this);
		}
		
		override public function get transformationMatrix():Matrix
		{
			var m:Matrix = new Matrix();
			//if( _scaleX != 0.0 || _scaleY != 0.0 ) m.scale(_scaleX,_scaleY);
			//if( _rotation != 0.0 ) m.rotate(_rotation);
			if( _x != 0.0 || _y != 0.0 ) m.translate(_x,_y);
			if( _scrollPositionX != 0.0 || _scrollPositionY != 0.0 ) m.translate(_scrollPositionX, _scrollPositionY);
			
			return m;
		}
		
		/**
		* Class Constructor Description
		*/
		public function GuiContainer()
		{
			super();
			
			_scrollPositionX = _scrollPositionY = 0.0;
		}
	}
}