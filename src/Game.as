﻿package {
	import command.MoveCommand;
	import events.MenuEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import units.*;  
	import command.*;
	
	import com.greensock.*; 
	import com.greensock.easing.*;


	public class Game extends Sprite implements IReceiver { 
		private static var distance:int = 400;   
		private var map1:Array = [  [1,2,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,5], 
									[2,0,1,0,0,2,4,2,0,1,3,3,3,0,1,0,0,0,0,5],
									[0,3,3,3,0,2,4,2,0,1,3,0,0,0,1,0,0,0,0,5],
									[0,3,3,3,3,0,1,2,0,1,2,2,0,0,1,0,0,0,0,5],
									[3,0,1,3,1,2,2,2,0,1,0,0,0,0,1,0,5,5,5,5], 
									[3,3,0,3,0,5,3,1,0,1,0,0,3,0,1,0,5,0,0,1],
									[1,0,2,0,0,0,0,5,0,1,0,0,0,3,1,0,5,0,0,1], 
									[1,0,0,0,0,0,0,0,0,2,4,4,0,0,0,0,0,0,0,1], 
									[5,0,0,3,0,0,0,2,0,4,4,4,0,0,0,0,0,0,0,1],
									[5,5,5,0,3,0,2,2,4,4,0,0,0,0,0,0,0,0,0,1],
									[5,5,5,3,0,0,3,0,4,0,0,3,3,3,0,0,0,0,5,1],
									[1,0,0,0,3,3,3,4,4,0,0,0,2,1,0,0,0,0,0,1],
									[1,0,3,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1],
									[1,0,0,0,1,0,0,0,0,0,0,0,0,1,5,0,0,0,4,4],
									[1,0,3,2,0,0,5,0,0,0,3,0,0,0,0,1,0,4,4,4],
									[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4]]; 
			
		
		private var ramka:Ramka;    
		public var unit_cont:Sprite = new Sprite;
		private var sqCont:Sprite = new Sprite; 
		public var masGoodUnit:Vector.<Unit> = new Vector.<Unit>;
		public var masBadUnit:Vector.<Unit> = new Vector.<Unit>;
		private var enemyTutnMas:Vector.<Unit> = new Vector.<Unit>;
		 
		private var masWater:Vector.<Point> = new Vector.<Point>;
		private var masPath:Vector.<Point> = new Vector.<Point>;  
		private var sqUnderPoint:Point = new Point();   
		private var masPoint:Vector.<Point> = new Vector.<Point>; 
		private var lines:DrawPath;    
		private var menu:Menu;
		private var map:Map;
		private var mas:Vector.<Object>;
		private var grid_size:int;
		private var dispatcher:Dispatcher;
		private var curhero:Point; 
		private var attack_mode:Boolean;
		private var enemyMas:Vector.<Point> = new Vector.<Point>;
		private var tar:Tar;  
		private var turn:Boolean;  
		public var ui:UI;   
		private var enemyPoint:Point;
		private var cutTurnEnemy:int;  
		private var skipper:Boolean; 
		
		public function Game() {
			ui = new UI(this);
			map = new Map(map1, this);
			addChild(map);
			mas = map._mas; 
			grid_size = Map.grid_size;
				
			ramka = new Ramka; 
			addChild(ramka);
			ramka.mouseEnabled = false;   
			ramka.mouseChildren = false; 
			ramka.width = ramka.height = grid_size;  
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap, true);
			  
			var goodFactory:CreatorUnits = new HeroCreator;
			var badFactory:CreatorUnits = new EnemyCreator;
			 
			addChild(unit_cont);
			unit_cont.addChild(sqCont);  
			lines = new DrawPath;  
			unit_cont.addChild(lines);
			
			goodFactory.creating(HeroCreator.GNOM, mas[3][3], 3, 3, unit_cont, masGoodUnit);
			goodFactory.creating(HeroCreator.GNOM, mas[2][2], 2, 2, unit_cont, masGoodUnit);
			goodFactory.creating(HeroCreator.ARCHER, mas[3][5], 3, 5, unit_cont, masGoodUnit);
			goodFactory.creating(HeroCreator.MAGE, mas[2][5], 2, 5, unit_cont, masGoodUnit);
			badFactory.creating(EnemyCreator.TROLL, mas[1][4], 1, 4, unit_cont, masBadUnit);
			badFactory.creating(EnemyCreator.SKELARCHER, mas[3][13], 3, 13, unit_cont, masBadUnit);
			badFactory.creating(EnemyCreator.DEATH, mas[7][9], 7, 9, unit_cont, masBadUnit);   
			badFactory.creating(EnemyCreator.SKELARCHER, mas[7][10], 7, 10, unit_cont, masBadUnit);
			// badFactory.creating(EnemyCreator.TROLL, mas[3][11], 3, 11, unit_cont, masBadUnit);
			 
			menu = new Menu(mas); 
			unit_cont.addChild(menu);   
			dispatcher = new Dispatcher(menu, this);
			dispatcher.setCommand(MenuEvent.MOVING, MoveCommand, this);   
			dispatcher.setCommand(MenuEvent.ATTACK, AttackCommand, this); 
			dispatcher.setCommand(MenuEvent.FINISH, FinishCommand, this);
			dispatcher.setCommand(MenuEvent.BACK, BackCommand, this);   
			
			unit_cont.x = -map.corX;  
			unit_cont.y = -map.corY;
			ui.addEventListener("END_TURN", livesTurn); 
			addChild(ui);
			var tween:TurnTweener = new TurnTweener("YOU TURN");
			addChild(tween);
			turn = true; 
		}  
		 
		private function clickedOnMap(e:MouseEvent):void { 
			if (!turn || menu.hitTestPoint(mouseX, mouseY, true)) return;
			if (menu.cons && !menu.hitTestPoint(mouseX, mouseY, true) && menu.first) {
				menu.killer(); 
				return;  
			} 
			var numX:int = (mouseX + map.corX)/ grid_size;
		 	var numY:int = (mouseY + map.corY) / grid_size;
			
			var hero:Unit; 
			var obj:Object; 
			  
			if (sqCont.hitTestPoint(mouseX, mouseY, true)) { 
				if(!attack_mode){
					if (masPoint.length != 0) {
						obj = mas[curhero.y][curhero.x]; 
						hero = obj.unit; 
						hero.prev = curhero;  
						obj.unit = undefined;    
						curhero = new Point(numX, numY);  
						mas[numY][numX].unit = hero;   
						hero.move();
						var walker:Walke = new Walke(hero, masPoint, 5); 
						walker.addEventListener("LAST_POINT", comes); 
					}  
				}
				else pressAttack(numX, numY); 
				clearSq();   
				return;
			} 
			clearSq();
			
			if (mas[numY][numX].unit != undefined) { 
				hero = mas[numY][numX].unit; 
				if (hero.enemy || !hero.turn) return;  
				curhero = new Point(numX, numY); 
				menu.init(numX, numY, true); 
				//unit_cont.setChildIndex(menu, unit_cont.numChildren-1);  
				ramka.visible = false;     
			}
		}
		 
		private function pressAttack(x:int, y:int):void {
			var s:String;
			var hero:Unit;
			var enemy:Unit;
			var cof:Number = 0;
			var damage:int;
			
			for (var i:int; i < enemyMas.length; i++ ) { 
				if (enemyMas[i].x == x && enemyMas[i].y == y) {
					hero = mas[curhero.y][curhero.x].unit;
					enemy = mas[enemyMas[i].y][enemyMas[i].x].unit;
					if (curhero.y == enemyMas[i].y) { 
						if (curhero.x > enemyMas[i].x) s = "l";
						else s = "r";
					}  
					else if (curhero.y > enemyMas[i].y) {   
						 s = "t"; 
					}
					else s = "d";
					hero.attack(s); 
					// 
					if (Math.random() * 100 < enemy.agi) {
						enemy.getDamage(0, false, true);
					}
					else {  
						cof = 1 - mas[enemyMas[i].y][enemyMas[i].x].coff * .1;
						damage = (hero.att - enemy.def) * cof;
						if (Math.random() * 100 < hero.agi) {
							damage *= 2; 
							hero.getDamage(0, true);   
						} 
						if (damage <= 0) damage = 1; 
						enemy.getDamage(damage);       
					}
					//
					enemy.addEventListener("DEAD", killUnit);
					endTurn(hero); 
					break; 
				} 
			} 
			attack_mode = false; 
		} 
		
		private function endTurn(obg:Unit):void {
			obg.turn = false;  
			TweenMax.to(obg, 1.4, { colorMatrixFilter: { hue:60 }} );
			for each (var unit:Unit in masGoodUnit) {
				if (unit.turn) return;   
			}
			EnemyTurn();  
		} 
		 
		private function endTurnEnemy(obg:Unit):void {
			obg.turn = false;   
			TweenMax.to(obg, 1.4, { colorMatrixFilter: { hue:60 }} );
			for each (var unit:Unit in masBadUnit) {
				if (unit.turn) return;    
			}
			skipper = false;
			turn = true;  
			YouTurn();   
		}
		
		private function YouTurn():void {
			trace("you turn"); 
		}
		 
		private function livesTurn(e:Event):void {   
			for each (var unit:Unit in masGoodUnit) {
				endTurn(unit);  
			}
		}  
		 
		private function EnemyTurn():void {
			if (!turn) return;
			var tween:TurnTweener = new TurnTweener("ENEMY TURN");
			addChild(tween); 
			turn = false;
			cutTurnEnemy = 0; 
			removeEventListener(MouseEvent.MOUSE_MOVE, moveramk); 
			removeEventListener(MouseEvent.CLICK, clickedOnMap, true);
			
			var dx:Number;     
			var dy:Number;
			var rast:Number;
			for each (var badunit:Unit in masBadUnit) {
				for each (var goodunit:Unit in masGoodUnit) {
					dx = badunit.x - goodunit.x;
					dy = badunit.y - goodunit.y; 
					rast = Math.sqrt(dx * dx + dy * dy); 
					if (rast < distance) {
						RastLowerDistance(badunit); 
					}
				}
			} 
			addAgroUnits();
			ramka.visible = false;  
		}    
		
		private function addAgroUnits():void {
			var p:Point;
			var dirX:int;  
			var dirY:int;
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
			var unit:Unit;
			for (var j:int=0; j < enemyTutnMas.length; j++) {
				p = gerCoord(enemyTutnMas[j].x, enemyTutnMas[j].y);  
				for (var i:int=0; i < direction.length; i++) {    
					dirX = p.x + direction[i][0];
					dirY = p.y + direction[i][1]; 
					if (getIndex(dirX, dirY)) {   
						unit = mas[dirY][dirX].unit;
						if (unit != null) {
							if (unit.enemy) RastLowerDistance(unit);
						}
					}
				}
			} 
			AI_start(); 
		}
		 
		private function AI_start():void {
			/*
			var cof:int;
			for each (var unit:Unit in enemyTutnMas) { 
				cof = unit.speed;
				cof++; 
				if (unit.type != "soldier") cof++;  
			}
			*/ 
			nextStep();
		}
		
		private function RastLowerDistance(tar:Unit):void {
			for each (var unit:Unit in enemyTutnMas) { 
				if (tar == unit) return; 
			}
			enemyTutnMas.push(tar); 
		}
		 
		private function moveRamka2(e:Event):void {
			if (enemyTutnMas[cutTurnEnemy].visible) { 
				removeEventListener(Event.ENTER_FRAME, moveRamka2)
				var timer:Timer = new Timer(1500, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, ShowRamka);
				timer.start();
			} 
		} 
		 
		private function ShowRamka(e:TimerEvent):void {
			e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, ShowRamka);
			e.target.stop(); 
			map.border = 10;  
			ramka.visible = true;  
			var p:Point = unit_cont.localToGlobal(new Point(enemyPoint.x, enemyPoint.y));
			ramka.x = p.x + 8; 
			ramka.y = p.y + 8;
			var ai:AI = new AI(EnemyUnit(enemyTutnMas[cutTurnEnemy]), gerCoord(enemyPoint.x, enemyPoint.y), mas, sqCont);  
			/* 
			p = gerCoord(enemyPoint.x, enemyPoint.y);  
			var unit:EnemyUnit = mas[p.y][p.x].unit;
			unit.skip();   
			unit.addEventListener("FINISH", nextEnemy); 
			*/
		}
		 
		private function nextEnemy(e:Event):void {
			endTurnEnemy(Unit(e.target));
			if (turn) return; 
			cutTurnEnemy++; 
			nextStep();
		} 
		
		private function nextStep():void {
			if(cutTurnEnemy < enemyTutnMas.length) {   
				enemyPoint = new Point(enemyTutnMas[cutTurnEnemy].x, enemyTutnMas[cutTurnEnemy].y);
				map.tracking = enemyTutnMas[cutTurnEnemy];     
				map.border = 200;    
				addEventListener(Event.ENTER_FRAME, moveRamka2);
				ramka.visible = false;   
			} 
			else if (!skipper && enemyTutnMas.length<masBadUnit.length) {
				var bol:Boolean; 
				skipper = true; 
				var mas:Vector.<Unit> = new Vector.<Unit>; 
				for each(var unit:Unit in masBadUnit) {
					bol = false;
					for each(var unit2:Unit in enemyTutnMas) {
						if (unit == unit2) bol = true; 
					} 
					if (!bol) mas.push(unit); 
				}
				enemyTutnMas = mas;
				cutTurnEnemy = 0; 
				nextStep(); 
			} 
		} 
		/* 
		private function moveRamka(e:Event):void {
			var p:Point = unit_cont.localToGlobal(new Point(enemyPoint.x+8, enemyPoint.y+8));
			var dx:Number = p.x - ramka.x;     
			var dy:Number = p.y - ramka.y; 
			
			var angle:Number = Math.atan2(dy, dx); 
			 ramka.x += 8 * Math.cos(angle);
			ramka.y += 8 * Math.sin(angle); 
		}
		 
		private function corrRamka(e:Event):void { 
			var p:Point = unit_cont.localToGlobal(new Point(enemyPoint.x, enemyPoint.y));
			ramka.x = p.x+8;
			ramka.y = p.y+8;
		}
		
		private function reborder(e:TimerEvent):void {
			ramka.removeEventListener(Event.ENTER_FRAME, corrRamka); 
			e.target.stop();
			e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, reborder);
			map.border = 80;
			//ramka.visible = true;  
		}
		*/
		private function killUnit(e:MenuEvent):void {
			var unit:Unit = e.tar;
			var s:String;
			unit_cont.removeChild(unit);
			for (s in masBadUnit) {  
				if (masBadUnit[s] == unit) masBadUnit.splice(int(s), 1);
			}
			var p:Point = gerCoord(unit.x, unit.y);  
			mas[p.y][p.x].unit = undefined; 
			unit.removeEventListener(MouseEvent.MOUSE_OUT, out_enemy);
			unit.removeEventListener(MouseEvent.MOUSE_OVER, over_enemy);
		}  
		
		private function comes(e:Event):void {  
			e.target.removeEventListener("LAST_POINT", comes);
			var obg:Unit = mas[curhero.y][curhero.x].unit;
			obg.stay();
			curhero = new Point(curhero.x, curhero.y);  
			menu.init(curhero.x, curhero.y, false);
			ramka.visible = false; 
		}
		
		public function finishMovement(tar:Unit):void {  
			tar.prev = null;  
			endTurn(tar); 
		} 
		
		public function backMovement(tar:Unit):void {
			var p:Point = tar.prev;
			if(p.x == curhero.x && p.y == curhero.y) return; 
			tar.x = p.x * grid_size - 8; 
			tar.y = p.y * grid_size-8;
			mas[p.y][p.x].unit = tar;
			mas[curhero.y][curhero.x].unit = undefined;  
			tar.prev = null;  
		}
		
		private function clearSq():void {  
			while (sqCont.numChildren>0) {
				sqCont.removeChildAt(0); 
			}
			masWater.splice(0, masWater.length);
			clearWater();
			lines.clear();
			
			var unit:Unit;  
			for each (var p:Point in enemyMas) {
				unit = mas[p.y][p.x].unit;
				if(unit!=null) {  
					unit.removeEventListener(MouseEvent.MOUSE_OUT, out_enemy);
					unit.removeEventListener(MouseEvent.MOUSE_OVER, over_enemy);
				}
			}
			if (tar!=null) { 
				unit_cont.removeChild(tar); 
				tar.removeEventListener(Event.ENTER_FRAME, rotateTar); 
				tar = null; 
			} 
			enemyMas.splice(0, enemyMas.length);
			sqUnderPoint = new Point();
		}  
		   
		private function clearWater():void {
			for each (var s:Vector.<Object> in mas) {
				for each (var k:Object in s) {
					k.water = 0;
					k.sq = false;   
				}  
			}  
		} 
	 
		public function getPath(spd:int):void { 
			mas[curhero.y][curhero.x].water = -1; 
			masWater.push(curhero);
			getSquare(masWater[0].y, masWater[0].x);
			var bol:Boolean = true;  
			while(bol) {  
				bol = scanPath(spd);
			} 
		}      
		 
		private function getSquare(y:int, x:int, color:uint=0xff0000):void {
			var fig:DisplayObject = new Drawler(color);
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
		
		public static function getIndex(x:int, y:int):Boolean { 
			if (x >= Map.worldCols || x < 0 || y >= Map.worldRows || y < 0) return false; 
			return true;
		}
 
		private function moveramk(e:MouseEvent):void {
			if (menu.cons) return; 
				else ramka.visible = true; 
			var numX:int = (mouseX + map.corX % grid_size) / grid_size;
			var numY:int = (mouseY + map.corY % grid_size) / grid_size;
			ramka.x = numX * grid_size - map.corX % grid_size;     
			ramka.y = numY * grid_size - map.corY % grid_size;  
			
			if (sqCont.hitTestPoint(mouseX, mouseY, true) && !attack_mode) {
				var tarX:int = (mouseX + map.corX) / grid_size; 
				var tarY:int = (mouseY + map.corY) / grid_size;
				if (mas[tarY][tarX].unit != undefined) {
					masPoint.splice(0, masPoint.length);  
					return;  
				}
				if ((sqUnderPoint.x != tarX) || (sqUnderPoint.y != tarY)) {
					sqUnderPoint = new Point(tarX, tarY);
					masPoint.splice(0, masPoint.length); 
					var p:Point = getGoodPath(sqUnderPoint); 
					masPoint.push(p); 
					while (mas[p.y][p.x].unit == undefined) {
						p = getGoodPath(p);  
						masPoint.push(p);    
					} 
					masPoint.splice(0, 0, new Point(tarX, tarY));
					lines.masPath = masPoint;
					lines.scanAndDraw();  
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
		 
		public static function gerCoord(x:Number, y:Number):Point {
			var p:Point = new Point();
			p.x = Math.floor((x+(Map.grid_size>>1)) / Map.grid_size);   
			p.y = Math.floor((y+(Map.grid_size>>1)) / Map.grid_size);  
			return p;
		}
		
		public function attack(tar:Unit):void {
			var dirX:int;
			var dirY:int;  
			var direction:Array = tar.direction;
			var unit:Unit;

			var target:Point = gerCoord(tar.x, tar.y);  
			
			for (var i:int = 0; i < direction.length; i++) {  
				dirX = target.x + direction[i][0];    
				dirY = target.y + direction[i][1]; 
				if (getIndex(dirX, dirY)) { 
					if (mas[dirY][dirX].unit != undefined) {
						unit = mas[dirY][dirX].unit;
						if (unit.enemy) {
							unit.addEventListener(MouseEvent.MOUSE_OVER, over_enemy);
							enemyMas.push(new Point(dirX, dirY)); 
							getSquare(dirY, dirX, 0x0000ff);   
						}
					}
					else getSquare(dirY, dirX, 0x00ffff); 
				}
			}
			attack_mode = true; 
		}
		
		public function over_enemy(e:MouseEvent):void {
			e.target.removeEventListener(MouseEvent.MOUSE_OVER, over_enemy);
			tar = new Tar;
			tar.x = e.target.x + 40;
			tar.y = e.target.y + 40;  
			unit_cont.addChild(tar);
			tar.mouseEnabled = false;
			tar.addEventListener(Event.ENTER_FRAME, rotateTar);
			e.target.addEventListener(MouseEvent.MOUSE_OUT, out_enemy);
		}
		  
		public function rotateTar(e:Event):void {
			tar.rotation-=4;
		}
		
		public function out_enemy(e:MouseEvent):void {
			e.target.removeEventListener(MouseEvent.MOUSE_OUT, out_enemy);
			unit_cont.removeChild(tar);
			tar.removeEventListener(Event.ENTER_FRAME, rotateTar);
			tar = null;   
			e.target.addEventListener(MouseEvent.MOUSE_OVER, over_enemy);
		}
		
		public function get _ramka():Ramka { return ramka; }
		public function get _turn():Boolean { return turn; }
//-----
	}
}
