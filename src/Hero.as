package  {
	import flash.display.Sprite;
	import flash.geom.Point;
	import units.Animation;
	import units.HeroCreator;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Hero extends Sprite {
		
		public static const STAY:String = "stay";
		public static const MOVE:String = "move";  
		private var _type:String; 
		protected var _hero:Animation; 
		private var _prev:Point;
		
		public function Hero() { 
			switch(Main.selectHero) {
				case HeroCreator.HERO_WARR: 
					type = "hero_warr";
				break;
				case HeroCreator.HERO_ARCHER:
					type = "hero_archer"; 
				break;
				case HeroCreator.HERO_MAGE:
					type = "hero_mage"; 
				break;
			}
			setState(STAY);
		}
		
		public function setState(s:String):void {  
			if (hero != null) {
				removeChild(hero);   
				hero = null;
			} 
			if (s == STAY) stay(); 
			else move(); 
		}
		  
		public function stay():void {   
			hero = Main.animationManager.getAnimation(type+"_stay"); 
			addChild(hero);
			hero.scaleX = hero.scaleY = 0.9;  
			//_hero.x = _hero.y;      
		}
		 
		public function move():void {  
			hero = Main.animationManager.getAnimation(type + "_walk");
			hero.movieLen = 8;  
			hero.delay = .05;  
			addChild(hero);     
			hero.scaleX = hero.scaleY = 0.9; 
		} 
		
		public function get hero():Animation {
			return _hero; 
		}
		
		public function set type(value:String):void {
			_type = value; 
		}
		 
		public function get type():String {
			return _type;
		}
		
		public function set hero(value:Animation):void {
			_hero = value;
		}
		
		public function get prev():Point {
			return _prev;
		}
		 
		public function set prev(value:Point):void {
			_prev = value;
		}
//-----		
	}
}