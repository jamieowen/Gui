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
			_indexer.add(_root);
			
			_invalidation = new Invalidation(this);
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
				
				if( onRender ) onRender( renderQueue );
				
				_invalidation.reset();
			}
		}
	}
}
import gui.core.GuiContext;
import gui.core.GuiObject;
import gui.core.GuiObjectContainer;

internal class Invalidation
{
	private var _invalid:Boolean = false;
	private var _invalidated : Vector.<GuiObject>;
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
	}

	public function Invalidation($context:GuiContext)
	{
		_context = $context;
		_invalidated = new Vector.<GuiObject>();
	}
	
	private function invalidate( $obj:GuiObject ):void
	{
		_invalid = true;
		if( _invalidated.indexOf($obj) == -1 )
			_invalidated.push($obj);
	}
	
	internal function dispose():void
	{
		_context = null;
		_invalidated.splice(0,uint.MAX_VALUE);
	}
		
	public function onAdded( $obj:GuiObject ):void
	{
		stats.added++;
		invalidate($obj);
		_context.indexer.add($obj);
	}
	
	public function onRemoved( $obj:GuiObject ):void
	{
		stats.removed++;
		invalidate($obj);
		_context.indexer.remove($obj);
	}

	public function onMoved( $obj:GuiObject ):void
	{
		stats.moved++;
		invalidate($obj);
		_context.indexer.update( $obj, $obj.getGlobalBounds() );
	}
	
	public function onResized( $obj:GuiObject ):void
	{
		stats.resized++;
		invalidate($obj);
		_context.indexer.update( $obj, $obj.getGlobalBounds() );
	}
	
	public function onSkinChanged( $obj:GuiObject ):void
	{
		stats.skinChanged++;
		invalidate($obj);
	}
	
	public function onScrolled( $obj:GuiObject ):void
	{
		stats.scrolled++;
		invalidate($obj);
		
		// temp solution to update children positions.
		var updateObj:Function = function($child:GuiObject):void
		{
			_context.indexer.update( $child, $child.getGlobalBounds() );
			
			var container:GuiObjectContainer = $child as GuiObjectContainer;
			if( container )
				for( var i:int = 0; i<container.numChildren; i++ )
					updateObj(container.getChildAt(i));
		};
		
		updateObj($obj);
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
	
	public function reset():void
	{
		added = removed = moved = resized = scrolled = skinChanged = dataChanged = 0;
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