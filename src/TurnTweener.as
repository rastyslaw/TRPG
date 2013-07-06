package {
	import com.greensock.*; 
	import com.greensock.easing.*;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author waltasar
	 */
	public class TurnTweener extends Sprite {
		
		private var turn:turnInfo; 
		 
		public function TurnTweener(s:String) {
			turn = new turnInfo;
			turn.tt.text = s;
			addChild(turn);
			turn.x = -turn.width; 
			turn.y =  Constants.STAGE_HEIGHT >> 1;  
			TweenLite.to(turn, 1, { x:Constants.STAGE_WIDTH>>1, ease:Quint.easeOut, onComplete:onFinishTween}); 
		}
		 
		private function onFinishTween():void {
			TweenLite.to(turn, 1, {delay:1, x:Constants.STAGE_WIDTH+turn.width, ease:Quint.easeOut, onComplete:killTween});  
		}
		
		private function killTween():void { 
			this.parent.removeChild(this); 
		}
//-----		
	}
}