package {
	
	public class AnimationManager {
		 
		private var animations:Object = {}; 
		 
		public function addAnimation(id:String, name:*):void {
			var animation:Animation = new Animation();
			animation.buildAnimation(id);
			animations[name] = animation;  
		} 
		   
		public function getAnimation(name:*):Animation {
			if (!animations[name]) return null; 
			var animation:Animation = new Animation();
			animation.frames = animations[name].frames;
			animation.play();  
			return animation;
		}
//----- 		
	}
}