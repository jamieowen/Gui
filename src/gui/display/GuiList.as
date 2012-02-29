package gui.display {
	import dump.nodes.SceneGroupNode;
	import gui.events.GuiEvent;
	import flashx.textLayout.events.ScrollEvent;
	import gui.core.IScrollable;
	import gui.core.GuiObjectContainer;

	/**
	 * @author jamieowen
	 */
	public class GuiList extends GuiObjectContainer implements IScrollable
	{
		// change flags.
		protected var changedSize:Boolean;
		
		protected var changedData:Boolean;
		
		protected var itemContainer:GuiContainer;
		
		protected var scrollIndicator:GuiScrollBar;
		
		private var _scrollDirection:uint;
		
		private var _itemSize:Number;
		
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
		
		/** Default item width or height, depending on scroll direction. Set to 0 to use the item renderer's height. **/
		public function set itemSize($value:Number):void
		{
			_itemSize = $value;
		}
		
		public function GuiList()
		{
			super();
			
			nodeAsGroup.clipChildren = true;
			itemContainer.addEventListener( GuiEvent.SCROLL, onScroll, false, 0, true );
		}
		
		override public function update():void
		{
			if( changedSize )
			{
				itemContainer.width = width;
				itemContainer.height = height;
				
				
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			itemContainer.removeEventListener( GuiEvent.SCROLL, onScroll);
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
