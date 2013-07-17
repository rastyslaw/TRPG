package spell.effect {
	import flash.geom.Point;
	import spell.IIcon;
	import spell.ShieldBoom;
	import units.IObserver;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Adsorb implements IEffect, IObserver, IIcon {  
		 
		private var timer:int = 4;
		private var _cof:int = 40;   
		private var unit:Unit;  
		private var _ico:String; 
		private var _mas:Vector.<Object>;  
		private var _game:Game; 
		
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
			var boom:ShieldBoom = new ShieldBoom();
			boom.tar = unit;
			boom.dam = int(_cof/3); 
			var p:Point = Game.gerCoord(unit.x, unit.y);
			boom.cast(p.x, p.y, _mas, _game);  
		}
		
		public function set mas(value:Vector.<Object>):void { 
			_mas = value; 
		}
		
		public function set game(value:Game):void { 
			_game = value;   
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
		
		public function get description():String {
			return "adsorb damage";
		}
//-----		
	}
}