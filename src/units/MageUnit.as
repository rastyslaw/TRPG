package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class MageUnit extends Unit {
		
		private var _mp:int;
		private var _max_mp:int;   
		private var spellMas:Array; 
		 
		override internal function setType():void { 
			type = "mage"; 
		}
		
		override internal function initDirection():void {
			_direction = [ [-1, 0], [1, 0], [0, -1], [0, 1], 
						   [-2, 0], [2, 0], [0, -2], [0, 2],
						   [-1,-1], [1, 1], [-1, 1], [1,-1] ]; 
		}
		
		public function get mp():int { return _mp; }
		public function set mp(value:int):void { _mp = value; }
		
		public function get max_mp():int { return _max_mp; }
		public function set max_mp(value:int):void { _max_mp = value; }
		
//-----		
	}
}