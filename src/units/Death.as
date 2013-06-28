package units {
	/**
	 * ...
	 * @author waltasar
	 */
	internal class Death extends Unit {
		
		override internal function draw():void { 
			var bmp:Animation = Main.animationManager.getAnimation("death");
			addChild(bmp);   
			bmp.scaleX = bmp.scaleY = 0.8;  
		}
//-----	
	}
}