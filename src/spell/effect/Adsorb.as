package spell.effect {
	import spell.IIcon;
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Adsorb implements IEffect, IObserver, IIcon {  
		 
		private var timer:int = 4;
		private var _cof:int = 30;  
		private var unit:Unit; 
		private var _ico:String; 
		
		public function Adsorb(tar:Unit, ico:String) { 
			unit = tar;
			_ico = ico; 
		}
		
		public function get ico():String { 
			return _ico;  
		}
		
		public function apply():void {
			unit.adsorber = _cof; 
		} 
		
		public function cancel():void {
			unit.adsorber = 0;     
		}
		
		public function update():void {
			timer--;   
			if (timer < 1) unit.setEffects(this, true);
		}
		 
		public function insalubrity():Boolean {
			return false; 
		}
		
		public function get _unit():Unit {
			return unit;  
		} 
		  
		public function get cof():Number {
			return 0;   
		}
//-----		
	}
}