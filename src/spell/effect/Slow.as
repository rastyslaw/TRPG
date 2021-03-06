package spell.effect {
	import spell.IIcon;
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Slow implements IEffect, IObserver, IIcon {  
		 
		private var timer:int = 4; 
		private var unit:Unit;
		private var _ico:String; 
		 
		public function Slow(tar:Unit, ico:String) { 
			unit = tar;
			_ico = ico; 
		}
		
		public function get ico():String { 
			return _ico;  
		}
		
		public function apply():void {
			unit.speed-=2; 
		}  
		
		public function cancel():void {
			unit.speed+=2;  
		}
		
		public function update():void {
			timer--;   
			if (timer < 1) unit.setEffects(this, true);
		}
		 
		public function insalubrity():Boolean {
			return true; 
		}
		
		public function get _unit():Unit {
			return unit;  
		}
		  
		public function get cof():Number {
			return 0; 
		}
		
		public function get description():String {
			return "reduced speed";
		}
//-----		
	}
}