package gui.display {
	import gui.gestures.ITapGesture;
	import gui.core.objects.GuiObject;

	/**
	 * @author jamieowen
	 */
	public class GuiButton extends GuiObject implements ITapGesture
	{
		public function GuiButton()
		{
			super();
			
			skin = "button";
		}
		
		public function onTap():void
		{
			trace( "onTap!" );
		}
	}
}
