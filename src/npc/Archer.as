package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Archer extends NPC {
		 
		override public function getIco():Bitmap {    
			return FaceAssets.getIco("face_archer");
		} 
		
		override public function getWords():String {        
			return "Hi, i'm soo busy";  
		}
		
		override protected function setType():void {     
			_type = "archer";     
		}
		
		override public function setPath():void {            
			_path = Vector.<Point>([new Point(15, 6), new Point(14, 6), new Point(14, 5), new Point(14, 4), new Point(15, 4)]);          
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