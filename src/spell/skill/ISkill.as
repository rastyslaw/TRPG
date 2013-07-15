package spell.skill {
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public interface ISkill {   
		function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void; 
		function set percent(value:int):void;
		function get percent():int; 
	}
//-----	
}