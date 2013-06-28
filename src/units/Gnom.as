package units { 
	/**
	 * ...
	 * @author waltasar 
	 */
	internal class Gnom extends Unit { 
		
		override internal function draw():void {
			var bmp:Animation = Main.animationManager.getAnimation("gnom");
			addChild(bmp);        
			bmp.scaleX = bmp.scaleY = 0.8; 
		}
		
		override internal function spd():void { 
			speed = 3;    
		}
//-----		
	} 
}