package gui.render
{
	public interface IGuiObjectRenderer
	{
		function renderRequest( $request:GuiRenderRequest, $renderer:GuiRenderer ):void;
	}
}