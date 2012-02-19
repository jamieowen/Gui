package gui.core
{
	import gui.indexing.QTreeData;
	import gui.indexing.QTree;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import gui.events.GuiEvent;
	import gui.events.GuiRenderEvent;
	import gui.render.GuiRenderRequest;

	/**
	 * Dispatched when a GuiObject is added to this context.
	 */
	[Event(name="guiAddedToContext", type="gui.events.GuiEvent")]
	
	/**
	 * Dispatched when a GuiObject is removed from this context.
	 */
	[Event(name="guiRemovedFromContext", type="gui.events.GuiEvent")]
	
	
	/**
	 * Dispatched when a GuiObject is resized.
	 */
	[Event(name="guiResize", type="gui.events.GuiEvent")]
	
	/**
	 * Dispatched when a GuiObject is moved.
	 */
	[Event(name="guiMove", type="gui.events.GuiEvent")]
	
	/**
	 * Dispatched when changes in the context have happened and clipping has taken place.
	 */
	[Event(name="guiRender", type="gui.events.GuiRenderEvent")]
	
	/**
	 * The GuiContext class is the root class for all GuiObjects
	 * to be added to.  Similar to the stage in display list terms.
	 * 
	 * Uses a single event dispatcher for the context at the moment.
	 */
	public class GuiContext extends GuiObjectContainer implements IEventDispatcher
	{
		private var _eventDispatcher:EventDispatcher;
		
		/** Will hold updated list of GuiObjects to be processed in the next update() call.  **/
		private var _invalidated:Vector.<GuiObject>; 
		
		/** Indicates that the invalidated objects need processing and to notify renderers if needed. **/
		private var _invalid:Boolean = false;
			
		private var _qtree:QTree;
		
		public function get qtree():QTree
		{
			return _qtree; 
		}
		
		public function GuiContext()
		{
			super();
			
			_qtree = new QTree(new Rectangle(0,0,4000000,4000000), (320*480)*4 );
			
			// add a data item for this - we may remove this - GuiContext may be should not be extending GuiObjectContainer
			// required, otherwise we receive events from the GuiContext.
			qdata = new QTreeData(this, getGlobalBounds());
			_qtree.add(qdata);
			
			_eventDispatcher = new EventDispatcher(this);
			
			addEventListener( GuiEvent.ADDED_TO_CONTEXT, onAddedToContext );
			addEventListener( GuiEvent.REMOVED_FROM_CONTEXT, onRemovedFromContext );
			addEventListener( GuiEvent.RESIZE, onResized );
			addEventListener( GuiEvent.MOVE, onMoved );
			addEventListener( GuiEvent.SCROLL, onScroll );
			
			_invalidated = new Vector.<GuiObject>();
			
			clipChildren = true;
		}
		
		public function dispose():void
		{
			removeEventListener( GuiEvent.ADDED_TO_CONTEXT, onAddedToContext );
			removeEventListener( GuiEvent.REMOVED_FROM_CONTEXT, onRemovedFromContext );
			removeEventListener( GuiEvent.RESIZE, onResized );
			removeEventListener( GuiEvent.MOVE, onMoved );
		}
		
		
		/**
		 * Invaliates the specfied object.
		 * 
		 * @param $child The GuiObject that has changed.
		 */
		protected function invalidate( $child:GuiObject ):void
		{
			_invalid = true;
			
			return;
			
			if( _invalidated.indexOf( $child ) == -1 )
			{
				_invalidated.push( $child );
				
				_invalid = true;
			}
		}
		
		/**
		 * Requires an update each frame.
		 * 
		 */
		public function update():void
		{
			if( _invalid )
			{
				_invalid = false;
				
				// quick impl for now.
				// just check everything from root.
				// _invalidated.splice(0,uint.MAX_VALUE); // remove all for now

				var timer:Number = getTimer();
				var viewRect:Rectangle = getGlobalBounds();
				
				var renderQueue:Vector.<GuiRenderRequest> 	= new Vector.<GuiRenderRequest>();
				var results:Vector.<QTreeData> 				= _qtree.find( viewRect );
				
				var i:int;
				var obj:GuiObject;
				
				var l:int = results.length;
				var viewClip:Rectangle;
				var guiRect:Rectangle;
				var intersects:Boolean;
				var intersect:Rectangle;
			
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
				
				//trace( "Render : " + l + " of " + _qtree.numItems );
				//trace( "time : " + (( getTimer()-timer )/1000).toFixed(3) + " " + l );
				
				// TODO Create a stats or render info object.
				trace( "QTree Nodes: " + qtree.numNodes );
				dispatchEvent( new GuiRenderEvent( GuiRenderEvent.RENDER,renderQueue ) );
			}
		}
		
		// Handlers
		/**
		 * Handles GuiObject's being added to the context.
		 * @param $event GuiEvent
		 */
		protected function onAddedToContext( $event:GuiEvent ):void
		{
			//trace( "Added : " + $event.guiObject );
			var gui:GuiObject 	= $event.guiObject;
			gui.qdata 			= new QTreeData(gui, gui.getGlobalBounds() );
			_qtree.add( gui.qdata );
			
			invalidate( gui );
		}
	
		/**
		 * Handles GuiObject's being removed from the context.
		 * @param $event GuiEvent
		 */
		protected function onRemovedFromContext( $event:GuiEvent ):void
		{
			trace( "Removed : " + $event.guiObject );
			
			var gui:GuiObject 	= $event.guiObject;
			_qtree.remove( gui.qdata );
			gui.qdata 			= null;
			
			invalidate( gui );
		}
		
		/**
		 * Handles GuiObject's being resized.
		 * @param $event GuiEvent
		 */
		protected function onResized( $event:GuiEvent ):void
		{
			trace( "Resize : " + $event.guiObject );
			
			var gui:GuiObject 	= $event.guiObject;
			_qtree.update( gui.qdata, gui.getGlobalBounds() );
			invalidate( gui );
		}
		
		/**
		 * Handles GuiObject's being moved.
		 * @param $event GuiEvent
		 */
		protected function onMoved( $event:GuiEvent ):void
		{
			//trace( "Moved : " + $event.guiObject );
			
			var gui:GuiObject 	= $event.guiObject;
			_qtree.update( gui.qdata, gui.getGlobalBounds() );
			invalidate( gui );
		}
		
		/**
		 * Handles GuiObjectContainers's scroll event.
		 * @param $event GuiEvent
		 */
		protected function onScroll( $event:GuiEvent ):void
		{
			//trace( "Scroll : " + $event.guiObject );

			var gui:GuiObject 	= $event.guiObject;
			_qtree.update( gui.qdata, gui.getGlobalBounds() );
			var cont:GuiObjectContainer = gui as GuiObjectContainer;
			invalidate( gui );
			
			//return;
			if( cont )
			{
				// update children - this should be looked at.
				var l:uint = cont.numChildren;
				var i:uint = 0;
				while( i<l )
				{
					dispatchEvent( new GuiEvent(GuiEvent.MOVE, cont.getChildAt(i++)));
				}
				//trace( "dispatch move on :" + l);
			}
			
			
		}
		
		// IEventDispatcher impl
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type,listener,useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return willTrigger(type);
		}
	}
}