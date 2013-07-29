package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Captain extends NPC {
		 
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_pirat");
		} 
		 
		override public function getWords():String {        
			return "I'm captain! Hoy!"; 
		}
		
		override protected function setType():void {     
			_type = "npc_pirat";     
		}
		
		override protected function setClip():void {     
			clip = new Talk_up; 
		}
//----		
	}
}