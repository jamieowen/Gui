package gui.display
{
	import flash.geom.Matrix;
	import gui.events.GuiEvent;
	import gui.core.IScrollable;
	import gui.core.IClippable;
	import gui.core.GuiObjectContainer;
	
	/**
	* Defines a scrollable container who's children are offset by the <code>scrollMatrix</code>
	*
	* @author jamieowen
	*/
	public class GuiScrollContainer extends GuiObjectContainer implements  IScrollable,IClippable
	{
		private var _scrollPositionX:Number;
		
		private var _scrollPositionY:Number;
		
		private var _clipChildren:Boolean;
		
		public function get clipChildren():Boolean
		{
			return _clipChildren;
		}
		
		public function set clipChildren( $value:Boolean ):void
		{
			_clipChildren = $value;
		}
		
		public function get scrollMatrix():Matrix
		{
			if( _scrollPositionX != 0.0 || _scrollPositionY != 0.0 ){ 
				var scroll:Matrix = new Matrix();
				scroll.translate(_scrollPositionX, _scrollPositionY );
				return scroll;
			}else
				return null;
		}
		
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
			if( context ) context.invalidation.onScrolled(this);
		}
		
		// scrollMinimumX - width?
		// scrollMaximumX
		// scrollMinimumY - height?
		// scrollMaximumY
		
		/**
		 * 
		* Creates the scrollable container.
		*/
		public function GuiScrollContainer()
		{
			_scrollPositionX = _scrollPositionY = 0.0;
			_clipChildren = true;
		}
	}
}