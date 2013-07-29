package units {
	import flash.display.Bitmap;
	import spell.skill.Binding;
	import spell.skill.ISkill;
	import spell.skill.Pierce;
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Archer extends ArrowUnit {
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_archer");
		}
		 
		override public function getName():String {   
			return "Gess";
		} 
		
		override protected function setSkilMas():void {      
			_skills = Vector.<ISkill>([new Binding, new Pierce]);        
		}
		
		override public function getClassName():String {     
			if (level <= 10) return "[Archer]";
			else return "[Sniper]";
		}
		 
		override protected function setDescription():void {   
			_description = "1111";
		}
		
		override internal function setSname():void {
			sname = "archer";   
		} 
		 
		override internal function setSpd():void { 
			speed = 2; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 70;
			att = 12;
			def = 8;
			agi = 18; 
		}
//-----		
	}
}