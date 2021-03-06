package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Guard extends NPC {
	
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_guard");
		}
		
		override public function getWords():String {        
			return "Go away!";
		}
		
		override protected function setType():void {     
			_type = "npc_guard";    
		}
		 
	    override protected function setPar():void {
			_look = true;
		}
		
		override protected function setClip():void {     
			clip = new Talk_up; 
		}
//-----		
	}
}