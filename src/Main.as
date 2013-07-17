package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import units.AnimationManager;
	import units.HeroCreator;
	/**
	 * ...
	 * @author waltasar
	 */
	[Frame(factoryClass = "Preloader")]
	[SWF(stageWidth="800", stageHeight="480", frameRate="30")]
	public class Main extends Sprite {
		
		public static var animationManager:AnimationManager;
		private var selectPanel:SelectPanel;
		
		public function Main():void { 
			if (stage) init(); 
			else addEventListener(Event.ADDED_TO_STAGE, init); 
		} 

		private function init(e:Event = null):void { 
			removeEventListener(Event.ADDED_TO_STAGE, init);  
			animationManager = new AnimationManager();
			animationManager.addAnimation("Sheep_stay", "sheep_stay");
			animationManager.addAnimation("Sheep_walk", "sheep_walk");
			
			//hero
			animationManager.addAnimation("Hero_warr_stay", "hero_warr_stay");  
			animationManager.addAnimation("Hero_warr_walk", "hero_warr_walk");  
			animationManager.addAnimation("Hero_warr_attack_t", "hero_warr_attack_t"); 
			animationManager.addAnimation("Hero_warr_attack_d", "hero_warr_attack_d");  
			animationManager.addAnimation("Hero_warr_attack_l", "hero_warr_attack_l"); 
			animationManager.addAnimation("Hero_warr_attack_r", "hero_warr_attack_r");
			
			animationManager.addAnimation("Hero_archer_stay", "hero_archer_stay");  
			animationManager.addAnimation("Hero_archer_walk", "hero_archer_walk");  
			animationManager.addAnimation("Hero_archer_attack_t", "hero_archer_attack_t"); 
			animationManager.addAnimation("Hero_archer_attack_d", "hero_archer_attack_d");  
			animationManager.addAnimation("Hero_archer_attack_l", "hero_archer_attack_l"); 
			animationManager.addAnimation("Hero_archer_attack_r", "hero_archer_attack_r");
			
			animationManager.addAnimation("Hero_mage_stay", "hero_mage_stay");  
			animationManager.addAnimation("Hero_mage_walk", "hero_mage_walk");  
			animationManager.addAnimation("Hero_mage_attack_t", "hero_mage_attack_t"); 
			animationManager.addAnimation("Hero_mage_attack_d", "hero_mage_attack_d");  
			animationManager.addAnimation("Hero_mage_attack_l", "hero_mage_attack_l"); 
			animationManager.addAnimation("Hero_mage_attack_r", "hero_mage_attack_r");  
			animationManager.addAnimation("Hero_mage_cast_t", "hero_mage_cast_t"); 
			animationManager.addAnimation("Hero_mage_cast_d", "hero_mage_cast_d");  
			animationManager.addAnimation("Hero_mage_cast_l", "hero_mage_cast_l"); 
			animationManager.addAnimation("Hero_mage_cast_r", "hero_mage_cast_r");  
			
			//units
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
			
			animationManager.addAnimation("Raise_stay", "raise_stay");
			animationManager.addAnimation("Raise_walk", "raise_walk");  
			animationManager.addAnimation("Raise_attack_t", "raise_attack_t"); 
			animationManager.addAnimation("Raise_attack_d", "raise_attack_d");  
			animationManager.addAnimation("Raise_attack_l", "raise_attack_l"); 
			animationManager.addAnimation("Raise_attack_r", "raise_attack_r");
			
			animationManager.addAnimation("Spider_stay", "spider_stay");
			animationManager.addAnimation("Spider_walk", "spider_walk");   
			animationManager.addAnimation("Spider_attack_t", "spider_attack_t"); 
			animationManager.addAnimation("Spider_attack_d", "spider_attack_d");  
			animationManager.addAnimation("Spider_attack_l", "spider_attack_l"); 
			animationManager.addAnimation("Spider_attack_r", "spider_attack_r");
			
			animationManager.addAnimation("Barbar_stay", "barbar_stay");
			animationManager.addAnimation("Barbar_walk", "barbar_walk");    
			animationManager.addAnimation("Barbar_attack_t", "barbar_attack_t"); 
			animationManager.addAnimation("Barbar_attack_d", "barbar_attack_d");  
			animationManager.addAnimation("Barbar_attack_l", "barbar_attack_l"); 
			animationManager.addAnimation("Barbar_attack_r", "barbar_attack_r");
			
			animationManager.addAnimation("Mage_stay", "mage_stay");
			animationManager.addAnimation("Mage_walk", "mage_walk");  
			animationManager.addAnimation("Mage_attack_t", "mage_attack_t"); 
			animationManager.addAnimation("Mage_attack_d", "mage_attack_d");  
			animationManager.addAnimation("Mage_attack_l", "mage_attack_l"); 
			animationManager.addAnimation("Mage_attack_r", "mage_attack_r");
			animationManager.addAnimation("Mage_cast_t", "mage_cast_t"); 
			animationManager.addAnimation("Mage_cast_d", "mage_cast_d");  
			animationManager.addAnimation("Mage_cast_l", "mage_cast_l");  
			animationManager.addAnimation("Mage_cast_r", "mage_cast_r");
			
			animationManager.addAnimation("Priest_stay", "priest_stay"); 
			animationManager.addAnimation("Priest_walk", "priest_walk");  
			animationManager.addAnimation("Priest_attack_t", "priest_attack_t"); 
			animationManager.addAnimation("Priest_attack_d", "priest_attack_d");  
			animationManager.addAnimation("Priest_attack_l", "priest_attack_l"); 
			animationManager.addAnimation("Priest_attack_r", "priest_attack_r");
			animationManager.addAnimation("Priest_cast_t", "priest_cast_t"); 
			animationManager.addAnimation("Priest_cast_d", "priest_cast_d");  
			animationManager.addAnimation("Priest_cast_l", "priest_cast_l");  
			animationManager.addAnimation("Priest_cast_r", "priest_cast_r");
			
			//enemy
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
			
			selectPanel = new SelectPanel;
			selectPanel.x = Constants.STAGE_WIDTH >> 1;
			selectPanel.y = Constants.STAGE_HEIGHT >> 1;
			addChild(selectPanel);
			selectPanel.addEventListener(MouseEvent.CLICK, select);
		} 
		  
		private function select(e:MouseEvent):void {
			selectPanel.removeEventListener(MouseEvent.CLICK, select);
			var i:uint;
			if (e.target.name == "b1") {
				i = HeroCreator.HERO_WARR; 
			}
			else if (e.target.name == "b2") {
				i = HeroCreator.HERO_ARCHER; 
			}
			else i = HeroCreator.HERO_MAGE;
			removeChild(selectPanel);
			Game.selectHero = i; 
			stage.addChild(new Game);
		}
		
//-----
	}
}