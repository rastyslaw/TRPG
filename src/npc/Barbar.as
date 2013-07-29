package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Barbar extends NPC {
		 
		override public function getIco():Bitmap {    
			return FaceAssets.getIco("face_barbar");
		}  
		
		override public function getWords():String {        
			return "Hi, i'm soo busy";  
		}
		
		override protected function setType():void {     
			_type = "barbar_gir";        
		}
		 
		override protected function setClip():void {     
			clip = new Talk_up;  
		}
//-----		
	}
}