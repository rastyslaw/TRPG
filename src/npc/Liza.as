package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Liza extends NPC {
		
		public function Liza() {
			random_walk = .1;   
		}
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_liza");
		}
		  
		override public function getWords():String {        
			return "I'm witch! Ha-ha-ha!\n456456456\nI'm witch! Ha-ha-ha!\nI'm witch!\nHa-ha-ha!\nI'm witch!"; 
		}
		  
		override public function setPath():void {            
			_path = Vector.<Point>([new Point(23, 12), new Point(22, 12), new Point(21, 12), new Point(20, 12), new Point(20, 11), new Point(20, 10),
									new Point(19, 10), new Point(18, 10), new Point(17, 10), new Point(16, 10), new Point(15, 10), new Point(14, 10),
									new Point(13, 10), new Point(12, 10), new Point(11, 10), new Point(11, 11), new Point(11, 12), new Point(11, 13),
									new Point(10, 13), new Point(9, 13), new Point(8, 13), new Point(7, 13), new Point(7, 14), new Point(7, 15),
									new Point(6, 15), new Point(5, 15), new Point(4, 15), new Point(3, 15), new Point(2, 15)]);         
		}
		 
		override protected function setType():void {     
			_type = "npc_liza"; 
		}
		   
		override protected function setPar():void {
			_walk = true;  
		}
		
		override protected function setClip():void {     
			clip = new Talk_up; 
		}
//-----		
	}
}