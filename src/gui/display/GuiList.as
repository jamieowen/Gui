package gui.display {
	import gui.core.GuiObjectContainer;
	import gui.core.IScrollable;
	import gui.enum.GuiScrollDirection;
	import gui.events.GuiEvent;

	/**
	 * @author jamieowen
	 */
	public class GuiList extends GuiObjectContainer implements IScrollable
	{
		// change flags.		
		protected var changedData:Boolean;
		
		protected var itemContainer:GuiContainer;
		
		protected var scrollIndicator:GuiScrollBar;
		
		private var _scrollDirection:uint;
		
		private var _itemSize:Number;
		
		private var _scrollIndicatorSize:Number;
		
		public function set scrollDirection($value:uint):void
		{
			_scrollDirection = $value;
		}
		
		public function get scrollDirection():uint
		{
			return _scrollDirection;
		}
		
		public function get scrollPositionX():Number
		{
			return itemContainer.scrollPositionX;
		}
		
		public function set scrollPositionX($position:Number):void
		{
			itemContainer.scrollPositionX = $position;
		}
		
		public function get scrollPositionY():Number
		{
			return itemContainer.scrollPositionY;
		}
		
		public function set scrollPositionY($position:Number):void
		{
			itemContainer.scrollPositionY = $position;
		}
		
		/** Default item width or height, depending on scroll direction. Set to 0 to use the item renderer's height after instantiated. **/
		public function set itemSize($value:Number):void
		{
			_itemSize = $value;
			changedSize = true;
		}
		
		/** Default width or heigh of the scrollIndicator, depending on the scroll**/
		public function set scrollIndicatorSize($value:Number):void
		{
			_scrollIndicatorSize = $value;
			changedSize = true;
		}
		
		public function GuiList()
		{
			super();
			
			//nodeAsGroup.clipChildren = true;
			
			itemContainer = new GuiContainer();
			addChild( itemContainer );
			scrollIndicator = new GuiScrollBar(this);
			addChild( scrollIndicator );
			itemContainer.addEventListener( GuiEvent.SCROLL, onScroll, false, 0, true );
			
			_scrollDirection = GuiScrollDirection.VERTICAL;
			_scrollIndicatorSize = 6;
			
			changedSize = true;
			invalidate();
			
			skin 				 = "guiList";
			itemContainer.skin 	 = "guiList.items";
			scrollIndicator.skin = "guiList.indicator";
		}
		
		override public function update():void
		{
			if( changedSize )
			{
				changedSize = false;
				
				itemContainer.width = width;
				itemContainer.height = height;
				itemContainer.x = itemContainer.y = 0;
				
				if( _scrollDirection == GuiScrollDirection.VERTICAL )
				{
					scrollIndicator.width 	= _scrollIndicatorSize;
					scrollIndicator.height 	= height;
					
					scrollIndicator.x 		= width-_scrollIndicatorSize;
					scrollIndicator.y 		= 0;
				}else
				if( _scrollDirection == GuiScrollDirection.HORIZONTAL )
				{
					scrollIndicator.width 	= width;
					scrollIndicator.height 	= _scrollIndicatorSize;
					
					scrollIndicator.x 		= 0;
					scrollIndicator.y 		= height-_scrollIndicatorSize;
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeAllChildren();
			
			itemContainer.dispose();
			scrollIndicator.dispose();			
			
			itemContainer.removeEventListener(GuiEvent.SCROLL, onScroll);
			
			itemContainer 	= null;
			scrollIndicator = null;
		}
		
		// ------------------------------------------------------------------
		// --------------------------------------------------- event handlers
		// ------------------------------------------------------------------
		
		protected function onScroll( $event:GuiEvent ):void
		{
			dispatchEvent( $event.clone() );
		}
		
	}
}
