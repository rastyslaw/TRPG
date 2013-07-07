package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class UI extends Sprite {
		
		public function UI(main:Game) { 
			var endTurn:EndTurn = new EndTurn;  
			endTurn.y = endTurn.height;
			endTurn.x = Constants.STAGE_WIDTH - endTurn.width; 
			addChild(endTurn);
			endTurn.addEventListener(MouseEvent.CLICK, clickTurn);
		}
		 
		private function clickTurn(e:MouseEvent):void {
			dispatchEvent(new Event("END_TURN"));  
		}
//-----	 
	}
}