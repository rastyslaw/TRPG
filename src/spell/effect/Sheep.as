package spell.effect {
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Sheep implements IEffect, IObserver { 
		 
		private var timer:int = 4; 
		private var unit:Unit;  
		 
		public function Sheep(tar:Unit) {
			unit = tar;   
		}  
		
		public function apply():void {
			unit.issheep = true;
			unit.stay();  
		} 
		
		public function cancel():void {
			unit.issheep = false;
			unit.stay();  
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