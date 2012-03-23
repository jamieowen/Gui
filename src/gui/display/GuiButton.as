package gui.display {
	import gui.events.GuiEvent;
	import gui.gestures.ITapGesture;
	import gui.core.objects.GuiObject;

	[Event(name="guiClick", type="gui.events.GuiEvent")]
	
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
			dispatchEvent( new GuiEvent(GuiEvent.CLICK, this) );
		}
	}
}
