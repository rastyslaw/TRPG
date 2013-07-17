package units {
	import flash.display.Bitmap;
	import spell.skill.ISkill;
	import spell.skill.Rage;
	import spell.skill.Stuner;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Barbar extends Unit { 
		
		[Embed(source = "../../assets/faces/face_barbar.png")]   
		private var ico:Class; 
		  
		override public function getIco():Bitmap {   
			return new ico(); 
		}  
		
		override public function getName():String {   
			return "Barb";
		} 
		
		override protected function setSkilMas():void {      
			_skills = Vector.<ISkill>([new Stuner, new Rage]);      
		}
		
		override public function getClassName():String {     
			return "[Barbarian]";
		}
		
		override protected function setDescription():void {   
			_description = "2222";
		}
		
		override internal function setSname():void {
			sname = "barbar";    
		}
		 
		override internal function setSpd():void { 
			speed = 4; 
		}
		
		override internal function setAttributes():void {
			hp = max_hp = 105; 
			att = 22; 
			def = 11;
			agi = 22; 
		}
//-----		
	} 
}