package spell.effect {
	import spell.IIcon;
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */ 
	public class Protect implements IEffect, IObserver, IIcon {  
		 
		private var unit:Unit;
		private var _cof:Number = 0.3;
		private var _ico:String;
		 
		public function Protect(tar:Unit, ico:String) { 
			unit = tar;
			_ico = ico; 
		}
		
		public function get ico():String { 
			return _ico; 
		}
		
		public function apply():void {
			trace("apply");
		} 
		
		public function cancel():void {
			trace("cancel");
		}
		
		public function get cof():Number {
			return _cof; 
		}
		
		public function update():void {}
		 
		public function insalubrity():Boolean {
			return false; 
		}
		
		public function get _unit():Unit {
			return unit;  
		}
		
		public function get description():String {
			return "under protection"; 
		}
//-----		
	}
}