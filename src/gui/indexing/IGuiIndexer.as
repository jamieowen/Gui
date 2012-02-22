package gui.indexing
{
	import gui.core.GuiObject;
	import gui.render.GuiRenderRequest;

	import flash.geom.Rectangle;
	/**
	 * @author jamieowen
	 */
	public interface IGuiIndexer
	{
		function get numItems():uint;
		
		function add( $data:GuiObject ):void;
		function remove( $data:GuiObject ):void;
		function removeAll():void;
		function update( $data:GuiObject, $updated:Rectangle ):void;
		function find( $rect:Rectangle ):Vector.<GuiRenderRequest>;
	}
}
