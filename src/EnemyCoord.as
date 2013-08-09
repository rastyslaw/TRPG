package  {
	import units.EnemyCreator;
	/**
	 * ...
	 * @author waltasar
	 */
	public class EnemyCoord {
		
		private static var mas1:Array = [[EnemyCreator.SKELARCHER,13,15]]; 
		//private static var mas1:Array = [[EnemyCreator.TROLL,3,6],[EnemyCreator.DEATH,2,7],[EnemyCreator.SKELARCHER,3,5]];
		
		public static function getCoords(i:int):Array {
			switch(i) { 
				case 1: 
					return mas1; 
				break;
				default: return []; 
			}
		}
		
//-----		
	}
}