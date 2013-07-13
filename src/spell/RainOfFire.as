package spell {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class RainOfFire implements ISpell {
		 
		private var spdam:Number = 1.5;     
		private var unit:Unit;
		private var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1], 
									   [ -1, -1], [1, -1], [1, -1], [-1, 1]];
		 
		public function get ico():String { 
			return "spell10";    
		}
		
		public function get ramka():int {  
			return Game.RAMKA_SQUARE;     
		} 
		
		public function get summon():Boolean { 
			return false;     
		}
		 
		public function set tar(value:Unit):void {
			unit = value;  
		}
		 
		public function get baff():Boolean {
			return false;       
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit; 
			var dirX:int; 
			var dirY:int; 
			var cof:Number = 1;
			var damage:int;
			var exp:uint;  
			var base_damage:int = unit.att * spdam; 
			if (Math.random() * 100 < unit.agi) { 
				base_damage *= 2;   
				unit.getDamage(0, true, false, 0xff6600);     
			} 
				
			if (mas[numY][numX].unit != undefined ) {    
				hero = mas[numY][numX].unit; 
				if (hero.enemy) { 
					if (mas[dirY][dirX].coff < 5) cof = 1 - mas[dirY][dirX].coff * .1; 
					damage = (base_damage - hero.def) * cof;   
					if (damage <= 0) damage = 1;
					exp += damage; 
					hero.getDamage(damage, false, false, 0xff6600);    
					if(hero.hp <= 0) game.killUnit(hero); 
				}
			}   
			 
			for (var i:int = 0; i < direction.length; i++) {   
				dirX = numX + direction[i][0];     
				dirY = numY + direction[i][1]; 
				if (Game.getIndex(dirX, dirY)) {  
					if (mas[dirY][dirX].unit != undefined) { 
						hero = mas[dirY][dirX].unit; 
						if (hero.enemy) {     
							if (mas[dirY][dirX].coff < 5) cof = 1 - mas[dirY][dirX].coff * .1;
							damage = (base_damage-hero.def) * cof;
							if (damage <= 0) damage = 1;
							exp += damage;  
							hero.getDamage(damage, false, false, 0xff6600);    
							if(hero.hp <= 0) game.killUnit(hero);   
						} 
					}   
				}  
			}
			unit.exp = uint(exp * 0.6); 
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