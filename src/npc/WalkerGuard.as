package npc {
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class WalkerGuard extends Guard { 
		
		public function WalkerGuard() {
			random_walk = .1;   
		}
		
		override public function getWords():String {        
			return "Go go go go!";
		}
		
		override public function setPath():void {             
			_path = Vector.<Point>([new Point(13, 19), new Point(14, 19), new Point(15, 19), new Point(16, 19), new Point(17, 19), new Point(18, 19),
									new Point(18, 18), new Point(18, 17), new Point(18, 16), new Point(18, 15), new Point(18, 14), new Point(18, 13),
									new Point(18, 12), new Point(18, 11), new Point(18, 10), new Point(18, 9), new Point(18, 8), new Point(17, 8),
									new Point(16, 8), new Point(15, 8), new Point(14, 8), new Point(13, 8), new Point(12, 8)]);         
		}
		 
		override protected function setPar():void {
			_look = true;
			_walk = true;    
		}
//-----		
	}
}