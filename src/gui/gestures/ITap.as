package gui.gestures {
	import gui.core.gestures.IGestureDelegate;
	
	/**
	 * @author jamieowen
	 */
	public interface ITap extends IGestureDelegate
	{
		function gesture_tap_onTap():void;
	}
}
