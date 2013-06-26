package {
	
	public class AnimationManager {
		
		private var animations:Object = {};
		
		public function AnimationManager() {}	
		
		public function addAnimation(id:String):void
		{
			var animation:Animation = new Animation();
			animation.buildAnimation(id);
			animations[id] = animation;
			//return animation;
		}
		
		public function getAnimation(id:*):Animation
		{
			if (!animations[id]) return null;
			
			var animation:Animation = new Animation();
			animation.frames = animations[id].frames;
			animation.play();
			return animation;
		}
	}
}