package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Fisher extends NPC {
		
		public function Fisher():void { 
			bobber = new Bobber();
			this.addChild(bobber);
			bobber.x = 84;
			bobber.y = 46;  
			bobber.mouseEnabled = false;
			bobber.visible = false; 
		}
		
		override public function getIco():Bitmap {    
			return FaceAssets.getIco("face_fisher");
		}
		
		override public function getWords():String {        
			return "Hi, i'm love fish!!"; 
		} 
		
		override protected function setType():void {     
			_type = "npc_fisher";  
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