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
		private var clip:Bitmap;
		private var textureMap:BitmapData;
		private var sourceX:uint;
		private var perdance:Boolean = true;
		private var zador:int;
		
		public function Animation() {}
		
		public function buildAnimation(identifier:String):void {
			
			ident = identifier;
			switch(ident){
				case "gnomd": 
					textureMap = new Gnomd(768, 96);  
				break; 
			}
			buildCacheFromClip();
		}
		
		public function buildCacheFromClip():void {
			
			clip = new Bitmap(); 
			
			while(perdance) {
				clip.bitmapData = new BitmapData(96, 96);
				clip.bitmapData.copyPixels(textureMap, 
                         new Rectangle(sourceX, 0, 96, 96), 
                         new Point(0, 0));
				sourceX += 96; 
				frames.push(clip.bitmapData);
				if (sourceX > textureMap.width - 96) { 
					perdance = false; 
				} 
			}
		}
		
		public function get totalFrames():Number {
			
			return frames.length;
		}
		
		public function play():void {
			
			gotoAndStop(currentFrame);
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		public function stop():void {
			
			gotoAndStop(currentFrame);
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		public function gotoAndStop(frame:Number):void
		{
			currentFrame = Math.round(frame);
			bitmapData = frames[currentFrame - 1];
		}
		public function gotoAndPlay(frame:Number):void
		{
			gotoAndStop(frame);
			play();
		}
		public function enterFrame(e:Event):void
		{
			if(zador == 0){
				currentFrame++;
				if (currentFrame > 7) currentFrame = 1;
				gotoAndStop(currentFrame);
			}
			zador++;
			if(zador >= 2){
				zador = 0;
			}
		}
		
		public function dead():void {
			stop();
			gotoAndStop(7);
			zador = 0;
			addEventListener(Event.ENTER_FRAME, deadrFrame);
		}
		public function kill():void {
			stop();
			this.parent.removeChild(this);
			delete this;
		}
		public function deadrFrame(e:Event):void
		{
			if(zador == 0){
				currentFrame++;
				gotoAndStop(currentFrame);
				if(currentFrame == 14){
					removeEventListener(Event.ENTER_FRAME, deadrFrame);
					//this.parent.removeChild(this);
					//delete this;
				}
			}
			zador++;
			if(zador >= 2){
				zador = 0;
			}
		}
		
		public function update():void
		{
			stop();
			frames = [];
			buildCacheFromClip();
		}
	}
}