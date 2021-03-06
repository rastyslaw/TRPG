package units {
	import flash.display.Bitmap;
	import spell.skill.Cutting;
	import spell.skill.Fragments;
	import spell.skill.ISkill;
	/**
	 * ...
	 * @author waltasar
	 */
	public class HeroArcher extends ArrowUnit {
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_heroarcher");
		}
		 
		override public function getName():String {   
			return "Hero";
		} 
		
		override public function getClassName():String {     
			return "[Archer]";
		}
		
		override protected function setSkilMas():void {      
			_skills = Vector.<ISkill>([new Cutting, new Fragments]);          
		}
		
		override protected function setDescription():void {   
			_description = "1111";
		}
		
		override internal function setSname():void {
			sname = "hero_archer";   
		} 
		 
		override internal function setSpd():void { 
			speed = 4; 
		}
		 
		override internal function setAttributes():void {
			hp = max_hp = 60;
			att = 22;
			def = 8;
			agi = 13; 
		}
//-----		
	}
}