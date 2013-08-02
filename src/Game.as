package {
	import command.MoveCommand;
	import events.MenuEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import spell.effect.Protect;
	import spell.effect.IEffect;
	import spell.ISpell;
	import spell.skill.Block;
	import spell.skill.Cutting;
	import spell.skill.ISkill;
	import spell.skill.Prot;
	import spell.Telepotr;
	import units.*;  
	import command.*;
	
	import com.greensock.*; 
	import com.greensock.easing.*;

	public class Game extends Sprite implements IReceiver { 
		public static const RAMKA_SIMPLE:uint     = 1;  
		public static const RAMKA_CROSS:uint      = 2;  
		public static const RAMKA_SQUARE:uint	  = 3;  
		
		public static var effects:UnitEffects; 
		public static var distance:int = 400;
		public var scrolling:Boolean = true;  
		
		private var lootMas:Array = [["boots1_gnom",0,2,0,0,0], ["chest1_gnom",0,5,2,0,0,"gnomset1"], ["helm1_gnom", 0,4,0,10,0,"gnomset1"], ["shield1_gnom", 0,6,0,0,0,"gnomset1"], ["shield2_gnom", 0,12,0,20,0], ["weapon1_gnom", 4,0,0,0,0],
									 ["weapon1_archer", 5,0,0,0,0,"archerset1"], ["chest1_archer", 0,1,0,0,0], ["helm2_archer", 0,1,0,0,0,"archerset1"], ["boots1_archer", 0,1,0,0,0,"archerset1"], ["helm1_archer", 0,1,0,0,0], 
									 ["helm1_mage",0,4,0,0,0,"mageset1"], ["book1_mage", 0,0,0,0,10,"mageset1"], ["book2_mage", 0,0,0,0,20], ["weapon1_mage", 12,0,0,0,0,"mageset1"], ["chest2_mage", 0,4,0,0,0,"mageset1"], ["chest1_mage", 0,4,0,0,0]];    
		public static var setsMas:Object = {"archerset1":["2AT","4AG"], "gnomset1":["2DF","20HP"], "mageset1":["10HP","20MP"]};    
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
		public var menu:Menu; 
		private var map:Map;
		private var mas:Vector.<Object>;
		private var grid_size:int;
		private var dispatcher:Dispatcher;
		private var curhero:Point; 
		private var attack_mode:Boolean;
		private var enemyMas:Vector.<Point> = new Vector.<Point>;
		private var tar:Tar;
		private var tarCast:TarCast;   
		private var turn:Boolean;  
		public var ui:UI;   
		private var enemyPoint:Point;
		private var cutTurnEnemy:int;  
		private var skipper:Boolean; 
		private var ai:AI;
		private var infoLand:InfoLand;
		private var charWindow:CharacterInfo; 
		public static var curcast:ISpell;  
		public static var goodFactory:CreatorUnits;
		public static var badFactory:CreatorUnits; 
		 
		public function Game():void {
			ui = new UI(this); 
		}
		
		public function setMap(mas:Array, cofMas:Array, tiles:Bitmap):void {
			//if(map==null) {   
				map = new Map(mas, cofMas, this, tiles);
				addChild(map); 
			//} 
		}
		
		public function init():void {
			mas = map._mas;  
			grid_size = Map.grid_size;
			ramka = new Ramka; 
			addChild(ramka);
			ramka.mouseEnabled = false;   
			ramka.mouseChildren = false; 
			ramka.width = ramka.height = grid_size;  
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap, true);
			   
			goodFactory = new HeroCreator;  
			badFactory = new EnemyCreator; 
			 
			addChild(unit_cont);
			unit_cont.addChild(sqCont);  
			lines = new DrawPath;   
			unit_cont.addChild(lines); 
			 
			effects = new UnitEffects;  
			goodFactory.init(unit_cont, masGoodUnit); 
			badFactory.init(unit_cont, masBadUnit);  
			
			goodFactory.creating(Main.selectHero, mas[7][5]); 
			 
			goodFactory.creating(HeroCreator.GNOM, mas[8][6]); 
			goodFactory.creating(HeroCreator.ARCHER, mas[9][7]);  
			goodFactory.creating(HeroCreator.MAGE, mas[7][8]); 
			goodFactory.creating(HeroCreator.PRIEST, mas[8][5]); 
			goodFactory.creating(HeroCreator.BARBAR, mas[7][9]); 
			  
			badFactory.creating(EnemyCreator.TROLL, mas[13][16]);
			badFactory.creating(EnemyCreator.DEATH, mas[12][17]);
			badFactory.creating(EnemyCreator.SKELARCHER, mas[13][15]);
			
			badFactory.creating(EnemyCreator.TROLL, mas[2][13]);
			badFactory.creating(EnemyCreator.DEATH, mas[3][14]);
			badFactory.creating(EnemyCreator.SKELARCHER, mas[1][12]);
			
			menu = new Menu(mas); 
			unit_cont.addChild(menu);   
			dispatcher = new Dispatcher(menu); 
			dispatcher.setCommand(MenuEvent.MOVING, MoveCommand, this);   
			dispatcher.setCommand(MenuEvent.ATTACK, AttackCommand, this); 
			dispatcher.setCommand(MenuEvent.FINISH, FinishCommand, this);
			dispatcher.setCommand(MenuEvent.BACK, BackCommand, this);   
			dispatcher.setCommand(MenuEvent.CHAR, CharCommand, this); 
			dispatcher.setCommand(MenuEvent.CAST, CastCommand, this); 
			 
			unit_cont.x = -map.corX;  
			unit_cont.y = -map.corY;
			ui.addEventListener("END_TURN", livesTurn); 
			addChild(ui);
			infoLand = new InfoLand;
			addChild(infoLand);  
			var tween:TurnTweener = new TurnTweener("YOU TURN");
			addChild(tween); 
			turn = true; 
		}
		
		private function clickedOnMap(e:MouseEvent):void {
			ramka.gotoAndStop(1);
			if (!turn || menu.hitTestPoint(mouseX, mouseY, true)) return;
			if (menu.cons && !menu.hitTestPoint(mouseX, mouseY, true) && menu.first) { 
				menu.killer();  
				return;      
			}
			sqCont.removeEventListener(MouseEvent.MOUSE_OUT, sqContOut);
			sqCont.removeEventListener(MouseEvent.MOUSE_OVER, sqContOver);
			var numX:int = (mouseX + map.corX) / grid_size;
		 	var numY:int = (mouseY + map.corY) / grid_size;
			var hero:Unit; 
			var obj:Object;  
			if (sqCont.hitTestPoint(mouseX, mouseY, true)) {  
				if (!attack_mode && curcast==null) {  
					if (masPoint.length != 0) {
						obj = mas[curhero.y][curhero.x];  
						hero = obj.unit; 
						hero.prev = curhero;  
						obj.unit = undefined;    
						curhero = new Point(numX, numY);  
						mas[numY][numX].unit = hero;   
						hero.move(); 
						var walker:Walke = new Walke(hero, masPoint, 5);
						map.tracking = hero;      
						map.border = 120; 
						walker.addEventListener("LAST_POINT", comes);  
					}  
				}  
				else if (attack_mode) pressAttack(numX, numY);
				else if (curcast != null) { 
					for each (var p:Point in enemyMas) {  
						var mob:Unit = mas[p.y][p.x].unit;  
						if(mob==null) mob = mas[p.y][p.x].grave; 
						mob.removeEventListener(MouseEvent.MOUSE_OUT, out_enemy);
						mob.removeEventListener(MouseEvent.MOUSE_OVER, over_enemy);
					}   
					var unt:Unit = mas[curhero.y][curhero.x].unit; 
					if (tarCast != null) { 
						if (ramka.contains(tarCast) || unit_cont.contains(tarCast)) {
							curcast.cast(numX, numY, mas, this); 
							if (mas[curhero.y][curhero.x].grave != undefined) {  
								Unit(mas[curhero.y][curhero.x].grave).kill();  
							}  
							if(unt!=null) lookProtect(unt);   
						} 
					}
					else backMovement(unt);   
					curcast = null;  
				} 
				clearSq();    
				return; 
			}    
			clearSq();   
			if (attack_mode || curcast!=null) backMovement(mas[curhero.y][curhero.x].unit);  
			attack_mode = false;
			curcast = null;
			if (mas[numY][numX].unit != undefined) { 
				hero = mas[numY][numX].unit; 
				if (!hero.enemy || hero.turn) {
					if (menu.cons) {
						menu.killer(); 
						if (!menu.first) backMovement(mas[curhero.y][curhero.x].unit);
						return;
					}  
					curhero = new Point(numX, numY);
				}
				menu.init(numX, numY, true); 
				//unit_cont.setChildIndex(menu, unit_cont.numChildren-1);  
				ramka.visible = false;     
			}
		}
		 
		private function pressAttack(x:int, y:int):void {
			var s:String;
			var hero:Unit = mas[curhero.y][curhero.x].unit;
			var enemy:Unit;
			var cof:Number = 1;
			var damage:int;
			var hit:Boolean;
			
			for (var i:int; i < enemyMas.length; i++ ) { 
				if (enemyMas[i].x == x && enemyMas[i].y == y) {
					hit = true; 
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
						cof = 1 - mas[enemyMas[i].y][enemyMas[i].x].def * .1;
						var n:Number = 1;  
						var m:int = Search.lookClass(hero.skills, Cutting);   
						if (m >= 0) n = hero.skills[m].correct();    
						damage = (hero.att - enemy.def*n) * cof; 
						if (Math.random() * 100 < hero.agi) {
							damage *= 2; 
							hero.getDamage(0, true);   
						}
						
						if (damage <= 0) damage = 1;
						enemy.getDamage(damage); 
						hero.exp = damage;
						calkSkills(hero, enemy, damage);  
					}    
					if(enemy.hp <= 0) killUnit(enemy); 
					endTurn(hero); 
					hero.prev = null;   
					break; 
				}  
			}
			if (!hit) backMovement(hero); 
			attack_mode = false;
		} 
		
		private function calkSkills(tar1:Unit, tar2:Unit, damage:int):void {  
			for each(var s:ISkill in tar1.skills) {  
				if(!s.defence()) s.calk(tar1, tar2, mas, damage, killUnit);       
			}   
		} 
		
		public function endTurn(obg:Unit):void {
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
			effects.notifyObserver();    
			var tween:TurnTweener = new TurnTweener("YOU TURN");
			addChild(tween); 
			for each (var unit:Unit in masBadUnit) {  
				TweenMax.to(unit, 1.4, { colorMatrixFilter: { hue:0 }} );
				unit.turn = true; 
				unit.agro = null; 
				enemyTutnMas.splice(0, enemyTutnMas.length);
			} 
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap, true);
			map.tracking = null;
			map.border = 80;
		} 
		 
		private function livesTurn(e:Event):void {   
			//for each (var unit:Unit in masGoodUnit) {
			//	endTurn(unit);
			if (charWindow!=null) {
				charWindow.kill();    
			} 
			EnemyTurn();
		}  
		 
		private function EnemyTurn():void {
			if (!turn) return;
			effects.notifyObserver();
			for each (var unit:Unit in masGoodUnit) { 
				TweenMax.to(unit, 1.4, { colorMatrixFilter: { hue:0 }} );
				unit.turn = true;   
			} 
			var tween:TurnTweener = new TurnTweener("ENEMY TURN");
			addChild(tween);  
			turn = false; 
			cutTurnEnemy = 0; 
			removeEventListener(MouseEvent.MOUSE_MOVE, moveramk); 
			removeEventListener(MouseEvent.CLICK, clickedOnMap, true);
			infoLand.visible = false;
			if (menu.cons) menu.killer();
			
			var dx:Number;     
			var dy:Number;
			var rast:Number;
			for each (var badunit:Unit in masBadUnit) {
				for each (var goodunit:Unit in masGoodUnit) {
					dx = badunit.x - goodunit.x;
					dy = badunit.y - goodunit.y;  
					rast = Math.sqrt(dx * dx + dy * dy); 
					if (rast < distance && badunit.turn) {
						badunit.agro = goodunit;  
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
							if (unit.enemy && unit.turn) { 
								unit.agro = enemyTutnMas[j].agro;    
								RastLowerDistance(unit);
							}
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
				var timer:Timer = new Timer(1000, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, ShowRamka);
				timer.start();
			}  
		} 
		 
		private function ShowRamka(e:TimerEvent):void {
			e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, ShowRamka);
			e.target.stop();  
			map.border = 40;   
			ramka.visible = true;  
			var p:Point = unit_cont.localToGlobal(new Point(enemyPoint.x, enemyPoint.y));
			ramka.x = p.x + 8; 
			ramka.y = p.y + 8;
			if (!skipper) {   
				var pp:Point = gerCoord(enemyPoint.x, enemyPoint.y); 
				ai = new AI(EnemyUnit(enemyTutnMas[cutTurnEnemy]), pp, mas, sqCont);   
				var retMas:Array = ai.init();
				if (retMas==null) {  
					p = gerCoord(enemyPoint.x, enemyPoint.y);   
					var unit2:EnemyUnit = mas[p.y][p.x].unit;
					unit2.skip();   
					unit2.addEventListener("FINISH", nextEnemy);
					clearSq(); 
					return; 
				} 
				if ((pp.x != retMas[1].x) || (pp.y != retMas[1].y)) {
					masPoint.splice(0, masPoint.length);  
					p = getGoodPath(retMas[1]);   
					masPoint.push(p);   
					while (mas[p.y][p.x].unit == undefined) { 
						p = getGoodPath(p);  
						masPoint.push(p);    
					} 
					masPoint.splice(0, 0, retMas[1]); 
					lines.masPath = masPoint; 
					lines.scanAndDraw();   
					  
					if (masPoint.length != 0) { 
						var obj:Object = mas[pp.y][pp.x];
						var hero:Unit = enemyTutnMas[cutTurnEnemy];
						hero.target = retMas[0];  
						obj.unit = undefined; 
						mas[retMas[1].y][retMas[1].x].unit = hero;
						hero.move();
						var walker:Walke = new Walke(hero, masPoint, 5);
						map.tracking = hero;       
						map.border = 120;     
						walker.addEventListener("LAST_POINT", enemyComes);   
					}
				}
				else {
					enemyTutnMas[cutTurnEnemy].target = retMas[0]; 
					enemyComes(null); 
				}
				setTimeout(relocateRamka, 200, retMas[1]); 
			}
			else {  
				p = gerCoord(enemyPoint.x, enemyPoint.y);   
				var unit:EnemyUnit = mas[p.y][p.x].unit;
				unit.skip();   
				unit.addEventListener("FINISH", nextEnemy);  
			}
		}
		
		private function relocateRamka(p:Point):void {
			if (p != null) {
				var num:Point = unit_cont.localToGlobal(new Point(p.x * grid_size, p.y * grid_size));
				ramka.x = num.x;       
				ramka.y = num.y; 
			} 
			lines.clear(); 
		}
		
		private function enemyComes(e:Event=null):void {   
			if (e != null) e.target.removeEventListener("LAST_POINT", enemyComes);
			map.tracking = null;       
			map.border = 80; 
			clearSq(); 
			var obg:Unit = enemyTutnMas[cutTurnEnemy];
			var tar:Unit = obg.target; 
			var tp:Point = gerCoord(obg.x, obg.y); 
			if (mas[tp.y][tp.x].grave != undefined) { 
				Unit(mas[tp.y][tp.x].grave).kill();  
			}
			if (tar == null) {
				obg.stay();
				nextEnemy();
				return;
			}
			var s:String;  
			var cof:Number = 1; 
			var damage:int;  
			obg.stay(); 
			if (obg.y == tar.y) { 
				if (obg.x > tar.x) s = "l";
				else s = "r"; 
			}  
			else if (obg.y > tar.y) {   
				 s = "t"; 
			}
			else s = "d";  
			obg.attack(s); 
			
			if (Math.random() * 100 < tar.agi) {
				tar.getDamage(0, false, true); 
			}
			else {
				var p:Point = gerCoord(tar.x, tar.y); 
				cof = 1 - mas[p.y][p.x].def * .1;  
				damage = (obg.att - tar.def) * cof; 
				if (Math.random() * 100 < obg.agi) {  
					damage *= 2; 
					obg.getDamage(0, true);   
				}
				if (damage <= 0) damage = 1; 
				else {
					var n:Number = 0;
					var m:int = Search.lookClass(tar.effects, Protect);   
					if (m >= 0) {
						var rev:Unit = tar.effects[m]._unit;
						n = tar.effects[m].cof;
						var damagePie:int = damage * n;
						rev.getDamage(damagePie);   
					} 
					m = Search.lookClass(tar.skills, Block);   
					if (m >= 0) { 
						damage = tar.skills[m].correct();  
					}
					damage = int(damage * (1 - n)); 	
				}
				tar.getDamage(damage);    
				obg.exp = damage;   
			} 
			for each(var ss:ISkill in tar.skills) {     
				if(ss.defence()) ss.calk(obg, tar, mas, damage, killUnit);    
			}   
			if (tar.hp <= 0) killUnit(tar);
			nextEnemy(); 
			//addEventListener(MenuEvent.DEAD, killUnit); 
		} 
		
		private function nextEnemy(e:Event=null):void {
			if (e == null) endTurnEnemy(enemyTutnMas[cutTurnEnemy]);
			else endTurnEnemy(Unit(e.target));
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
		
		private function removeFromMas(e:MenuEvent):void {
			var unit:Unit = e.tar; 
			unit.removeEventListener(MenuEvent.DEAD, removeFromMas);
			var p:Point = gerCoord(unit.x, unit.y);  
			mas[p.y][p.x].grave = undefined;  
			unit_cont.removeChild(unit); 
			unit = null; 
		}
		         
		public function killUnit(unit:Unit):void {   
			unit.grave();  
			unit.addEventListener(MenuEvent.DEAD, removeFromMas);
			unit_cont.setChildIndex(unit, 2);  
			var s:String;       
			if(unit.enemy){  
				for (s in masBadUnit) {  
					if (masBadUnit[s] == unit) masBadUnit.splice(int(s), 1);
				}
			}   
			else {    
				for (s in masGoodUnit) {  
					if (masGoodUnit[s] == unit) masGoodUnit.splice(int(s), 1);
				}
			} 
			var p:Point = gerCoord(unit.x, unit.y);  
			mas[p.y][p.x].unit = undefined; 
			mas[p.y][p.x].grave = unit;  
			unit.removeEventListener(MouseEvent.MOUSE_OUT, out_enemy);
			unit.removeEventListener(MouseEvent.MOUSE_OVER, over_enemy);
		}  
		 
		private function comes(e:Event):void {  
			e.target.removeEventListener("LAST_POINT", comes);
			map.tracking = null;      
			map.border = 80; 
			var obg:Unit = mas[curhero.y][curhero.x].unit;
			obg.stay();
			curhero = new Point(curhero.x, curhero.y);  
			menu.init(curhero.x, curhero.y, false); 
			ramka.visible = false; 
		}
		
		public function finishMovement(tar:Unit):void {  
			tar.prev = null;  
			endTurn(tar);
			if (mas[curhero.y][curhero.x].grave != undefined) {
				Unit(mas[curhero.y][curhero.x].grave).kill(); 
			}
			var m:int = Search.lookClass(tar.skills, Prot);     
			if (m >= 0) applyProt(tar);   
			else lookProtect(tar);   
		} 
		  
		public function lookProtect(unit:Unit):void {   
			for each(var ss:IEffect in unit.effects) {       
				if (ss is Protect) {  
					unit.setEffects(ss, true);        
					break;   
				}   
			}       
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]]; 
			var dirX:int;   
			var dirY:int;   
			var tar:Unit;  
			var p2:Point = Game.gerCoord(unit.x, unit.y); 
				for (var i:int; i < direction.length; i++) {    
					dirX = p2.x + direction[i][0];      
					dirY = p2.y + direction[i][1];   
					if (getIndex(dirX, dirY)) {  
						tar = mas[dirY][dirX].unit;  
						if(tar!=null) { 
							var m:int = Search.lookClass(tar.skills, Prot);     
							if (m >= 0) unit.setEffects(new Protect(tar, "skill3")); 
						}
					} 
				} 
		}   
		   
		public function applyProt(unit:Unit):void {
			var m:int;
			for each(var ss:Unit in masGoodUnit) {       
				m = Search.lookClass(ss.effects, Protect);      
				if (m >= 0) ss.setEffects(ss.effects[m], true);  
			}  
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]]; 
			var dirX:int;    
			var dirY:int;  
			var tar:Unit;  
			var p2:Point = Game.gerCoord(unit.x, unit.y); 
				for (var i:int; i < direction.length; i++) {    
					dirX = p2.x + direction[i][0];     
					dirY = p2.y + direction[i][1];   
					if (getIndex(dirX, dirY)) {    
						tar = mas[dirY][dirX].unit;   
						if(tar!=null) {    
							if(!tar.enemy) tar.setEffects(new Protect(unit, "skill3")); 
						}
					} 
				} 
		}
		
		public function backMovement(tar:Unit):void {
			var p:Point = tar.prev;
			if (tar.prev == null) return; 
			if(p.x == curhero.x && p.y == curhero.y) return; 
			tar.x = p.x * grid_size - 8; 
			tar.y = p.y * grid_size - 8;
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
			if (tarCast != null) {
				if (ramka.contains(tarCast)) {
					sqCont.removeEventListener(MouseEvent.MOUSE_OUT, sqContOut);
					ramka.removeChild(tarCast);
					tarCast = null;
				}
				else {
					unit_cont.removeChild(tarCast);  
					tarCast = null;
				}
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
			var tarX:int = (mouseX + map.corX) / grid_size; 
			var tarY:int = (mouseY + map.corY) / grid_size; 
			
			if(!infoLand.visible) infoLand.visible = true;
			infoLand.percent.text = "0";
			if(mas[tarY][tarX].def != 9) infoLand.percent.text = String(mas[tarY][tarX].def * 10);
			
			ramka.x = numX * grid_size - map.corX % grid_size;     
			ramka.y = numY * grid_size - map.corY % grid_size;  
			
			if (sqCont.hitTestPoint(mouseX, mouseY, true) && !attack_mode && curcast==null) {
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
					if (curWater < min && mas[dirY][dirX].unit==undefined) {
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
			p.x = int((x+(Map.grid_size>>1)) / Map.grid_size);   
			p.y = int((y+(Map.grid_size>>1)) / Map.grid_size);  
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
		
		public function castNow(tar:Unit):void {
			ramka.gotoAndStop(curcast.ramka);
			var dirX:int; 
			var dirY:int;  
			var direction:Array = [[ -1, 0], [1, 0], [0, -1], [0, 1]];   
			var unit:Unit;
			var target:Point = gerCoord(tar.x, tar.y);  
			var i:int;
			if (!curcast.summon) { 
				direction = tar.direction;
				for (i = 0; i < direction.length; i++) {   
					dirX = target.x + direction[i][0];    
					dirY = target.y + direction[i][1]; 
					if (getIndex(dirX, dirY)) {
						if (mas[dirY][dirX].unit != undefined || mas[dirY][dirX].grave != undefined) { 
							unit = mas[dirY][dirX].unit; 
							if(unit==null) unit = mas[dirY][dirX].grave;  
							if (curcast.baff=="good" || curcast.baff=="massgood") {   
								if (!unit.enemy) { 
									unit.addEventListener(MouseEvent.MOUSE_OVER, over_enemy);
									enemyMas.push(new Point(dirX, dirY));
									getSquare(dirY, dirX, 0xC28216);  
								}  
								if(curcast.baff=="massgood") sqCont.addEventListener(MouseEvent.MOUSE_OVER, sqContOver); 
							}    
							else {      
								if (unit.enemy || unit.hero==null) { 
									unit.addEventListener(MouseEvent.MOUSE_OVER, over_enemy); 
									enemyMas.push(new Point(dirX, dirY)); 
									getSquare(dirY, dirX, 0xC28216);  
								}
								if(curcast.baff!="bad") sqCont.addEventListener(MouseEvent.MOUSE_OVER, sqContOver);  
							}
						}     
						else getSquare(dirY, dirX, 0x00ffff);  
					} 
				} 
			} 
			else { 
				if(curcast is Telepotr) direction = tar.direction; 
				for (i = 0; i < direction.length; i++) {       
					dirX = target.x + direction[i][0];     
					dirY = target.y + direction[i][1]; 
					if (getIndex(dirX, dirY)) {
						if (curcast.ress==null) {  
							unit = mas[dirY][dirX].unit;
							if(unit==null){     
								getSquare(dirY, dirX, 0xC28216); 
							}
							else getSquare(dirY, dirX, 0x00ffff); 
							sqCont.addEventListener(MouseEvent.MOUSE_OVER, sqContOver);  
						}
						else { 
							unit = mas[dirY][dirX].grave;  
							if(unit!=null){  
								if (curcast.ress=="bad") {  
										unit.addEventListener(MouseEvent.MOUSE_OVER, over_enemy);
										enemyMas.push(new Point(dirX, dirY)); 
										getSquare(dirY, dirX, 0xC28216); 
								}
								else {  
									if (!unit.enemy) {  
										unit.addEventListener(MouseEvent.MOUSE_OVER, over_enemy);
										enemyMas.push(new Point(dirX, dirY)); 
										getSquare(dirY, dirX, 0xC28216); 
									}
								}
							}
							else getSquare(dirY, dirX, 0x00ffff);  
						}   
					}
				}   
			} 
			if(curcast.baff=="good" || curcast.baff=="massgood") {    
				tar.addEventListener(MouseEvent.MOUSE_OVER, over_enemy);
				var cp:Point= gerCoord(tar.x, tar.y)
				enemyMas.push(cp);
				getSquare(cp.y, cp.x, 0xC28216); 
			}
			setChildIndex(ramka, this.numChildren-1);
		}
		
		public function showChar(tar:Unit):void {   
			removeEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			removeEventListener(MouseEvent.CLICK, clickedOnMap, true);
			scrolling = false;
			charWindow = new CharacterInfo(tar, lootMas); 
			addChild(charWindow);  
			charWindow.addEventListener("KILL", killChar);
			charWindow.x = Constants.STAGE_WIDTH >> 1;
			charWindow.y = Constants.STAGE_HEIGHT >> 1; 
		}  
		  
		private function killChar(e:Event):void {
			addEventListener(MouseEvent.MOUSE_MOVE, moveramk);
			addEventListener(MouseEvent.CLICK, clickedOnMap, true);
			removeChild(charWindow);
			scrolling = true; 
			menu.mouseEnabled = true; 
			menu.mouseChildren = true;
			charWindow = null; 
		} 
		
		private function sqContOver(e:MouseEvent):void {
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, sqContOver);
			tarCast = new TarCast;
			var p:Point = gerCoord(mouseX, mouseY); 
			tarCast.x = tarCast.y = 36;  
			tarCast.mouseEnabled = false;    
			ramka.addChild(tarCast);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, sqContOut);
		}
		
		private function sqContOut(e:MouseEvent):void {
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, sqContOut);
			ramka.removeChild(tarCast);
			tarCast = null; 
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, sqContOver);
		}
		
		private function over_enemy(e:MouseEvent):void { 
			e.target.removeEventListener(MouseEvent.MOUSE_OVER, over_enemy);
			if(curcast==null) { 
				tar = new Tar;
				tar.x = e.target.x + 40;
				tar.y = e.target.y + 40;   
				unit_cont.addChild(tar);
				tar.mouseEnabled = false;
				tar.addEventListener(Event.ENTER_FRAME, rotateTar);
			}
			else { 
				tarCast = new TarCast; 
				tarCast.x = e.target.x + 40; 
				tarCast.y = e.target.y + 40;   
				tarCast.mouseEnabled = false;    
				unit_cont.addChild(tarCast);  
			}
			e.target.addEventListener(MouseEvent.MOUSE_OUT, out_enemy);
		}
		    
		public function rotateTar(e:Event):void { 
			if (tar!=null) tar.rotation -= 4;
			else e.currentTarget.removeEventListener(Event.ENTER_FRAME, rotateTar);
		} 
		
		public function out_enemy(e:MouseEvent):void {
			e.target.removeEventListener(MouseEvent.MOUSE_OUT, out_enemy);
			if(curcast==null) {
				unit_cont.removeChild(tar);   
				tar.removeEventListener(Event.ENTER_FRAME, rotateTar);
				tar = null;
			}
			else {
				unit_cont.removeChild(tarCast); 
				tarCast = null;
			}
			e.target.addEventListener(MouseEvent.MOUSE_OVER, over_enemy);
		}
		 
		public function get _ramka():Ramka { return ramka; }
		public function get _turn():Boolean { return turn; }
//-----
	}
}
