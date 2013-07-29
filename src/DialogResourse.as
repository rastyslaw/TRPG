package {
	/**
	 * ...
	 * @author waltasar
	 */
	public class DialogResourse {
		
		private static const monkReplic:Array = ["bla-bla", "bla-bla-bla-bla-bla-\nbla-bla-bla-bla-\nbla-bla-bla-bla-bla-bla-bla-bla-bla-\nbla-bla-bla-bla-bla-bla-bla-bla-\nbla-bla-bla-bla-bla-\nbla-bla-bla-\nbla",
										         "bla-bla-bla-bla","bla-bla-bla-bla-bla-bla-bla-bla"];
		private static const girlReplic:Array = ["he-he", "he-he-he-he\nhe-hehe-hehe-he\nhe-hehe-hehe-he\nhe-hehe-he",
										         "he-hehe-hehe-he", "he-hehe-hehe-hehe-hehe-he"];
												 
		public static function getReplicsMas(s:String):Array {
			s = s.substr(4);
			switch(s) {
				case "monk":
					return monkReplic;	  
				break;
				case "girl":  
					return girlReplic;	  
				break; 
				default: return [];
			}
		}
//-----		
	}
}