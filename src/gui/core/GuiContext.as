package gui.core
{
	import gui.render.GuiRenderRequest;
	import gui.indexing.IGuiIndexer;
	import gui.indexing.NoIndexer;

	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * 
	 */
	public class GuiContext
	{
		/** helper class to handle change in the context **/
		private var _invalidation:Invalidation;
		
		/** The spatial indexing used for the context**/
		private var _indexer:IGuiIndexer;
		
		/** The root GuiObject **/
		private var _root:GuiObject;
		
		/** Temp render function for a single renderer **/
		public var onRender:Function;
		
		public function get root():GuiObject
		{
			return _root;
		}
		
		public function get invalidation():Invalidation
		{
			return _invalidation;
		}

		public function get indexer():IGuiIndexer
		{
			return _indexer; 
		}
		
		public function GuiContext($guiRoot:*,$indexer:IGuiIndexer=null)
		{
			super();
			
			if( $guiRoot is Class ) _root = new $guiRoot();
			else if( $guiRoot is GuiObject ) _root = $guiRoot;
			else throw new ArgumentError("Root cannot be null.");
			
			_root.setContext(this);
			
			_indexer = ( $indexer == null ) ? new NoIndexer():$indexer;
			
			// invalidation will add root to the Indexer
			_invalidation = new Invalidation(this);
			_invalidation.onAdded(_root);
		}
		
		public function dispose():void
		{
			_invalidation.dispose();
		}
		
		/**
		 * Requires an update each frame.
		 * 
		 */
		public function update():void
		{
			if( _invalidation.invalid )
			{
				var timer:Number 		= getTimer();
				var viewRect:Rectangle 	= _root.getGlobalBounds();
				
				var renderQueue:Vector.<GuiRenderRequest> 	= _indexer.find(viewRect);
				
				if( onRender != null ) onRender( renderQueue );
				
				_invalidation.reset();
			}
		}
	}
}

import flash.utils.Dictionary;
import gui.core.GuiContext;
import gui.core.GuiObject;
import gui.core.GuiObjectContainer;

internal class Invalidation
{
	private var _invalid:Boolean = false;
	private var _invalidated : Vector.<GuiObject>;
	private var _items:Dictionary;
	private var _context:GuiContext;
	
	private var _stats:InvalidationStats;
		
	public function get stats():InvalidationStats
	{
			return _stats;		
	}
		
	public function get invalidated():Vector.<GuiObject>
	{
			return _invalidated;
	}
	
	public function get invalid():Boolean
	{
		return _invalid;
	}
	
	public function reset():void
	{
		_invalid = false;
		_invalidated.splice(0, uint.MAX_VALUE);
		_stats.reset();
		
		clearDict();
	}
	
	private function clearDict():void
	{
		// clear dict
		for( var key:Object in _items )
		{
			_items[key] = null;
			delete _items[key];
		}
	}
	
	/**
	 *
	 */
	private function update():void
	{
		// call update() on all GuiObjects and update indexes
		
		
	}

	public function Invalidation($context:GuiContext)
	{
		_context = $context;
		
		_invalidated = new Vector.<GuiObject>();
		_items = new Dictionary(true);
		_stats = new InvalidationStats();
	}
	
	private function invalidate( $obj:GuiObject, $updateIndex:Boolean = false, $addIndex:Boolean = false, $removeIndex:Boolean = false):void
	{
		_invalid = true;
		var item:InvalidationItem;
		if( _invalidated.indexOf($obj) == -1 )
		{
			item = new InvalidationItem($obj, $updateIndex, $addIndex, $removeIndex );
			_invalidated.push($obj);
			_items[ $obj ] = item;
		}else
		{
			item = _items[$obj] as InvalidationItem;
			item.updateIndex = $updateIndex;
			item.addIndex = $addIndex;
			item.removeIndex = $removeIndex;
		}
	}

	internal function dispose():void
	{
		_context = null;
		_invalidated.splice(0,uint.MAX_VALUE);
		_invalidated = null;
		clearDict();
		_items = null;
	}
		
	public function onAdded( $obj:GuiObject ):void
	{
		stats.added++;
		invalidate($obj,false,true,false);
	}
	
	public function onRemoved( $obj:GuiObject ):void
	{
		stats.removed++;
		invalidate($obj,false,false,true);
	}

	public function onMoved( $obj:GuiObject ):void
	{
		stats.moved++;
		invalidate($obj,true);
		var container:GuiObjectContainer = $obj as GuiObjectContainer;
		if( container )
		{
			for( var i:int = 0; i<container.numChildren; i++ )
					onMoved(container.getChildAt(i));
		}
	}
	
	
	public function onResized( $obj:GuiObject ):void
	{
		stats.resized++;
		invalidate($obj,true);
	}
	
	public function onSkinChanged( $obj:GuiObject ):void
	{
		stats.skinChanged++;
		invalidate($obj);
	}
	
	public function onScrolled( $obj:GuiObject ):void
	{
		stats.scrolled++;
		onMoved( $obj ); // temp solution - not good for large scrolls - shuod have an indexed container offset instead
	}
}

internal class InvalidationItem
{
	public var gui:GuiObject;
	public var updateIndex:Boolean = false;
	public var addIndex:Boolean = false;
	public var removeIndex:Boolean = false;
	
	public function InvalidationItem($gui:GuiObject, $updateIndex:Boolean, $addIndex:Boolean, $removeIndex:Boolean )
	{ 
		gui = $gui;
		updateIndex = $updateIndex;
		addIndex = $addIndex;
		removeIndex = $removeIndex;
	}
}

internal class InvalidationStats
{
	public var added:uint;
	public var removed:uint;
	public var moved:uint;
	public var resized:uint;
	public var scrolled:uint;
	public var skinChanged:uint;
	public var dataChanged:uint;
	
	internal function reset():void
	{
		added = removed = moved = resized = scrolled = skinChanged = dataChanged = 0;
	}
	
	public function toString():String
	{
		return "[InvalidationStats] added:" + added + " removed:" + removed + " moved:" + moved + " resized:" + resized + " scrolled:" + scrolled + " skin:" + skinChanged + " data:" + dataChanged;
	}
	
}



				//TODO Update GuiContext to support new return from Indexer.
				
				//var i:int;
				//var obj:GuiObject;
				
				//var l:int = results.length;
				//var viewClip:Rectangle;
				//var guiRect:Rectangle;
				//var intersects:Boolean;
				//var intersect:Rectangle;
				
				
				/**
				while( i<l )
				{
					obj = results[i++].data as GuiObject;
					
					if( obj is GuiObjectContainer ) continue; // do nothing - we do not render GuiObjectContainers at the moment.
					
					guiRect = obj.getGlobalBounds();
					
					if( obj.parent && obj.parent.clipChildren )
						viewClip = obj.parent.getGlobalBounds(); // TODO : use the parent's clipping rect - this will not include clip rects further up the tree - but will do for now.
					else
						viewClip = viewRect;
					
					if( clipChildren == false && viewClip == viewRect ) // skip extra intersection checking if the GuiContext root is not clipping. ( as area is off stage / screen )
					{
						renderQueue.push(new GuiRenderRequest(obj,guiRect,null));
						continue;
					}
					// check intersection.
					intersect = viewClip.intersection(guiRect);
					intersects = intersect.size.length != 0.0;
					
					if( intersects )
						renderQueue.push(new GuiRenderRequest(obj,guiRect,intersect));
					else
					if( viewClip.containsRect(guiRect))
						renderQueue.push(new GuiRenderRequest(obj,guiRect,null));
					// else leave out.
				}
				**/
				
				//trace( "Render : " + l + " of " + _qtree.numItems );
				//trace( "time : " + (( getTimer()-timer )/1000).toFixed(3) + " " + l );
				
				// TODO Create a stats or render info object.
				// trace( "QTree Nodes: " + qtree.numNodes );
				//dispatchEvent( new GuiRenderEvent( GuiRenderEvent.RENDER,renderQueue ) );