package  {
	/**
	 * ...
	 * @author waltasar
	 */
	public class Quests {
		
		private static const quest1:Array = ["Urgent order", "Find a church priest and talk to him",
											 "To you a little girl came running and said that you urgently calling a priest. She does not know what happened. You should as soon as possible to find him and find out what's wrong"];
		
		public static function getQuestLog(i:int):Array {
			switch(i) {
				case 1:
					return quest1; 
				break;
				default: return ["", "", ""];
			}
		}
		
//-----		
	}
}