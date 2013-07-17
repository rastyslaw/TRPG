package spell.effect {
	import spell.IIcon;
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Fury implements IEffect, IObserver, IIcon {  
		 
		private var timer:int = 4;
		private var _cof:Number = 1.5; 
		private var unit:Unit;
		private var _ico:String;
		 
		public function Fury(tar:Unit, ico:String) { 
			unit = tar;
			_ico = ico; 
		}
		
		public function get ico():String { 
			return _ico;  
		}
		
		public function apply():void {
			unit.agi = unit.agi * cof;   
		} 
		
		public function cancel():void {
			unit.agi = unit.agi / cof;  
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
			return _cof; 
		}
		
		public function get description():String {
			return "battle rage";
		}
//-----		
	}
}