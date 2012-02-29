package gui.core
{
	import flash.geom.Matrix;
	
	/**
	 * Scrollable interface to attach to containers.
	 * 
	 * @see <code>GuiScrollContainer</code> for example.
	 * 
	 * @author jamieowen
	 */
	public interface IScrollable 
	{
		function get scrollPositionX():Number;
		function set scrollPositionX($position:Number):void;
		
		function get scrollPositionY():Number;
		function set scrollPositionY($position:Number):void;
	}
}
