package events {
	import flash.events.Event;
	import units.Unit;
	/**
	 * ... 
	 * @author waltasar
	 */ 
	public class MenuEvent extends Event { 
		
		public static const MOVING:String 	= 'moving'; 
		public static const ATTACK:String 	= 'attack'; 
		public static const BACK:String  	= 'back';
		public static const FINISH:String 	= 'finish'; 
		public static const DEAD:String 	= 'dead'; 
		public static const CHAR:String 	= 'char'; 
		public static const CAST:String 	= 'cast'; 
		
		public var tar:Unit;  
		
		public function MenuEvent(type:String, tar:Unit, bubbles:Boolean=false, cancelable:Boolean = false) {
			this.tar = tar; 
			super(type, bubbles, cancelable);   
		} 
		 
		override public function clone():Event { 
			return new MenuEvent(type, tar, bubbles, cancelable);    
		}
//-----		
	}
}