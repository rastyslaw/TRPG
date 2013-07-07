package  {
	import events.MenuEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Menu extends Sprite { 
		  
		private var mas:Vector.<Object>; 
		private var elements:Array; 
		private var obg:Unit;  
		private var type:String;
		private var enemyMas:Vector.<Point> = new Vector.<Point>(); 
		private var target:Point;
		private var radius:int = 60; 
		private var cont:Sprite;
		private var _cons:Boolean; 
		private var _first:Boolean;
		
		public function Menu(mas:Vector.<Object>) {
			this.mas = mas;   
		}  
		
		public function init(numX:int, numY:int, first:Boolean):void {
			_first = first;
			elements = [Cbtn, Mbtn, Abtn, Sbtn, Bbtn, Obtn];
			enemyMas.splice(0, enemyMas.length);
			obg = mas[numY][numX].unit;
			type = obg.type;  
			target = new Point(numX, numY);   
			if (first) { 
				elements.splice(4);     
				if (!scanMas()) elements.splice(2); 
				else if (type != "mage") elements.pop();    
			}  
			else {
				elements.splice(1, 1);   
				if (!scanMas()) elements.splice(1, 2); 
				else if (type != "mage") elements.splice(2, 1);  
			}
			this.x = numX * Map.grid_size;
			this.y = numY * Map.grid_size;
			drawMenu();
			cons = true; 
		}
		
		private function drawMenu():void {
			cont = new Sprite; 
			var len:int = elements.length; 
			var angle:int = 360 / len;
			var c:DisplayObject;
			var curAngle:int;  
			var rad:Number;
			for (var i:int; i < len; i++) {
				rad = curAngle * Math.PI / 180;
				c = new elements[i];
				c.y = radius * Math.sin(rad);  
				c.x = radius * Math.cos(rad);
				cont.addChild(c);
				curAngle += angle;
			}
			addChild(cont); 
			cont.x = Map.grid_size >> 1; 
			cont.y = Map.grid_size >> 1;
			addEventListener(MouseEvent.CLICK, sendNote); 
		}
		
		private function sendNote(e:MouseEvent):void {
			var eventName:String; 
			var s:String = String(e.target);
			var req:RegExp = /\s/; 
			s = s.substr(s.search(req)+1, 1); 
			switch(s) {  
				case "M":  
					eventName = MenuEvent.MOVING;
				break;
				case "A":  
					eventName = MenuEvent.ATTACK; 
				break;
				case "O":  
					eventName = MenuEvent.FINISH; 
				break;
				case "B":  
					eventName = MenuEvent.BACK;  
				break;
			}
			dispatchEvent(new MenuEvent(eventName, obg)); 
			killer(); 
		}
		
		public function killer():void {
			removeEventListener(MouseEvent.CLICK, sendNote);
			removeChild(cont);  
			cons = false; 
		}
		
		private function scanMas():Boolean {
			var dirX:int;
			var dirY:int; 
			var direction:Array = obg.direction;
			
				for (var i:int = 0; i < direction.length; i++) {  
					dirX = target.x + direction[i][0]; 
					dirY = target.y + direction[i][1];     
					if (getIndex(dirX, dirY)) {
						if (mas[dirY][dirX].unit != undefined)
							if (Unit(mas[dirY][dirX].unit).enemy)
							enemyMas.push(new Point(dirX, dirY));   
					}
				}  
			if(enemyMas.length!=0) return true; 	
			else return false;    
		}
		 
		private function getIndex(x:int, y:int):Boolean {  
			if (x >= Map.worldCols || x < 0 || y >= Map.worldRows || y < 0) return false; 
			return true;
		}
		
		public function get cons():Boolean { return _cons;}
		public function set cons(value:Boolean):void {	_cons = value; }
		
		public function get first():Boolean { return _first; } 
//-----		
	}
}