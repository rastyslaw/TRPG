package {
	/**
	 * ...
	 * @author waltasar
	 */
	public class DialogResourse {
		
		private static const monkReplic1:Array = ["bla-bla", "bla-bla-bla-bla-bla-\nbla-bla-bla-bla-\nbla-bla-bla-bla-bla-bla-bla-bla-bla-\nbla-bla-bla-bla-bla-bla-bla-bla-\nbla-bla-bla-bla-bla-\nbla-bla-bla-\nbla",
										         "bla-bla-bla-bla", "bla-bla-bla-bla-bla-bla-bla-bla"];
		private static const monkReplic2:Array = ["222222", "bla-bla-bla-bla-bla-\nbla-bla-bla-bla-\nbla-bla-bla-bla-bla-bla-bla-bla-bla-\nbla-bla-bla-bla-bla-bla-bla-bla-\nbla-bla-bla-bla-bla-\nbla-bla-bla-\nbla",
										         "bla-bla-bla-bla","bla-bla-bla-bla-bla-bla-bla-bla"];										 
		private static const girlReplic:Array = ["he-he", "he-he-he-he\nhe-hehe-hehe-he\nhe-hehe-hehe-he\nhe-hehe-he",
										         "he-hehe-hehe-he", "he-hehe-hehe-hehe-hehe-he"];
		private static const archerReplic:Array = ["he-he archer", "he-he-he-he\nhe-hehe-hehe-he\nhe-hehe-hehe-he\nhe-hehe-he",
										         "he-hehe-hehe-he", "he-hehe-hehe-hehe-hehe-he"];
		private static const barbarReplic:Array = ["he-he barbar", "he-he-he-he\nhe-hehe-hehe-he\nhe-hehe-hehe-he\nhe-hehe-he",
										         "he-hehe-hehe-he", "he-hehe-hehe-hehe-hehe-he"]; 
		private static const mageReplic:Array = ["he-he mage", "he-he-he-he\nhe-hehe-hehe-he\nhe-hehe-hehe-he\nhe-hehe-he",
										         "he-hehe-hehe-he", "he-hehe-hehe-hehe-hehe-he"];
		private static const guardReplic:Array = ["he-he guard", "he-he-he-he\nhe-hehe-hehe-he\nhe-hehe-hehe-he\nhe-hehe-he",
										         "he-hehe-hehe-he", "he-hehe-hehe-hehe-hehe-he"];												 
		public static function getReplicsMas(s:String):Array {     
			if (s.substr(0,3) == "npc") s = s.substr(4); 
			switch(s) { 
				case "monk":
					if(Main.questLine == 1) return monkReplic1;	  
					else return monkReplic2;	    
				break;
				case "girl":  
					return girlReplic;	  
				break;
				case "archer":    
					return archerReplic;	  
				break; 
				case "barbar_gir":   
					return barbarReplic;	  
				break;
				case "mage":   
					return mageReplic;	  
				break;
				case "guard":  
					return guardReplic;	  
				break;
				default: return [];
			}
		}
		
//-----		
	}
}