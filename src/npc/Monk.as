package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Monk extends NPC {
		 
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_monk");
		} 
		
		override public function getWords():String {        
			return "Hi, my son";  
		}
		
		override protected function setType():void {     
			_type = "npc_monk";     
		}
		 
		override protected function setPar():void {
			_work = true; 
		}
		
		override protected function setClip():void {     
			clip = new Ress_up; 
		}
		
		override public function get dialog():Boolean {
			if (Main.questLine == 1 || Main.questLine == 3) return true; 
			else return false;  
		}
//-----		
	}
}