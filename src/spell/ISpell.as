package spell {
	import flash.display.Sprite;
	import units.Unit;
	/**
	 * ... 
	 * @author waltasar
	 */
	public interface ISpell {
		function get ico():String;
		function get ramka():int;
		function get summon():Boolean;
		function cast(numX:int, numY:int, map:Vector.<Object>, game:Game):void;
		function set tar(value:Unit):void; 
		function get baff():String; 
		function get ress():String;   
	}
//-----	
}