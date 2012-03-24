package gui.gestures
{
	import gui.core.gestures.IGestureDelegate;
	
	/**
	 * @author jamieowen
	 */
	public interface ISwipeLeftRight extends IGestureDelegate
	{
		function gesture_swipe_onSwipeLeft():void;
		function gesture_swipe_onSwipeRight():void;
	}
}
