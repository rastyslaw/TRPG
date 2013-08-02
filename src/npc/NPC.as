package npc {
	import events.NpcEvent;
	import flash.desktop.Clipboard;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer; 
	import units.Animation;
	/**
	 * ...
	 * @author waltasar
	 */
	public class NPC extends Hero { 
		
		protected var _type:String; 
		protected var clip:MovieClip;
		
		protected var _work:Boolean;  
		protected var _talk:Boolean = true;
		protected var _look:Boolean; 
		protected var _walk:Boolean; 
		protected var anvil:Bitmap;
		protected var bobber:Bobber;
		
		private var timer:Timer;
		private var busy:Boolean; 
		protected var _path:Vector.<Point>;  
		private var fask:Sprite;
		private var _walker:Walke;
		private var _dialog:Boolean;
		
		protected var random_walk:Number = .2;
		protected var random_work:Number = .2;
		protected var random_look:Number = .2; 
		
		public function NPC() {
			isHero = false; 
			setType();
			setPar();
			setPath();
			type = _type;
			setState(Hero.STAY);
			setClip();
			addChild(clip);
			clip.mouseEnabled = false;
			clip.mouseChildren = false; 
			clip.x = 40; 
			clip.y = 6;
			clip.visible = false;
			
			fask = new Sprite();
			fask.graphics.beginFill(0, 0); 
			fask.graphics.drawRect(20, 10, 40, 60);
			fask.graphics.endFill();
			addChild(fask);
			fask.addEventListener(MouseEvent.MOUSE_OVER, showClip);
			
			timer = new Timer(1000, 0);
			timer.addEventListener(TimerEvent.TIMER, tick);
			timer.start();
		}
		
		protected function setPar():void {}
		
		public function setPath():void {        
			_path = new Vector.<Point>;      
		}
		
		//Abstract method   
		public function getIco():Bitmap {        
			throw new IllegalOperationError("Abstract method must be overridden in a subclass"); 
		}
		
		//Abstract method    
		public function getWords():String {        
			throw new IllegalOperationError("Abstract method must be overridden in a subclass"); 
		}
		
		private function tick(e:TimerEvent):void {
			if (busy) return; 
			if (_work) { 
				if (Math.random() < random_work) {
					if (anvil != null) anvil.visible = false;
					if (bobber != null) bobber.visible = true;
					busy = true; 
					doing("work"); 
				}
			}
			if (_look && !busy) {  
				if (Math.random() < random_look) {
					busy = true;
					doing("look");  
				}  
			} 
			if (_walk && !busy ) { 
				if (Math.random() < random_walk) {
					busy = true;  
					dispatchEvent(new NpcEvent(NpcEvent.MOVING, this));
				}
			}
		} 
		 
		private function doing(s:String):void {
			check();  
			_hero = Main.animationManager.getAnimation(_type + "_" + s);
			_hero.movieLen = 8; 
			_hero.delay = .05;    
			addChild(_hero);       
			_hero.scaleX = _hero.scaleY = 0.9;
			timer = new Timer(1600, 1); 
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, goStay);
			timer.start();
		}
		
		private function goStay(e:TimerEvent):void {
			e.currentTarget.stop();  
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, goStay);
			_hero.removeEventListener("FINISH", goStay); 
			setState("stay");
			busy = false;
			if (anvil != null) anvil.visible = true; 
			if (bobber != null) bobber.visible = false; 
		}
		
		public function check():void {
			if (_hero != null) {
				removeChild(_hero);   
				_hero = null;  
			} 
		} 
		 
		public function talking(unit:Hero):void {
			if (busy) return;
			check(); 
			_hero = Main.animationManager.getAnimation(_type + "_talk");
			_hero.movieLen = 8; 
			_hero.repeat = false;
			_hero.delay = .08;   
			addChild(_hero);       
			_hero.scaleX = _hero.scaleY = 0.9;
			correct(unit);
			busy = true;   
		}
		 
		private function correct(unit:Hero):void {
			if (unit.x == this.x) {
				if (unit.y < this.y) _hero.gotoAndPlay(Animation.MOVING_TOP);
				else _hero.gotoAndPlay(Animation.MOVING_BOTTOM);
			} 
			else { 
				if (unit.x < this.x) _hero.gotoAndPlay(Animation.MOVING_LEFT);
				else _hero.gotoAndPlay(Animation.MOVING_RIGHT); 
			}
			_hero.addEventListener("FINISH", goBack);   
		} 
		
		private function goBack(e:Event):void {
			_hero.removeEventListener("FINISH", goBack);  
			_hero.gotoAndStop(_hero.currentFrame-8);
			//timer = new Timer(1000, 1);  
			//timer.addEventListener(TimerEvent.TIMER_COMPLETE, goStay);
			//timer.start(); 
		}
		
		private function showClip(e:MouseEvent):void {
			fask.removeEventListener(MouseEvent.MOUSE_OVER, showClip); 
			clip.visible = true;
			fask.addEventListener(MouseEvent.MOUSE_OUT, hideClip);
		}
		
		private function hideClip(e:MouseEvent):void {
			fask.removeEventListener(MouseEvent.MOUSE_OUT, hideClip);
			clip.visible = false;   
			fask.addEventListener(MouseEvent.MOUSE_OVER, showClip);
		}
		
		//Abstract method    
		protected function setType():void {     
			throw new IllegalOperationError("Abstract method must be overridden in a subclass"); 
		}
		
		//Abstract method    
		protected function setClip():void {      
			throw new IllegalOperationError("Abstract method must be overridden in a subclass"); 
		}
		
		public function get path():Vector.<Point> {
			return _path;
		}
		
		public function get _fask():Sprite {
			return fask;
		}
		
		public function set _busy(value:Boolean):void {
			busy = value;
		}
		
		public function get walker():Walke {
			return _walker;
		} 
		
		public function set walker(value:Walke):void { 
			_walker = value;
		} 
		
		public function get dialog():Boolean {
			return _dialog; 
		}
		 
		public function set walk(value:Boolean):void {
			_walk = value;
		}
//-----		
	}
}