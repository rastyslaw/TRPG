package spell {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Channel implements ISpell, IIcon { 
		 
		private var spdam:Number = 2.5;    
		private var unit:Unit; 
		 
		public function get ico():String { 
			return "spell13";   
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
			return null;       
		}
		
		public function get ress():String {
			return null; 
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit; 
			var dirX:int; 
			var dirY:int; 
			var cof:Number = 1;
			var damage:int; 
			var base_damage:int = unit.att * spdam; 
			if (Math.random() * 100 < unit.agi) { 
				base_damage *= 2;   
				unit.getDamage(0, true, false);      
			} 
				 
			if (mas[numY][numX].unit != undefined ) {    
				hero = mas[numY][numX].unit;   
				if (hero.enemy) { 
					 cof = 1 - mas[dirY][dirX].def * .1; 
					damage = (base_damage - hero.def) * cof;   
					if (damage <= 0) damage = 1; 
					hero.getDamage(damage, false, false, 0x011D65);
					unit.healing(int(damage/2));  
					if(hero.hp <= 0) game.killUnit(hero); 
				}
			}   
			unit.exp = damage;   
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
		
		public function get description():String {
			return "hit the target on [num] damage and heals himself for 50% of the damage done";     
		}
//-----		
	}
}