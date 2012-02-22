package gui.indexing 
{
	import gui.core.GuiContext;
	import flash.utils.Dictionary;
	import gui.render.GuiRenderRequest;
	import gui.core.GuiObject;
	import flash.geom.Rectangle;
	import gui.indexing.qtree.QTreeData;
	import gui.indexing.qtree.QTreeNode;
	/**
	 * @author jamieowen
	 */
	public class QTree implements IGuiIndexer
	{
		private var _guiToQTree:Dictionary;
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
			
			_guiToQTree = new Dictionary(true);
		}
		
		public function add( $data:GuiObject ):void
		{
			// TODO Check duplicates?
			var qdata:QTreeData = new QTreeData($data, $data.getGlobalBounds() );  
			_guiToQTree[$data] = qdata; 
			_root.add( qdata );
		}
		
		public function remove( $data:GuiObject ):void
		{
			var qdata:QTreeData = _guiToQTree[ $data ];
			_root.remove( qdata );
		}
		
		public function removeAll():void
		{
			// TODO Implement removeAll() in QTree
		}
		
		public function update( $data:GuiObject, $updated:Rectangle ):void
		{
			var qdata:QTreeData = _guiToQTree[ $data ];
			_root.update( qdata, $updated );
		}
		
		public function find( $rect:Rectangle ):Vector.<GuiRenderRequest>
		{
			//TODO Solution to abstract out the GuiRenderRequest. to pass clipping rect generation to quad tree.
			//return _root.find( $rect );
			return null;
		}
	
	}
}
