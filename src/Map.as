package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Map extends Sprite {
		
		private var playerObj:Object=new Object();
		private var canvasBD:BitmapData;
		private var backgroundBD:BitmapData;
		private var backgroundRect:Rectangle;
		private var backgroundPoint:Point; 
		public var border:int = 80;   
		private var aWorld:Array = []
		private var mas:Vector.<Object>;
		
		public static var worldCols:int; 
		public static var worldRows:int;
		public static const grid_size:int = 64;
		
		private var startDraw:Boolean;
		private var worldWidth:int;
		private var worldHeight:int; 
		private var bufferBD:BitmapData;
		private var bufferRect:Rectangle;
		private var bufferPoint:Point;
		private var viewWidth:int;
		private var viewHeight:int;
		private var viewCols:int;
		private var viewRows:int;
		public var viewXOffset:int;
		public var viewYOffset:int;
		private var tileRect:Rectangle;
		private var tilePoint:Point;
			
		private var sprites_width:int;
		private var sprites_height:int;
		private var sprites64x64:BitmapData;
		private var sprites_perRow:int;
		
		private var _speedX:int;  
		private var _speedY:int;  
		private var canvasBitmap:Bitmap;
		public static const FRAME_RATE:int = 30;
		private var _period:Number = 1000 / FRAME_RATE;
		private var _beforeTime:int = 0;
		private var _afterTime:int = 0;
		private var _timeDiff:int = 0;
		private var _sleepTime:int = 0;
		private var _overSleepTime:int = 0;
		private var _excess:int = 0;
		private var gameTimer:Timer;
		private var game:Game;
		private var ui:UI;
		public var tracking:Unit; 
		
		public function Map(ar:Array, cont:Game) { 
			aWorld = ar;
			game = cont; 
			ui = game.ui;  
			worldCols = 20;    
			worldRows = 16; 
			mas = new Vector.<Object>(worldRows, true); 
			var obj:Object; 
			var c:int;
			var vector:Vector.<Object>;  
			for(var i:int=0; i<worldRows; i++){ 
				vector = new Vector.<Object>(worldCols, true); 
				for(var j:int=0; j<worldCols; j++){ 
					 c = aWorld[i][j];
					 obj = new Object;
					 switch(c) {
						case 1:
						case 2:
							obj.coff = 2;   
						break;
						case 3:
							obj.coff = 3;   
						break;
						case 4:
							obj.coff = 5;    
						break;
						case 5: 
							obj.coff = 9;    
						break;
						default: obj.coff = 1;   
					 }
					 vector[j] = obj;  
				}   
				mas[i] = vector;      
			}
			viewWidth = 800;
			viewHeight = 480; 
			worldWidth = worldCols * grid_size; 
			worldHeight = worldRows * grid_size; 
			viewCols = Math.ceil(viewWidth/grid_size);  
			viewRows = Math.ceil(viewHeight/grid_size);  
			
			viewXOffset = viewYOffset = 256; 
			  
			tileRect = new Rectangle(0,0,grid_size,grid_size);
			tilePoint = new Point(0,0); 
	   
			canvasBD = new BitmapData(viewWidth,viewHeight,false,0x000000);
			bufferBD = new BitmapData(viewWidth+2*grid_size,viewHeight+2*grid_size,false,0x000000);
			bufferRect = new Rectangle(0,0,viewWidth,viewHeight);
			bufferPoint = new Point(0,0); 
			canvasBitmap = new Bitmap(canvasBD); 
			addChild(canvasBitmap);   
			  
			sprites_width=384;  
			sprites_height=64;  
			sprites64x64=new tileset(sprites_width,sprites_height);
			sprites_perRow=sprites_width/grid_size;
			
			gameTimer = new Timer(_period,1); 
			gameTimer.addEventListener(TimerEvent.TIMER, runGame);
			gameTimer.start();  
		}
		
		private function runGame(e:TimerEvent):void { 
				_beforeTime = getTimer(); 
				_overSleepTime = (_beforeTime - _afterTime) - _sleepTime;
				
				updatePlayer();
				if(_speedX!=0 || _speedY!=0) {
					canvasBD.lock();
					drawView();   
					canvasBD.unlock();
				}
				if(!startDraw) {
					startDraw = true;
					drawView(); 
				}
				
				_afterTime = getTimer();
				_timeDiff = _afterTime - _beforeTime;
				_sleepTime = (_period - _timeDiff) - _overSleepTime;        
				if (_sleepTime <= 0) {
					_excess -= _sleepTime
					_sleepTime = 2;
				}         
				gameTimer.reset(); 
				gameTimer.delay = _sleepTime;
				gameTimer.start();
			
				while (_excess > _period) {
					updatePlayer();
					_excess -= _period;
				}
				e.updateAfterEvent();
		}
			
			
		public function hScroll(val:Number):void {
		  _speedX += val;
		}
			 
		public function vScroll(val:Number):void {
		  _speedY += val;
		}
		
		private function updMapPos():void { 
			//var curX:Number = (game._turn) ? mouseX : game._ramka.x; 
			//var curY:Number = (game._turn) ? mouseY : game._ramka.y; 
			var curX:Number;
			var curY:Number; 
			if (tracking != null) {
				var p:Point = game.unit_cont.localToGlobal(new Point(tracking.x, tracking.y));
				curX = p.x;
				curY = p.y;  
			}
			else {
				curX = mouseX;
				curY = mouseY;
			}
		  if (curX < border) hScroll(-2);
		  else if (curX > viewWidth - border)  
		  	hScroll(2);
			   
		  if (curY < border) vScroll(-2); 
		  else if (curY > viewHeight - border) 
			vScroll(2);
		}
		
		private function updatePlayer():void {
			if(int(_speedX)!=0) {
				viewXOffset += int(_speedX);  
				if (viewXOffset < 0)  viewXOffset=0;   
				else if (viewXOffset > (worldWidth-viewWidth)-1) {
					viewXOffset = (worldWidth - viewWidth)-1;
					//trace("hit end of world width");
				}
				_speedX *= .86;
			} 
			if(int(_speedY)!=0) {
				viewYOffset += int(_speedY);   
				if (viewYOffset < 0) viewYOffset=0;
				else if (viewYOffset > (worldHeight-viewHeight)-1) {
					viewYOffset = (worldHeight-viewHeight)-1;
					//trace("hit end of world height");
				}
				_speedY *= .86;
			} 	    
			if (!ui.hitTestPoint(mouseX, mouseY, true) || !game._turn)  updMapPos();    
			game.unit_cont.x = -viewXOffset;  
			game.unit_cont.y = -viewYOffset;  
		}  
		
		private function clearUnit():void {
			var s:String;
			for (s in game.masGoodUnit) {
				game.masGoodUnit[s].visible = false; 
			} 
			for (s in game.masBadUnit) {
				game.masBadUnit[s].visible = false; 
			}  
		}
		
		private function drawView():void {
			clearUnit();
			var tilex:int = int(viewXOffset/grid_size);
			var tiley:int = int(viewYOffset/grid_size);
			var tileNum:int;   
			var rowper:int; 
			var colper:int;
			var obj:Unit;
			for (var rowCtr:int=0; rowCtr<=viewRows; rowCtr++) {
				for (var colCtr:int=0; colCtr<=viewCols; colCtr++) {  
					rowper = rowCtr+tiley; 
					colper = colCtr+tilex;
					if(rowper >= worldRows) rowper = worldRows-1; 
					if(colper >= worldCols) colper = worldCols-1
					tileNum = aWorld[rowper][colper];
					
					if (mas[rowper][colper].unit != undefined) {
						obj = mas[rowper][colper].unit; 
						obj.visible = true;   
					} 
					tilePoint.x=colCtr*grid_size;  
					tilePoint.y=rowCtr*grid_size; 
					tileRect.x = int((tileNum % sprites_perRow))*grid_size;
					tileRect.y = int((tileNum / sprites_perRow))*grid_size;
					bufferBD.copyPixels(sprites64x64,tileRect,tilePoint);
				} 
			} 
			bufferRect.x=viewXOffset % grid_size;
			bufferRect.y=viewYOffset % grid_size;
			canvasBD.copyPixels(bufferBD, bufferRect, bufferPoint);
		}
		
		public function get _mas():Vector.<Object> { return mas; } 
		public function get corX():int { return viewXOffset; }
		public function get corY():int { return viewYOffset; }
		public function set corX(value:int):void {
			viewXOffset = value;
		}
		public function set corY(value:int):void {
			viewYOffset = value;
			
		}
		
//-----		
	}
}