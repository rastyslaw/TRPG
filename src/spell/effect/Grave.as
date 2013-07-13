package spell.effect {
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Grave implements IEffect { 
		
		private var _timer:int = 2;
		private var unit:Unit;
		private var grave:GraveGr;
		
		public function Grave(tar:Unit) {
			unit = tar;  
		}
		 
		public function apply():void {
			unit.hero.kill();
			unit.hero = null; 
			unit.hpBar.tt.text = ""; 
			grave = new GraveGr;
			unit.addChildAt(grave, 0);    
		}
		
		public function cancel():void {
			unit.removeChild(grave); 
			//unit.stay();     
		}
		
		public function get timer():int { return _timer; } 
//-----		
	}
}