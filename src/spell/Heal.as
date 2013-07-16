package spell {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Heal implements ISpell, IIcon { 
		 
		private var spdam:Number = 2.5;    
		private var unit:Unit;
		 
		public function get ico():String { 
			return "spell1";   
		}
		
		public function get ramka():int {  
			return Game.RAMKA_SIMPLE;    
		} 
		
		public function get summon():Boolean {
			return false;     
		}
		 
		public function set tar(value:Unit):void {
			unit = value;  
		}
		   
		public function get baff():String {
			return "good";       
		}
		
		public function get ress():String {
			return null;
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit = mas[numY][numX].unit; 
			var heal:int = unit.att * spdam; 
			if (Math.random() * 100 < unit.agi) {
				heal *= 2;   
				unit.healing(0, true);     
			}
			hero.healing(heal);    
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