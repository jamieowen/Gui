package gui.display
{
	import gui.core.IScrollable;
	import gui.core.objects.GuiObjectContainer;
	import gui.enum.GuiScrollDirection;
	
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class GuiScrollBar extends GuiObjectContainer
	{
		protected var _target:IScrollable;
		
		protected var scrollBackground:GuiBitmap;
		
		protected var scrollBar:GuiBitmap;
		
		private var _scrollDirection:uint;
		
		public function set scrollDirection($value:uint):void
		{
			_scrollDirection = $value;
		}
		
		public function get scrollDirection():uint
		{
			return _scrollDirection;
		}
		
		/**
		* Class Constructor Description
		*/
		public function GuiScrollBar($target:IScrollable)
		{
			_target = $target;
			
			scrollBackground = new GuiBitmap();
			scrollBar 		 = new GuiBitmap();
			
			scrollBar.skin = scrollBackground.skin = "scroll";
			
			addChild( scrollBackground );
			addChild( scrollBar );
			
			changedSize = true;
			invalidate();
			
			_scrollDirection = GuiScrollDirection.VERTICAL;
		}
		
		override public function update():void
		{
			if( changedSize )
			{
				changedSize = false;
				
				scrollBackground.width  = width;
				scrollBackground.height = height; 
				
				if( _scrollDirection == GuiScrollDirection.VERTICAL )
				{
					scrollBar.height = height/2;
					scrollBar.width  = width;
				}else
				if( _scrollDirection == GuiScrollDirection.HORIZONTAL )
				{
					scrollBar.height = height;
					scrollBar.width  = width/2;
				}
				
			}
		}
	}
}