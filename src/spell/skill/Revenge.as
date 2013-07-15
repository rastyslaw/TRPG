package spell.skill {
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Revenge implements ISkill {
		 
		private var _percent:Number = 0.9; 
		  
		public function calk(tar1:Unit, tar2:Unit, mas:Vector.<Object>, damage:int, func:Function):void {
			var unit:Unit;
			var cof:Number = 1; 
			var s:String;  
			var damage:int;  
			if (Math.random() < _percent) {
				var p1:Point = Game.gerCoord(tar1.x, tar1.y);
				var p2:Point = Game.gerCoord(tar2.x, tar2.y); 
				if (tar1.y == tar2.y) {  
					if (tar1.x < tar2.x) s = "l";
					else s = "r";
				}   
				else if (tar1.y < tar2.y) {   
					 s = "t";   
				} 
				else s = "d"; 
				tar2.attack(s);   
				if (Math.random() * 100 < tar1.agi) {
					tar1.getDamage(0, false, true);
				}
				else {   
					if(mas[p1.y][p1.x].coff < 5) cof = 1 - mas[p1.y][p1.x].coff * .1; 
					damage = (tar2.att - tar1.def) * cof;
					if (Math.random() * 100 < tar2.agi) { 
						damage *= 2;  
						tar2.getDamage(0, true);   
					}    
					if (damage <= 0) damage = 1; 
					tar1.getDamage(damage);  
					tar2.exp = damage; 
					for each(var ss:ISkill in tar2.skills) {      
						if(!(ss is Revenge)) ss.calk(tar2, tar1, mas, damage, func);    
					}
				} 
				if(tar1.hp <= 0) func(tar1);    
			}
		}

		public function set percent(value:int):void {
			_percent = value/100; 
		}
		
		public function get percent():int {
			return int(_percent*100); 
		} 
//-----		
	}
}