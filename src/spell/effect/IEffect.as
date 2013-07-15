package spell.effect {
	/**
	 * ...
	 * @author waltasar
	 */
	public interface IEffect {
		function apply():void;
		function cancel():void;
		function insalubrity():Boolean;  
	}
//-----	
}