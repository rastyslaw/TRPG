package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle; 
	import flash.utils.getDefinitionByName;
	
	public class Animation extends Bitmap {
		
		public var frames:Array = [];
		public var currentFrame:Number = 1;
		private var ident:String;
		private var textureMap:BitmapData;
		private var sourceX:uint;
		private var perdance:Boolean = true;
		private var _repeat:Boolean = true; 
		 
		public function Animation():void {
			Gnom_stay;
			Archer_stay; 
			Mage_stay;
			Troll_stay;
			SkeletArcher_stay;
			Death_stay;
		}
		
		public function buildAnimation(identifier:String):void {
			ident = identifier;
			textureMap = new (getDefinitionByName(identifier))();
			buildCacheFromClip();
		}
		
		public function buildCacheFromClip():void {
			var bmpd:BitmapData;
			while(perdance) {  
				bmpd = new BitmapData(96, 96);
				bmpd.copyPixels(textureMap,  
                         new Rectangle(sourceX, 0, 96, 96), 
                         new Point(0, 0));
				sourceX += 96; 
				frames.push(bmpd);  
				if (sourceX > textureMap.width - 96) {
					perdance = false; 
				} 
			}
		}
		
		public function get totalFrames():Number {
			return frames.length;
		}
		
		public function set repeat(b:Boolean):void {
			_repeat = b; 
		}
		
		public function play():void {  
			gotoAndStop(currentFrame);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function stop():void {
			gotoAndStop(currentFrame); 
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function gotoAndStop(frame:Number):void {
			currentFrame = Math.round(frame);
			bitmapData = frames[currentFrame - 1];
		}
		
		public function gotoAndPlay(frame:Number):void {
			gotoAndStop(frame);
			play();
		}
		
		public function enterFrame(e:Event):void {
			currentFrame++;
			if (currentFrame > totalFrames) {
				if (_repeat) {
					currentFrame = 1;
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