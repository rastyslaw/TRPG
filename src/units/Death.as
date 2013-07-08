package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Death extends EnemyUnit {
		
		override internal function setSname():void {
			sname = "death";   
		}
		
		override internal function setEnemy():void { 
			enemy = true;  
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 120;
			att = 14;
			def = 8;
			agi = 5; 
		}
//-----	
	}
}