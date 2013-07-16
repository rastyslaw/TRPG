package spell.skill {
	import flash.geom.Point;
	import spell.effect.Slow;
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Binding implements ISkill, IIcon {   
		
		private var _percent:Number = .9;  
		
		public function get ico():String { 
			return "skill8";    
		} 
		
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			if (Math.random() < _percent) { 
				tar2.setEffects(new Slow(tar2, ico));  
			}
		} 
		
		public function correct():Number {
			return 0; 
		}
		
		public function defence():Boolean {
			return false;   
		}
		
		public function set percent(value:int):void {
			_percent = value/100; 
		}
		
		public function get percent():int {
			return int(_percent*100); 
		}
//-----		
	}
}