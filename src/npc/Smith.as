package npc {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Smith extends NPC {
		
		[Embed(source = "../../assets/faces/face_smith.png")]   
		private var ico:Class; 
		 
		public function Smith():void {
			anvil = new Bitmap(new Anvil);
			addChild(anvil);
			anvil.scaleX = anvil.scaleY = .9;
		}
		
		override public function getIco():Bitmap {   
			return new ico();  
		}
		
		override public function getWords():String {        
			return "Hi, noob!"; 
		}
		
		override protected function setType():void {     
			_type = "npc_smith";  
		}
		
		override protected function setPar():void {
			_work = true; 
		}
		
		override protected function setClip():void {     
			clip = new Ggg;  
		}
//-----		
	}
}