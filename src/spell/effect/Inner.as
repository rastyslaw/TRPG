package spell.effect {
	/**
	 * ...
	 * @author waltasar
	 */
	public class Inner implements IEffect {
		 
		private var _timer:int = 2;
		
		public function apply():void {
			trace("apply");
		}
		
		public function cancel():void {
			trace("cancel"); 
		}
		
		public function get timer():int { return _timer; } 
//-----		
	}
}