package  {
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public interface IReceiver { 
		function getPath(spd:int):void;
		function attack(tar:Unit):void; 
		function finishMovement(tar:Unit):void; 
		function backMovement(tar:Unit):void; 
	}
//-----	
}