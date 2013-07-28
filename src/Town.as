package  {
	import com.greensock.TweenLite;
	import events.NpcEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import npc.Captain;
	import npc.Cook;
	import npc.ExitGuard;
	import npc.Farmer;
	import npc.Fisher;
	import npc.Guard;
	import npc.Liza;
	import npc.Monk;
	import npc.NPC;
	import npc.Professor;
	import npc.Smith;
	import npc.WalkerGuard;
	import units.Animation;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Town extends Sprite { 
		
		private var map:Map;
		private var ramka:Sapog; 
		private var scrolling:Boolean = true;
		public var unit_cont:Sprite = new Sprite;
		private var npc_cont:Sprite = new Sprite;
		private var roofs:Sprite = new Sprite;
		
		private var playerObj:Object=new Object();
		private var canvasBD:BitmapData;
		private var backgroundBD:BitmapData;
		private var backgroundRect:Rectangle;
		private var backgroundPoint:Point; 
		public var border:int;   
		private var aWorld:Array = []
		private var mas:Vector.<Object>; 
		
		public var worldCols:int; 
		public var worldRows:int;
		
		private var masWater:Vector.<Point> = new Vector.<Point>;
		private var masPath:Vector.<Point> = new Vector.<Point>;
		private var masPoint:Vector.<Point> = new Vector.<Point>;
		
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
		public const FRAME_RATE:int = 30;
		private var _period:Number = 1000 / FRAME_RATE;
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
		private var curpoint:Point = new Point();
		private var walker:Walke;
		private var replic:Replic;
		private var ui:Sprite; 
		private var replic_tar:NPC;
		private var replicTimer:Timer;
		private var face:Face; 
		private var sqCont:Sprite = new Sprite;
		private var dely:Boolean; 
		private var autoScroll:Boolean;
		
		public function Town(ar:Array, cofMas:Array, tiles:Bitmap) {
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
					 if(c>cofMas[0]) obj.coff = 1;  
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
			
			viewXOffset = viewYOffset = 64; 
			  
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
			unit_cont.addChildAt(sqCont, 0);   
			drawBox(); 
			//
			hero = new Hero; 
			hero.x = hero.y = 2 * grid_size - 8; 
			unit_cont.addChild(hero);
			mas[2][2].unit = hero; 
			//
			buildNPC();  
			ramka = new Sapog; 
			addChild(ramka); 
			ramka.mouseEnabled = false;    
			ramka.mouseChildren = false; 
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap);
			 
			addChild(unit_cont);
			ui = new Sprite;
			addChild(ui);
			createRoof();
			
			face = new Face; 
			ui.addChild(face);  
			var bmp:Bitmap = hero.getHeroIcon();
			bmp.scaleX = bmp.scaleY = 0.7; 
			face.addChild(bmp);
			bmp.x = bmp.y = 10;
			face.addEventListener(MouseEvent.CLICK, face_clicked);
			
			addEventListener(Event.ENTER_FRAME, scanRoofs);
			unit_cont.x = -viewXOffset;   
			unit_cont.y = -viewYOffset; 
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
		
		private function drawBox():void { 
			var box1:Box1 = new Box1; 
			box1.x = 9 * grid_size;
			box1.y = 7 * grid_size;
			unit_cont.addChild(box1);
			mas[7][9].coff = 0;
			var box2:Box1 = new Box1; 
			box2.x = 28 * grid_size;
			box2.y = 22 * grid_size;
			unit_cont.addChild(box2);
			mas[22][28].coff = 0;
			var box3:Box1_empty = new Box1_empty;  
			box3.x = 0 * grid_size;
			box3.y = 17 * grid_size;
			unit_cont.addChild(box3);
			mas[17][0].coff = 0;
			var box4:Box2 = new Box2; 
			box4.x = 27 * grid_size;
			box4.y = 6 * grid_size;
			unit_cont.addChild(box4); 
			mas[6][27].coff = 0;
			var box5:Box2= new Box2; 
			box5.x = 17 * grid_size;
			box5.y = 24 * grid_size;
			unit_cont.addChild(box5); 
			mas[24][17].coff = 0; 
			var box6:Box2_empty = new Box2_empty;  
			box6.x = 11 * grid_size;  
			box6.y = 14 * grid_size;  
			unit_cont.addChild(box6); 
			mas[14][11].coff = 0; 
		}
		
		private function createRoof():void {
			var roof1:Roof_cook = new Roof_cook;
			roof1.x = 10 * grid_size;
			roof1.y = 2 * grid_size;
			roofs.addChild(roof1); 
			var roof2:Roof_alhim = new Roof_alhim;
			roof2.x = 2 * grid_size;
			roof2.y = 10 * grid_size; 
			roofs.addChild(roof2);
			var roof3:Roof_home = new Roof_home;
			roof3.x = 22 * grid_size; 
			roof3.y = 3 * grid_size; 
			roofs.addChild(roof3);
			var roof4:Roof_cherch = new Roof_cherch;
			roof4.x = 12 * grid_size; 
			roof4.y = 11 * grid_size; 
			roofs.addChild(roof4);
			var roof5:Roof_prison = new Roof_prison;
			roof5.x = 22 * grid_size; 
			roof5.y = 18 * grid_size;  
			roofs.addChild(roof5); 
			unit_cont.addChild(roofs); 
		}
		
		private function buildNPC():void {
			var liza:NPC = new Liza; 
			liza.x = 2 * grid_size - 8;
			liza.y = 15 * grid_size - 8; 
			npc_cont.addChild(liza); 
			mas[15][2].unit = liza;    
 
			var guard1:NPC = new Guard; 
			guard1.x = 25 * grid_size - 8;
			guard1.y = 24 * grid_size - 8;  
			npc_cont.addChild(guard1);
			mas[24][25].unit = guard1; 
			
			var guard2:NPC = new ExitGuard; 
			guard2.x = 3 * grid_size - 8;
			guard2.y = 1 * grid_size - 8; 
			npc_cont.addChild(guard2);
			mas[1][3].unit = guard2;  
			 
			var guard3:NPC = new WalkerGuard; 
			guard3.x = 12 * grid_size - 8;
			guard3.y = 8 * grid_size - 8; 
			npc_cont.addChild(guard3);
			mas[8][12].unit = guard3; 
			
			var fisher:NPC = new Fisher; 
			fisher.x = 12 * grid_size - 8; 
			fisher.y = 22 * grid_size - 8;  
			npc_cont.addChild(fisher);
			mas[22][12].unit = fisher;
			
			var captain:NPC = new Captain; 
			captain.x = 4 * grid_size - 8; 
			captain.y = 19 * grid_size - 8;  
			npc_cont.addChild(captain); 
			captain._busy = true;   
			mas[19][4].unit = captain; 
			
			var cook:NPC = new Cook; 
			cook.x = 12 * grid_size - 8; 
			cook.y = 4 * grid_size - 8;  
			npc_cont.addChild(cook);
			mas[4][12].unit = cook; 
			
			var professor:NPC = new Professor; 
			professor.x = 4 * grid_size - 8;  
			professor.y = 12 * grid_size - 8;  
			npc_cont.addChild(professor); 
			mas[12][4].unit = professor;
			
			var monk:NPC = new Monk; 
			monk.x = 13 * grid_size - 8;  
			monk.y = 13 * grid_size - 8;   
			npc_cont.addChild(monk); 
			mas[13][13].unit = monk;  
			
			unit_cont.addChild(npc_cont);
			
			liza._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			captain._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			monk._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			professor._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			cook._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			guard1._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			guard2._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			guard3._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			fisher._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			
			liza.addEventListener(NpcEvent.MOVING, moveNpc);  
			professor.addEventListener(NpcEvent.MOVING, moveNpc);
			guard3.addEventListener(NpcEvent.MOVING, moveNpc);
		}
		 
		private function show_dialog(e:MouseEvent = null):void {
			//trace(getQualifiedClassName(e.target)); 
			if (walker != null) { 
				var numX:int = (mouseX + viewXOffset) / grid_size;
				var numY:int = (mouseY + viewYOffset) / grid_size;
				if (numX == walker.last.x && numY == walker.last.y) return;
			}
			var obg:NPC;
			if (e != null) obg = NPC(e.currentTarget.parent);
			else obg = replic_tar;
			replic_tar = null; 
			if ( (Math.abs(hero.x - obg.x) + Math.abs(hero.y - obg.y)) == grid_size ) {
				if (replic != null) {
					replicTimer.stop(); 
					replicTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
					replic.removeEventListener(MouseEvent.CLICK, killReplic);
					ui.removeChild(replic);
					replic = null;   
				}
				replic = new Replic;  
				ui.addChild(replic);
				setChildIndex(ui, numChildren-1);
				replic.addEventListener(MouseEvent.CLICK, killReplic);
				replic.y = Constants.STAGE_HEIGHT;
				replic.x = 6;
				TweenLite.to(replic, .6, { y:replic.y-replic.height-6}); 
				//else replic.removeChildAt(replic.numChildren - 1);
				replic.addChild(obg.getIco()); 
				replic.info.info.text = obg.getWords();
				replic.scrol.visible = false;
				if (replic.info.info.numLines > 3) replic.scrol.visible = true;
				replic.info.info.height = replic.info.info.textHeight;
				obg.talking(hero);
				  
				replicTimer = new Timer(1000+(replic.info.info.maxScrollV)*1000, 1);
				replicTimer.addEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
				replicTimer.start();
			}
			else if(obg.walker==null) { 
				if (replic != null) killReplicNow(); 
				var min:Number = Number.MAX_VALUE;  
				var dirX:Number; 
				var dirY:Number;
				var rast:Number;  
				var point:Point = gerCoord(hero.x, hero.y);
				var pointNpc:Point = gerCoord(obg.x, obg.y);
				var rez:int; 
				var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
				var dX:int; 
				var dY:int;
				for (var i:int = 0; i < direction.length; i++) {  
					dX = pointNpc.x + direction[i][0];
					dY = pointNpc.y + direction[i][1]; 
					if (getIndex(dX, dY) && mas[dY][dX].unit == undefined && mas[dY][dX].coff != 0 ) {
						dirX = dX - point.x;   
						dirY = dY - point.y;  
						rast = Math.sqrt(dirX * dirX + dirY * dirY); 
						if (rast < min) { 
							min = rast;  
							rez = i; 
						}
					}
				} 
				var rezPoint:Point = new Point(pointNpc.x + direction[rez][0], pointNpc.y + direction[rez][1]); 
				clearSq(); 
				if (walker != null) { 
					if (rezPoint.x == walker.last.x && rezPoint.y == walker.last.y) return;
					hero.x = hero.prev.x * grid_size - 8;  
					hero.y = hero.prev.y * grid_size - 8; 
					walker.kill(); 
				} 
				curpoint = new Point(rezPoint.x, rezPoint.y);  
				hero.prev = gerCoord(hero.x, hero.y); 
				if (!getPath()) return; 
				hero.setState(Hero.MOVE);
				masPoint.splice(0, masPoint.length);  
				var p:Point = getGoodPath(curpoint);
				masPoint.push(p);
				var err:int;
				while (p!=null) {      
					p = getGoodPath(p);      
					masPoint.push(p);
					err++;
					if (err > 20) p = null;  
				}       
				masPoint.splice(0, 0, curpoint);
				getSquare(curpoint.y, curpoint.x);
				setChildIndex(ramka, numChildren-1);
				walker = new Walke(hero, masPoint, 4, refresh); 
				walker.addEventListener("LAST_POINT", comes);
				replic_tar = obg;   
			}
		} 
		
		private function killreplictick(e:TimerEvent):void {
			e.currentTarget.stop();
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
			if (replic == null) return;
			killReplicNow();  
		}
		
		private function killReplicNow():void {
			replicTimer.stop(); 
			replicTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
			replic.removeEventListener(MouseEvent.CLICK, killReplic); 
			TweenLite.to(replic, .3, { y:Constants.STAGE_HEIGHT, onComplete:onFinishTween } );
		}
		 
		private function killReplic(e:MouseEvent = null):void {
			if (replic.scrol.visible) {
				var i:int = replic.info.info.maxScrollV - replic.info.info.bottomScrollV;
				if ( i * 27 != replic.info.info.y) { 
					replic.info.info.y -= 27; 
				}
				else {
					replic.scrol.visible = false; 
					replic.removeEventListener(MouseEvent.CLICK, killReplic); 
					TweenLite.to(replic, .3, { y:Constants.STAGE_HEIGHT, onComplete:onFinishTween}); 
				} 
			} 
			else { 
				replic.removeEventListener(MouseEvent.CLICK, killReplic); 
				TweenLite.to(replic, .3, { y:Constants.STAGE_HEIGHT, onComplete:onFinishTween } );
			}
		}
		
		private function onFinishTween():void {
			ui.removeChild(replic); 
			replic = null; 
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
			var curX:Number;
			var curY:Number; 
			if (tracking != null) {
				var p:Point = unit_cont.localToGlobal(new Point(tracking.x, tracking.y));
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
				}
				_speedX *= .86;
			} 
			if(int(_speedY)!=0) {
				viewYOffset += int(_speedY);   
				if (viewYOffset < 0) viewYOffset=0;
				else if (viewYOffset > (worldHeight-viewHeight)-1) {
					viewYOffset = (worldHeight-viewHeight)-1;
				} 
				_speedY *= .86; 
			} 	     
			if((scrolling && !ui.hitTestPoint(mouseX, mouseY)) || autoScroll) updMapPos();       
			unit_cont.x = -viewXOffset;  
			unit_cont.y = -viewYOffset;  
		}  
		
		private function drawView():void {
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
	 
		private function clickedOnMap(e:MouseEvent):void {
			clearSq();
			if (ui.hitTestPoint(mouseX, mouseY, true)) return;      
			var numX:int = (mouseX + viewXOffset) / grid_size;
		 	var numY:int = (mouseY + viewYOffset) / grid_size;
			if (!ramka.visible || dely || mas[numY][numX].unit is Hero) return;
				if (walker != null) {
					if (numX == walker.last.x && numY == walker.last.y) return;
					hero.x = hero.prev.x * grid_size - 8;   
					hero.y = hero.prev.y * grid_size - 8; 
					replic_tar = null;
					walker.kill();
					replic_tar = null;
				} 
				curpoint = new Point(numX, numY);  
				hero.prev = gerCoord(hero.x, hero.y); 
				if (!getPath()) return;    
				hero.setState(Hero.MOVE);
				masPoint.splice(0, masPoint.length);  
				var p:Point = getGoodPath(curpoint);
				masPoint.push(p);
				var er:int;
				while (p!=null) {      
					p = getGoodPath(p);       
					masPoint.push(p);   
					er++; 
					if (er > 100) { 
						throw new Error("опять цикл глючит");
						p = null; 
					}
				}        
				masPoint.splice(0, 0, curpoint);
				getSquare(curpoint.y, curpoint.x);
				setChildIndex(ramka, numChildren - 1);
				setChildIndex(ui, numChildren-1); 
				walker = new Walke(hero, masPoint, 4, refresh);
				//tracking = hero;         
				//border = 200;  
				walker.addEventListener("LAST_POINT", comes);
				var timer:Timer = new Timer(300, 1);  
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, refresh_dely);
				timer.start();
				dely = true; 
		} 
		  
		private function refresh_dely(e:TimerEvent):void {
			e.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, refresh_dely);
			e.currentTarget.stop();
			dely = false;
		}
		
		private function moveNpc(e:NpcEvent):void {  
			var tar:NPC = e.tar;  
			tar.prev = gerCoord(tar.x, tar.y);   
			var mas:Vector.<Point> = tar.path;      
			if ((mas[0].x == tar.prev.x) && (mas[0].y == tar.prev.y)) {
				var timeMas:Vector.<Point> = new Vector.<Point>;
				for (var p:int=mas.length-1; p>0; p--) {
					timeMas.push(mas[p]); 
				} 
				timeMas.push(mas[0]);
				mas = timeMas;
			}  
			tar.setState(Hero.MOVE); 
			var walker:Walke = new Walke(tar, mas, 2, refresh);  
			walker.addEventListener("LAST_POINT", npcComes);
		}
		 
		private function npcComes(e:Event):void {
			var walke:Walke = Walke(e.currentTarget);
			var tar:NPC = walke._unit;
			tar.setState(Hero.STAY);
			//  
			//while (sqCont.numChildren>0) { 
			//	sqCont.removeChildAt(0); 
			//}
			var p:Point = gerCoord(tar.x, tar.y); 
			mas[tar.prev.y][tar.prev.x].unit = undefined;
			mas[p.y][p.x].unit = tar;
			tar.prev = p;  
			//getSquare(tar.prev.y, tar.prev.x);   
			//getSquare(p.y, p.x, 0x0000ff); 
			//
			tar._busy = false;
			tar.walker = null; 
		}
		
		private function getSquare(y:int, x:int, color:uint=0xff0000):void {
			//var fig:DisplayObject = new Drawler(color);
			var fig:Shape = new Shape;
			fig.graphics.beginFill(0xff0000, .8); 
			fig.graphics.drawCircle(grid_size>>1, grid_size>>1, 4); 
			fig.graphics.endFill(); 
			sqCont.addChildAt(fig, 0); 
			fig.x = x * grid_size;   
			fig.y = y * grid_size;   
		}
		
		private function refresh(tar:*, s:uint = 0):Boolean {
			var xx:int;
			var yy:int;
			switch(s) { 
				case Animation.MOVING_BOTTOM:
					yy = grid_size + (grid_size >> 1);
				break;
				case Animation.MOVING_TOP:
					yy = -(grid_size >> 1);
				break;
				case Animation.MOVING_LEFT:
					xx = -(grid_size >> 1);  
				break;
				case Animation.MOVING_RIGHT:  
					xx = grid_size + (grid_size >> 1);
				break;  
			}
			var p:Point = gerCoord(tar.x + xx, tar.y + yy);
			if (mas[p.y][p.x].unit != undefined) {
				if (getQualifiedClassName(tar) != "Hero") {
					tar.walker.pause(mas[p.y][p.x]);   
				}
				else {      
					walker.kill(); 
				}  
				return true;
			}  
			//while (sqCont.numChildren>0) { 
			//	sqCont.removeChildAt(0); 
			//}
			mas[tar.prev.y][tar.prev.x].unit = undefined;
			//getSquare(tar.prev.y, tar.prev.x);   
			mas[p.y][p.x].unit = tar;
			//getSquare(p.y, p.x, 0x0000ff); 
			tar.prev = p;
			return false;  
		}
		   
		private function comes(e:Event):void { 
			//while (sqCont.numChildren>0) { 
			//	sqCont.removeChildAt(0); 
			//}
			walker.removeEventListener("LAST_POINT", comes);
			
			hero.setState(Hero.STAY);
			
			var p:Point = gerCoord(hero.x, hero.y);  
			mas[hero.prev.y][hero.prev.x].unit = undefined;
			mas[p.y][p.x].unit = hero;
			//getSquare(hero.prev.y, hero.prev.x);    
			//getSquare(p.y, p.x, 0x0000ff); 
			hero.prev = p;  
			
			//tracking = null;       
			//border = 64; 
			walker = null;  
			if (replic_tar != null) show_dialog();
		}
		
		private function clearSq():void {
			while (sqCont.numChildren>0) { 
				sqCont.removeChildAt(0); 
			} 
			masWater.splice(0, masWater.length);
			clearWater();
		}  
		  
		private function clearWater():void { 
			for each (var s:Vector.<Object> in mas) {
				for each (var k:Object in s) {
					k.water = 0;
				}  
			}  
		} 
	 
		public function getPath():Boolean {
			var p:Point = gerCoord(hero.x, hero.y);
			mas[p.y][p.x].water = -1;
			mas[curpoint.y][curpoint.x].water = 99; 
			masWater.push(p);  
			var bol:Boolean = true;
			var er:int;
			while(bol) {     
				bol = scanPath(); 
				er++;
				if (er > 80) return false;
			}
			return true; 
		}       
		
		private function getIndx(y:int, x:int, i:int):void {
			var text:TextField = new TextField();
			text.text = String(i);
			text.textColor = 0xff0000;
			var textF:TextFormat = new TextFormat();
			textF.size = 30;
			text.setTextFormat(textF); 
			sqCont.addChildAt(text, 0);  
			text.x = x * grid_size;  
			text.y = y * grid_size;   
		}
		
		private function scanPath():Boolean {
			var timeMas:Vector.<Point> = new Vector.<Point>;
			var b:Boolean = true; 
			var index:int;
			var curIndex:int; 
			var dirX:int;
			var dirY:int;
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];  
			for each (var p:Point in masWater) {
				curIndex = mas[p.y][p.x].water;
				if (curIndex == -1) curIndex = 0; 
				curIndex++; 
				for (var i:int = 0; i < direction.length; i++) {  
					dirX = p.x + direction[i][0];
					dirY = p.y + direction[i][1];    
					if (getIndex(dirX, dirY)) {  
						index = mas[dirY][dirX].coff;    
						var op:Object = mas[dirY][dirX];
						if (op.water==0 && index!=0) { 
							op.water = curIndex;
							if(op.unit==undefined) { 
								timeMas.push(new Point(dirX, dirY));
								//getIndx(dirY, dirX, curIndex);  
							} 
						}
						else if (op.water == 99) { 
							timeMas.push(new Point(dirX, dirY));
							//getIndx(dirY, dirX, curIndex);  
							return false;  
						}
					}  
			    }
			} 
			masWater = timeMas;
			return b;
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
					if (curWater == -1) return null;  
					if (curWater < min && curWater!=0 && mas[dirY][dirX].unit==undefined) {
						min = curWater;
						p.x = dirX;
						p.y = dirY;   
					}
				}  
			}
			getSquare(p.y, p.x);  
			return p; 
		}
		
		public function getIndex(x:int, y:int):Boolean { 
			if (x >= worldCols || x < 0 || y >= worldRows || y < 0) return false; 
			return true; 
		} 
		 
		public function gerCoord(x:Number, y:Number):Point {
			var p:Point = new Point();
			p.x = int((x+(grid_size>>1)) / grid_size);   
			p.y = int((y+(grid_size>>1)) / grid_size);  
			return p;
		}
		
		private function moveramk(e:MouseEvent):void {
			ramka.visible = false;  
			var numX:int = (mouseX + viewXOffset % grid_size) / grid_size;
			var numY:int = (mouseY + viewYOffset % grid_size) / grid_size;
		
			ramka.x = numX * grid_size - viewXOffset % grid_size;      
			ramka.y = numY * grid_size - viewYOffset % grid_size;
			var p:Point = unit_cont.globalToLocal(new Point(ramka.x, ramka.y));
			p = gerCoord(p.x, p.y);
			var obj:Object = mas[p.y][p.x];
			if (obj.coff != 0 && obj.unit==undefined) ramka.visible = true;
		}
		
		private function scanRoofs(e:Event):void { 
			var obg:DisplayObject;
			var p:Point = unit_cont.localToGlobal(new Point(hero.x+10, hero.y));
			for (var i:int; i < roofs.numChildren; i++ ) {
				obg = roofs.getChildAt(i);
				if (obg.hitTestPoint(p.x, p.y, true)) obg.visible = false;  
				else obg.visible = true;  
			} 
		}
//-----
	}
}
  