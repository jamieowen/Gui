package gui.gestures
{
	import gui.core.gestures.IGestureDelegate;

	/**
	 * @author jamieowen
	 */
	public interface ISwipeUpDown extends IGestureDelegate
	{
		function onSwipeUp():void;
		function onSwipeDown():void;
	}
}
