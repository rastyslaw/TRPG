package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class HeroCreator extends CreatorUnits {
		
		public static const ARCHER:uint  = 0; 
		public static const GNOM:uint 	 = 1; 
		public static const MAGE:uint	 = 2;
		
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
			default:
				throw new Error("Invalid unit"); 
			}
		} 
		
//-----		
	}
}