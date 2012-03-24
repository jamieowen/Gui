package gui.display {
	import gui.events.GuiEvent;
	import gui.gestures.ITap;
	import gui.core.objects.GuiObject;

	[Event(name="guiClick", type="gui.events.GuiEvent")]
	
	/**
	 * @author jamieowen
	 */
	public class GuiButton extends GuiObject implements ITap
	{
		public function GuiButton()
		{
			super();
			
			skin = "button";
		}
		
		public function gesture_tap_onTap():void
		{
			dispatchEvent( new GuiEvent(GuiEvent.CLICK, this) );
		}
	}
}
