package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Cook extends NPC {
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_cook");
		} 
		
		override public function getWords():String {        
			return "Hi, I'm like eat";  
		}
		
		override protected function setType():void {     
			_type = "npc_cook";     
		}
		 
		override protected function setPar():void {
			_work = true; 
		}
		
		override protected function setClip():void {     
			clip = new Talk_up; 
		}
//-----		
	}
}