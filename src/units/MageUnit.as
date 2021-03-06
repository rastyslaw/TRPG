package units {
	import flash.errors.IllegalOperationError;
	import spell.ISpell; 
	/**
	 * ...
	 * @author waltasar
	 */
	public class MageUnit extends Unit {
		
		private var _mp:int;
		private var _max_mp:int;   
		protected var _spellMas:Vector.<ISpell>;   
		    
		public function MageUnit() {
			setSpellMas(); 
		}
		 
		override internal function setType():void {   
			type = "mage"; 
		}
		 
		protected function setSpellMas():void {      
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}
		
		override internal function initDirection():void {
			_direction = [ [-1, 0], [1, 0], [0, -1], [0, 1], 
						   [-2, 0], [2, 0], [0, -2], [0, 2],
						   [-1,-1], [1, 1], [-1, 1], [1,-1] ]; 
		}
		
		public function get mp():int {  
			return _mp+correctLoot(5); 
		}
		public function set mp(value:int):void { _mp = value; }
		
		public function get max_mp():int {
			return _max_mp+correctLoot(5); 
		}
		public function set max_mp(value:int):void { _max_mp = value; }
		
		public function get spellMas():Vector.<ISpell> {
			return _spellMas;  
		}
//-----		
	}
}