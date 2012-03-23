package gui.core.gestures
{
	/**
	 * @author jamieowen
	 */
	public interface IGestureProcessor
	{
		/** Called by the manager to notify the Gesture a gesture delegate has been added to the context **/
		function delegateAdded($delegate : IGestureDelegate) : void;
		
		/** Called by the manager to notify the Gesture a gesture delegate has been removed from the context **/
		function delegateRemoved( $delegate:IGestureDelegate ):void;
		
		/** Called by the manager to every frame **/
		function update():void;
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		function inputDown($x:Number, $y:Number):void;
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		function inputUp($x:Number, $y:Number):void;
		
		/** allows the gesture to act on user input.  this can be touch, mouse, gesture events, etc. **/
		function inputMove($x:Number, $y:Number):void;
		
		/** disposes of the gesture **/
		function dispose():void;
	}
}
