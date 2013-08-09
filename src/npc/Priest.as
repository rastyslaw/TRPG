package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Priest extends NPC {
		 
		override public function getIco():Bitmap {    
			return FaceAssets.getIco("face_priest");
		} 
		
		override public function getWords():String {        
			return "Hi, i'm soo busy";  
		}
		
		override protected function setType():void {     
			_type = "priest";      
		} 

		override protected function setClip():void {     
			clip = new Talk_up;  
		}
		
		override public function get dialog():Boolean {
			if (Main.questLine == 6) return true; 
			else return false;   
		}
//-----		
	}
}