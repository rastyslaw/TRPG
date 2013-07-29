package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Mage extends NPC {
		 
		override public function getIco():Bitmap {    
			return FaceAssets.getIco("face_mage");
		} 
		
		override public function getWords():String {        
			return "Hi, i'm soo busy";  
		}
		
		override protected function setType():void {     
			_type = "mage";     
		}
		
		override public function setPath():void {            
			_path = Vector.<Point>([new Point(4, 13), new Point(5, 13)]);          
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