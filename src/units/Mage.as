package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Mage extends MageUnit {
		
		override internal function setSname():void {
			sname = "mage";   
		}
		
		override internal function setSpd():void { 
			speed = 3; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 40;
			att = 8;
			def = 3;
			agi = 2; 
		}
//-----		
	}
}