package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Captain extends NPC {
		
		[Embed(source = "../../assets/faces/face_pirat.png")]   
		private var ico:Class; 
		  
		override public function getIco():Bitmap {   
			return new ico();  
		} 
		
		override public function getWords():String {        
			return "I'm captain! Hoy!"; 
		}
		
		override protected function setType():void {     
			_type = "npc_pirat";     
		}
		
		override protected function setClip():void {     
			clip = new Ppp; 
		}
//----		
	}
}