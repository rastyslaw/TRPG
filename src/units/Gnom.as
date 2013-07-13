package units { 
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author waltasar 
	 */
	internal class Gnom extends Unit { 
		
		[Embed(source = "../../assets/faces/face_gnom.png")]   
		private var ico:Class; 
		
		override public function getIco():Bitmap {   
			return new ico(); 
		}  
		
		override public function getName():String {   
			return "Gimli";
		} 
		
		override public function getClassName():String {     
			if (level <= 10) return "[Warrior]";
			else return "[Berserk]";
		}
		
		override protected function setDescription():void {   
			_description = "2222";
		}
		
		override internal function setSname():void {
			sname = "gnom";    
		}
		 
		override internal function setSpd():void { 
			speed = 3; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 100;
			att = 22;
			def = 11;
			agi = 6; 
		}
//-----		
	} 
}