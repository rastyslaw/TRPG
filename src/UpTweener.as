package {
	import com.greensock.*;
	import com.greensock.easing.*;	
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author waltasar
	 */
	public class UpTweener extends Sprite {
		
		public function UpTweener(obg:Sprite) { 
			TweenLite.to(obg, 3, { y:-16, alpha:0.6, onComplete:onFinishTween}); 
		}
		 
		private function onFinishTween():void {  
			dispatchEvent(new Event("FINISH"));  
		}
//-----		
	}
}