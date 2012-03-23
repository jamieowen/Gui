package gui.core.objects
{
	import gui.core.context.nsGuiInternal;
	import gui.events.GuiEvent;
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
		use namespace nsGuiInternal;
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
				// TODO : simple/ugly bubbling impl for now. - not handling any preventDefault(), etc - Not sure if Signals may be better
				
				( $event as GuiEvent ).setBubbleTarget( this ); // set the target at the bubble target only. ( setBubbleTarget can only be called once )
				
				if( $event.type == GuiEvent.ADDED_TO_CONTEXT ) trace( this + "[Bubble] added to context : " + $event.target );
				
				 
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