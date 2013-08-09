package  {
	import boxes.Box;
	import boxes.Container1;
	import boxes.Container2;
	import com.greensock.TweenLite;
	import events.NpcEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import npc.Archer;
	import npc.Barbar;
	import npc.Captain;
	import npc.Cook;
	import npc.ExitGuard;
	import npc.Farmer;
	import npc.Fisher;
	import npc.Girl;
	import npc.Guard;
	import npc.Liza;
	import npc.Mage;
	import npc.Monk;
	import npc.NPC;
	import npc.Professor;
	import npc.Smith;
	import npc.WalkerGuard;
	import units.Animation;
	import units.HeroCreator;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Town extends Sprite implements IShled { 
		
		private var map:Map;
		private var ramka:Sapog; 
		private var scrolling:Boolean = true;
		public var unit_cont:Sprite = new Sprite;
		private var npc_cont:Sprite = new Sprite;
		private var boxCont:Sprite = new Sprite;
		private var roofs:Sprite = new Sprite;
		private var roofsMas:Vector.<DisplayObject> = new Vector.<DisplayObject>;
		private var boxMas:Vector.<DisplayObject> = new Vector.<DisplayObject>; 
		private var npcMas:Vector.<Hero> = new Vector.<Hero>; 
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
		private var curpoint:Point = new Point();
		private var walker:Walke;
		private var replic:Dialog;
		private var ui:Sprite; 
		private var replic_tar:NPC;
		private var walker_box:Box;
		private var replicTimer:Timer;
		private var face:Face; 
		private var sqCont:Sprite = new Sprite;
		private var dely:Boolean; 
		private var autoScroll:Boolean;
		private var party:PartyGr;
		private var typeMap:String;
		
		public function Town(ar:Array, cofMas:Array, tiles:Bitmap, tip:String=null) {
			grid_size = border = Map.grid_size;   
			typeMap = tip; 
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
			unit_cont.addChild(boxCont);
			drawBox(); 
			//	
			hero = new Hero; 
			if (typeMap == null) {
				viewXOffset = grid_size * 16;
				viewYOffset = grid_size * 3;
				hero.x = 25 * grid_size - 8; 
				hero.y = 5 * grid_size-8;
				mas[5][25].unit = hero; 
			}   
			else if (typeMap == "dead") {
				viewXOffset = grid_size * 8;  
				viewYOffset = grid_size * 12;
				hero.x = hero.y =  14 * grid_size - 8; 
				mas[14][14].unit = hero; 
			}
			else {
				viewXOffset = 0;  
				viewYOffset = grid_size * 16;
				hero.x = 5 * grid_size - 8; 
				hero.y = 19 * grid_size - 8; 
				mas[19][5].unit = hero; 
			}
			unit_cont.addChild(hero);   
			//
			buildNPC();  
			ramka = new Sapog; 
			addChild(ramka); 
			ramka.mouseEnabled = false;    
			ramka.mouseChildren = false; 
			  
			addChild(unit_cont);
			ui = new Sprite;
			addChild(ui);
			createRoof();
			
			var quest_btn:Quest_btn = new Quest_btn;
			ui.addChild(quest_btn);
			quest_btn.buttonMode = true; 
			quest_btn.y = quest_btn.height; 
			quest_btn.x = Constants.STAGE_WIDTH - quest_btn.width; 
			quest_btn.addEventListener(MouseEvent.CLICK, open_quests);
			  
			face = new Face; 
			ui.addChild(face);  
			var bmp:Bitmap = hero.getHeroIcon();
			bmp.scaleX = bmp.scaleY = 0.7; 
			face.addChild(bmp);
			bmp.x = bmp.y = 10;
			
			party = new PartyGr;
			party.x = face.width+10;
			addChild(party);   
			party.nam.text = String(Main.numParty);
			
			addEventListener(Event.ENTER_FRAME, scanRoofs);
			unit_cont.x = -viewXOffset;    
			unit_cont.y = -viewYOffset;
			scrolling = false;
			if (typeMap == null) start_quest(); 
			else { 
				scrolling = true;   
				addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
				addEventListener(MouseEvent.CLICK, clickedOnMap);  
				face.addEventListener(MouseEvent.CLICK, face_clicked);
				for each(var b:Box in boxMas) {
					b.addEventListener(MouseEvent.CLICK, box_clicked); 	
				}
			}
		} 
		 
		private function open_quests(e:MouseEvent):void { 
			if (Main.questLine == 0) return; 
			var qWindow:Quest_window = new Quest_window;
			var qmas:Array = Quests.getQuestLog(Main.questLine); 
			qWindow.nam.text = qmas[0];
			qWindow.short.text = qmas[1];
			qWindow.long.text = qmas[2];  
			ui.addChild(qWindow); 
			qWindow.x = Constants.STAGE_WIDTH - 10;
			qWindow.y = (Constants.STAGE_HEIGHT >> 1) - (qWindow.height>>1);
			qWindow.clos.addEventListener(MouseEvent.CLICK, close_quest);
		} 
		
		private function close_quest(e:MouseEvent):void {
			e.currentTarget.addEventListener(MouseEvent.CLICK, close_quest);
			ui.removeChild(e.currentTarget.parent);    
		}
		
		private function start_quest():void {
			var girl:NPC = new Girl; 
			girl.x = 20 * grid_size - 8;
			girl.y = 11 * grid_size - 8; 
			npc_cont.addChild(girl);
			npcMas.push(girl);
			girl.walk = false;
			girl.prev = new Point(20, 11); 
			mas[11][20].unit = girl;
			Girl(girl).run();
			var maspath:Vector.<Point> = Vector.<Point>([new Point(24, 5), new Point(24, 6), new Point(24, 7),
														 new Point(24, 8), new Point(24, 9), new Point(20, 9), null]); 
			var walker:Walke = new Walke(girl, maspath, 5, refresh);  
			walker.addEventListener("LAST_POINT", girlTalk);
		} 
		   
		private function girlTalk(e:Event):void {
			var tar:NPC = Walke(e.target)._unit; 
			var dialog:Dialog = new Dialog(tar, hero.getHeroIcon());   
			ui.addChild(dialog); 
			dialog.y = Constants.STAGE_HEIGHT;  
			dialog.x = 6;   
			tar.talking(hero);
			tar.walker = null;
			tar.moving = false; 
			dialog.addEventListener("DIALOG_OFF", hero_focus);
		}
		
		private function hero_focus(e:Event):void {
			var tar:NPC = Dialog(e.target).target;
			scrolling = true; 
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap);  
			face.addEventListener(MouseEvent.CLICK, face_clicked);
			for each(var b:Box in boxMas) {
				b.addEventListener(MouseEvent.CLICK, box_clicked); 	
			}
			Main.questLine++; 
			var newquest:GetNewQuest = new GetNewQuest; 
			addChild(newquest); 
			var rmas:Array = Quests.getQuestLog(Main.questLine); 
			newquest.nam.text = rmas[0]; 
			newquest.x = Constants.STAGE_WIDTH >> 1;
			newquest.y = Constants.STAGE_HEIGHT >> 1;
			newquest.alpha = 0;
			TweenLite.to(newquest, 0.6, {alpha:1, onComplete:onFinishTweenNewQuest, onCompleteParams:[newquest]});
			Girl(tar).run();    
			var maspath:Vector.<Point> = Vector.<Point>([new Point(24, 10), new Point(24, 9), new Point(24, 8), new Point(24, 7), new Point(24, 6), null]); 
			var walker:Walke = new Walke(tar, maspath, 5, refresh);  
			walker.addEventListener("LAST_POINT", girlWalk);  
		}
		   
		private function onFinishTweenNewQuest(tar:*):void { 
			TweenLite.to(tar, 1, {delay:3, alpha:0, onComplete:function():void{removeChild(tar)}});
		}
		
		private function girlWalk(e:Event):void { 
			var tar:NPC = Walke(e.target)._unit;
			tar.walk = true;
			tar._busy = false;  
			tar.setState(Hero.STAY); 
			tar.walker = null;
			tar.moving = false; 
			tar._fask.addEventListener(MouseEvent.CLICK, show_dialog);
			tar.addEventListener(NpcEvent.MOVING, moveNpc);  
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
			var boxCoors:Array = [[9,7],[28,22],[27,6],[17,24],[11,14]]; 
			var box:Box;
			var numX:int;
			var numY:int; 
			for (var i:int; i < boxCoors.length;i++) {
				var j:int = Math.floor(Math.random()*Main.boxTypes.length); 
				box = new Main.boxTypes[j];
				numX = boxCoors[i][0];
				numY = boxCoors[i][1];
				box.x = numX * grid_size;
				box.y = numY * grid_size; 
				boxCont.addChild(box); 
				mas[numY][numX].coff = 0;
				boxMas.push(box);
				box.addEventListener(MouseEvent.CLICK, box_clicked); 	
			}
		}
		
		private function createRoof():void {
			var roof1:Roof_cook = new Roof_cook;
			roof1.x = 10 * grid_size;
			roof1.y = 2 * grid_size;
			roofs.addChild(roof1);
			roofsMas.push(roof1);
			var roof2:Roof_alhim = new Roof_alhim;
			roof2.x = 2 * grid_size;
			roof2.y = 10 * grid_size; 
			roofs.addChild(roof2);
			roofsMas.push(roof2);
			var roof3:Roof_home = new Roof_home;
			roof3.x = 22 * grid_size; 
			roof3.y = 3 * grid_size; 
			roofs.addChild(roof3);
			roofsMas.push(roof3);
			var roof4:Roof_cherch = new Roof_cherch;
			roof4.x = 12 * grid_size; 
			roof4.y = 11 * grid_size; 
			roofs.addChild(roof4);
			roofsMas.push(roof4);
			var roof5:Roof_prison = new Roof_prison;
			roof5.x = 22 * grid_size; 
			roof5.y = 18 * grid_size;  
			roofs.addChild(roof5);
			roofsMas.push(roof5); 
			unit_cont.addChild(roofs); 
		}
		
		private function buildNPC():void {
			var liza:NPC = new Liza; 
			liza.x = 2 * grid_size - 8;
			liza.y = 15 * grid_size - 8; 
			npc_cont.addChild(liza);
			npcMas.push(liza); 
			mas[15][2].unit = liza;    
			
			var guard1:NPC = new Guard; 
			guard1.x = 26 * grid_size - 8;
			guard1.y = 24 * grid_size - 8;  
			npc_cont.addChild(guard1);
			npcMas.push(guard1);
			mas[24][26].unit = guard1; 
			
			var guard2:NPC = new ExitGuard; 
			guard2.y = 2 * grid_size-8;
			var per:int;
			if (typeMap == null) per = 3;
			else per = 2;    
			guard2.x = per * grid_size-8; 
			mas[2][per].unit = guard2;  
			npc_cont.addChild(guard2);
			npcMas.push(guard2);
			 
			var guard3:NPC = new WalkerGuard; 
			guard3.x = 12 * grid_size - 8;
			guard3.y = 8 * grid_size - 8; 
			npc_cont.addChild(guard3);
			npcMas.push(guard3);
			mas[8][12].unit = guard3; 
			
			var fisher:NPC = new Fisher; 
			fisher.x = 12 * grid_size - 8; 
			fisher.y = 22 * grid_size - 8;  
			npc_cont.addChild(fisher);
			npcMas.push(fisher);
			mas[22][12].unit = fisher;
			
			var captain:NPC = new Captain; 
			captain.x = 4 * grid_size - 8; 
			captain.y = 19 * grid_size - 8;  
			npc_cont.addChild(captain);
			npcMas.push(captain);
			captain._busy = true;   
			mas[19][4].unit = captain; 
			
			var cook:NPC = new Cook; 
			cook.x = 12 * grid_size - 8; 
			cook.y = 4 * grid_size - 8;  
			npc_cont.addChild(cook);
			npcMas.push(cook);
			mas[4][12].unit = cook; 
			
			var professor:NPC = new Professor; 
			professor.x = 4 * grid_size - 8;  
			professor.y = 12 * grid_size - 8;  
			npc_cont.addChild(professor);
			npcMas.push(professor);
			mas[12][4].unit = professor;
			
			var monk:NPC = new Monk; 
			monk.x = 13 * grid_size - 8;  
			monk.y = 13 * grid_size - 8;   
			npc_cont.addChild(monk);
			npcMas.push(monk); 
			mas[13][13].unit = monk;  
			if (typeMap == null) {
				if(Main.selectHero != HeroCreator.HERO_ARCHER) {
					var archer:NPC = new Archer; 
					archer.x = 15 * grid_size - 8;  
					archer.y = 4 * grid_size - 8;    
					npc_cont.addChild(archer);
					npcMas.push(archer); 
					mas[4][15].unit = archer; 
					archer.addEventListener(NpcEvent.MOVING, moveNpc);
					archer._fask.addEventListener(MouseEvent.CLICK, show_dialog); 
				}
				if(Main.selectHero != HeroCreator.HERO_MAGE) {
					var mage:NPC = new Mage; 
					mage.x = 5 * grid_size - 8;   
					mage.y = 13 * grid_size - 8;   
					npc_cont.addChild(mage);
					npcMas.push(mage); 
					mas[13][5].unit = mage;
					mage.addEventListener(NpcEvent.MOVING, moveNpc);
					mage._fask.addEventListener(MouseEvent.CLICK, show_dialog);
				}
				if(Main.selectHero != HeroCreator.HERO_WARR) {  
					var barbar:NPC = new Barbar;  
					barbar.x = 24 * grid_size - 8;   
					barbar.y = 20 * grid_size - 8;   
					npc_cont.addChild(barbar);
					npcMas.push(barbar);  
					barbar.moving = true;
					mas[20][24].unit = barbar;
					barbar._fask.addEventListener(MouseEvent.CLICK, show_dialog);
				}
			}
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
			if (replic != null) {
				if (obg == replic.target) return;
				replic.onFinishTween();
			}
			if ( (Math.abs(hero.x - obg.x) + Math.abs(hero.y - obg.y)) == grid_size ) {
				replic = new Dialog(obg, hero.getHeroIcon());   
				ui.addChild(replic);
				removeEventListener(MouseEvent.CLICK, clickedOnMap); 
				replic.y = Constants.STAGE_HEIGHT;  
				replic.x = 6;  
				if(!obg.moving) obg.talking(hero);
				replic.addEventListener("DIALOG_OFF", nuller);
			} 
			else if (obg.walker == null) { 
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
					if (getIndex(dX, dY) && mas[dY][dX].coff != 0 ) {
						if(mas[dY][dX].unit == undefined || mas[dY][dX].unit.isHero){	  
							dirX = dX - point.x;   
							dirY = dY - point.y;  
							rast = Math.sqrt(dirX * dirX + dirY * dirY); 
							if (rast < min) { 
								min = rast;  
								rez = i; 
							}
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
				setChildIndex(ramka, numChildren - 1);
				setChildIndex(ui, numChildren - 1);
				walker = new Walke(hero, masPoint, 4, refresh);
				walker.last = pointNpc;
				walker.addEventListener("LAST_POINT", comes);
				replic_tar = obg;   
			}
		} 
		
		private function box_clicked(e:MouseEvent=null):void {
			if (walker != null) { 
				var numX:int = (mouseX + viewXOffset) / grid_size; 
				var numY:int = (mouseY + viewYOffset) / grid_size;  
				if (numX == walker.last.x && numY == walker.last.y) return;   
			}
			var obg:Box
			if (e == null) obg = walker_box;  
			else obg = Box(e.currentTarget);
			walker_box = null;  
			if ( (Math.abs(hero.x+8 - obg.x) + Math.abs(hero.y+8 - obg.y)) == grid_size ) {
				obg.getGold();
				obg.removeEventListener(MouseEvent.CLICK, box_clicked);   
			} 
			else {  
				var min:Number = Number.MAX_VALUE;   
				var dirX:Number; 
				var dirY:Number; 
				var rast:Number;  
				var point:Point = gerCoord(hero.x, hero.y);
				var pointNpc:Point = gerCoord(obg.x, obg.y);
				var rez:int; 
				var direction:Array = [[0, 1], [0, -1], [ -1, 0], [1, 0]];  
				var dX:int; 
				var dY:int;
				for (var i:int = 0; i < direction.length; i++) {  
					dX = pointNpc.x + direction[i][0];
					dY = pointNpc.y + direction[i][1];  
					if (getIndex(dX, dY) && mas[dY][dX].coff != 0 ) {
						if(mas[dY][dX].unit == undefined || mas[dY][dX].unit.isHero){	  
							dirX = dX - point.x;   
							dirY = dY - point.y;  
							rast = Math.sqrt(dirX * dirX + dirY * dirY); 
							if (rast < min) { 
								min = rast;  
								rez = i; 
							}
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
				setChildIndex(ramka, numChildren - 1);
				setChildIndex(ui, numChildren - 1);
				walker = new Walke(hero, masPoint, 4, refresh);
				walker.last = pointNpc;
				walker_box = obg;
				walker.addEventListener("LAST_POINT", comes);
			}
		}
		
		private function nuller(e:Event):void {
			addEventListener(MouseEvent.CLICK, clickedOnMap); 
			var tar:NPC = Dialog(e.currentTarget).target;
			if (!tar.moving) { 
				tar._busy = false; 
				tar.setState(Hero.STAY); 
			}
			replic = null;
			if (!tar.dialog) return;  
			if (tar is Monk) { 
				Main.questLine++; 
				var newquest:GetNewQuest = new GetNewQuest; 
				addChild(newquest);
				var rmas:Array = Quests.getQuestLog(Main.questLine); 
				newquest.nam.text = rmas[0]; 
				newquest.x = Constants.STAGE_WIDTH >> 1;
				newquest.y = Constants.STAGE_HEIGHT >> 1;  
				newquest.alpha = 0;
				TweenLite.to(newquest, 0.6, {alpha:1, onComplete:onFinishTweenNewQuest, onCompleteParams:[newquest]});
			} 
			else if (tar is Archer || tar is Barbar || tar is Mage) {
				Main.numParty++;
				if(tar is Archer) Main.masParty.push(HeroCreator.ARCHER);
				else if (tar is Barbar) Main.masParty.push(HeroCreator.BARBAR);
				else Main.masParty.push(HeroCreator.MAGE);   
				party.nam.text = String(Main.numParty); 
				npc_cont.removeChild(tar);
				delNpcFromMas(tar);  
				var p:Point = gerCoord(tar.x, tar.y);
				mas[p.y][p.x].unit = undefined; 
				tar.removeEventListener(MouseEvent.CLICK, show_dialog);
				if(tar.hasEventListener(NpcEvent.MOVING)) tar.removeEventListener(NpcEvent.MOVING, moveNpc);
				tar = null; 
				if (Main.numParty > 2) {
					var complquest:CompletedQuest = new CompletedQuest; 
					addChild(complquest); 
					var cmas:Array = Quests.getQuestLog(Main.questLine); 
					complquest.nam.text = cmas[0];  
					complquest.x = Constants.STAGE_WIDTH >> 1;
					complquest.y = Constants.STAGE_HEIGHT >> 1;  
					complquest.alpha = 0; 
					TweenLite.to(complquest, 0.6, {alpha:1, onComplete:onFinishTweenNewQuest, onCompleteParams:[complquest]});
					Main.questLine++;
				} 
			}  
			else if (tar is ExitGuard) {   
				tar.prev = new Point(3, 2);
				tar.setState(Hero.MOVE);
				var maspath:Vector.<Point> = Vector.<Point>([new Point(2, 2), null]); 
				var walker:Walke = new Walke(tar, maspath, 2, refresh);   
				walker.addEventListener("LAST_POINT", guardMoves); 
				Main.questLine++;  
			} 
		} 
		   
		private function delNpcFromMas(obg:NPC):void {  
			for (var i:int; i < npcMas.length; i++ ) {
				if (obg == npcMas[i]) {
					npcMas.splice(i, 1);
					break;
				}
			}
		}
		
		private function guardMoves(e:Event):void {  
			var tar:NPC = Walke(e.target)._unit;
			tar._busy = false;  
			tar.setState(Hero.STAY); 
			tar.walker = null;
			tar.moving = false; 
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
			if ((scrolling && !ui.hitTestPoint(mouseX, mouseY)) || autoScroll) updMapPos();
			clearUnit(); 
		}  
		
		private function clearUnit():void {
			var xx:int;
			var yy:int;
			var width:int;
			var height:int; 
			width =  height = grid_size>>1;
			for each(var s:Hero in npcMas) {  
				xx = s.x + (s.width>>1);  
				yy = s.y + (s.height >> 1);
				
				if (xx < viewXOffset-width || xx > viewXOffset+Constants.STAGE_WIDTH+width ||
					yy < viewYOffset-height || yy > viewYOffset+Constants.STAGE_HEIGHT+height) { 
					if(npc_cont.contains(s)) npc_cont.removeChild(s); 
				}
				else if(!npc_cont.contains(s)) npc_cont.addChild(s);    
			}
			var obg:DisplayObject;
			for each (obg in roofsMas) {  
				width = obg.width >> 1; 
				height = obg.height >> 1;
				xx = obg.x + width;     
				yy = obg.y + height;
				if (xx < viewXOffset-width || xx > viewXOffset+Constants.STAGE_WIDTH+width ||
					yy < viewYOffset-height || yy > viewYOffset+Constants.STAGE_HEIGHT+height) { 
					if(roofs.contains(obg)) roofs.removeChild(obg); 
				} 
				else if(!roofs.contains(obg)) roofs.addChild(obg);  
			}
			for each (obg in boxMas) {   
				width = obg.width >> 1; 
				height = obg.height >> 1;
				xx = obg.x + width;     
				yy = obg.y + height;
				if (xx < viewXOffset-width || xx > viewXOffset+Constants.STAGE_WIDTH+width ||
					yy < viewYOffset-height || yy > viewYOffset+Constants.STAGE_HEIGHT+height) { 
					if(boxCont.contains(obg)) boxCont.removeChild(obg); 
				} 
				else if(!boxCont.contains(obg)) boxCont.addChild(obg);  
			} 
		}
			
		private function drawView():void {
			var tilex:int = int(viewXOffset/grid_size);
			var tiley:int = int(viewYOffset/grid_size);
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
			bufferRect.y=viewYOffset % grid_size;
			canvasBD.copyPixels(bufferBD, bufferRect, bufferPoint);
			unit_cont.x = -viewXOffset;
			unit_cont.y = -viewYOffset;
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
					walker_box = null;
					walker.kill(); 
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
				setChildIndex(ramka, numChildren - 1);
				setChildIndex(ui, numChildren-1); 
				walker = new Walke(hero, masPoint, 4, refresh);
				walker.last = curpoint;
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
			tar.moving = false; 
		}
		
		public function getSquare(y:int, x:int, color:uint=0xff0000):void {   
			//var fig:DisplayObject = new Drawler(color);
			var fig:Shape = new Shape; 
			fig.graphics.beginFill(color, .8);  
			fig.graphics.drawCircle(Map.grid_size>>1, Map.grid_size>>1, 4); 
			fig.graphics.endFill(); 
			sqCont.addChildAt(fig, 0); 
			fig.x = x * Map.grid_size;   
			fig.y = y * Map.grid_size;   
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
		
		private function kill():void {
			removeEventListener(Event.ENTER_FRAME, scanRoofs);
			removeEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			removeEventListener(MouseEvent.CLICK, clickedOnMap);
			gameTimer.removeEventListener(TimerEvent.TIMER, runGame);
			gameTimer.stop();
			face.removeEventListener(MouseEvent.CLICK, face_clicked);
			Main(this.parent).drawRoad(this);  
		}
		
		private function comes(e:Event):void {
			if (hero.y <= 64) {
				kill();
				return;
			}
			while (sqCont.numChildren>0) { 
				sqCont.removeChildAt(0); 
			}
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
			else if (walker_box != null) box_clicked(); 
		}
		
		private function clearSq():void {
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
		
		public function clearPath():void {
			while (sqCont.numChildren>0) {  
				sqCont.removeChildAt(0); 
			}
		}
		
		public function getPath():Boolean {
			while (sqCont.numChildren>0) { 
				sqCont.removeChildAt(0); 
			} 
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
  