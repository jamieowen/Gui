package gui.gestures {
	import gui.core.gestures.IGestureDelegate;
	
	/**
	 * @author jamieowen
	 */
	public interface ITap extends IGestureDelegate
	{
		function onTap():void;
	}
}
