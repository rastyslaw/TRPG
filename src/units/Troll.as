package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Troll extends EnemyUnit {
		
		override internal function setSname():void {
			sname = "troll";   
		}

		override internal function setSpd():void { 
			speed = 4; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 160;
			att = 14;
			def = 12;
			agi = 4; 
		}
//-----		
	}
}