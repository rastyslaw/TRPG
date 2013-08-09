package units {
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar
	 */
	internal class SkeletArcher extends EnemyUnit { 
		 
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_raise"); 
		}
		
		override public function getName():String {   
			return "Skeleton";  
		} 
		
		override protected function setDescription():void {   
			_description = "3333";
		}
		
		override internal function setSname():void {
			sname = "skeletarcher";   
		}
		
		override internal function setType():void { 
			type = "archer"; 
		}
		
		override internal function setEnemy():void { 
			enemy = true;  
		}
		
		override internal function setSpd():void { 
			speed = 3; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 20;
			att = 26;
			def = 2;
			agi = 19; 
		}
//-----		
	}
}