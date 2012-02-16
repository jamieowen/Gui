package gui.indexing 
{
	import flash.geom.Rectangle;
	/**
	 * @author jamieowen
	 */
	public class QTree
	{
		private var _root:QTreeNode;
		private var _minSize:Number;
		
		public function get root():QTreeNode
		{
			return _root;
		}
		
		public function get numNodes():uint
		{
			return _root.numNodes;
		}
		
		public function get numItems():uint
		{
			return _root.numItems;
		}
		
		public function get minSize():Number
		{
			return _minSize;		
		}
		
		public function QTree($rectangle:Rectangle, $minSize:Number = 100)
		{
			_root = new QTreeNode($rectangle,null,this);
			_minSize = $minSize;
		}
		
		public function add( $data:QTreeData ):void
		{
			_root.add( $data );
		}
		
		public function remove( $data:QTreeData ):void
		{
			_root.remove( $data );
		}
		
		public function update( $data:QTreeData, $updated:Rectangle ):void
		{
			_root.update( $data, $updated );
		}
		
		public function find( $rect:Rectangle ):Vector.<QTreeData>
		{
			return _root.find( $rect );
		}
	
	}
}
