package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class HeroCreator extends CreatorUnits {
		
		public static const ARCHER:uint 	 = 0; 
		public static const GNOM:uint 		 = 1; 
		public static const MAGE:uint		 = 2;
		public static const PRIEST:uint 	 = 3; 
		public static const ZOMBIE:uint  	 = 4;
		public static const SPIDER:uint      = 5;
		
		public static const HERO_MAGE:uint   = 6;
		public static const HERO_ARCHER:uint = 7; 
		public static const HERO_WARR:uint   = 8; 
		
		public static const BARBAR:uint 	 = 9;
		
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
				case HERO_MAGE:
					return new HeroMage();   
				break;
				case HERO_ARCHER:
					return new HeroArcher();   
				break;
				case HERO_WARR: 
					return new HeroWarr();   
				break;
				case BARBAR:   
					return new Barbar();   
				break;
			default:
				throw new Error("Invalid unit"); 
			}
		} 
		
//-----		
	}
}