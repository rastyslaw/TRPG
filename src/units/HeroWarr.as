package units {
	import flash.display.Bitmap;
	import spell.skill.ISkill;
	import spell.skill.Revenge;
	import spell.skill.Splash;
	/**
	 * ...
	 * @author waltasar
	 */
	public class HeroWarr extends Unit { 
		
		[Embed(source = "../../assets/faces/face_herowarr.png")]   
		private var ico:Class;   
		
		override public function getIco():Bitmap {   
			return new ico(); 
		}  
		
		override public function getName():String {   
			return "Hero";
		}   
		
		override protected function setSkilMas():void {      
			_skills = Vector.<ISkill>([new Splash, new Revenge]);       
		}
		
		override public function getClassName():String {     
			return "[Warrior]";
		}
		
		override protected function setDescription():void {   
			_description = "2222";
		}
		 
		override internal function setSname():void {
			sname = "hero_warr";    
		}
		 
		override internal function setSpd():void { 
			speed = 4; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 100;
			att = 19; 
			def = 16;
			agi = 8; 
		}
//-----		
	} 
}