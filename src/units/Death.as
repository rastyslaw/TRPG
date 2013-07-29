package units {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Death extends EnemyUnit {
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_raise");
		}
		
		override public function getName():String {   
			return "Death";  
		}
		
		override protected function setDescription():void {   
			_description = "3333";
		}
		
		override internal function setSname():void {
			sname = "death";   
		}
		
		override internal function setEnemy():void { 
			enemy = true;  
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 110;
			att = 24;
			def = 8; 
			agi = 5; 
		}
//-----	
	}
}