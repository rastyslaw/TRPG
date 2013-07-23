package  {
	import events.MenuEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import spell.IIcon;
	import spell.ISpell;
	import units.MageUnit;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Menu extends Sprite { 
		
		[Embed(source = "../assets/spell.xml", mimeType = "application/octet-stream")]
		public static const TextureXMLData:Class;
  
		[Embed(source = "../assets/spell.png")]   
		public static const TextureData:Class;
		
		private var spellXml:XML;
		private var texture:Bitmap;
		private var mas:Vector.<Object>; 
		private var elements:Array; 
		private var obg:Unit;  
		private var type:String;
		private var enemyMas:Vector.<Point> = new Vector.<Point>(); 
		private var target:Point;
		private var radius:int = 60; 
		private var cont:Sprite;  
		private var spellcont:Sprite; 
		private var _cons:Boolean; 
		private var _first:Boolean;
		
		public function Menu(mas:Vector.<Object>) {
			this.mas = mas; 
			texture = Bitmap(new TextureData());  
			spellXml = XML(new TextureXMLData());     
		}  
		
		public function init(numX:int, numY:int, first:Boolean):void {
			_first = first;
			elements = [Cbtn, Mbtn, Abtn, Sbtn, Bbtn, Obtn]; 
			enemyMas.splice(0, enemyMas.length); 
			obg = mas[numY][numX].unit;
			if(obg.turn && !obg.enemy) { 
				type = obg.type;   
				target = new Point(numX, numY);    
				if (first) { 
					elements.splice(4);      
					if (!scanMas()) killElement(Abtn);   
					if (type != "mage") killElement(Sbtn);  
				}  
				else {
					elements.splice(0, 2);      
					if (!scanMas()) killElement(Abtn);  
					if (type != "mage") killElement(Sbtn); 
				}
			}
			else elements.splice(1);
			this.x = numX * Map.grid_size;
			this.y = numY * Map.grid_size;
			drawMenu();
			cons = true; 
		}
		
		private function killElement(obg:*):void {
			for (var i:int; i < elements.length; i++ ) { 
				if (elements[i] == obg) {
					elements.splice(i, 1); 
				}
			}
		}
		
		private function drawMenu():void {
			cont = new Sprite;  
			var len:int = elements.length; 
			var angle:int = 360 / len;
			var c:DisplayObject;
			var curAngle:int = -90;  
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
			cont.addEventListener(MouseEvent.CLICK, sendNote); 
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
				case "C":  
					eventName = MenuEvent.CHAR;  
				break;
			}   
			if (s != "S") dispatchEvent(new MenuEvent(eventName, obg));
			else {
				spellClicked();
				return; 
			}
			if(s!="C") killer(); 
		}
		
		private function spellClicked():void {
			cont.visible = false;
			if (spellcont!=null) {
				spellcont.visible = true; 
				return; 
			} 
			var mas:Vector.<ISpell> = MageUnit(obg).spellMas; 
			var len:int = mas.length; 
			var angle:int = 360 / (len+1);
			var c:MenuElm;   
			var curAngle:int = -90;     
			var rad:Number; 
			spellcont = new Sprite; 
			var ex:ZBtn = new ZBtn;  
			rad = curAngle * Math.PI / 180;
			ex.y = radius * Math.sin(rad);  
			ex.x = radius * Math.cos(rad);
			spellcont.addChild(ex);
			curAngle += angle;
			
			var bmpd:BitmapData;
			var bmp:Bitmap; 
			var Width:Number;
			var Height:Number;
			var sname:String; 
			for (var i:int; i < len; i++) { 
				rad = curAngle * Math.PI / 180;  
				c = new MenuElm;  
				c.y = radius * Math.sin(rad);  
				c.x = radius * Math.cos(rad); 
				spellcont.addChild(c);
				sname = IIcon(mas[i]).ico;    
				Width = spellXml.SubTexture.(attribute('name') == sname).@width;
				Height = spellXml.SubTexture.(attribute('name') == sname).@height; 
				bmpd = new BitmapData(Width, Height);  
				bmpd.copyPixels(texture.bitmapData,        
                       new Rectangle(spellXml.SubTexture.(attribute('name') == sname).@x, spellXml.SubTexture.(attribute('name') == sname).@y, Width, Height), 
                       new Point(0, 0));  
				bmp = new Bitmap(bmpd);
				bmp.scaleX = bmp.scaleY = 0.7;   
				bmp.x -= bmp.width >> 1;
				bmp.y -= bmp.height >> 1;
				c.addChild(bmp);   
				curAngle += angle;
			}  
			addChild(spellcont); 
			spellcont.x = Map.grid_size >> 1;   
			spellcont.y = Map.grid_size >> 1;  
			spellcont.addEventListener(MouseEvent.CLICK, clickOnSpell); 
		}
		 
		private function clickOnSpell(e:MouseEvent):void {
			if (e.target is ZBtn) {
				spellcont.visible = false;
				cont.visible = true; 
			} 
			else { 
				var mas:Vector.<ISpell> = MageUnit(obg).spellMas;
				var i:int = spellcont.getChildIndex(DisplayObject(e.target));
				Game.curcast = mas[i - 1];
				Game.curcast.tar = obg; 
				dispatchEvent(new MenuEvent(MenuEvent.CAST, obg));
				killer(); 
			} 
		}
		
		public function killer():void {
			removeEventListener(MouseEvent.CLICK, sendNote);
			if (cont!=null) { 
				removeChild(cont); 
				cont = null;   
			}  
			if (spellcont!=null) { 
				removeChild(spellcont);
				spellcont = null; 
			}
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