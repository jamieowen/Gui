package gui.renderers
{
	import gui.core.context.GuiContext;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import gui.render.GuiRenderer;
	import gui.render.IGuiObjectSkin;

	/**
	* Renderer for classic Flash Display List.
	*
	* @author jamieowen
	*/
	public class DisplayListRenderer extends GuiRenderer 
	{
		private var _container:DisplayObjectContainer;
		
		/**
		* @param $context The GuiContext to render.
		* @param $container The DisplayObjectContainer to render to.
		*/
		public function DisplayListRenderer($context:GuiContext, $container:DisplayObjectContainer)
		{
			super( $context );
			
			_container = $container;
		}
		
		override protected function get numSkins():uint
		{
			return _container.numChildren;
		}
		
		override protected function getSkinAt($idx:uint):IGuiObjectSkin
		{
			return _container.getChildAt($idx) as IGuiObjectSkin;
		}

		override protected function addSkin( $skin:IGuiObjectSkin ):void
		{
			_container.addChild( $skin as DisplayObject );
		}

		override protected function removeSkin( $skin:IGuiObjectSkin ):void
		{
			_container.removeChild( $skin as DisplayObject );
		}
		
	}
}