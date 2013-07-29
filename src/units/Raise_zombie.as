package units {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Raise_zombie extends Unit { 
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_raise");
		}  
		
		override public function getName():String {   
			return "Zombie"; 
		}  
		
		override public function getClassName():String {     
			return "[Warrior]";
		}
		
		override protected function setDescription():void {   
			_description = "2222";
		}
		
		override internal function setSname():void {
			sname = "raise";      
		}
		 
		override internal function setSpd():void { 
			speed = 2; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 60; 
			att = 16;
			def = 11;
			agi = 1;  
		}
//-----		
	}
}