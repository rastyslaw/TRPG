package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class ArrowUnit extends Unit {
		
		override internal function setType():void { 
			type = "archer"; 
		}
		 
		override internal function initDirection():void {
			_direction = [ [-2, 0], [2, 0], [0, -2], [0, 2],
						   [-1,-1], [1, 1], [-1, 1], [1,-1] ]; 
		}
//-----	
	}
}