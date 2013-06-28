package {
	import flash.display.Sprite;
	import flash.events.Event;

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
			animationManager.addAnimation("Gnom_stay", "gnom");
			animationManager.addAnimation("Archer_stay", "archer");
			animationManager.addAnimation("Mage_stay", "mage");
			animationManager.addAnimation("Troll_stay", "troll");
			animationManager.addAnimation("SkeletArcher_stay", "skeletarcher");
			animationManager.addAnimation("Death_stay", "death"); 
			stage.addChild(new Game); 
		}

	}

}