package spell.skill {
	import flash.geom.Point;
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */   
	public class Prot implements ISkill, IIcon {    
		   
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {}
		
		public function get ico():String { 
			return "skill3";  
		} 
		
		public function defence():Boolean {
			return true;     
		} 
		
		public function correct():Number {
			return 0; 
		}
		
		public function set percent(value:int):void {}
		public function get percent():int { return 0;  }
//-----		
	}
}