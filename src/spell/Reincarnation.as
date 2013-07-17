package spell {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Reincarnation implements ISpell, IIcon { 
		
		private var unit:Unit;
		
		public function get ico():String { 
			return "spell4";   
		}
		
		public function get ramka():int {  
			return Game.RAMKA_SIMPLE;    
		} 
		
		public function get summon():Boolean {
			return true;     
		}
		 
		public function set tar(value:Unit):void {
			unit = value;  
		}
		  
		public function get baff():String {
			return "";        
		}
		
		public function get ress():String {
			return "good";       
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit; 
			var dirX:int;  
			var dirY:int;   
			var p:Point = Game.gerCoord(unit.x, unit.y);
			 
			hero = mas[numY][numX].grave;
			mas[numY][numX].grave = undefined;
			mas[numY][numX].unit = hero;  
			hero.raincar();        
			
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
			game.endTurn(unit);   
			unit.prev = null; 
		}
		
		public function get description():String { 
			return "back target to life";     
		}
//-----		
	}
}