package spell.skill {
	import spell.effect.Stun;
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Stuner implements ISkill, IIcon {   
		
		private var _percent:Number = .9;   
		
		public function get ico():String {  
			return "skill9";      
		} 
		
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			if (Math.random() < _percent) {    
				tar2.setEffects(new Stun(tar2, ico));
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
		
		public function get description():String {
			return String(percent)+"% to stun the target for 1 round";  
		}
//-----		
	}
}