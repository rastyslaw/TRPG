package {
	import boxes.*;
	import flash.display.Bitmap;
	import flash.display.Sprite; 
	import flash.errors.IOError;
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
		
		public static const TILESIZE:uint = 15; 
		public static var totalGold:int;
		public static var boxTypes:Array = [Container1, Container2];
		public static var questLine:uint;
		public static const FRAME_RATE:int = 30;
		public static var numParty:uint = 1;
		public static var masParty:Array = [HeroCreator.ARCHER, HeroCreator.MAGE]; 
		public static var gold:uint;   
		public static var selectHero:uint;
		public static var animationManager:AnimationManager; 
		private var selectPanel:SelectPanel;
		private var level:int = 1;
		 
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
			animationManager.addAnimation("Archer_talk", "archer_talk");  
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
			animationManager.addAnimation("Barbar_gir_stay", "barbar_gir_stay");
			animationManager.addAnimation("Barbar_walk", "barbar_walk");
			animationManager.addAnimation("Barbar_talk", "barbar_talk");    
			animationManager.addAnimation("Barbar_attack_t", "barbar_attack_t"); 
			animationManager.addAnimation("Barbar_attack_d", "barbar_attack_d");  
			animationManager.addAnimation("Barbar_attack_l", "barbar_attack_l"); 
			animationManager.addAnimation("Barbar_attack_r", "barbar_attack_r");
			
			animationManager.addAnimation("Mage_stay", "mage_stay");
			animationManager.addAnimation("Mage_walk", "mage_walk");
			animationManager.addAnimation("Mage_talk", "mage_talk"); 
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
			animationManager.addAnimation("Priest_talk", "priest_talk"); 
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
			
			//npc
			animationManager.addAnimation("Npc_liza_stay", "npc_liza_stay");
			animationManager.addAnimation("Npc_liza_walk", "npc_liza_walk");   
			animationManager.addAnimation("Npc_liza_talk", "npc_liza_talk");    
			
			animationManager.addAnimation("Npc_smith_stay", "npc_smith_stay");
			animationManager.addAnimation("Npc_smith_work", "npc_smith_work");    
			animationManager.addAnimation("Npc_smith_talk", "npc_smith_talk");
			
			animationManager.addAnimation("Npc_guard_stay", "npc_guard_stay");
			animationManager.addAnimation("Npc_guard_walk", "npc_guard_walk");   
			animationManager.addAnimation("Npc_guard_talk", "npc_guard_talk");
			animationManager.addAnimation("Npc_guard_look", "npc_guard_look"); 
			
			animationManager.addAnimation("Npc_fisher_stay", "npc_fisher_stay");
			animationManager.addAnimation("Npc_fisher_work", "npc_fisher_work");   
			animationManager.addAnimation("Npc_fisher_talk", "npc_fisher_talk");
			
			animationManager.addAnimation("Npc_farmer_stay", "npc_farmer_stay");
			animationManager.addAnimation("Npc_farmer_walk", "npc_farmer_walk");    
			animationManager.addAnimation("Npc_farmer_talk", "npc_farmer_talk");
			animationManager.addAnimation("Npc_farmer_look", "npc_farmer_look");
			animationManager.addAnimation("Npc_farmer_work", "npc_farmer_work");
			
			animationManager.addAnimation("Npc_prof_stay", "npc_prof_stay"); 
			animationManager.addAnimation("Npc_prof_walk", "npc_prof_walk");    
			animationManager.addAnimation("Npc_prof_talk", "npc_prof_talk");
			animationManager.addAnimation("Npc_prof_look", "npc_prof_look");
			animationManager.addAnimation("Npc_prof_work", "npc_prof_work");
			 
			animationManager.addAnimation("Npc_cook_stay", "npc_cook_stay"); 
			animationManager.addAnimation("Npc_cook_talk", "npc_cook_talk");
			animationManager.addAnimation("Npc_cook_work", "npc_cook_work");
			 
			animationManager.addAnimation("Npc_monk_stay", "npc_monk_stay"); 
			animationManager.addAnimation("Npc_monk_talk", "npc_monk_talk");
			animationManager.addAnimation("Npc_monk_work", "npc_monk_work");
			
			animationManager.addAnimation("Npc_pirat_stay", "npc_pirat_stay");  
			
			animationManager.addAnimation("Npc_girl_stay", "npc_girl_stay");  
			animationManager.addAnimation("Npc_girl_run", "npc_girl_run"); 
			animationManager.addAnimation("Npc_girl_talk", "npc_girl_talk"); 
			animationManager.addAnimation("Npc_girl_walk", "npc_girl_walk");
			
			var faceassets:FaceAssets = new FaceAssets;
			
			selectPanel = new SelectPanel;
			selectPanel.x = Constants.STAGE_WIDTH >> 1;
			selectPanel.y = Constants.STAGE_HEIGHT >> 1;
			addChild(selectPanel);
			selectPanel.addEventListener(MouseEvent.CLICK, select);
			
		} 
		
		public function drawRoad(obg:Town):void {
			removeChild(obg);
			obg = null;
			var level:Levels = new Levels;
			var mas:Array = level.getLevel("road1", TILESIZE);    
			var clas:Bitmap = level.getTileset("road1");   
			addChild(new Road(mas[0], mas[1], clas, 1));
		}
		
		public function drawBattle(obg:Road):void {
			removeChild(obg);
			obg = null;
			var level:Levels = new Levels;
			var mas:Array = level.getLevel("battle1", TILESIZE);    
			var clas:Bitmap = level.getTileset("battle1");    
			
			var game:Game = new Game(1); 
			game.setMap(mas[0], mas[1], clas);   
			addChild(game);
			game.init();  
		}
		
		public function goToTown(obg:Game, s:String):void {
			removeChild(obg); 
			obg = null; 
			var level:Levels = new Levels;
			var mas:Array = level.getLevel("town1", TILESIZE);    
			var clas:Bitmap = level.getTileset("town1");   
			addChild(new Town(mas[0], mas[1], clas, s));  
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
			selectHero = i;  
			  
			var level:Levels = new Levels;
			var mas:Array = level.getLevel("battle1", TILESIZE);    
			var clas:Bitmap = level.getTileset("battle1");    
			
			var game:Game = new Game(1); 
			game.setMap(mas[0], mas[1], clas);   
			addChild(game);
			game.init();  
		} 

//-----
	}
}