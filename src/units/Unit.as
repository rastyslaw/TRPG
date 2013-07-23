package units {
	import events.MenuEvent;
	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError; 
	import flash.display.Sprite; 
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import spell.effect.Adsorb;
	import spell.effect.Grave;
	import spell.effect.IEffect;
	import spell.skill.ISkill;
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
		private var stayState:StayState;
		private var moveState:MoveState;
		private var attackState:AttackState;
		private var _sname:String;   
		private var _hp:int;
		private var _max_hp:int;   
		private var _att:uint;
		private var _def:uint;  
		private var _agi:uint;  
		private var _agro:Unit;
		private var _level:uint = 1;
		private var _exp:uint = 10; 
		private var graves:Grave; 
		private var _issheep:Boolean;  
		private var _adsorber:int;
		private var goodArr:Arr;   
		private var badArr:Arr;
		
		protected var _description:String;
		protected var _itemMas:Array = [];
		protected var _effects:Vector.<IEffect> = new Vector.<IEffect>;  
		protected var _skills:Vector.<ISkill>; 
		 
		internal var _direction:Array; 
		
		public var hero:Animation;  
		public var state:IState;  
		public var hpBar:HpBar;
		public var target:Unit; 
		public var mainMas:Vector.<Unit>;
		public var summon:Boolean;  
		
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
			setSkilMas();
			
			createArr();
		}
		
		private function createArr():void {
			goodArr = new Arr;
			badArr = new Arr;
			var color:ColorTransform = new ColorTransform;
			color.color = 0xff0000;
			badArr.transform.colorTransform = color; 
			goodArr.scaleY = -1; 
			addChild(goodArr);
			addChild(badArr);
			goodArr.y = badArr.y = 20; 
			goodArr.x = this.width - 34;
			badArr.x = this.width - 22;
			badArr.visible = goodArr.visible = false; 
		}
		
		internal function initDirection():void {
			_direction = [[ -1, 0], [1, 0], [0, -1], [0, 1]]; 
		}
		 
		protected function setSkilMas():void {      
			 _skills = new Vector.<ISkill>;   
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
		 
		public function cast(value:String):void {
			state = attackState;   
			attackState.side = value;
			attackState.index = "cast"; 
			state.createAndPlay(this);    
		}
		
		public function grave():void {
			graves = new Grave(this); 
			_effects.push(graves);  
			graves.apply();
			Game.effects.subscribeObserver(graves);   
		} 
		
		public function raincar():void { 
			stay(); 
			hp = max_hp * 0.2;   
			mainMas.push(this);
			for (var e:int; e < _effects.length; e++ ) {
				if (_effects[e] == graves) _effects.splice(e, 1);
			}
			graves.back();  
			Game.effects.unsubscribeObserver(IObserver(graves));
			graves = null;
			turn = true;
		}
		
		public function purdg():void {
			var effect:IEffect;
			for (var e:int; e < _effects.length; e++ ) {
				effect = _effects[e];
				if(effect.insalubrity()){ 
					effect.cancel();  
					Game.effects.unsubscribeObserver(IObserver(effect));
					_effects.splice(e, 1);
				}
			} 
		}
		
		public function getDamage(value:int, crit:Boolean=false, dodge:Boolean=false, color:uint=0):void {
			var tween:TweenBar = new TweenBar(); 
			if (color != 0) tween.color = color; 
			if (dodge) tween.value = "dodge";  
			else if (crit) tween.value = "crit"; 
 			else {
				var m:int = Search.lookClass(effects, Adsorb);   
				if (m >= 0) {
					adsorber -= value; 
					if (adsorber < 0) {  
						setEffects(effects[m], true); 
						hp = hp - adsorber;  
						tween.value = String(adsorber); 
						adsorber = 0; 
					} 
					else tween.value = String("adsorb"); 
				} 
				else {
					tween.value = String(value);
					hp = hp - value;   
				}
				//if (hp <= 0) dispatchEvent(new MenuEvent("DEAD", this));  
			}
			tween.init();
			addChild(tween);
			tween.x = tween.y = 40;
		}
		 
		public function healing(value:int, crit:Boolean=false):void { 
			var tween:TweenBar = new TweenBar(); 
			if (crit) tween.value = "crit";  
			else {
				tween.color = 0x00ff00;   
				tween.value = String(value);  
				hp = hp + value; 
				if (hp >= max_hp) hp = max_hp;  
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
			_hp = value-correctLoot(4);  
			hpBar.tt.text = String(value);  
		} 
		 
		public function get max_hp():int {
			return _max_hp+correctLoot(4);  
		}
		 
		public function kill():void { 
			for each (var e:IEffect in _effects) {
				Game.effects.unsubscribeObserver(IObserver(e));
			} 
			dispatchEvent(new MenuEvent(MenuEvent.DEAD, this));  
		}
		
		public function set max_hp(value:int):void { _max_hp = value; }
				
		public function get att():uint {
			return _att + correctLoot(1);
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
		public function set exp(value:uint):void { 
			_exp += value;
			if (_exp >= 100) {
				_exp = 0;
				level++; 
			}
		} 
		
		public function get description():String { return _description; }
		
		public function get sname():String {
			if (level < 10) return _sname;
			else return _sname+"_dual";  
		} 
		public function set sname(value:String):void { _sname = value; }
		
		public function get itemMas():Array { return _itemMas; }       
		public function set itemMas(value:Array):void { _itemMas = value; }   
		
		public function get skills():Vector.<ISkill> { return _skills; }  
		 
		public function get issheep():Boolean { return _issheep;} 
		public function set issheep(value:Boolean):void { _issheep = value; }
		
		public function get effects():Vector.<IEffect> { return _effects; } 
		
		public function get adsorber():int { return _adsorber; } 
		public function set adsorber(value:int):void { _adsorber = value;}
		
		public function setEffects(value:IEffect, del:Boolean=false):void {
			var e:int;
			var per:Boolean; 
			if (!del) {
				for (e=0; e < _effects.length; e++ ) {
					if (getQualifiedClassName(_effects[e]) == getQualifiedClassName(value)) per = true;
				}  
				if (!per) {  
					_effects.push(value);
					value.apply(); 
					Game.effects.subscribeObserver(IObserver(value));
				} 
			}
			else { 
				for (e=0; e < _effects.length; e++ ) {
					if (_effects[e] == value) _effects.splice(e, 1);
				}
				value.cancel();  
				Game.effects.unsubscribeObserver(IObserver(value));
				value = null; 
			}
			// 
			badArr.visible = goodArr.visible = false; 
			for each(var effect:IEffect in _effects) {
				if (effect is Grave) break;
				if (effect.insalubrity()) badArr.visible = true; 
				else goodArr.visible = true;    
			}
		}
		
//-----		 
	}
}
