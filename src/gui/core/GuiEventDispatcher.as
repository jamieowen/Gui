package gui.core
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	
	/**
	* Basic override of Flash EventDispatcher to support bubbling on <code>GuiObject</code> instances.
	*
	* @author jamieowen
	*/
	public class GuiEventDispatcher extends EventDispatcher
	{
		/**
		* Class Constructor Description
		*/
		public function GuiEventDispatcher($target:IEventDispatcher)
		{
			super($target);
		}
		
		override public function dispatchEvent( $event:Event ):Boolean
		{
			if( $event.bubbles )
			{
				// TODO : simple bubbling impl for now. - not handling any preventDefault(), etc.
				var res:Boolean = super.dispatchEvent( $event );
				if( this.hasOwnProperty("parent") && this["parent"] is IEventDispatcher )
					res = ( this["parent"] as IEventDispatcher ).dispatchEvent( $event );
				return res;
			}else
			{
				return super.dispatchEvent($event);
			}
		}
	}
}