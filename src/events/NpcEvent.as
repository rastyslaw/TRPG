package events {
	import flash.events.Event;
	import npc.NPC;
	/**
	 * ...
	 * @author waltasar
	 */
	public class NpcEvent extends Event { 
		
		public static const MOVING:String 	= 'moving'; 
		
		public var tar:NPC;  
		 
		public function NpcEvent(type:String, tar:NPC, bubbles:Boolean=false, cancelable:Boolean = false) {
			this.tar = tar; 
			super(type, bubbles, cancelable);   
		} 
		  
		override public function clone():Event { 
			return new NpcEvent(type, tar, bubbles, cancelable);    
		}
//-----		
	}
}