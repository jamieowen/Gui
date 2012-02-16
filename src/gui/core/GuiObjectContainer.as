package gui.core
{
	
	import flash.geom.Matrix;
	import flash.utils.getQualifiedClassName;
	
	import gui.errors.AbstractClassError;
	import gui.events.GuiEvent;

	public class GuiObjectContainer extends GuiObject
	{
		private var _children:Vector.<GuiObject>;
		
		private var _scrollPositionX:Number;
		
		private var _scrollPositionY:Number;
		
		private var _clipChildren:Boolean;
	
		public function get numChildren():int
		{
			return _children.length;
		}
		
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
			dispatchContextEvent( new GuiEvent( GuiEvent.SCROLL, this ) );
		}
		
		public function get scrollPositionY():Number
		{
			return _scrollPositionY;
		}
		
		public function set scrollPositionY($position:Number):void
		{
			if( _scrollPositionY == $position ) return;
			_scrollPositionY = $position;
			dispatchContextEvent( new GuiEvent(GuiEvent.SCROLL,this) );
		}
		
		// scrollMinimumX - width?
		// scrollMaximumX
		// scrollMinimumY - height?
		// scrollMaximumY
		
		public function GuiObjectContainer()
		{
			super();
			
			if (getQualifiedClassName(this) == "gui.display::GuiObjectContainer")
				throw new AbstractClassError();
			
			_scrollPositionX = _scrollPositionY = 0.0;
			_clipChildren = false;
			_children = new Vector.<GuiObject>();
		}

		public function addChild(child:GuiObject):void
		{
			addChildAt(child, numChildren);
		}
		
		public function addChildAt(child:GuiObject, index:int):void
		{
			if (index >= 0 && index <= numChildren)
			{
				child.removeFromParent();
				_children.splice(index, 0, child);
				child.setParent(this);
				
				if( context )
				{
					context.dispatchEvent(new GuiEvent(GuiEvent.ADDED_TO_CONTEXT,child));	
					if( child is GuiObjectContainer ) dispatchEventOnChildren( GuiEvent.ADDED_TO_CONTEXT, child as GuiObjectContainer );
				}
			}
			else
			{
				throw new RangeError("Invalid child index");
			}
		}
		
		
		/**
		 * 
		 * @param $context pass in ref to context if needed - as saves some extra calls 
		 */
		protected function dispatchEventOnChildren( $type:String, $container:GuiObjectContainer ):void
		{
			var i:int = 0;
			var l:int = $container.numChildren;
			var child:GuiObject;
			var context:GuiContext = context;
			if( context == null ) return;
			
			while( i<l )
			{
				child = $container.getChildAt(i++);
				context.dispatchEvent(new GuiEvent($type,child));
				if( child is GuiObjectContainer ) dispatchEventOnChildren( $type,child as GuiObjectContainer );
			}
		}

		public function removeChild(child:GuiObject):void
		{
			var childIndex:int = getChildIndex(child);
			if (childIndex != -1) removeChildAt(childIndex);
		}
		
		public function removeChildAt(index:int):void
		{
			if (index >= 0 && index < numChildren)
			{
				var child:GuiObject = _children[index];
				if( context )
				{
					context.dispatchEvent(new GuiEvent(GuiEvent.REMOVED_FROM_CONTEXT,this));	
					dispatchEventOnChildren( GuiEvent.REMOVED_FROM_CONTEXT, child as GuiObjectContainer );
				}
				child.setParent(null);
				_children.splice(index, 1);
			}
			else
			{
				throw new RangeError("Invalid child index");
			}
		}
		
		public function removeChildren(beginIndex:int=0, endIndex:int=-1):void
		{
			if (endIndex < 0 || endIndex >= numChildren) 
				endIndex = numChildren - 1;
			
			for (var i:int=beginIndex; i<=endIndex; ++i)
				removeChildAt(beginIndex);
		}
		
		/** Returns a child object at a certain index. */
		public function getChildAt(index:int):GuiObject
		{
			if (index >= 0 && index < numChildren)
				return _children[index];
			else
				throw new RangeError("Invalid child index");
		}
		
		/** Returns a child object with a certain name (non-recursively). */
		public function getChildByName(name:String):GuiObject
		{
			for each (var currentChild:GuiObject in _children)
			if (currentChild.name == name) return currentChild;
			return null;
		}
		
		/** Returns the index of a child within the container, or "-1" if it is not found. */
		public function getChildIndex(child:GuiObject):int
		{
			return _children.indexOf(child);
		}
		
		/** Moves a child to a certain index. Children at and after the replaced position move up.*/
		public function setChildIndex(child:GuiObject, index:int):void
		{
			var oldIndex:int = getChildIndex(child);
			if (oldIndex == -1) throw new ArgumentError("Not a child of this container");
			_children.splice(oldIndex, 1);
			_children.splice(index, 0, child);
		}
		
		/** Swaps the indexes of two children. */
		public function swapChildren(child1:GuiObject, child2:GuiObject):void
		{
			var index1:int = getChildIndex(child1);
			var index2:int = getChildIndex(child2);
			if (index1 == -1 || index2 == -1) throw new ArgumentError("Not a child of this container");
			swapChildrenAt(index1, index2);
		}
		
		/** Swaps the indexes of two children. */
		public function swapChildrenAt(index1:int, index2:int):void
		{
			var child1:GuiObject = getChildAt(index1);
			var child2:GuiObject = getChildAt(index2);
			_children[index1] = child2;
			_children[index2] = child1;
		}
		
		/** Determines if a certain object is a child of the container (recursively). */
		public function contains(child:GuiObject):Boolean
		{
			if (child == this) return true;
			
			for each (var currentChild:GuiObject in _children)
			{
				if (currentChild is GuiObjectContainer)
				{
					if ((currentChild as GuiObjectContainer).contains(child)) return true;
				}
				else
				{
					if (currentChild == child) return true;
				}
			}
			
			return false;
		}

			
		
	}
}