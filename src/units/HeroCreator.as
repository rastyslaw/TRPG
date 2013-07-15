package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class HeroCreator extends CreatorUnits {
		
		public static const ARCHER:uint  = 0; 
		public static const GNOM:uint 	 = 1; 
		public static const MAGE:uint	 = 2;
		public static const PRIEST:uint  = 3; 
		public static const ZOMBIE:uint  = 4;
		public static const SPIDER:uint  = 5;
		
		override protected function createUnit(unit:uint):Unit {
			switch(unit) {
				case ARCHER:
					return new Archer();
				break;
				case GNOM:
					return new Gnom();
				break;
				case MAGE:
					return new Mage(); 
				break;
				case PRIEST:
					return new Priest();  
				break;
				case ZOMBIE:
					return new Raise_zombie();   
				break;
				case SPIDER:
					return new Spider();  
				break;
			default:
				throw new Error("Invalid unit"); 
			}
		} 
		
//-----		
	}
}