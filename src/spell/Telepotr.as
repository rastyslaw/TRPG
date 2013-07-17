package spell {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Telepotr implements ISpell, IIcon { 
		 
		private var unit:Unit;
		 
		public function get ico():String { 
			return "spell15";    
		} 
		
		public function get ramka():int { 
			return Game.RAMKA_SIMPLE;      
		} 
		
		public function get summon():Boolean {
			return true;      
		}
		
		public function get baff():String {
			return "bad";       
		}
		
		public function set tar(value:Unit):void {
			unit = value;  
		}
		
		public function get ress():String {
			return null ;
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var p:Point = Game.gerCoord(unit.x, unit.y); 
			mas[numY][numX].unit = unit;  
			mas[p.y][p.x].unit = undefined; 
			unit.x = numX * Map.grid_size - 8;
			unit.y = numY * Map.grid_size - 8;   

			var s:String; 
			if (p.y == numY) { 
				if (p.x > numX) s = "l";
				else s = "r";
			}   
			else if (p.y > numY) {    
				 s = "t"; 
			} 
			else s = "d"; 
			unit.cast(s);
			
			game.finishMovement(unit);
		}
		
		public function get description():String { 
			return "teleport)";     
		}
//-----		
	}
}