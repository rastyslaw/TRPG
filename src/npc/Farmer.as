package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Farmer extends NPC {
		
		public function Farmer():void {
			random_work = .1;
			random_look = .1; 
			random_walk = .3; 
		}
		
		override public function getIco():Bitmap {    
			return FaceAssets.getIco("face_farmer");
		} 
		 
		override public function getWords():String {        
			return "Hi, i'm farmer!"; 
		}    
		  
		override public function setPath():void {            
			_path = Vector.<Point>([new Point(4, 5), new Point(4, 6), new Point(5, 6), new Point(5, 7), new Point(6, 7), new Point(7, 7)]);       
		}
		
		override protected function setType():void {     
			_type = "npc_farmer";  
		} 
		
		override protected function setPar():void {
			_work = true;
			_look = true;
			_walk = true; 
		}
		
		override protected function setClip():void {     
			clip = new Talk_up;   
		}
//-----		
	}
}