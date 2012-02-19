package gui.renderers.starling
{
	import gui.render.GuiRenderer;
	import gui.render.GuiRenderRequest;
	import gui.render.IGuiObjectRenderer;
	
	import starling.text.TextField;
	
	public class StarlingGuiTextField extends TextField implements IGuiObjectRenderer
	{
		public function StarlingGuiTextField(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0x0, bold:Boolean=false)
		{
			super(width, height, text, fontName, fontSize, color, bold);
		}
		
		public function renderRequest( $request:GuiRenderRequest, $renderer:GuiRenderer ):void
		{
			
		}
	}
}