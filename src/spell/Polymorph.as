package spell {
	import flash.geom.Point;
	import spell.effect.Sheep;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Polymorph implements ISpell, IIcon { 
		 
		private var unit:Unit; 
		 
		public function get ico():String { 
			return "spell12";   
		}
		
		public function get ramka():int { 
			return Game.RAMKA_SIMPLE;      
		} 
		
		public function get summon():Boolean {
			return false;     
		}
		
		public function get baff():String {
			return "bad";       
		}
		
		public function set tar(value:Unit):void {
			unit = value;  
		}
		
		public function get ress():String {
			return null  ;
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit; 
			var dirX:int;  
			var dirY:int; 
					  
			hero = mas[numY][numX].unit;  
			if (hero == null) return;
			hero.setEffects(new Sheep(hero, ico));  
			
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