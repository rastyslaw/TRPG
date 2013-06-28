package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Mage extends Unit {
		
		override internal function draw():void {
			var bmp:Animation = Main.animationManager.getAnimation("mage");
			addChild(bmp);      
			bmp.scaleX = bmp.scaleY = 0.8;  
		}
//-----		
	}
}