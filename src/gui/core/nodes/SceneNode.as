package gui.core.nodes {
	import flash.geom.Rectangle;
	import gui.core.objects.GuiObject;
	import gui.core.traverser.RenderCollector;



	/**
	 * @author jamieowen
	 */
	public class SceneNode
	{
		protected var _invalid:Boolean;
		protected var _guiObject:GuiObject;
		
		private var _parent:SceneGroupNode;
		
		/** The parent node**/
		public function get parent():SceneGroupNode
		{
			return _parent;
		}
		
		/** The gui object to represent**/
		public function get guiObject():GuiObject
		{
			return _guiObject;
		}
		
		/** Is the node a leaf node**/
		public function get isLeafNode():Boolean
		{
			return true;
		}
		
		/** Is the node contained by, or intersected by the view rectangle **/
		public function inView( $rect:Rectangle ):Boolean
		{
			if( !guiObject.visible ) return false;
			
			var res:Boolean = false;
			
			var rect:Rectangle = $rect.intersection(_guiObject.getBounds());
			if( rect.width*rect.height>0)
				res = true;
			else
				res = false;
			
			return res;
			// TODO need to calculate clipping rectangles somewhere. this has to be passed into a render request object.
		}
		
		/** **/
		public function SceneNode(guiObject:GuiObject,parent : SceneGroupNode = null) 
		{
			_parent = parent;
			_guiObject = guiObject;
			
			_invalid = false;
		}
		
		/** Collects the nodes in view for rendering**/
		public function collect(renderer:RenderCollector) : void
		{
			if( renderer.enterNode(this) )
				renderer.addToRender(this);
		}
		
		/** TODO : This should only be called on invalid objects **/
		/** Called before a render process to update invalid objects **/
		public function update():void
		{
			//trace( "node : " + _guiObject.depth );
			
			if( _invalid )
			{
				_invalid = false;
				// call update on guiObject
				_guiObject.update();
			}
		}
		
		/** Invalidates the gui object in some way**/
		public function invalidate():void
		{
			_invalid = true;
		}
		
		/** Seperate set function for guiObject as objects should only be set initially.**/
		public function setGuiObject($guiObject:GuiObject):void
		{
			_guiObject = $guiObject;
		}
		
		internal function setParent($node:SceneGroupNode):void
		{
			_parent = $node;
		}
	}
}
