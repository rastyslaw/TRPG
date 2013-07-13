package {
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.Sprite;
	/** 
	 * ...
	 * @author waltasar
	 */
	public class TweenBar extends Sprite {
		
		private var obg:DamageBar;
		private var _value:String;
		private var _color:uint = 0xDDE901; 
		
		public function init():void {
			obg = new DamageBar;
			obg.tt.text = _value;
			obg.tt.textColor = _color;   
			addChild(obg);   
			TweenLite.to(obg, 0.3, { y:-20, ease:Quint.easeOut, onComplete:onFinishTween}); 
		}
		
		private function onFinishTween():void {
			TweenLite.to(obg, 0.7, {y:0, ease:Elastic.easeOut, onComplete:killTween});  
		}
		 
		private function killTween():void { 
			this.parent.removeChild(this); 
		}
		
		public function set value(value:String):void { _value = value; }
		 
		public function set color(value:uint):void {
			_color = value;
		}
//-----		
	}
}