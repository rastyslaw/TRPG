package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class SkeletArcher extends Unit {
		
		override internal function draw():void { 
			var bmp:Animation = Main.animationManager.getAnimation("skeletarcher");
			addChild(bmp);     
			bmp.scaleX = bmp.scaleY = 0.8;  
		}
//-----		
	}
}