package units {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Mage extends MageUnit { 
		
		[Embed(source = "../../assets/faces/face_mage.png")]   
		private var ico:Class; 
		
		override public function getIco():Bitmap {   
			return new ico(); 
		}
		
		override public function getName():String {   
			return "Slayer";
		}  
		 
		override public function getClassName():String {     
			if (level <= 10) return "[Mage]";
			else return "[Arhimage]";
		}
		
		override protected function setDescription():void {   
			_description = "3333";
		}
		
		override internal function setSname():void {
			sname = "mage";   
		}
		
		override internal function setSpd():void { 
			speed = 3; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 16;
			att = 8;
			def = 3;
			agi = 2; 
		}
//-----		
	}
}