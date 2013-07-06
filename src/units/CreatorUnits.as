package units {
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError; 
	/**
	 * ...
	 * @author waltasar
	 */ 
	//Abstract class   
	public class CreatorUnits {
		
		public function creating(unit:uint, oj:Object, numX:int, numY:int, cont:DisplayObjectContainer, mas:Vector.<Unit>):void {  
			var obg:Unit = createUnit(unit); 
			obg.init(); 
			oj.unit = obg;  
			cont.addChild(obg);
			mas.push(obg); 
			obg.x = numY * Map.grid_size - 8;
			obg.y = numX * Map.grid_size - 8; 
		}
		 
		//Abstract method   
		protected function createUnit(unit:uint):Unit { 
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
			return null; 
		}  
		
//-----		
	}
}