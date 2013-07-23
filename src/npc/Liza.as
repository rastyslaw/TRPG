package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Liza extends NPC {
		
		[Embed(source = "../../assets/faces/face_liza.png")]   
		private var ico:Class;  
		 
		public function Liza() {
			random_walk = .3;  
		}
		
		override public function getIco():Bitmap {   
			return new ico();  
		}
		  
		override public function getWords():String {        
			return "I'm witch! Ha-ha-ha!\n456456456\nI'm witch! Ha-ha-ha!\nI'm witch!\nHa-ha-ha!\nI'm witch!"; 
		}
		  
		override public function setPath():void {           
			_path = Vector.<Point>([new Point(1, 2), new Point(2, 2), new Point(3, 2), new Point(4, 2), new Point(5, 2), new Point(6, 2)]);       
		}
		 
		override protected function setType():void {     
			_type = "npc_liza"; 
		}
		   
		override protected function setPar():void {
			_walk = true;  
		}
		
		override protected function setClip():void {     
			clip = new Ppp; 
		}
//-----		
	}
}