package  {
	/**
	 * ...
	 * @author waltasar
	 */
	public class Quests {
		
		private static const quest1:Array = ["Urgent order", "Find a church priest and talk to him",
											 "To you a little girl came running and said that you urgently calling a priest. She does not know what happened. You should as soon as possible to find him and find out what's wrong"];
		private static const quest2:Array = ["Search teams", "To rescue the missing priest, find two volunteers",
											 "You talked to the priest and found that they had an argument with another priest, who is better. And to prove his superiority to turn undead, he went to the nearest graveyard. Save him from certain death."];
		private static const quest3:Array = ["Rescue priest", "You put together a team and overgrowth you have the strength rescue the priest",
											 "You find the team and returned to the priest. It is recommended that you start looking at the nearest graveyard. Harry should be there. Maybe he's still alive. You need to hurry."];
		 
		public static function getQuestLog(i:int):Array {
			var mas:Array; 
			switch(i) {
				case 1: 
					return quest1; 
				break;
				case 2:
					mas = quest2;
					if(Main.numParty != 1) mas[0] = "Find one more member the team";  
					return mas;  
				break;
				case 3:
					mas = quest2;
					mas[0] = "Go back and talk to the priest";   
					return mas; 
				break;
				case 4:
				case 5:  
					return quest3; 
				break; 
				default: return ["", "", ""];
			}
		}
		
//-----		
	}
}