package gui.renderers
{
	import starling.events.TouchPhase;
	import starling.events.Touch;
	import gui.core.context.nsGuiInternal;
	import starling.events.TouchEvent;
	import gui.core.context.GuiContext;
	import gui.render.GuiRenderer;
	import gui.render.IGuiObjectSkin;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class StarlingGuiRenderer extends GuiRenderer
	{
		use namespace nsGuiInternal;
		
		/** The starling container **/
		private var _container:DisplayObjectContainer;
		
		/**
		* Class Constructor Description
		*/
		public function StarlingGuiRenderer($context:GuiContext, $container:DisplayObjectContainer)
		{
			super($context);
			
			_container = $container;
			
			// map events to the context..
			_container.touchable = true;
			_container.stage.addEventListener(TouchEvent.TOUCH, onTouchEvent );
		}
		
		private function onTouchEvent( $event:TouchEvent ):void
		{
			var touch:Touch;
			for( var i:uint = 0; i<$event.touches.length; i++ )
			{
				touch = $event.touches[i];
				
				// TODO : Renderer needs to offset positions by the renderer's target object container's position.  i.e. the viewport offset
				
				switch( touch.phase )
				{ 
					case TouchPhase.BEGAN :
						context.inputDown( touch.globalX, touch.globalY );
						break;
						
					case TouchPhase.ENDED :
						context.inputUp( touch.globalX, touch.globalY );
						break;
					
					case TouchPhase.MOVED :
						context.inputMove( touch.globalX, touch.globalY );
						break;
				}
			}
		}
		
		/** Returns the number of skins rendererd **/
		override protected function get numSkins():uint
		{
			return _container.numChildren;
		}
		
		/** Returns a skin at the given index of the container **/
		override protected function getSkinAt($idx:uint):IGuiObjectSkin
		{
			return _container.getChildAt($idx) as IGuiObjectSkin;
		}

		/** Adds a skin to the container **/
		override protected function addSkin( $skin:IGuiObjectSkin ):void
		{
			_container.addChild( $skin as DisplayObject );
		}
		
		/** Removes a skin from the container **/
		override protected function removeSkin( $skin:IGuiObjectSkin ):void
		{
			_container.removeChild( $skin as DisplayObject );
		}
	}
}