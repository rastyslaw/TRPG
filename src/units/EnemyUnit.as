package units {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
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
			zzz.x = 36;
			//var tween:UpTweener = new UpTweener(zzz); 
			//tween.addEventListener("FINISH", next); 
			setTimeout(next, 1200); 
		}
		 
		private function next():void {
			turn = false; 
			removeChild(zzz); 
			dispatchEvent(new Event("FINISH"));  
		}
		
		override protected function setDescription():void {  }
	
		override public function get direction():Array {  
			if (type=="archer") {
				_direction = [ [-2, 0], [2, 0], [0, -2], [0, 2],
							[-1,-1], [1, 1], [-1, 1], [1,-1] ]; 
			} 
			else if(type=="mage") {  
				_direction = [ [-1, 0], [1, 0], [0, -1], [0, 1], 
							[-2, 0], [2, 0], [0, -2], [0, 2],
							[-1,-1], [1, 1], [-1, 1], [1,-1] ]; 
			}
			return _direction;  
		}
		 
//-----		
	}
}