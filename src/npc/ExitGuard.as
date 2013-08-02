package npc {
	/**
	 * ...
	 * @author waltasar
	 */ 
	public class ExitGuard extends Guard { 
		
		override public function getWords():String {        
			return "There's too dangerous!"; 
		}
		
		override public function get dialog():Boolean {
			if (Main.questLine == 4) return true; 
			else return false;   
		}
//-----		
	}
}