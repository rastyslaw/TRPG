package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Archer extends Unit {
		 
		override internal function draw():void { 
			var bmp:Animation = Main.animationManager.getAnimation("archer");
			addChild(bmp);  
			bmp.scaleX = bmp.scaleY = 0.8;  
		}
//-----		
	}
}