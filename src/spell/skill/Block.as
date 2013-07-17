package spell.skill {
	import flash.geom.Point;
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Block implements ISkill, IIcon {   
		
		private var _percent:Number = .9; 
		private var cof:Number = 0.5;  
		private var dam:int;
		 
		public function get ico():String { 
			return "skill5";  
		}
		
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			dam = damage; 
		}
		
		public function correct():Number { 
			if (Math.random() < _percent) { 
				dam = int(dam * cof);   
				if(dam<=0) dam = 1; 
			} 
			return dam;  
		}
		
		public function defence():Boolean {
			return true;    
		}
		
		public function set percent(value:int):void {
			_percent = value/100; 
		}
		
		public function get percent():int {
			return int(_percent*100); 
		}
		
		public function get description():String {
			return String(percent)+"% to block half damage";   
		}
//-----		
	}
}