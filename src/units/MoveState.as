package units {
	/**
	 * ...
	 * @author waltasar
	 */ 
	public class MoveState implements IState {
		
		private var _index:String = "walk";
		
		public function createAndPlay(type:Unit):void {
			var hero:Animation;   
			type.hero.kill(); 
			if (!type.issheep) hero = Main.animationManager.getAnimation(type.sname + "_" + _index);
			else hero = Main.animationManager.getAnimation("sheep_walk");  
			hero.movieLen = 8;  
			hero.delay = .05;  
			type.addChildAt(hero, 0);          
			hero.scaleX = hero.scaleY = 0.8; 
			type.hero = hero;
		}
		
		public function get index():String { return _index; }
//-----		 
	}
}