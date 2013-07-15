package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class StayState implements IState {
		
		private var _index:String = "stay"; 
		
		public function createAndPlay(type:Unit):void {
			var hero:Animation;
			if (type.hero != null) type.hero.kill();
			if (!type.issheep) hero = Main.animationManager.getAnimation(type.sname + "_" + _index);
			else hero = Main.animationManager.getAnimation("sheep_stay");  
			type.addChildAt(hero, 0); 
			hero.scaleX = hero.scaleY = 0.8; 
			type.hero = hero; 
		}
		
		public function get index():String { return _index; }
//-----		
	}
}