package units {
	import flash.display.Bitmap;
	import spell.Dispel;
	import spell.Heal;
	import spell.ISpell;
	import spell.MassHeal;
	import spell.Raise;
	import spell.Reincarnation;
	import spell.Summon;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Priest extends MageUnit { 
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_priest");
		}
		
		override protected function setSpellMas():void {        
			_spellMas = Vector.<ISpell>([new Reincarnation, new Raise, new Dispel, new Heal, new MassHeal]);         
		}
		  
		override public function getName():String {   
			return "Bet"; 
		}  
		 
		override public function getClassName():String {     
			if (level <= 10) return "[Priest]";
			else return "[GrandPriest]"; 
		}
		
		override protected function setDescription():void {   
			_description = "fghrhswrgseg";
		}
		
		override internal function setSname():void {
			sname = "priest";     
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