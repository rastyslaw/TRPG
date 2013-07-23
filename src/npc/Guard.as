package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Guard extends NPC {
		
		[Embed(source = "../../assets/faces/face_guard.png")]   
		private var ico:Class; 
		  
		override public function getIco():Bitmap {   
			return new ico();  
		}
		
		override public function getWords():String {        
			return "Go away!";
		}
		
		override protected function setType():void {     
			_type = "npc_guard";    
		}
		
	    override protected function setPar():void {
			_look = true;
			//_walk = true;  
		}
		
		override protected function setClip():void {     
			clip = new Ppp; 
		}
//-----		
	}
}