package units {
	import flash.display.Bitmap;
	import spell.Channel;
	import spell.ISpell;
	import spell.Shield;
	import spell.Storm;
	import spell.Summon;
	import spell.Telepotr;
	/**
	 * ...
	 * @author waltasar
	 */
	public class HeroMage extends MageUnit { 
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_heromage");
		}
		 
		override protected function setSpellMas():void {          
			_spellMas = Vector.<ISpell>([new Summon, new Shield, new Channel, new Storm, new Telepotr]);               
		}
		  
		override public function getName():String {   
			return "Hero"; 
		}  
		 
		override public function getClassName():String {     
			return "[Mage]"; 
		}
		
		override protected function setDescription():void {   
			_description = "fghrhswrgseg";
		}
		
		override internal function setSname():void {
			sname = "hero_mage";      
		} 
		
		override internal function setSpd():void { 
			speed = 3; 
		} 
		
		override internal function setAttributes():void {
			hp = max_hp = 46;
			att = 10;
			def = 5;
			agi = 11; 
			mp = max_mp = 30;
		}
//-----		
	}
}