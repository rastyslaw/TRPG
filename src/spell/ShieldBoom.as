package spell {
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class ShieldBoom implements ISpell, IIcon { 
		
		private var spdam:Number = 2;  
		private var unit:Unit;
		private var _dam:int;
		private var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
		 
		public function get ico():String {   
			return "spell6";   
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
			return null;      
		}
		
		public function get ress():String {
			return null      
		}
		
		public function set dam(value:int):void {
			_dam = value;   
		}
		
		public function cast(numX:int, numY:int, mas:Vector.<Object>, game:Game):void {
			var hero:Unit; 
			var dirX:int; 
			var dirY:int;  
			var cof:Number = 1;
			var exp:uint;  

			for (var i:int = 0; i < direction.length; i++) {   
				dirX = numX + direction[i][0];     
				dirY = numY + direction[i][1]; 
				if (Game.getIndex(dirX, dirY)) {  
					if (mas[dirY][dirX].unit != undefined) { 
						hero = mas[dirY][dirX].unit; 
						if (hero.enemy) {     
							cof = 1 - mas[dirY][dirX].def * .1;
							hero.getDamage(_dam);    
							if(hero.hp <= 0) game.killUnit(hero);   
						} 
					}   
				}   
			}
			unit.exp = _dam;  
		}
		
		public function get description():String { 
			return "";     
		}
//-----		 
	}
}