package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Monk extends NPC {
		
		[Embed(source = "../../assets/faces/face_monk.png")]   
		private var ico:Class; 
		  
		override public function getIco():Bitmap {   
			return new ico();  
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
			clip = new Ppp; 
		}
//-----		
	}
}