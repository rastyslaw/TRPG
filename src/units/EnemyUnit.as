package units {
	import flash.events.Event;
	/**
	 * ...
	 * @author waltasar
	 */
	public class EnemyUnit extends Unit {
		
		private var zzz:Zzz;
		 
		override internal function setEnemy():void { 
			enemy = true;  
		}
		 
		public function skip():void {  
			zzz = new Zzz;  
			addChild(zzz);
			zzz.y = 10;
			var tween:UpTweener = new UpTweener(zzz); 
			tween.addEventListener("FINISH", next); 
		}
		 
		private function next(e:Event):void {
			turn = false; 
			removeChild(zzz); 
			dispatchEvent(new Event("FINISH"));  
		}
		   
		public function enemyDirection(s:String=null):Array {
			switch(s) {
				case "archer":
					_direction = [ [-2, 0], [2, 0], [0, -2], [0, 2],
								[-1,-1], [1, 1], [-1, 1], [1,-1] ]; 
				break;
				case "mage": 
					_direction = [ [-1, 0], [1, 0], [0, -1], [0, 1], 
								[-2, 0], [2, 0], [0, -2], [0, 2],
								[-1,-1], [1, 1], [-1, 1], [1,-1] ]; 
				break;
			}
			return _direction; 
		}
		 
//-----		
	}
}