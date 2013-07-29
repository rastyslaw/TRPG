package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import npc.NPC;
	import units.Animation;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Walke extends Sprite {
		
		private var unit:*;  
		private var pointMas:Vector.<Point> = new Vector.<Point>(); 
		private var step:int;
		private var curStep:int; 
		private var tarX:Number;
		private var tarY:Number; 
		private var compas:String;  
		private var index:int = -1;
		private var movie:Animation;
		private var refresh:Function;
		private var hitt:Object;
		private var _last:Point;
		private var _mas:Vector.<Point>;
		
		public function Walke(tar:*, mas:Vector.<Point>, spd:int, func:Function=null):void {
			unit = tar;
			_mas = mas;
			if(unit is NPC) unit.walker = this;
			refresh = func; 
			movie = unit.hero; 
			step = curStep = spd;
			for (var i:int = mas.length-2; i >= 0; i--) {  
				pointMas.push(new Point(mas[i].x * Map.grid_size - 8, mas[i].y * Map.grid_size - 8));
			} 
			_last = mas[0];   
			if(!correct()) addEventListener(Event.ENTER_FRAME, moving); 
		} 
		 
		private function correct():Boolean {
			var s:uint;
			index++;
			if (unit is Hero) {
				if (unit.isHero) redrawPath(); 
			}
			curStep = step; 
			if (index < pointMas.length) { 
				tarX = pointMas[index].x; 
				tarY = pointMas[index].y;
				if (unit.x == tarX) {
					compas = "y"; 
					if (unit.y > tarY) {
						curStep *= -1; 
						s = Animation.MOVING_TOP;
					}
					else s = Animation.MOVING_BOTTOM;
				}   
				else {
					compas = "x";  
					if (unit.x > tarX) {
						curStep *= -1; 
						s = Animation.MOVING_LEFT; 
					}
					else s = Animation.MOVING_RIGHT;
				}
				movie.gotoAndPlay(s);  
				if (refresh != null) { 
					if (refresh(unit, s)) { 
						return true;
					}
				}
			}
			else kill();
			return false;
		}  
		
		private function redrawPath():void {
			Town.clearPath();
			var total:int = _mas.length - 1; 
			for (var p:int; p < total-index; p++ ){
				if(_mas[p]!=null) Town.getSquare(_mas[p].y, _mas[p].x);
			}
		}
		
		private function moving(e:Event):void {
			//compas == "x" ? unit.x += step : unit.y += step; 
			if (compas == "x") { 
				unit.x += curStep;
				if(curStep > 0) { 
					if (unit.x > tarX || ((tarX - unit.x) < 2) ) { 
						unit.x = tarX;
						correct(); 
					}
				}
				else {
					if (unit.x < tarX || ((unit.x - tarX) < 2) ) { 
						unit.x = tarX;
						correct(); 
					}
				}
			}
			else {
				unit.y += curStep;
				if(curStep > 0) { 
					if (unit.y > tarY || ((tarY - unit.y) < 2) ) { 
						unit.y = tarY; 
						correct();  
					}
				}
				else {
					if (unit.y < tarY || ((unit.y - tarY) < 2) ) { 
						unit.y = tarY; 
						correct();  
					}
				}
			}
		}
		
		public function pause(obj:Object):void {
			hitt = obj; 
			removeEventListener(Event.ENTER_FRAME, moving);
			//unit.setState(Hero.STAY);
			var timer:Timer = new Timer(1000, 0);  
			timer.addEventListener(TimerEvent.TIMER, play);
			timer.start(); 
		}  
		
		public function play(e:TimerEvent):void {
			if (hitt.unit == undefined) {
				e.currentTarget.removeEventListener(TimerEvent.TIMER, play);
				e.currentTarget.stop();
				run(); 
				hitt = null; 
			} 
		} 
		 
		private function run():void {
			index--;
			//if (this.hasEventListener(Event.ENTER_FRAME)) return;
			addEventListener(Event.ENTER_FRAME, moving);  
			//unit.setState(Hero.MOVE);
			correct();
		}
		
		public function kill():void {  
			// if (refresh != null) refresh(unit); 
			//pointMas.splice(0, pointMas.length);
			removeEventListener(Event.ENTER_FRAME, moving);
			dispatchEvent(new Event("LAST_POINT"));
		}
		
		public function get _unit():* {
			return unit;
		}
		
		public function get last():Point {
			return _last;
		}
//-----		
	}
}