package spell {
	import flash.geom.Point;
	import spell.effect.Inner;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class InnerFire implements ISpell, IIcon { 
		 
		private var unit:Unit;
		private var _cof:Number = 1.3;
		 
		public function get ico():String { 
			return "spell11";   
		}
		
		public function get ramka():int { 
			return Game.RAMKA_SIMPLE;      
		} 
		
		public function get summon():Boolean {
			return false;     
		}
		
		public function get baff():String {
			return "good";      
		}
		
		public function set tar(value:Unit):void {
			unit = value;  
		}
		
		public function get ress():String {
			return null ;
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit; 
					 
			hero = mas[numY][numX].unit;  
			if (hero == null) return;
			hero.setEffects(new Inner(hero, ico)); 
			
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
			return "targets attack increase on "+ String(_cof)+" %";     
		}
//-----		
	}
}