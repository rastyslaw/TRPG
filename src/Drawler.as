package  {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	/**
	 * ...
	 * @author waltasar 
	 */
	public class Drawler extends Shape { 
		
		public function Drawler(color:uint):void {  
			this.graphics.beginFill(color, 0.3);  
			this.graphics.drawRect(4, 4, Map.grid_size-6, Map.grid_size-6);
			this.graphics.endFill(); 
		}
		
//-----		
	}
}