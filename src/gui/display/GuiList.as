package gui.display {
	import gui.gestures.ISwipeLeftRight;
	import gui.core.objects.GuiObject;
	import gui.core.IScrollable;
	import gui.core.objects.GuiObjectContainer;
	import gui.enum.GuiScrollDirection;
	import gui.events.GuiEvent;

	/**
	 * @author jamieowen
	 */
	public class GuiList extends GuiObjectContainer implements IScrollable
	{
		/** If the data provider has changed **/		
		protected var changedData:Boolean;
		
		/** The container that will hold the item renderers and perform scrolling **/
		protected var itemContainer:GuiContainer;
		
		/** The scroll indicator **/
		protected var scrollIndicator:GuiScrollBar;
		
		/** The scroll direction **/
		private var _scrollDirection:uint;
		
		// -----------------
		// List ItemRenderer details.
		
		/** Vector of list items **/
		private var _dataItems:Array;
		
		private var _itemRendererClass:Class;
		
		private var _itemRendererFunction:Function;
		
		
		/** ************************* **/
		/** SIZES**/
		
		private var _itemSize:Number; // passed in from a measurements object in the context
		
		private var _scrollIndicatorSize:Number; // passed in from a measurements object in the context
		
		/** ************************* **/

		
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
		
		public function get dataItems():Array
		{
			return _dataItems;
		}
		
		public function set dataItems( $dataItems:Array ):void
		{
			_dataItems = $dataItems;
			changedData = true;
			invalidate();
		}
		
		/** ************************* **/
		/** SIZES - SHOULD BE MOVED **/
		
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
		
		/** ************************* **/
				
		
		/**
		 * Creates a new List.
		 */
		public function GuiList()
		{
			super();
			
			// TODO global clip feature?
			//nodeAsGroup.clipChildren = true;
			
			itemContainer = new GuiContainer();
			addChild( itemContainer );
			
			scrollIndicator = new GuiScrollBar(this);
			addChild( scrollIndicator );
			
			itemContainer.addEventListener( GuiEvent.SCROLL, onScroll, false, 0, true );
			
			_scrollDirection = GuiScrollDirection.VERTICAL;
			_scrollIndicatorSize = 6;
			
			_itemRendererClass = GuiButton;
			
			changedSize = true;
			invalidate();
			
			skin 				 = "guiList";
			itemContainer.skin 	 = "guiList.items";
			scrollIndicator.skin = "guiList.indicator";
		}
		
		/** Disposes of the List**/
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
		
		/** Update after size adjust or data change. **/
		override public function update():void
		{
			
			if( changedData )
			{
				// TODO refresh all for now - could use object pooling here.
				
				changedData = false;
				itemContainer.removeAllChildren();
				
				var create:Function = _itemRendererFunction;
				if( create == null ) create = function($data:*):GuiObject{
						return new _itemRendererClass();
					};
											
				
				if( _dataItems )
				{
					var item:GuiObject;
					var data:*;
					var pos:Number = 0;
					for( var i:int = 0; i<_dataItems.length; i++ )
					{
						data = _dataItems[i];
						item = create(data);
						itemContainer.addChild( item );
						
						item.width 	= width;
						item.height = 49;
						item.x = 0;
						item.y = pos;
						pos+=50;
					}
				}
			}
			
			if( changedSize )
			{
				changedSize = false;
				
				itemContainer.width = width;
				itemContainer.height = height;
				
				itemContainer.x = itemContainer.y = 0;
				
				if( _scrollDirection == GuiScrollDirection.VERTICAL )
				{
					scrollIndicator.width 	= _scrollIndicatorSize;
					scrollIndicator.height 	= height-6;
					
					scrollIndicator.x 		= (width-_scrollIndicatorSize)-3;
					scrollIndicator.y 		= 3;
				}else
				if( _scrollDirection == GuiScrollDirection.HORIZONTAL )
				{
					scrollIndicator.width 	= width;
					scrollIndicator.height 	= _scrollIndicatorSize;
					
					scrollIndicator.x 		= 0;
					scrollIndicator.y 		= height-_scrollIndicatorSize;
				}
				
				// TODO : Update staggering across depths.
				// force update
				// scrollIndicator.update();
				// itemContainer.update();
				
				trace( "scroll : " + width + " " + height + " " + scrollIndicator.width + " " + scrollIndicator.height );
			}
			

		}
		

		// ------------------------------------------------------------------
		// --------------------------------------------------- event handlers
		// ------------------------------------------------------------------
		
		/** Update scroller **/
		protected function onScroll( $event:GuiEvent ):void
		{
			dispatchEvent( $event.clone() );
		}
		
	}
}
