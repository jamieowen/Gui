package gui.renderers
{
	import starling.display.DisplayObject;
	import gui.render.IGuiObjectSkin;
	import gui.core.GuiContext;
	import starling.display.DisplayObjectContainer;
	import gui.render.GuiRenderer;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class StarlingGuiRenderer extends GuiRenderer
	{
		/** The starling container **/
		private var _container:DisplayObjectContainer;
		
		/**
		* Class Constructor Description
		*/
		public function StarlingGuiRenderer($context:GuiContext, $container:DisplayObjectContainer)
		{
			super($context);
			
			_container = $container;
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