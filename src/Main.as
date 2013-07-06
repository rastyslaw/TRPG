package {
	import flash.display.Sprite;
	import flash.events.Event;
	import units.AnimationManager;
	/**
	 * ...
	 * @author waltasar
	 */
	[Frame(factoryClass = "Preloader")]
	[SWF(stageWidth="800", stageHeight="480", frameRate="30")]
	public class Main extends Sprite {
		
		public static var animationManager:AnimationManager;
		
		public function Main():void { 
			if (stage) init(); 
			else addEventListener(Event.ADDED_TO_STAGE, init); 
		} 

		private function init(e:Event = null):void { 
			removeEventListener(Event.ADDED_TO_STAGE, init);  
			animationManager = new AnimationManager();    
			animationManager.addAnimation("Gnom_stay", "gnom_stay"); 
			animationManager.addAnimation("Gnom_walk", "gnom_walk"); 
			animationManager.addAnimation("Gnom_attack_t", "gnom_attack_t"); 
			animationManager.addAnimation("Gnom_attack_d", "gnom_attack_d");  
			animationManager.addAnimation("Gnom_attack_l", "gnom_attack_l"); 
			animationManager.addAnimation("Gnom_attack_r", "gnom_attack_r"); 
			 
			animationManager.addAnimation("Archer_stay", "archer_stay");
			animationManager.addAnimation("Archer_walk", "archer_walk");  
			animationManager.addAnimation("Archer_attack_t", "archer_attack_t"); 
			animationManager.addAnimation("Archer_attack_d", "archer_attack_d");  
			animationManager.addAnimation("Archer_attack_l", "archer_attack_l"); 
			animationManager.addAnimation("Archer_attack_r", "archer_attack_r");
			
			animationManager.addAnimation("Mage_stay", "mage_stay");
			animationManager.addAnimation("Mage_walk", "mage_walk");  
			animationManager.addAnimation("Mage_attack_t", "mage_attack_t"); 
			animationManager.addAnimation("Mage_attack_d", "mage_attack_d");  
			animationManager.addAnimation("Mage_attack_l", "mage_attack_l"); 
			animationManager.addAnimation("Mage_attack_r", "mage_attack_r");
			
			animationManager.addAnimation("Troll_stay", "troll_stay");
			animationManager.addAnimation("Troll_walk", "troll_walk");  
			animationManager.addAnimation("Troll_attack_t", "troll_attack_t"); 
			animationManager.addAnimation("Troll_attack_d", "troll_attack_d");  
			animationManager.addAnimation("Troll_attack_l", "troll_attack_l"); 
			animationManager.addAnimation("Troll_attack_r", "troll_attack_r");
			 
			animationManager.addAnimation("SkeletArcher_stay", "skeletarcher_stay");
			animationManager.addAnimation("SkeletArcher_walk", "skeletarcher_walk");  
			animationManager.addAnimation("SkeletArcher_attack_t", "skeletarcher_attack_t"); 
			animationManager.addAnimation("SkeletArcher_attack_d", "skeletarcher_attack_d");  
			animationManager.addAnimation("SkeletArcher_attack_l", "skeletarcher_attack_l"); 
			animationManager.addAnimation("SkeletArcher_attack_r", "skeletarcher_attack_r");
			
			animationManager.addAnimation("Death_stay", "death_stay");
			animationManager.addAnimation("Death_walk", "death_walk");   
			animationManager.addAnimation("Death_attack_t", "death_attack_t"); 
			animationManager.addAnimation("Death_attack_d", "death_attack_d");  
			animationManager.addAnimation("Death_attack_l", "death_attack_l"); 
			animationManager.addAnimation("Death_attack_r", "death_attack_r");
			
			stage.addChild(new Game); 
		} 
//-----
	}
}