package tests.gui.renderers
{
	import gui.core.GuiObject;
	import gui.render.GuiRenderer;
	import gui.render.GuiRenderRequest;
	import gui.render.IGuiObjectSkin;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class GuiRendererTestImplSkin implements IGuiObjectSkin
	{
		/**
		* Class Constructor Description
		*/
		public function GuiRendererTestImplSkin()
		{
		
		}
		
		public function attach($newGui:GuiObject,$renderer:GuiRenderer):void
		{
		}
		

		public function release($previousGui:GuiObject,$renderer:GuiRenderer):void
		{
			
		}
		
		/**
		 * 
		 */
		public function renderRequest( $request:GuiRenderRequest, $renderer:GuiRenderer ):void
		{
			
		}
		
		/**
		 * 
		 */
		public function dispose():void
		{
			
		}
		
	}
}