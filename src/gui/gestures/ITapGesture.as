package gui.gestures {
	import gui.core.gestures.IGestureDelegate;
	
	/**
	 * @author jamieowen
	 */
	public interface ITapGesture extends IGestureDelegate
	{
		function onTap():void;
	}
}
