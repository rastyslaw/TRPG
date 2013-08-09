package  {
	import boxes.Box;
	import boxes.Container1;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Road extends Sprite implements IShled { 
		
		private var face:Face; 
		private var walker:Walke;
		private var map:Map;
		private var ramka:Sapog; 
		private var tree_cont:Sprite = new Sprite; 
		private var canvasBD:BitmapData; 
		private var backgroundBD:BitmapData;  
		private var backgroundRect:Rectangle; 
		private var backgroundPoint:Point; 
		public var border:int;   
		private var aWorld:Array = [];
		private var mas:Vector.<Object>; 
		public var worldCols:int; 
		public var worldRows:int;
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
		private var tileRect:Rectangle;
		private var tilePoint:Point;
		private var sprites_width:int;
		private var sprites_height:int;
		private var sprites64x64:BitmapData;
		private var sprites_perRow:int;
		private var _speedX:int;   
		private var _speedY:int;  
		private var canvasBitmap:Bitmap;   
		private var _period:Number = 1000 / Main.FRAME_RATE;
		private var _beforeTime:int = 0;
		private var _afterTime:int = 0;
		private var _timeDiff:int = 0;
		private var _sleepTime:int = 0;
		private var _overSleepTime:int = 0;
		private var _excess:int = 0; 
		private var gameTimer:Timer;
		private var game:Game;
		public var tracking:Hero;
		private var grid_size:int;
		private var hero:Hero;
		private var dely:Boolean;
		private var autoScroll:Boolean;
		private var sqCont:Sprite = new Sprite;
		private var walkerTar:Box;  
		
		public function Road(ar:Array, cofMas:Array, tiles:Bitmap, num:int) {
			grid_size = border = Map.grid_size;   
			aWorld = ar;  
			worldCols = ar[0].length;
			worldRows = ar.length;  
			mas = new Vector.<Object>(worldRows, true);  
			var obj:Object; 
			var c:int; 
			var vector:Vector.<Object>;  
			for(var i:int=0; i<worldRows; i++){ 
				vector = new Vector.<Object>(worldCols, true); 
				for(var j:int=0; j<worldCols; j++){ 
					 c = aWorld[i][j]; 
					 obj = new Object; 
					 if(c<cofMas[0]) obj.coff = 1;  
					 else obj.coff = 0;
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
 
			tileRect = new Rectangle(0,0,grid_size,grid_size);
			tilePoint = new Point(0,0); 
	   
			canvasBD = new BitmapData(viewWidth,viewHeight,false,0x000000);
			bufferBD = new BitmapData(viewWidth+2*grid_size,viewHeight+2*grid_size,false,0x000000);
			bufferRect = new Rectangle(0,0,viewWidth,viewHeight); 
			bufferPoint = new Point(0,0); 
			canvasBitmap = new Bitmap(canvasBD); 
			addChild(canvasBitmap);    
			sprites64x64 = tiles.bitmapData;    
			sprites_width = sprites64x64.width; 
			sprites_height=sprites64x64.height;  
			sprites_perRow=sprites_width/grid_size; 
			
			gameTimer = new Timer(_period,1); 
			gameTimer.addEventListener(TimerEvent.TIMER, runGame);
			gameTimer.start();
			
			addChild(tree_cont);
			tree_cont.addChildAt(sqCont, 0);
			var trees:Road1_trees = new Road1_trees;
			tree_cont.addChild(trees);
			//drawBox(); 
			
			hero = new Hero; 
			hero.x = 0 * grid_size - 8; 
			hero.y = 3 * grid_size - 8;  
			tree_cont.addChild(hero);  
			
			ramka = new Sapog; 
			addChild(ramka); 
			ramka.mouseEnabled = false;    
			ramka.mouseChildren = false; 
			
			face = new Face; 
			addChild(face);  
			var bmp:Bitmap = hero.getHeroIcon();
			bmp.scaleX = bmp.scaleY = 0.7; 
			face.addChild(bmp);
			bmp.x = bmp.y = 10;
			 
			var party:PartyGr = new PartyGr;
			party.x = face.width+10;
			addChild(party); 
			party.nam.text = String(Main.numParty);
			
			drawBoxes(num); 
			
			face.addEventListener(MouseEvent.CLICK, face_clicked);
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap);  
		}
		
		private function drawBoxes(num:int):void {
			var boxCoors:Array;
			switch(num) { 
				case 1:
					boxCoors = [[3,1],[8,1],[23,1],[6,5],[17,5]]; 
				break;
			}
			var box:Box;
			for (var i:int; i < boxCoors.length;i++) {
				var j:int = Math.floor(Math.random()*Main.boxTypes.length); 
				box = new Main.boxTypes[j]; 
				box.x = boxCoors[i][0] * grid_size;
				box.y = boxCoors[i][1] * grid_size; 
				tree_cont.addChild(box);    
				box.addEventListener(MouseEvent.CLICK, box_clicked); 	
			}
		} 
		
		private function box_clicked(e:MouseEvent=null):void {
			var box:Box;
			if (e == null) box = walkerTar; 
			else box = e.currentTarget as Box;
			 walkerTar = null;
			if ( (Math.abs(hero.x+8 - box.x) + Math.abs(hero.y+8 - box.y)) == grid_size ) {
				box.getGold();
				box.removeEventListener(MouseEvent.CLICK, box_clicked);
				return;
			} 
			var p:Point = gerCoord(box.x, box.y);
			var pHero:Point = gerCoord(hero.x, hero.y);
			var numX:int = p.x;
			var numY:int; 
			if (p.y == 1) numY = p.y + 1;
			else numY = p.y - 1;
			if (walker != null) { 
				if (numX == walker.last.x && numY == walker.last.y) return;
				hero.x = pHero.x * grid_size - 8;    
				hero.y = pHero.y * grid_size-8;
				walkerTar = null;
				walker.kill();
			}  
			hero.setState(Hero.MOVE);
			walkerCreate(numX, numY, pHero);
			walkerTar = box;  
			var timer:Timer = new Timer(300, 1);  
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, refresh_dely);
			timer.start();
			dely = true; 	 
		}
		
		private function face_clicked(e:MouseEvent):void {
			tracking = hero;
			autoScroll = true;
			var timer:Timer = new Timer(100, 0);
			timer.addEventListener(TimerEvent.TIMER, scan_camera_face);
			timer.start();
		}
		
		private function scan_camera_face(e:TimerEvent):void {
			if (_speedX == 0 && _speedY == 0 ) { 
				e.target.stop(); 
				e.target.removeEventListener(TimerEvent.TIMER, scan_camera_face);
				tracking = null;   
				autoScroll = false;  
			}
		}
		
		private function moveramk(e:MouseEvent):void {
			ramka.visible = false;   
			var numX:int = (mouseX + viewXOffset % grid_size) / grid_size;
			var numY:int = mouseY / grid_size;
			ramka.x = numX * grid_size - viewXOffset % grid_size;       
			ramka.y = numY * grid_size;
			var p:Point = tree_cont.globalToLocal(new Point(ramka.x, ramka.y));
			p = gerCoord(p.x, p.y);
			var obj:Object = mas[p.y][p.x]; 
			if (obj.coff != 0 && !hero.hitTestPoint(ramka.x+ramka.width/2, ramka.y+ramka.height/2)) ramka.visible = true;
		}
		
		private function clickedOnMap(e:MouseEvent):void {     
			var numX:int = (mouseX + viewXOffset) / grid_size; 
		 	var numY:int = mouseY / grid_size; 
			if (!ramka.visible || dely || hero.hitTestPoint(ramka.x+ramka.width/2, ramka.y+ramka.height/2)) return;
				var p:Point = gerCoord(hero.x, hero.y);
				if (walker != null) { 
					if (numX == walker.last.x && numY == walker.last.y) return;
					hero.x = p.x * grid_size - 8;      
					hero.y = p.y * grid_size-8;
					walkerTar = null;
					walker.kill();
				} 
				var curpoint:Point = new Point(numX, numY);
				hero.setState(Hero.MOVE);
				walkerCreate(numX, numY, p); 
				var timer:Timer = new Timer(300, 1);  
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, refresh_dely);
				timer.start();
				dely = true; 
		} 
		
		public function clearPath():void {
			while (sqCont.numChildren>0) {  
				sqCont.removeChildAt(0); 
			}  
		} 
		
		public function getSquare(y:int, x:int, color:uint=0xff0000):void {   
			var fig:Shape = new Shape; 
			fig.graphics.beginFill(color, .8);  
			fig.graphics.drawCircle(grid_size>>1, grid_size>>1, 4); 
			fig.graphics.endFill(); 
			sqCont.addChildAt(fig, 0); 
			fig.x = x * Map.grid_size;   
			fig.y = y * Map.grid_size;   
		} 
		
		private function walkerCreate(numX:int, numY:int, p:Point):void { 
			var qmas:Vector.<Point> = new Vector.<Point>();
			var j:int = 1;
			if (numX < p.x) j = -1;
			while (numX != p.x) {
				p.x += j;
				qmas.splice(0, 0, new Point(p.x, p.y));
			}
			j = 1;  
			if (numY < p.y) j = -1;  
			while (numY != p.y) { 
				p.y += j;
				qmas.splice(0, 0, new Point(p.x, p.y));   
			}  
			var curpoint:Point = new Point(numX, numY);
			qmas.push(null);
			walker = new Walke(hero, qmas, 4);
			walker.last = curpoint; 
			walker.addEventListener("LAST_POINT", comes);
		}
		
		private function kill():void {
			removeEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			removeEventListener(MouseEvent.CLICK, clickedOnMap);
			gameTimer.removeEventListener(TimerEvent.TIMER, runGame);
			gameTimer.stop();
			face.removeEventListener(MouseEvent.CLICK, face_clicked);
			Main(this.parent).drawBattle(this);    
		}
		
		private function comes(e:Event):void {
			if (hero.x >= worldWidth-grid_size-8) {
				kill(); 
				return;
			}
			if (walkerTar != null) box_clicked();
			walker.removeEventListener("LAST_POINT", comes);
			hero.setState(Hero.STAY);
			walker = null; 
		}
		
		private function refresh_dely(e:TimerEvent):void {
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, refresh_dely);
			e.currentTarget.stop();
			dely = false;
		}
		
		public function gerCoord(x:Number, y:Number):Point {
			var p:Point = new Point();
			p.x = int((x+(grid_size>>1)) / grid_size);   
			p.y = int((y+(grid_size>>1)) / grid_size);  
			return p;
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
					canvasBD.lock();
					drawView();
					canvasBD.unlock();
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

		private function updMapPos():void { 
			var curX:Number;
			var curY:Number; 
			if (tracking != null) {
				var p:Point = tree_cont.localToGlobal(new Point(tracking.x, tracking.y));
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
		} 
		
		private function updatePlayer():void {
			if(int(_speedX)!=0) {
				viewXOffset += int(_speedX);  
				if (viewXOffset < 0)  viewXOffset=0;   
				else if (viewXOffset > (worldWidth-viewWidth)-1) {
					viewXOffset = (worldWidth - viewWidth)-1;
				}
				_speedX *= .86;
			}  
			if ((!face.hitTestPoint(mouseX, mouseY)) || autoScroll) updMapPos();
		}
		
		private function drawView():void {
			var tilex:int = int(viewXOffset/grid_size);
			var tiley:int;
			var tileNum:int;   
			var rowper:int; 
			var colper:int; 
			var obj:Hero;
			for (var rowCtr:int=0; rowCtr<=viewRows; rowCtr++) {
				for (var colCtr:int=0; colCtr<=viewCols; colCtr++) {  
					rowper = rowCtr+tiley;  
					colper = colCtr+tilex; 
					if(rowper >= worldRows) rowper = worldRows-1; 
					if(colper >= worldCols) colper = worldCols-1
					tileNum = aWorld[rowper][colper];
					tilePoint.x=colCtr*grid_size;    
					tilePoint.y=rowCtr*grid_size; 
					tileRect.x = int((tileNum % sprites_perRow))*grid_size;
					tileRect.y = int((tileNum / sprites_perRow))*grid_size;
					bufferBD.copyPixels(sprites64x64,tileRect,tilePoint);
				} 
			} 
			bufferRect.x=viewXOffset % grid_size;
			canvasBD.copyPixels(bufferBD, bufferRect, bufferPoint);
			tree_cont.x = -viewXOffset;
		}
		
//-----		
	}
}