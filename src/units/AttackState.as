package units {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author waltasar
	 */
	public class AttackState implements IState {
		
		private var _index:String = "attack";  
		private var _side:String; 
		private var unit:Unit; 
		 
		public function createAndPlay(type:Unit):void {
			unit = type; 
			var hero:Animation;
			type.hero.kill(); 
			hero = Main.animationManager.getAnimation(type.sname + "_" + _index + "_" + _side);
			hero.movieLen = 12;  
			hero.repeat = false;   
			type.addChildAt(hero, 0); 
			hero.scaleX = hero.scaleY = 0.8; 
			hero.addEventListener("FINISH", goStay); 
			type.hero = hero; 
		}  
		
		private function goStay(e:Event):void { 
			e.target.removeEventListener("FINISH", goStay);
			unit.stay();  
		} 
		
		public function set side(value:String):void {
			_side = value; 
		}
		 
		public function get index():String { return _index; }
		
		public function set index(value:String):void {
			_index = value; 
		}
//-----		
	}
}