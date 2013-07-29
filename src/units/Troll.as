package units {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Troll extends EnemyUnit {
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_raise");
		}
		
		override public function getName():String {   
			return "Green Troll";  
		}
		
		override protected function setDescription():void {   
			_description = "3333";
		}
		
		override internal function setSname():void {
			sname = "troll";   
		}
		
		override internal function setSpd():void { 
			speed = 4; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 160;
			att = 14;
			def = 12;
			agi = 4; 
		}
//-----		
	}
}