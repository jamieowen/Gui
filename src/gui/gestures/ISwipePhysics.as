package gui.gestures
{
	import gui.core.gestures.IGestureDelegate;

	/**
	 * @author jamieowen
	 */
	public interface ISwipePhysics extends IGestureDelegate
	{
		function get gesture_swipePhysics_x():Number; // current x position
		function get gesture_swipePhysics_y():Number; // current y position
		function set gesture_swipePhysics_x($x:Number):void;
		function set gesture_swipePhysics_y($y:Number):void;
		
		function get gesture_swipePhysics_constrainX():Boolean; // return true or false to use constraints.
		function get gesture_swipePhysics_constrainY():Boolean; // return true or false to use constraints.
		function get gesture_swipePhysics_minX():Number;
		function get gesture_swipePhysics_maxX():Number;
		function get gesture_swipePhysics_minY():Number;
		function get gesture_swipePhysics_maxY():Number;
		
		function get gesture_swipePhysics_easing():Function // easing to use when over snap
		function get gesture_swipePhysics_mass():Number;
		
		function gesture_swipePhysics_onMinXOvershoot():void; // triggers event when a swipe overshoots a constraint
		function gesture_swipePhysics_onMaxXOvershoot():void;
		
		function gesture_swipePhysics_onMinYOvershoot():void;
		function gesture_swipePhysics_onMaxYOvershoot():void;
	}
}
