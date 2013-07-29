package units { 
	import flash.display.Bitmap;
	import spell.skill.Block;
	import spell.skill.ISkill;
	import spell.skill.Prot;
	import spell.skill.Revenge;
	import spell.skill.Splash;
	/**
	 * ...
	 * @author waltasar 
	 */
	internal class Gnom extends Unit { 
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_gnom");
		}  
		
		override public function getName():String {   
			return "Gimli";
		} 
		
		override protected function setSkilMas():void {      
			_skills = Vector.<ISkill>([new Prot, new Block]);      
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
			att = 19;
			def = 11;
			agi = 6; 
		}
//-----		
	} 
}