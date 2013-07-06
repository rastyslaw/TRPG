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
			speed = 3; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 160;
			att = 10;
			def = 18;
			agi = 4; 
		}
//-----		
	}
}