package gui.indexing
{
	import flash.utils.Dictionary;
	import gui.render.GuiRenderRequest;
	import flash.geom.Rectangle;
	import gui.core.GuiObject;
	/**
	* An index that performs no spatial indexing.
	* But returns GuiObjects with clipping data and gui rects converted
	* to view space.
	*
	* @author jamieowen
	*/
	public class NoIndexer implements IGuiIndexer
	{
		private var _index:Dictionary;
		private var _numItems:uint;
		
		public function get numItems():uint
		{
			return _numItems;
		}
		
		/**
		* Class Constructor Description
		*/
		public function NoIndexer()
		{
			_index = new Dictionary();
			_numItems = 0;
		}
		
		public function add($data : GuiObject) : void
		{
			_numItems++;
			_index[$data] = $data.getGlobalBounds();
		}

		public function remove($data : GuiObject) : void
		{
			if( _index[$data] == null ) return;
			_numItems--;
			_index[$data] = null;
			delete _index[$data];
		}
		
		public function removeAll():void
		{
			// TODO Implement removeAll() in NoIndexer
		}

		public function update($data : GuiObject, $updated : Rectangle) : void
		{
			_index[$data]=$updated;
		}

		public function find($rect : Rectangle) : Vector.<GuiRenderRequest>
		{
			var rect:Rectangle;
			var req:GuiRenderRequest;
			var intersect:Rectangle;
			var results:Vector.<GuiRenderRequest> = new Vector.<GuiRenderRequest>();
			
			for( var key:Object in _index )
			{
				rect = _index[key];
				intersect = $rect.intersection(rect);
				
				//trace( rect + " " + intersect );
				// Rectangle.intersection() returns 
				// Rectangle(0,0,0,0) for no intersection
				// Rectangle(x,y,w,h) for containment of Rectangle(x,y,w,h);
				// Rectangle(xx,xx,xx,xx) for intersection 
				if( intersect.width != 0.0 || intersect.height != 0.0 )
				{
					req = new GuiRenderRequest(key as GuiObject, rect, intersect );
					results.push( req );
				}
			}
			
			return results;
		}
	}
}
import gui.core.GuiObject;
import flash.geom.Rectangle;

internal class IndexItem
{
	public var rect:Rectangle;
	public var gui:GuiObject;
	
	public function IndexItem($gui:GuiObject,$rect:Rectangle)
	{
		gui = $gui;
		rect = $rect;
	}
}