package npc {
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Girl extends NPC {
		
		public function Girl() {
			random_walk = .1;   
		}
		
		override public function getIco():Bitmap {   
			return FaceAssets.getIco("face_priest"); 
		}
		  
		override public function getWords():String {        
			return "Ha-ha-ha!"; 
		}
		   
		override public function setPath():void {            
			_path = Vector.<Point>([new Point(23, 15), new Point(24, 15), new Point(24, 14), new Point(24, 13), new Point(25, 13), new Point(26, 13),
									new Point(26, 12), new Point(25, 12), new Point(25, 11), new Point(25, 10), new Point(24, 10)]);         
		}
		  
		override protected function setType():void {     
			_type = "npc_girl"; 
		}
		
	    public function run():void {
			super.check();  
			_hero = Main.animationManager.getAnimation(_type + "_run");
			_hero.movieLen = 8;
			_hero.delay = .05;      
			addChild(_hero);        
			_hero.scaleX = _hero.scaleY = 0.9;
		}
		
		override protected function setPar():void {
			_walk = true;  
		}
		
		override protected function setClip():void {     
			clip = new Talk_up; 
		}
		
		override public function get dialog():Boolean {
			if (Main.questLine == 0) return true; 
			else return false;  
		}
//-----		
	}
}