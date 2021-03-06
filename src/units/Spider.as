package units { 
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Spider extends Unit { 
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_spider");
		}  
		
		override public function getName():String {   
			return "Spider";
		} 
		
		override public function getClassName():String {     
			return "[Warrior]";
		}
		 
		override protected function setDescription():void {   
			_description = "2222";
		}
		
		override internal function setSname():void {
			sname = "spider";     
		} 
		 
		override internal function setSpd():void { 
			speed = 4; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 60;
			att = 22;
			def = 5;
			agi = 11;  
		}
//-----		
	}
}