package gui.indexing.qtree {
	import flash.geom.Rectangle;
	
	/**
	 * @author jamieowen
	 */
	public class QTreeData
	{
		public var rect:Rectangle;
		public var data:*;
		public var node:QTreeNode; // the node this data is stored in - for faster access to updating the position.
		
		public function QTreeData($data:*,$rect:Rectangle)
		{
			data = $data;
			rect = $rect;
		}
		

	}
}
