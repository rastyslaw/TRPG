package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Professor extends NPC {
		
		public function Farmer():void {
			random_work = .1;
			random_look = .1;   
			random_walk = .3; 
		} 
		
		override public function getIco():Bitmap {    
			return FaceAssets.getIco("face_prof");
		} 
		 
		override public function getWords():String {        
			return "Hi, i'm crazy!";  
		}    
		  
		override public function setPath():void {             
			_path = Vector.<Point>([new Point(3, 13), new Point(3, 12), new Point(4, 12)]);       
		}
		
		override protected function setType():void {     
			_type = "npc_prof";  
		} 
		
		override protected function setPar():void {
			_work = true;
			_look = true;
			_walk = true; 
		}
		
		override protected function setClip():void {     
			clip = new Potion_up;   
		}
//-----		
	}
}