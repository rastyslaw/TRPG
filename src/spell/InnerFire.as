package spell {
	import flash.geom.Point;
	import spell.effect.Inner;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class InnerFire implements ISpell { 
		 
		private var unit:Unit;
		 
		public function get ico():String { 
			return "spell11";   
		}
		
		public function get ramka():int { 
			return Game.RAMKA_SIMPLE;      
		} 
		
		public function get summon():Boolean {
			return false;     
		}
		
		public function get baff():Boolean {
			return true;      
		}
		
		public function set tar(value:Unit):void {
			unit = value;  
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit; 
			var dirX:int; 
			var dirY:int; 
					
			hero = mas[numY][numX].unit;  
			if (hero == null) return;
			if (hero.enemy) return; 
			hero.setEffects(new Inner);
			
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