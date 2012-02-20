package gui.render
{
	public interface IGuiObjectSkin
	{
		function renderRequest( $request:GuiRenderRequest, $renderer:GuiRenderer ):void;
	}
}