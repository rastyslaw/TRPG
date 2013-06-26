package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class Mainn extends Sprite{
		 
		private var playerObj:Object=new Object();
		private var canvasBD:BitmapData;
		private var backgroundBD:BitmapData;
		private var backgroundRect:Rectangle;
		private var backgroundPoint:Point; 
		private var border:int = 80;   
		private var aWorld:Array = [[1,2,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], 
									[2,0,0,0,0,2,2,2,0,1,3,3,3,0,1,0,0,0,0,1],
									[0,3,3,3,0,2,1,2,0,1,3,0,0,0,1,0,0,0,0,1],
									[0,3,3,3,0,2,1,2,0,1,2,2,0,0,1,0,0,0,0,1],
									[3,0,1,3,0,2,2,2,0,1,0,0,0,0,1,0,0,0,0,1], 
									[3,3,0,3,0,0,0,0,0,1,0,0,3,0,1,0,0,0,0,1],
									[1,0,2,0,0,0,0,0,0,1,0,0,0,3,1,0,0,0,0,1], 
									[1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,1], 
									[1,0,0,3,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,1],
									[1,2,0,0,3,0,2,2,2,0,0,0,0,0,0,0,0,0,0,1],
									[1,2,0,3,0,0,3,0,0,0,0,3,3,3,0,0,0,0,0,1],
									[1,0,0,0,3,3,3,0,0,0,0,0,2,1,0,0,0,0,0,1],
									[1,0,3,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1],
									[1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1],
									[1,0,3,2,0,0,0,0,0,0,3,0,0,0,0,1,0,0,0,1],
									[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]];
		private var mas:Vector.<Object>; 		  			
		private var worldCols:int;
		private var worldRows:int;
		private var worldWidth:int;
		private var worldHeight:int; 
		private var bufferBD:BitmapData;
		private var bufferRect:Rectangle;
		private var bufferPoint:Point;
	
		private var viewWidth:int;
		private var viewHeight:int;
		private var viewCols:int;
		private var viewRows:int;
		private var viewXOffset:Number;
		private var viewYOffset:Number;
		private var tileRect:Rectangle;
		private var tilePoint:Point;
			
		private var sprites_width:int;
		private var sprites_height:int;
		private var sprites16x16:BitmapData;
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
		private var startDraw:Boolean;
		private var animationManager:AnimationManager;
		private var obj:Animation; 
		private var ramka:Ramka; 
		private var grid_size:int = 64;
		
		private var unit_cont:Sprite = new Sprite;
		private var sqCont:Sprite = new Sprite;
		private var masUnit:Vector.<Animation> = new Vector.<Animation>;
		
		private var masWater:Vector.<Point> = new Vector.<Point>;
		private var masPath:Vector.<Point> = new Vector.<Point>;  
		private var sqUnderPoint:Point = new Point();   
		private var masPoint:Vector.<Point>; 
		private var lines:Shape = new Shape;  
		
		public function Mainn() { 
			var animationManager:AnimationManager = new AnimationManager();
			animationManager.addAnimation("gnomd");
			
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
					 if(c == 1 || c == 2) obj.coff = 2;  
					 else if(c == 3) obj.coff = 3; 
					 else obj.coff = 1;
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
			  
			sprites_width=256;  
			sprites_height=256;  
			sprites16x16=new sprites_png(sprites_width,sprites_height);
			sprites_perRow=sprites_width/grid_size;
			
			ramka = new Ramka;
			addChild(ramka);
			ramka.mouseEnabled = false; 
			ramka.mouseChildren = false;
			ramka.width = ramka.height = grid_size; 
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap);
			 
			obj = animationManager.getAnimation("gnomd");
			obj.scaleX = obj.scaleY = 0.8;
			mas[4][5].unit = obj;
			var obj2:Animation = animationManager.getAnimation("gnomd");
			obj2.scaleX = obj2.scaleY = 0.8; 
			mas[2][6].unit = obj2;
			 
			addChild(unit_cont);
			unit_cont.addChild(sqCont);
			unit_cont.addChild(lines);
			unit_cont.x = -viewXOffset; 
			unit_cont.y = -viewYOffset;
			
			gameTimer=new Timer(_period,1); 
			gameTimer.addEventListener(TimerEvent.TIMER, runGame);
			gameTimer.start();  
		} 
		
		private function clickedOnMap(e:MouseEvent):void {
			var numX:int = (mouseX + viewXOffset)/ grid_size;
		 	var numY:int = (mouseY + viewYOffset)/ grid_size;
			//trace(mas[numY][numX].coff);
			//trace(sqCont.hitTestPoint(mouseX,mouseY,true));    
			clearSq();
			if (mas[numY][numX].unit != undefined) {
				mas[numY][numX].water = -1; 
				getSquare(numY, numX); 
				masWater.push(new Point(numX, numY));   
				getPath(6); 
			}
		}
		 
		private function clearSq():void { 
			while (sqCont.numChildren>0) {
				sqCont.removeChildAt(0);
			}
			masWater.splice(0, masWater.length);
			clearWater();
			lines.graphics.clear();
		}
		
		private function clearWater():void {
			for each (var s:Vector.<Object> in mas) {
				for each (var k:Object in s) {
					k.water = 0;
					k.sq = false;  
				}  
			}  
		} 
	
		private function getPath(spd:int):void {
			var bol:Boolean = true;  
			while(bol) {  
				bol = scanPath(spd);
			} 
		}      
		
		private function getSquare(y:int, x:int):void {
			var fig:Shape = new Shape;
			fig.graphics.beginFill(0xff0000, 0.3);  
			fig.graphics.drawRect(4, 4, grid_size-6, grid_size-6);
			fig.graphics.endFill();
			sqCont.addChildAt(fig, 0);
			fig.x = x * grid_size; 
			fig.y = y * grid_size;   
		}
		
		private function scanPath(spd:int):Boolean {
			var timeMas:Vector.<Point> = new Vector.<Point>;
			var b:Boolean; 
			var index:int;
			var curIndex:int; 
			var dirX:int;
			var dirY:int;
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];  
			for each (var p:Point in masWater) {
				curIndex = mas[p.y][p.x].water;
				if (curIndex == -1) curIndex = 0;
				for (var i:int = 0; i < direction.length; i++) {  
					dirX = p.x + direction[i][0];
					dirY = p.y + direction[i][1];    
					if (getIndex(dirX, dirY)) {  
						index = mas[dirY][dirX].coff;   
						var op:Object = mas[dirY][dirX];
						if (op.water == 0 || (op.water > index + curIndex)) { 
							op.water = index + curIndex; 
							if(op.unit==undefined) { 
								timeMas.push(new Point(dirX, dirY));
								if (op.water <= spd) {
									if (!op.sq) {
										getSquare(dirY, dirX);
										op.sq = true; 
									}
									b = true;   
								}
							}
						}
					} 
			    }    
			} 
			masWater = timeMas;
			return b;
		}
		
		private function getIndex(x:int, y:int):Boolean { 
			if (x >= worldCols || x < 0 || y >= worldRows || y < 0) return false; 
			return true;
		}
 
		private function moveramk(e:MouseEvent):void {
			var numX:int = (mouseX + viewXOffset % grid_size) / grid_size;
			var numY:int = (mouseY + viewYOffset % grid_size) / grid_size;
			ramka.x = numX * grid_size - viewXOffset % grid_size;     
			ramka.y = numY * grid_size - viewYOffset % grid_size;  
			
			if (sqCont.hitTestPoint(mouseX, mouseY, true)) {
				var tarX:int = (mouseX + viewXOffset) / grid_size; 
				var tarY:int = (mouseY + viewYOffset) / grid_size;
				if (mas[tarY][tarX].unit != undefined) return;  
				if ((sqUnderPoint.x != tarX) || (sqUnderPoint.y != tarY)) { 
					sqUnderPoint = new Point(tarX, tarY);
					masPoint = new Vector.<Point>();
					var p:Point = getGoodPath(sqUnderPoint);
					masPoint.push(p); 
					while (mas[p.y][p.x].unit == undefined) {
						p = getGoodPath(p); 
						masPoint.push(p);   
					} 
					masPoint.splice(0, 0, new Point(tarX, tarY)); 
					lines.graphics.clear();
					lines.graphics.lineStyle(6, 0xff0000, 0.7);
					var len:int = masPoint.length; 
					lines.graphics.moveTo(masPoint[len-1].x*grid_size+(grid_size>>1), masPoint[len-1].y*grid_size+(grid_size>>1));  
					for (var s:int=len-2; s >= 0; s--) {  
						lines.graphics.lineTo(masPoint[s].x*grid_size+(grid_size>>1), masPoint[s].y*grid_size+(grid_size>>1));
					}
				}
			}  
		} 
		
		private function getGoodPath(point:Point):Point {
			var min:int = 99;
			var dirX:int;
			var dirY:int; 
			var curWater:int; 
			var p:Point = new Point(); 
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
			for (var i:int = 0; i < direction.length; i++) {  
				dirX = point.x + direction[i][0];
				dirY = point.y + direction[i][1];
				if (getIndex(dirX, dirY)) {  
					curWater = mas[dirY][dirX].water;
					if (curWater == -1) return new Point(dirX, dirY); 
					if (curWater < min) {
						min = curWater;
						p.x = dirX;
						p.y = dirY;   
					}
				}
			}
			return p;
		}
		
		private function getPointToPixels(n:int, b:Boolean):Number {
			var r:int = n * grid_size;
			if (b) return r - (grid_size >> 1); 
			return r; 
		}
		 
		private function setGridLocation(coords:Array) :void {
			this.x = getPointToPixels(coords[0], true); 
			this.y = getPointToPixels(coords[1], true);
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
		  if (mouseX < border) hScroll(-2);
		  else if (mouseX > viewWidth - border) 
		  	hScroll(2);
			  
		  if (mouseY < border) vScroll(-2);
		  else if (mouseY > viewHeight - border)
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
				if (viewYOffset < 0) {  
					viewYOffset=0;
				} 
				else if (viewYOffset > (worldHeight-viewHeight)-1) {
					viewYOffset = (worldHeight-viewHeight)-1;
					//trace("hit end of world height");
				}
				_speedY *= .86;
			} 	 
			updMapPos();
			unit_cont.x = -viewXOffset;
			unit_cont.y = -viewYOffset;
		}  
		
		private function clearUnit():void {
			for (var s:String in masUnit) {
				unit_cont.removeChild(masUnit[s]);
			} 
			masUnit.splice(0, masUnit.length);
		}
		
		private function drawView():void {
			clearUnit();
			var tilex:int = int(viewXOffset/grid_size);
			var tiley:int = int(viewYOffset/grid_size);
			var tileNum:int;   
			var rowper:int;
			var colper:int;
			var obj:Animation;
			for (var rowCtr:int=0; rowCtr<=viewRows; rowCtr++) {
				for (var colCtr:int=0; colCtr<=viewCols; colCtr++) {  
					rowper = rowCtr+tiley; 
					colper = colCtr+tilex;
					if(rowper >= worldRows) rowper = worldRows-1; 
					if(colper >= worldCols) colper = worldCols-1
					tileNum = aWorld[rowper][colper];
					
					if (mas[rowper][colper].unit != undefined) {
						obj = mas[rowper][colper].unit
						if (!unit_cont.contains(obj)) {
							unit_cont.addChild(obj);
							masUnit.push(obj);  
							obj.y = rowper * grid_size - 8;
							obj.x = colper * grid_size - 8; 
						}
					} 
					tilePoint.x=colCtr*grid_size; 
					tilePoint.y=rowCtr*grid_size; 
					tileRect.x = int((tileNum % sprites_perRow))*grid_size;
					tileRect.y = int((tileNum / sprites_perRow))*grid_size;
					bufferBD.copyPixels(sprites16x16,tileRect,tilePoint);
				} 
			} 
			bufferRect.x=viewXOffset % grid_size;
			bufferRect.y=viewYOffset % grid_size;
			canvasBD.copyPixels(bufferBD,bufferRect,bufferPoint);
		}
//-----
	}
}
