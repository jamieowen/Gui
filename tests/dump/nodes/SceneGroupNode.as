package dump.nodes 
{
	import dump.traverser.RenderCollector;
	import gui.core.GuiObject;
	
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class SceneGroupNode extends SceneNode
	{
		private var _clipChildren:Boolean = false;
		
		private var _children:Vector.<SceneNode>;
		
		/** Return the objects child nodes. **/
		public function get children():Vector.<SceneNode>
		{
			return _children;
		}
		
		/** @inheritDoc **/
		override public function get isLeafNode():Boolean
		{
			return false;
		}
		
		public function get clipChildren():Boolean
		{
			return _clipChildren;
		}
		
		/** Clips this groups children by the guiObjects bounds**/
		public function set clipChildren( $value:Boolean ):void
		{
			_clipChildren = $value;
		}
		
		/** */
		public function SceneGroupNode(guiObject:GuiObject = null,parent : SceneGroupNode = null)
		{
			super(guiObject,parent);
			
			_children = new Vector.<SceneNode>();		
		}
		
		override public function collect(renderer:RenderCollector):void
		{
			if(renderer.enterNode(this))
			{
				if( renderer.renderGroups ) renderer.addToRender( this );
				if( clipChildren ) renderer.pushClipRect(guiObject.getBounds());
				
				renderer.pushMatrix( guiObject.transformationMatrix );
			
				var i:uint = 0;
				var l:uint = _children.length;
				while( i<l )
					_children[i++].collect(renderer);
				
				renderer.popMatrix();
				
				if( clipChildren ) renderer.popClipRect();
			}
		}
		
		override public function update():void
		{
			var i:uint = 0;
			var l:uint = _children.length;
			while( i<l )
				_children[i++].update();
			
			//trace( "cont : " + _guiObject.depth );
			if( _invalid )
			{
				_invalid = false;

				// call update on guiObject
				guiObject.update();
			}
		}
		
		public function add( child:SceneNode ):void
		{
			if( _children.indexOf(child) == -1 )
			{
				if( child.parent ) child.parent.remove(child);
				child.setParent(this);
				_children.push(child);
			}
		}
		
		public function remove( child:SceneNode ):void
		{
			var idx:uint = _children.indexOf(child);
			if( idx != -1 )
			{
				_children.splice(idx, 1);
				child.setParent(null);
			}
		}

	}
}