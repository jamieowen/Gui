package gui.gestures
{
	import gui.core.gestures.IGestureDelegate;

	/**
	 * @author jamieowen
	 */
	public interface ISwipeUpDown extends IGestureDelegate
	{
		function gesture_swipe_onSwipeUp():void;
		function gesture_swipe_onSwipeDown():void;
	}
}
