package spell {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class MassHeal implements ISpell {
		
		private var spdam:Number = 2;  
		private var unit:Unit;
		private var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
		 
		public function get ico():String { 
			return "spell3";   
		} 
		
		public function get ramka():int { 
			return Game.RAMKA_CROSS;    
		}
		
		public function get summon():Boolean {
			return false;     
		}
		 
		public function set tar(value:Unit):void {
			unit = value;  
		} 
		  
		public function get baff():String { 
			return "massgood";        
		}
		
		public function get ress():String {
			return null;
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit = mas[numY][numX].unit; 
			var dirX:int; 
			var dirY:int; 
			var heal:int = unit.att * spdam; 
			
			if (Math.random() * 100 < unit.agi) {
				heal *= 2;   
				unit.healing(0, true);     
			}  
			if(hero!=null) hero.healing(heal);       
 
			for (var i:int = 0; i < direction.length; i++) {   
				dirX = numX + direction[i][0];     
				dirY = numY + direction[i][1];  
				if (Game.getIndex(dirX, dirY)) {
					hero = mas[dirY][dirX].unit; 
					if (hero != null) {  
						if (!hero.enemy) {   
							hero = mas[dirY][dirX].unit; 
							hero.healing(heal);
						} 
					}    
				}  
			} 
			unit.exp = heal;  
			var s:String;
			var p:Point = Game.gerCoord(unit.x, unit.y); 
			if (p.y == numY) { 
				if (p.x > numX) s = "l";
				else s = "r";
			}  
			else if (p.y > numY) {    
				 s = "t"; 
			}
			else s = "d"; 
			unit.cast(s);
			 		
			game.endTurn(unit);   
			unit.prev = null; 
		}
//-----		
	}
}