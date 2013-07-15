package spell.skill {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Splash implements ISkill {
		
		private var _percent:Number = 1; 
		private var cof:Number = 0.5; 
		  
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
			var dirX:int; 
			var dirY:int;
			var unit:Unit; 
			if (Math.random() < _percent) { 
				var p1:Point = Game.gerCoord(tar1.x, tar1.y); 
				var p2:Point = Game.gerCoord(tar2.x, tar2.y);
				if (p1.x != p2.x) direction.splice(0, 2);
				else direction.splice(2);
				 
				for (var i:int; i < direction.length; i++) {   
					dirX = p1.x + direction[i][0];    
					dirY = p1.y + direction[i][1]; 
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
		 
		public function set percent(value:int):void {
			_percent = value/100; 
		}
		
		public function get percent():int {
			return int(_percent*100); 
		}
//-----		
	}
}