package spell {
	/**
	 * ...
	 * @author waltasar
	 */
	public class Fireball implements ISpell {
		 
		public function get ico():String { 
			return "spell5";  
		}
		
		public function get ramka():int {
			return Game.RAMKA_SIMPLE;    
		}
//-----		 
	}
}