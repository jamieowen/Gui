package gui.core.nodes.indexing
{
	import flash.geom.Rectangle;
	import gui.core.objects.GuiObject;
	import gui.render.GuiRenderRequest;

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
