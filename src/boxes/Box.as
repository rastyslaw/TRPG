package boxes {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Box extends Sprite {
		
		protected var full:MovieClip; 
		protected var empty:MovieClip; 
		protected var _state:String = "full";
		private var cont:Sprite; 
		private var hand:MovieClip;
		 
		public function Box():void {
			cont = new Sprite;  
			addChild(cont);
			hand = new Hand; 
			hand.y = -10;
			hand.mouseEnabled = false;
			setFull();
			setEmpty();
			setState(state);
		}  
		
		//Abstract method    
		protected function setFull():void {     
			throw new IllegalOperationError("Abstract method must be overridden in a subclass"); 
		}
		
		//Abstract method    
		protected function setEmpty():void {      
			throw new IllegalOperationError("Abstract method must be overridden in a subclass"); 
		}
		
		public function setState(s:String):void {
			if (cont.numChildren != 0) cont.removeChildAt(0);
			if (s == "full") {
				cont.addChild(full);
				addEventListener(MouseEvent.MOUSE_OVER, showHand);
			}
			else if (s == "empty") { 
				cont.addChild(empty);
				removeEventListener(MouseEvent.MOUSE_OVER, showHand); 
				removeEventListener(MouseEvent.MOUSE_OUT, hideHand);
				if(this.contains(hand)) removeChild(hand);  
			} 
			else return; 
			state = s;
		}
		 
		private function showHand(e:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OVER, showHand);
			addChild(hand);
			addEventListener(MouseEvent.MOUSE_OUT, hideHand);
		}
		
		private function hideHand(e:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, hideHand);
			removeChild(hand); 
			addEventListener(MouseEvent.MOUSE_OVER, showHand);
		}
		  
		public function getGold():void {
			setState("empty"); 
			var i:int = Math.random() * 20; 
			Main.gold += i;
		}
		
		public function get state():String { return _state; }
		public function set state(value:String):void { _state = value; }
//-----		
	}
}