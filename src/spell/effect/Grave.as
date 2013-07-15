package spell.effect {
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Grave implements IEffect, IObserver { 
		
		private var timer:int = 4;  
		private var unit:Unit;
		private var grave:GraveGr;
		
		public function Grave(tar:Unit) {
			unit = tar;  
		} 
		 
		public function apply():void { 
			if (unit.hero!=null) {
				unit.hero.kill();
				unit.hero = null; 
			}
			unit.hpBar.tt.text = ""; 
			grave = new GraveGr; 
			unit.addChildAt(grave, 0);
			grave.mouseEnabled = false;
		} 
		
		public function cancel():void { 
			unit.removeChild(grave);
			unit.kill();
		}
		
		public function back():void { 
			unit.removeChild(grave); 
		}
		
		public function update():void {
			timer--;  
			if (timer < 1) unit.setEffects(this, true);
		}
		 
		public function insalubrity():Boolean {
			return false; 
		}
//-----		
	}
}