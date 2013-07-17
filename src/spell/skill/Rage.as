package spell.skill {
	import spell.effect.Fury;
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Rage implements ISkill, IIcon {   
		
		private var _percent:Number = .9;  
		
		public function get ico():String {  
			return "skill10";      
		} 
		
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			if (Math.random() < _percent) {   
				tar1.setEffects(new Fury(tar1, ico));   
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
			return String(percent)+"% enter into battle trans and increase agi by 50%";  
		}
//-----		
	}
}