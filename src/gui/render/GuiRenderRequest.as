package gui.render
{
	import flash.geom.Rectangle;
	import gui.core.objects.GuiObject;
	
	
	/**
	 * Wraps up a render request to pass to Renderers.
	 */
	public class GuiRenderRequest
	{
		/**
		 * The GuiObject being rendered ( in model space )
		 */
		public var gui:GuiObject;
		
		/**
		 * The GuiObject's transformed position in view space.
		 */
		public var guiRect:Rectangle;
		
		/**
		 * Contains the GuiObject's clip rectangle in relation to view space.
		 * Is null if no clipping was performed.
		 */
		public var clipRect:Rectangle;

		
		/**
		 * 
		 * @param 
		 */
		public function GuiRenderRequest($gui:GuiObject, $guiRect:Rectangle, $clipRect:Rectangle = null)
		{
			gui = $gui;
			guiRect = $guiRect;
			clipRect = $clipRect;
		}
	}
}