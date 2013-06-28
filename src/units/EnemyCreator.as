package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class EnemyCreator extends CreatorUnits {
		
		public static const SKELARCHER:uint  = 0; 
		public static const TROLL:uint 	     = 1;
		public static const DEATH:uint	     = 2;
		
		override protected function createUnit(unit:uint):Unit {
			switch(unit) {
				case SKELARCHER:
					return new SkeletArcher(); 
				break;
				case TROLL:
					return new Troll();
				break;
				case DEATH:
					return new Death(); 
				break;
			default:
				throw new Error("Invalid unit"); 
			}
		}  
		
//-----
	}
}