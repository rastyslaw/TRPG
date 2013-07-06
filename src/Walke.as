package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import units.Animation;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Walke extends Sprite {
		
		private var unit:Unit;
		private var pointMas:Vector.<Point> = new Vector.<Point>(); 
		private var step:int;
		private var curStep:int; 
		private var tarX:Number;
		private var tarY:Number; 
		private var compas:String;  
		private var index:int = -1;
		private var movie:Animation;
		
		public function Walke(tar:Unit, mas:Vector.<Point>, spd:int):void {
			unit = tar;
			movie = unit.hero;
			step = curStep = spd;
			for (var i:int = mas.length-2; i >= 0; i--) {  
				pointMas.push(new Point(mas[i].x * Map.grid_size - 8, mas[i].y * Map.grid_size - 8));
			}
			correct(); 
			addEventListener(Event.ENTER_FRAME, moving);
		} 
		
		private function correct():void {
			index++;
			curStep = step;
			if (index < pointMas.length){
				tarX = pointMas[index].x; 
				tarY = pointMas[index].y; 
				if (unit.x == tarX) { 
					compas = "y";
					if (unit.y > tarY) {
						curStep *= -1; 
						movie.gotoAndPlay(Animation.MOVING_TOP);
					}
					else movie.gotoAndPlay(Animation.MOVING_BOTTOM);
				} 
				else {
					compas = "x";  
					if (unit.x > tarX) {
						curStep *= -1;
						movie.gotoAndPlay(Animation.MOVING_LEFT);
					}
					else movie.gotoAndPlay(Animation.MOVING_RIGHT);
				}
			}
			else kill(); 
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
		
		private function kill():void {
			removeEventListener(Event.ENTER_FRAME, moving);
			dispatchEvent(new Event("LAST_POINT"));
		}
//-----		
	}
}