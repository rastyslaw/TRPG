package boxes {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author waltasar
	 */  
	public class Container2 extends Box { 
		
		override protected function setFull():void {     
			full = new Box2; 
		}
		
		override protected function setEmpty():void {      
			empty = new Box2_empty;
		}
		
//-----		
	}
}