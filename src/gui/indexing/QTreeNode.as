package gui.indexing
{
	import flash.text.engine.ElementFormat;
	import flash.geom.Rectangle;
	/**
	 * @author jamieowen
	 */
	public class QTreeNode
	{
		public var nodes:Vector.<QTreeNode>;
		public var qtree:QTree;
		
		public var parent:QTreeNode;
		
		public var items:Vector.<QTreeData>;
		public var rect:Rectangle;
		
		
		public function get numNodes():uint
		{
			var num:uint = 0;
			if( nodes )
			{
				num = nodes.length;
				var i:int = 0;
				
				while( i<4 )
					num+=nodes[i++].numNodes;
			}
			
			return num;
		}
		
		/**
		 * Recursively returns the total number of items within this node and its children.
		 */
		public function get numItems():uint
		{
			var num:uint = 0;
			if( items ) num = items.length;
			
			if(nodes == null) return num;
			
			var i:int = 0;
			while( i<4 )
				num+=nodes[i++].numItems;
			
			return num;
		}
		
		public function get subItems():Vector.<QTreeData>
		{
			var sub:Vector.<QTreeData> = items == null ? new Vector.<QTreeData>() : items;
			
			if( nodes )
			{
				var i:int = 0;
				while( i<4 )
					sub = sub.concat( nodes[i++].subItems );
			}
			
			return sub;
		}
		
		/**
		 * Creates a new QTreeNode
		 * 
		 * @param $rect The rectangular region this node occupies
		 * @param $parent The parent of this node.
		 * @param $qtree The QTree instance managing this node.
		 */
		public function QTreeNode($rect:Rectangle, $parent:QTreeNode, $qtree:QTree)
		{
			rect 	= $rect;
			parent 	= $parent;
			qtree	= $qtree;
		}
		
		/**
		 * Adds a QTreeData object to the quad tree
		 * 
		 * @param $data The data including rectangle to add.
		 */
		public function add( $data:QTreeData ):void
		{
			if( nodes == null ) // create nodes if we don't already have them
			{
				var w:Number = rect.width/2;
				var h:Number = rect.height/2;
				var minReached:Boolean = false;
				
				if( w*h > qtree.minSize ) 
				{
					nodes = new Vector.<QTreeNode>(4);
						
					nodes[0] = new QTreeNode(new Rectangle(rect.x, rect.y, w, h),this,qtree);
					nodes[1] = new QTreeNode(new Rectangle(rect.x+w, rect.y, w, h),this,qtree);
					nodes[2] = new QTreeNode(new Rectangle(rect.x, rect.y+h, w, h),this,qtree);
					nodes[3] = new QTreeNode(new Rectangle(rect.x+w, rect.y+h, w, h),this,qtree);
				}else
					minReached = true;
			}
			
			var i:int = 0;
			var node:QTreeNode;
			
			// search child nodes.
			if( !minReached )
			{
				while( i<4 )
				{
					node = nodes[i++];
					if( node.rect.containsRect($data.rect) )
					{
						node.add( $data );
						return;
					}
				}	
			}
			
			// add to this node if we are here - we have either reached smallest node size or the rect fits here and not the children
			if( items == null ) items = new Vector.<QTreeData>();
			
			$data.node = this;
			items.push( $data );
		}

		public function remove( $data:QTreeData ):void
		{
			$data.node.items.splice( $data.node.items.indexOf($data), 1 );
			
			// notify
		}
		
		/**
		 * Updates the position of a QTreeData object by traversing up the tree. Faster for moving of objects.
		 * 
		 * @param $data The QTreeData object
		 * @param $updated The new rectangle to apply to the data object.
		 */
		public function update( $data:QTreeData, $updated:Rectangle ):void
		{
			// work up from current node and test
			var parent:QTreeNode = $data.node;
			var move:uint = 0;
			while( parent )
			{
				move++;
				if( parent.rect.containsRect($updated) ) //updated position is fully contained by this - insert at this point. 
				{
					//trace( parent );
					remove( $data );
					$data.rect = $updated;
					parent.add( $data );
					parent = null;
				}else
					parent = parent.parent;
			}
			
			// notify
			
			//trace( "Update Cost : " + move );
			//remove( $data ); // remove and readd to test quickly.
			//$data.rect = $updated;
			//add( $data );
		}
		
		public function find( $rect:Rectangle ):Vector.<QTreeData>
		{
			var results:Vector.<QTreeData> = new Vector.<QTreeData>();
		
			var i:int = 0;
			var item:QTreeData;
			
			var l:uint = 0;
			if( items ) l = items.length;
			
			if( items )
			{
				while( i<items.length )
				{
					item = items[i++];
					if( item.rect.intersects($rect) )
						results.push( item );
				}
			}
			
			i = 0;
			if(nodes)
			{
				var node:QTreeNode;
				while( i<4 )
				{
					node = nodes[i++];
					
					if( node.rect.containsRect($rect) )
					{
						results = results.concat( node.find($rect) );
						break;
					}
					
					if( $rect.containsRect( node.rect ) ) // view rect fully contains node so add all sub children of this node and continue.
					{
						if( node.items )
						{
							results = results.concat( node.subItems );
							continue;
						}
					}
					
					if( node.rect.intersects($rect) )
					{
						results = results.concat(node.find($rect));
					}
				}
			}
			
			return results;
		}
		
			
		
	}
}
