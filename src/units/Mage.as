package units {
	import flash.display.Bitmap;
	import spell.Fireball;
	import spell.Flare;
	import spell.InnerFire;
	import spell.ISpell;
	import spell.Polymorph;
	import spell.RainOfFire;
	import spell.Reincarnation;
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
		
		override protected function setSpellMas():void {      
			_spellMas = Vector.<ISpell>([new Flare, new Fireball, new RainOfFire, new InnerFire, new Polymorph]);  
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
			hp = max_hp = 56;
			att = 12;
			def = 3;
			agi = 32;
			mp = max_mp = 20;
		}
//-----		
	}
}