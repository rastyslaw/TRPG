package spell.effect {
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public interface IEffect { 
		function apply():void; 
		function cancel():void; 
		function insalubrity():Boolean;
		function get _unit():Unit;
		function get cof():Number;      
	}
//-----	
}