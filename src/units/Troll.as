package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Troll extends Unit {
		
		override internal function draw():void { 
			var bmp:Animation = Main.animationManager.getAnimation("troll");
			addChild(bmp);  
			bmp.scaleX = bmp.scaleY = 0.8;  
		}
//-----		
	}
}