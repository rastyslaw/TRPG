package units {
	import events.MenuEvent;
	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError; 
	import flash.display.Sprite; 
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar
	 */
	//Abstract class 
	public class Unit extends Sprite { 
		
		private var _speed:int;  
		private var _type:String;
		private var _enemy:Boolean; 
		private var _turn:Boolean;
		private var _prev:Point; 
		public var state:IState;
		private var stayState:StayState;
		private var moveState:MoveState;
		private var attackState:AttackState;   
		public var hero:Animation;  
		internal var sname:String;   
		
		private var _hp:int;
		private var _max_hp:int;  
		private var _att:uint;
		private var _def:uint;  
		private var _agi:uint;   
		private var hpBar:HpBar;
		 
		internal var _direction:Array; 
		public var target:Unit; 
		private var _agro:Unit;
		private var _level:uint = 1;
		private var _exp:uint = 10;
		protected var _description:String;
		protected var _itemMas:Array= []; 
		
		//Abstract method    
		internal function setSname():void {  
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		} 
		
		//Abstract method   
		public function getIco():Bitmap {     
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}
		
		//Abstract method  
		public function getName():String {   
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		} 
		
		//Abstract method    
		public function getClassName():String {     
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		} 
		
		//Abstract method      
		protected function setDescription():void {     
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}
		
		internal function init():void {  
			moveState = new MoveState;
			stayState = new StayState;
			attackState = new AttackState;  
			setSname(); 
			stay();  
			setSpd();
			setType(); 
			setEnemy(); 
			_turn = true;
			createBar();
			setAttributes();
			initDirection();
			setDescription(); 
		}
		
		internal function initDirection():void {
			_direction = [[ -1, 0], [1, 0], [0, -1], [0, 1]]; 
		}
		
		private function createBar():void {
			hpBar = new HpBar;
			addChild(hpBar);
			hpBar.mouseChildren = false; 
			hpBar.mouseEnabled = false; 
			hpBar.y = Map.grid_size;
		}
		
		//Abstract method  
		internal function setAttributes():void {
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}
		
		internal function setSpd():void {
			_speed = 5;   
		} 
		
		internal function setType():void { 
			_type = "soldier";    
		}
		 
		internal function setEnemy():void {
			_enemy = false; 
		}
		 
		public function stay():void {  
			state = stayState;       
			state.createAndPlay(this);
		}
		
		public function move():void {
			state = moveState;  
			state.createAndPlay(this);   
		}
		
		public function attack(value:String):void {
			state = attackState;   
			attackState.side = value;
			state.createAndPlay(this);   
		} 
		 
		public function getDamage(value:int, crit:Boolean=false, dodge:Boolean=false):void {
			var tween:TweenBar = new TweenBar();
			if (dodge) tween.value = "dodge"; 
			else if (crit) tween.value = "crit";
			else {
				tween.value = String(value);  
				hp -= value; 
				if (hp <= 0) dispatchEvent(new MenuEvent("DEAD", this));  
			}
			tween.init();
			addChild(tween);
			tween.x = tween.y = 40;
		}
		 
		public function correctLoot(num:int):int { 
			var bonus:int;
			for (var i:int; i < itemMas.length; i++) {
				bonus += itemMas[i][num];
			}  
			return bonus;   
		}
		 
		public function getBonus():Array { 
			var s:String = "";
			var mas:Array = [];
			var rex:Array = [];  
			for (var i:int; i < itemMas.length; i++) { 
				s = itemMas[i][6]; 
				if (s != null && Search.lookLine(mas, s)==0) {   
					if (Search.look(itemMas, s, 6) > 1) rex.push(Game.setsMas[s][0]);  
					if (Search.look(itemMas, s, 6) > 3) rex.push(Game.setsMas[s][1]);  
					mas.push(s) 
				} 
			}  
			return rex;   
		}
		
		public function get speed():int { return _speed; }
		public function set speed(value:int):void { _speed = value;  }
		
		public function get type():String { return _type; }
		public function set type(value:String):void { _type = value; }
		
		public function get enemy():Boolean { return _enemy; } 
		public function set enemy(value:Boolean):void { _enemy = value; }
		
		public function get turn():Boolean { return _turn; } 
		public function set turn(value:Boolean):void { _turn = value;  }
		
		public function get prev():Point {	return _prev; } 
		public function set prev(value:Point):void { _prev = value; }
		
		public function get hp():int {
			return _hp+correctLoot(4);
		}  
		public function set hp(value:int):void {
			_hp = value;
			hpBar.tt.text = String(value);  
		}
		 
		public function get max_hp():int {
			return _max_hp+correctLoot(4); 
		}
		
		public function set max_hp(value:int):void { _max_hp = value; }
				
		public function get att():uint {
			return _att+correctLoot(1); 
		}
		public function set att(value:uint):void { _att = value; }
				
		public function get def():uint {
			return _def+correctLoot(2);
		}  
		public function set def(value:uint):void { _def = value; }
				
		public function get agi():uint {
			return _agi+correctLoot(3);
		}
		public function set agi(value:uint):void { _agi = value; }
		
		public function get direction():Array { return _direction; }
		
		public function get agro():Unit { return _agro; } 
		public function set agro(value:Unit):void { _agro = value; }
		
		public function get level():uint { return _level; } 
		public function set level(value:uint):void { _level = value;}
		 
		public function get exp():uint { return _exp; }
		public function set exp(value:uint):void { _exp = value; } 
		
		public function get description():String { return _description; }
		public function get _sname():String { return sname; }
		
		public function get itemMas():Array { return _itemMas; }       
		public function set itemMas(value:Array):void { _itemMas = value; }   
//-----		 
	}
}
