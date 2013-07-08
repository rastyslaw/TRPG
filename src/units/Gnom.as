package units { 
	/**
	 * ...
	 * @author waltasar 
	 */
	internal class Gnom extends Unit { 
		
		override internal function setSname():void {
			sname = "gnom";   
		}
		 
		override internal function setSpd():void { 
			speed = 3; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 100;
			att = 22;
			def = 11;
			agi = 6; 
		}
//-----		
	} 
}