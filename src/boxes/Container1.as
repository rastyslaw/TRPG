package boxes {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Container1 extends Box { 
		
		override protected function setFull():void {     
			full = new Box1; 
		}
		
		override protected function setEmpty():void {      
			empty = new Box1_empty;
		}
		
//-----		
	}
}