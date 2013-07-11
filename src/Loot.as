package  {
	import flash.display.Sprite;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Loot extends Sprite {
		
		private var _who:String;
		private var _att:int;
		private var _def:int;
		private var _agi:int; 
		private var _hp:int;
		private var _mp:int;
		private var _sett:String;   
		private var _mas:Array; 
		private var _slot:String;
		
		public function Loot() {
			addChild(new Place); 
		}
		 
		public function set mas(value:Array):void { 
			_who = value[0];  
			_att = value[1];
			_def = value[2];  
			_agi = value[3];
			_hp = value[4];  
			_mp = value[5]; 
			if(value[6]!=undefined) _sett = value[6];  
			_mas = value; 
			scanSlot();
		}
		
		private function scanSlot():void {
			if (_who.search("weapon") != -1) _slot = "weapon";
			else if (_who.search("boots") != -1) _slot = "boots";
			else if (_who.search("chest") != -1) _slot = "chest";
			else if (_who.search("helm") != -1) _slot = "helm";
			else  _slot = "shield";  
		}
		
		public function get who():String { return _who; }
		public function get att():int { return _att; }
		public function get sett():String { return _sett; }
		public function get mp():int { return _mp; } 
		public function get hp():int { return _hp; }
		public function get agi():int { return _agi; }
		public function get def():int {	return _def; }
		public function get mas():Array { return _mas; }
		public function get slot():String { return _slot; }  
		
//-----		
	}
}