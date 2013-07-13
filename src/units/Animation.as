package units {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle; 
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	
	public class Animation extends Bitmap { 
		
		public static var MOVING_RIGHT:uint    = 1; 
		public static var MOVING_TOP:uint	   = 1;  
		public static var MOVING_BOTTOM:uint   = 1;    
		public static var MOVING_LEFT:uint	   = 1;  
		public static var SIZE_CADR:uint 	   = 96;
		  
		public var frames:Array = [];
		public var currentFrame:Number = 1;
		private var ident:String;
		private var textureMap:BitmapData;
		private var sourceX:int;
		private var sourceY:int;  
		private var perdance:Boolean = true;
		private var _repeat:Boolean = true; 
		private var _movieLen:int = 1;
		private var curFrame:int;
		private var _delay:Number = 0; 
		private var timer:Timer;
		private var can:Boolean = true;
		
		private var moveSide:int;
		
		public function Animation():void {
			Archer_stay; Archer_walk; Archer_attack_d; Archer_attack_t; Archer_attack_l; Archer_attack_r;
			Mage_stay; Mage_walk; Mage_attack_d; Mage_attack_t; Mage_attack_l; Mage_attack_r; Mage_cast_d; Mage_cast_t; Mage_cast_l; Mage_cast_r; 
			Troll_stay; Troll_walk; Troll_attack_d; Troll_attack_t; Troll_attack_l; Troll_attack_r;
			SkeletArcher_stay; SkeletArcher_walk; SkeletArcher_attack_d; SkeletArcher_attack_t; SkeletArcher_attack_l; SkeletArcher_attack_r;
			Death_stay; Death_walk; Death_attack_d; Death_attack_t; Death_attack_l; Death_attack_r;
			Gnom_stay; Gnom_walk; Gnom_attack_d; Gnom_attack_t; Gnom_attack_l; Gnom_attack_r; 
		}
		 
		public function buildAnimation(identifier:String):void {
			ident = identifier;
			textureMap = new (getDefinitionByName(identifier))();
			buildCacheFromClip();
		}
		
		public function buildCacheFromClip():void {
			var bmpd:BitmapData;
			while(perdance) {   
				bmpd = new BitmapData(SIZE_CADR, SIZE_CADR);  
				bmpd.copyPixels(textureMap,  
                         new Rectangle(sourceX, sourceY, SIZE_CADR, SIZE_CADR), 
                         new Point(0, 0));
				sourceX += SIZE_CADR;  
				frames.push(bmpd);   
				if (sourceX > textureMap.width - SIZE_CADR) {
					sourceY += SIZE_CADR;  
					if (sourceY >= textureMap.height) perdance = false;
					else sourceX = 0; 
				} 
			}
		}
		
		public function get totalFrames():Number {
			return frames.length;
		}
		
		public function set repeat(b:Boolean):void {
			_repeat = b; 
		}
		 
		public function set movieLen(value:int):void {
			_movieLen = value;
			MOVING_TOP = MOVING_RIGHT + _movieLen;    
			MOVING_BOTTOM = MOVING_TOP + _movieLen;      
			MOVING_LEFT = MOVING_BOTTOM + _movieLen;  
		}
		
		public function get movieLen():int { return _movieLen; } 
		
		public function set delay(value:Number):void {
			_delay = value*1000;
			timer = new Timer(_delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, tick); 
		}
		
		private function tick(e:TimerEvent):void { 
			can = true;   
		}
		
		public function play():void {  
			gotoAndStop(currentFrame);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function stop():void {
			gotoAndStop(currentFrame); 
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function gotoAndStop(frame:int):void {
			currentFrame = frame;
			bitmapData = frames[currentFrame - 1];
		}
		 
		public function gotoAndPlay(frame:int):void {
			if (moveSide == frame) return;   
			moveSide = frame;
			gotoAndStop(frame); 
			curFrame = 0;
			play();
		}
		 
		public function enterFrame(e:Event):void { 
			if (!can) return; 
			currentFrame++; 
			curFrame++; 
			if (timer) { 
				can = false;
				timer.start(); 
			} 
			if (curFrame >= movieLen) { 
				if (_repeat) { 
					currentFrame-= movieLen;
					curFrame = 0; 
				}  
				else { 
					removeEventListener(Event.ENTER_FRAME, enterFrame); 
					dispatchEvent(new Event("FINISH")); 
					return;  
				} 
			} 
			gotoAndStop(currentFrame);  
		} 
		
		public function kill():void { 
			stop();
			if (timer!=null) {
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, tick);
				timer.stop();
			}
			this.parent.removeChild(this);
			delete this;
		}  
		
		public function update():void {
			stop();
			frames = [];
			buildCacheFromClip();
		}
//-----		
	}
}