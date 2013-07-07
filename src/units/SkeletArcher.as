package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class SkeletArcher extends ArrowUnit {
		
		override internal function setSname():void {
			sname = "skeletarcher";   
		}
		
		override internal function setEnemy():void { 
			enemy = true;  
		}
		
		override internal function setSpd():void { 
			speed = 2; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 20;
			att = 26;
			def = 2;
			agi = 19; 
		}
//-----		
	}
}