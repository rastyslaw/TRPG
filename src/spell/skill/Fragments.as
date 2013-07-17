package spell.skill {
	import flash.geom.Point;
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Fragments implements ISkill, IIcon {   
		
		private var _percent:Number = .9; 
		private var cof:Number = 0.3; 
		
		public function get ico():String { 
			return "skill2";   
		} 
		
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
			var dirX:int; 
			var dirY:int;  
			var unit:Unit; 
			if (Math.random() < _percent) { 
				var p2:Point = Game.gerCoord(tar2.x, tar2.y);
				 
				for (var i:int; i < direction.length; i++) {   
					dirX = p2.x + direction[i][0];    
					dirY = p2.y + direction[i][1]; 
					if (Game.getIndex(dirX, dirY)) {
						unit = mas[dirY][dirX].unit; 
						if (unit != null) {  
							if (unit.enemy) { 
								unit.getDamage(int(damage * cof));
								if(unit.hp <= 0) func(unit); 
							}
						} 
					} 
				}
				//
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
			return String(percent)+"% to damage all targets around current";   
		}
//-----		
	}
}