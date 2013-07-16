package spell.skill {
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Cutting implements ISkill, IIcon {   
		
		private var _percent:Number = .9;  
		private var cof:Number = 0.5;  
		 
		public function get ico():String { 
			return "skill1";      
		} 
		
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {}  
		
		public function correct():Number {  
			if (Math.random() < _percent) { 
				return cof;    
			}
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