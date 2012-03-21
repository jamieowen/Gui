package gui.errors
{
	/**
	 * 
	 * @author jamieowen
	 */
	public class GuiArgumentError extends Error
	{
		public function GuiArgumentError(message : * = "", id : * = 0)
		{
			super(message, id);
		}
	}
}
