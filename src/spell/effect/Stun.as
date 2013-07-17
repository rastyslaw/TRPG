package spell.effect {
	import com.greensock.TweenMax;
	import spell.IIcon;
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Stun implements IEffect, IObserver, IIcon {  
		 
		private var timer:int = 2;
		private var unit:Unit;
		private var _ico:String;
		 
		public function Stun(tar:Unit, ico:String) { 
			unit = tar;
			_ico = ico; 
		}
		
		public function get ico():String { 
			return _ico;  
		}  
		 
		public function apply():void {
			unit.turn = false;
			TweenMax.to(unit, 1.4, { colorMatrixFilter: { hue:60 }} );
		}  
		 
		public function cancel():void {
			unit.turn = true;
			TweenMax.to(unit, 1.4, { colorMatrixFilter: { hue:0 }} );
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
			return "stunned"; 
		}
//-----		
	}
}