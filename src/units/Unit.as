package units {
	import flash.errors.IllegalOperationError; 
	import flash.display.Sprite; 
	/**
	 * ...
	 * @author waltasar
	 */
	//Abstract class 
	public class Unit extends Sprite {
		
		public var speed:int;  
		
		//Abstract method 
		internal function draw():void { 
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		} 
		
		internal function spd():void { 
			speed = 5;  
		} 

//-----		 
	}
}
