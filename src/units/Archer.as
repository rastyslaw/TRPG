package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Archer extends ArrowUnit {
		 
		override internal function setSname():void {
			sname = "archer";   
		}
		 
		override internal function setSpd():void { 
			speed = 2; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 70;
			att = 12;
			def = 8;
			agi = 8; 
		}
//-----		
	}
}