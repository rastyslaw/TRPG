package units {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError; 
	/**
	 * ...
	 * @author waltasar
	 */ 
	//Abstract class   
	public class CreatorUnits {
		
		private var cont:DisplayObjectContainer;
		private var unitmas:Vector.<Unit>;
		 
		public function init(obg:DisplayObjectContainer, mas:Vector.<Unit>):void {  
			cont = obg; 
			unitmas = mas; 
		}
		
		public function creating(unit:uint, oj:Object):void {  
			var obg:Unit = createUnit(unit); 
			obg.init(); 
			oj.unit = obg;  
			cont.addChild(obg);
			unitmas.push(obg);
			obg.mainMas = unitmas;
			obg.x = oj.j * Map.grid_size - 8;
			obg.y = oj.i * Map.grid_size - 8; 
		}
		 
		//Abstract method   
		protected function createUnit(unit:uint):Unit { 
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
			return null; 
		}  
		
//-----		
	}
}