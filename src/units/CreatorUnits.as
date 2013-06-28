package units {
	import flash.errors.IllegalOperationError; 
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author waltasar
	 */ 
	//Abstract class   
	public class CreatorUnits {
		
		public function creating(unit:uint, obj:Object):void {  
			var obg:Unit = createUnit(unit);
			obg.draw();
			obg.spd();
			obj.unit = obg; 
		}
		
		//Abstract method  
		protected function createUnit(unit:uint):Unit { 
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
			return null; 
		}  
		
//-----		
	}
}