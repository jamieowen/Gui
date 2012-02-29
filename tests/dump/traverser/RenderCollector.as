package dump.traverser
{
	import gui.render.GuiRenderRequest;
	import flash.geom.Matrix;
	import gui.core.GuiObjectContainer;
	import flash.geom.Rectangle;
	import dump.nodes.SceneNode;
	
	/**
	 * @author jamieowen
	 */
	public class RenderCollector
	{
		private var _renderList:Vector.<GuiRenderRequest>;
		private var _viewRect:Rectangle;
		private var _toRender:GuiObjectContainer;
		private var _renderGroups:Boolean = false;
		
		private var _matrixStack:Vector.<Matrix>;
		private var _clipRectStack:Vector.<Rectangle>;
		
		public function get viewRect():Rectangle
		{
			return _viewRect;
		}
		
		public function get renderList():Vector.<GuiRenderRequest>
		{
			return _renderList;
		}
		
		public function get renderGroups():Boolean
		{
			return _renderGroups;
		}
		
		public function RenderCollector($toRender:GuiObjectContainer)
		{
			_toRender 		= $toRender;
			
			_renderList 	= new Vector.<GuiRenderRequest>();
			_matrixStack 	= new Vector.<Matrix>();
			_clipRectStack	= new Vector.<Rectangle>();
			_viewRect		= new Rectangle();
		}
		
		public function pushClipRect( $clipRect:Rectangle ):void
		{
			_clipRectStack.push( _viewRect );
			_viewRect = _viewRect.intersection($clipRect);
		}
		
		public function popClipRect():void
		{
			_viewRect = _clipRectStack.pop();
		}
		
		/** Pushes the transformation matrix to the stack and adjusts the view rectangle*/
		public function pushMatrix($matrix:Matrix):void
		{
			_matrixStack.push( $matrix );
			_viewRect.x -= $matrix.tx;
			_viewRect.y -= $matrix.ty;
		}
		
		/** Pops the previous matrix**/
		public function popMatrix():void
		{
			var matrix:Matrix = _matrixStack.pop();
			_viewRect.x += matrix.tx;
			_viewRect.y += matrix.ty;
		}
		
		private function pushMatrixRect( $rect:Rectangle, $matrix:Matrix ):void
		{
			$rect.x -= $matrix.tx;
			$rect.y -= $matrix.ty;
		}
		
		public function enterNode( $node:SceneNode ):Boolean
		{
			return $node.inView( _viewRect );
		}
		
		public function render():void
		{
			// collect items to render
			_renderList.splice(0,uint.MAX_VALUE);
			
			_viewRect.x = _toRender.x;
			_viewRect.y = _toRender.y;
			
			_viewRect.width = _toRender.width;
			_viewRect.height = _toRender.height;
			
			//trace( "Viewrect : " + _viewRect );
			_toRender.node.update();
			_toRender.node.collect(this);
			
			// then pass _renderList to render()
			
			//trace( "Render count: " + _renderList.length );
		}
		
		public function addToRender( $node:SceneNode ):void
		{
			var req:GuiRenderRequest = new GuiRenderRequest($node.guiObject, $node.guiObject.getGlobalBounds() );
			_renderList.push( req );
		}
	}
}
