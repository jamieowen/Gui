package gui.render
{
	import gui.core.GuiObject;
	public interface IGuiObjectSkin
	{
		/**
		 * Render the skin according to a request.
		 * The skin should position itself and size its self according based on the 
		 * position and clip rectangle information provided in the request.
		 * 
		 * This can be called multiple times whilst the skin is onscreen. When a GuiObject
		 * invalidates.
		 */
		function renderRequest( $request:GuiRenderRequest, $renderer:GuiRenderer ):void;
		
		/**
		 * Most skins should be cached for future use. But when the cache limit is exceeded
		 * skins will be disposed of.
		 * This code should be freeing the skin up for garbage collection completely.
		 */
		function dispose():void;
		
		/**
		 * Attaches the skin to appear on screen representing a certain GuiObject.
		 * renderRequest() will be called after this so leave sizing/positioning code here.
		 * Called once during the skin's use on screen.
		 */
		function attach($newGui:GuiObject,$renderer:GuiRenderer):void;
		
		/**
		 * Removes the skin from screen and releases the skin to be used again.
		 * Called once (at the end) of the skin's appearance on screen.
		 */
		function release($previousGui:GuiObject,$renderer:GuiRenderer):void;
	}
}