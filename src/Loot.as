package  {
	import flash.display.Sprite;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Loot extends Sprite {
		
		private var _who:String;
		private var _par:int;
		
		public function Loot() {
			addChild(new Place); 
		}
		
		public function get who():String {
			return _who; 
		}
		
		public function set who(value:String):void {
			_who = value;
		}
		
		public function get par():int {
			return _par;
		}
		 
		public function set par(value:int):void {
			_par = value;
		}
//-----		
	}
}