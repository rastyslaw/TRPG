package spell.skill {
	import flash.geom.Point;
	import spell.IIcon;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Pierce implements ISkill, IIcon {   
		 
		private var _percent:Number = .9; 
		private var cof:Number = 0.5; 
		 
		public function get ico():String { 
			return "skill7";   
		}
		 
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			var unit:Unit;
			var direction:Array;
			var dirX:int; 
			var dirY:int;
			
			if (Math.random() < _percent) { 
				var p1:Point = Game.gerCoord(tar1.x, tar1.y); 
				var p2:Point = Game.gerCoord(tar2.x, tar2.y);
			
				if (p1.y == p2.y) {  
					if (p1.x > p2.x) direction = [-1, 0];
					else direction = [1, 0];
				}  
				else if (p1.y > p2.y) {   
					 direction = [0, -1];
				}  
				else direction = [0, 1]; 
					
				dirX = p2.x + direction[0];     
				dirY = p2.y + direction[1]; 
					
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