package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class SkeletArcher extends EnemyUnit { 
		 
		override internal function setSname():void {
			sname = "skeletarcher";   
		}
		
		override internal function setType():void { 
			type = "archer"; 
		}
		
		override internal function setEnemy():void { 
			enemy = true;  
		}
		
		override internal function setSpd():void { 
			speed = 3; 
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