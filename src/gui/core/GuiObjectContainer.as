package gui.core
{
	import dump.nodes.SceneGroupNode;
	import dump.nodes.SceneNode;
	import gui.errors.AbstractClassError;
	import gui.events.GuiEvent;

	import flash.utils.getQualifiedClassName;
	
	public class GuiObjectContainer extends GuiObject
	{
		private var _children:Vector.<GuiObject>;
		
		public function get nodeAsGroup():SceneGroupNode
		{
			return node as SceneGroupNode;
		}
		
		public function get numChildren():int
		{
			return _children.length;
		}

		public function GuiObjectContainer($node:SceneNode=null)
		{
			super($node);
			
			if( $node == null )
			{
				setNode(new SceneGroupNode());
				node.setGuiObject(this);
			}
			
			if (getQualifiedClassName(this) == "gui.core::GuiObjectContainer")
				throw new AbstractClassError();
			
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
				if( child.parent ) {
					child.parent.removeChild(child);
				}
				_children.splice(index, 0, child);
				
				child.setParent(this);
				
				child.dispatchEvent( new GuiEvent(GuiEvent.ADDED,child) );
				if( child is GuiObjectContainer ) dispatchEventOnChildren( GuiEvent.ADDED, child as GuiObjectContainer );
				
				( node as SceneGroupNode ).add(child.node);
				
				if( context )
				{
					context.invalidation.onAdded( child );
					child.dispatchEvent( new GuiEvent(GuiEvent.ADDED_TO_CONTEXT,child) );
					if( child is GuiObjectContainer )
					{
						callOnAddedOnChildren(child as GuiObjectContainer);
						dispatchEventOnChildren( GuiEvent.ADDED_TO_CONTEXT, child as GuiObjectContainer );
					}
				}
			}
			else
			{
				throw new RangeError("Invalid child index");
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
				
				child.dispatchEvent( new GuiEvent(GuiEvent.REMOVED,child) );
				if( child is GuiObjectContainer ) dispatchEventOnChildren( GuiEvent.REMOVED, child as GuiObjectContainer );
				
				( node as SceneGroupNode ).remove(child.node);
				
				if( context )
				{
					context.invalidation.onRemoved( child );
					child.dispatchEvent( new GuiEvent(GuiEvent.REMOVED_FROM_CONTEXT,child) );
					
					if( child is GuiObjectContainer )
					{
						callOnRemovedOnChildren(child as GuiObjectContainer);
						dispatchEventOnChildren( GuiEvent.REMOVED_FROM_CONTEXT, child as GuiObjectContainer );
					}
				}
					
				child.setParent(null);
				
				_children.splice(index, 1);
			}
			else
			{
				throw new RangeError("Invalid child index");
			}
		}
		
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
				child.dispatchEvent(new GuiEvent($type,child));
				if( child is GuiObjectContainer ) dispatchEventOnChildren( $type,child as GuiObjectContainer );
			}
		}
		
		protected function callOnAddedOnChildren($container:GuiObjectContainer):void
		{
			var l:uint = $container.numChildren;
			var child:GuiObject;
			for( var i:int = 0; i<l; i++ )
			{
				child = $container.getChildAt(i);
				context.invalidation.onAdded(child);
				if( child is GuiObjectContainer ) callOnAddedOnChildren(child as GuiObjectContainer);
			}
		}
		
		protected function callOnRemovedOnChildren($container:GuiObjectContainer):void
		{
			var l:uint = $container.numChildren;
			var child:GuiObject;
			for( var i:int = 0; i<l; i++ )
			{
				child = $container.getChildAt(i);
				context.invalidation.onRemoved(child);
				if( child is GuiObjectContainer ) callOnRemovedOnChildren(child as GuiObjectContainer);
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
		
		public function removeAllChildren():void
		{
			while(numChildren)
				removeChildAt(0);
		}
	}
}