package gui.gestures
{
	import gui.core.gestures.IGestureDelegate;
	
	/**
	 * @author jamieowen
	 */
	public interface ISwipeLeftRight extends IGestureDelegate
	{
		function onSwipeLeft():void;
		function onSwipeRight():void;
	}
}
