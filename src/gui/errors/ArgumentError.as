package gui.errors
{
	/**
	 * 
	 * @author jamieowen
	 */
	public class ArgumentError extends Error
	{
		public function ArgumentError(message : * = "", id : * = 0)
		{
			super(message, id);
		}
	}
}
