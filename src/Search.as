package  {
	/**
	 * ...
	 * @author waltasar
	 */
	public class Search {
		
		public static function look(mas:*, s:*, j:int):int {
			var num:int; 
			for (var i:int; i < mas.length; i++) {
				if (mas[i][j] == s) num++; 
			}
			return num;  
		}
		
		public static function lookLine(mas:*, s:*):int {
			var num:int;
			trace(s);
			for (var i:int; i < mas.length; i++) {
				trace(mas[i]);
				if (mas[i] == s) num++; 
			}
			return num;  
		}
		 
		public static function lookClass(mas:*, s:Class):int {
			for (var i:int; i < mas.length; i++) {
				if (mas[i] is s) return i;
			} 
			return -1; 
		}
//-----		
	}
}