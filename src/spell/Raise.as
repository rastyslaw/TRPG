package spell {
	import flash.geom.Point;
	import units.HeroCreator;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Raise implements ISpell, IIcon { 
		
		private var unit:Unit;
		
		public function get ico():String { 
			return "spell7";    
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
			return "bad";       
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit;    
			var p:Point = Game.gerCoord(unit.x, unit.y);
			  
			hero = mas[numY][numX].grave;
			hero.kill();  
			mas[numY][numX].grave = undefined;  
			Game.goodFactory.creating(HeroCreator.ZOMBIE, mas[numY][numX]); 
			game.unit_cont.setChildIndex(game.menu, game.unit_cont.numChildren-1); 
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
//-----		
	}
}