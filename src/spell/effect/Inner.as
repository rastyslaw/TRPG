package spell.effect {
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Inner implements IEffect, IObserver { 
		 
		private var timer:int = 4;
		private var cof:Number = 1.3;
		private var unit:Unit;
		
		public function Inner(tar:Unit) {
			unit = tar;   
		}
		
		public function apply():void {
			unit.att = unit.att * cof;   
		} 
		
		public function cancel():void {
			unit.att = unit.att / cof;  
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