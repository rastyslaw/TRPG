package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import units.MageUnit;
	import units.Unit;
	/**
	 * ...
	 * @author waltasar
	 */
	public class CharacterInfo extends Sprite {
		
		[Embed(source = "../assets/loot.xml", mimeType = "application/octet-stream")]
		public static const TextureXMLData:Class;
 
		[Embed(source = "../assets/loot.png")]  
		public static const TextureData:Class;
		
		private var main:CharWindow;
		private var unit:Unit;
		private var bg:CharBg;
		private var _state:String;
		private var lootXml:XML; 
		private var lootMas:Array;
		private var botom:int;
		private var texture:Bitmap;
		private var _sortState:String = "all";
		
		public function CharacterInfo(tar:Unit, mas:Array) {
			lootMas = mas;
			texture = Bitmap(new TextureData()); 
			lootXml = XML(new TextureXMLData());  
			unit = tar; 
			main = new CharWindow();   
			addChild(main);
			bg = main.bg;
			init();
			main.close.addEventListener(MouseEvent.CLICK, closed);
			state = "atr";  
		}
		
		private function init():void {
			main.ico.addChildAt(unit.getIco(), 0);
			main.level.text = String(unit.level); 
			main.infoProgress.text = String(unit.exp);
			main.progress.lod.width = unit.exp * 96 / 100;  
			main.clas.text = unit.getClassName();  
			main.nam.text = unit.getName(); 
			main.hp.text = String(unit.hp + "/" + unit.max_hp); 
			if (unit.type == "mage") main.mp.text = String(MageUnit(unit).mp + "/" + MageUnit(unit).max_mp);
		}
		
		private function atr_open(e:MouseEvent=null):void { 
			main.attributes.removeEventListener(MouseEvent.CLICK, atr_open);
			bg.gotoAndStop(1); 
			bg.at.text = String(unit.att); 
			bg.df.text = String(unit.def); 
			bg.ag.text = String(unit.agi);  	 
			bg.mv.text = String(unit.speed);
			bg.info.text = unit.description;
			main.inventory.addEventListener(MouseEvent.CLICK, inv_open);
		}
		
		private function inv_open(e:MouseEvent=null):void { 
			main.inventory.removeEventListener(MouseEvent.CLICK, inv_open);
			bg.gotoAndStop(2);
			bg.cont.scrollRect = new Rectangle(0, 0, 156, 210);   
			bg.progress.visible = false;
			var place:Loot; 
			var bmpd:BitmapData;
			var bmp:Bitmap;
			var Width:Number;
			var Height:Number;
			for(var i:int; i < lootMas.length; i++) { 
			    place = new Loot;
				place.x = int(i/4)*52;  
				place.y = (i%4)*52; 
				bg.cont.addChild(place);
				botom = place.x + 52; 
				place.who = lootMas[i][0]; 
				place.par = lootMas[i][1];
				Width = lootXml.SubTexture.(attribute('name') == lootMas[i][0]).@width;
				Height = lootXml.SubTexture.(attribute('name') == lootMas[i][0]).@height;
				bmpd = new BitmapData(Width, Height);  
				bmpd.copyPixels(texture.bitmapData,     
                       new Rectangle(lootXml.SubTexture.(attribute('name') == lootMas[i][0]).@x, lootXml.SubTexture.(attribute('name') == lootMas[i][0]).@y, Width, Height), 
                       new Point(0, 0)); 
				bmp = new Bitmap(bmpd); 
				place.addChild(bmp); 
				place.addEventListener(MouseEvent.CLICK, equip);
				place.addEventListener(MouseEvent.MOUSE_OVER, showStat); 
			}
			if(lootMas.length>12){ 
				bg.progress.visible = true;   
				bg.progress.addEventListener(MouseEvent.MOUSE_DOWN, startdrag);
				bg.progress.width = (156/botom) * 156;
			} 
			botom -= 158;
			bg.only.addEventListener(MouseEvent.CLICK, sort);
			bg.all.addEventListener(MouseEvent.CLICK, sort);
			drawCurLoot();
			main.attributes.addEventListener(MouseEvent.CLICK, atr_open);
		}
		
		private function drawCurLoot():void { 
			var bmpd:BitmapData;
			var bmp:Bitmap; 
			var item:Loot;
			var Width:Number;
			var Height:Number;
			var mas:Array = unit.itemMas;
			for (var j:int; j < mas.length; j++) {
				item = new Loot;
				item.who = mas[j][0];   
				item.par = mas[j][1]; 
				if (mas[j][0].search("weapon") != -1) bg.weapon_slot.addChild(item);
				else if (mas[j][0].search("boots") != -1) bg.boots_slot.addChild(item); 
				else if (mas[j][0].search("chest") != -1) bg.chest_slot.addChild(item);
				else if (mas[j][0].search("helm") != -1) bg.head_slot.addChild(item); 
				else bg.shield_slot.addChild(item);    
			 
				Width = lootXml.SubTexture.(attribute('name') == mas[j][0]).@width;
				Height = lootXml.SubTexture.(attribute('name') == mas[j][0]).@height; 
				bmpd = new BitmapData(Width, Height);  
				bmpd.copyPixels(texture.bitmapData,     
                       new Rectangle(lootXml.SubTexture.(attribute('name') == mas[j][0]).@x, lootXml.SubTexture.(attribute('name') == mas[j][0]).@y, Width, Height), 
                       new Point(0, 0)); 
				bmp = new Bitmap(bmpd);   
				item.addChild(bmp);    
				item.addEventListener(MouseEvent.MOUSE_OVER, showStat);
			}     
		}
		
		private function showStat(e:MouseEvent):void {
			trace(e.currentTarget.par);  
		}
		
		private function equip(e:MouseEvent):void {
			var loot:Loot = Loot(e.currentTarget); 
			if (e.shiftKey) {
				for (var i:int; i < bg.cont.numChildren; i++) {
					if (bg.cont.getChildAt(i) == loot) { 
						bg.cont.removeChild(loot); 
						lootMas.splice(i, 1); 
						sorting(sortState);  
					}
				}
			}
			else {
				if (sortState=="only") equipCurItem(loot);  
				else if( loot.who.search(unit._sname) != -1 ) equipCurItem(loot);    
  			}
		} 
		
		private function equipCurItem(item:Loot):void {
			for (var i:int; i < bg.cont.numChildren; i++) {
				if (bg.cont.getChildAt(i) == item) {   
					bg.cont.removeChild(item);  
				}   
			}
			var bol:Boolean; 
			var lot:Loot;  
			if (item.who.search("weapon") != -1) {
				if (bg.weapon_slot.numChildren > 1) {
					lot = Loot(bg.weapon_slot.getChildAt(1));
					bg.weapon_slot.removeChild(lot);
					bol = true; 
				}
				bg.weapon_slot.addChild(item); 
			}
			else if (item.who.search("boots") != -1) {
				if (bg.boots_slot.numChildren > 1) {
					lot = Loot(bg.boots_slot.getChildAt(1));
					bg.boots_slot.removeChild(lot);
					bol = true;
				}
				bg.boots_slot.addChild(item); 
			}
			else if (item.who.search("chest") != -1) {
				if (bg.chest_slot.numChildren > 1) {
					lot = Loot(bg.chest_slot.getChildAt(1));
					bg.chest_slot.removeChild(lot);
					bol = true;
				}
				bg.chest_slot.addChild(item);
			}
			else if (item.who.search("helm") != -1) {
				if (bg.head_slot.numChildren > 1) {
					lot = Loot(bg.head_slot.getChildAt(1));
					bg.head_slot.removeChild(lot);
					bol = true; 
				}
				bg.head_slot.addChild(item); 
			}
			else {
				if (bg.shield_slot.numChildren > 1) {
					lot = Loot(bg.shield_slot.getChildAt(1));
					bg.shield_slot.removeChild(lot);
					bol = true;  
				}
				bg.shield_slot.addChild(item);    
			}
			item.x = item.y = 0;
			var mas:Array = unit.itemMas;
			if (bol) {
				bg.cont.addChild(lot);
				for (var j:int; j < mas.length; j++) {
					if (mas[j][0]==lot.who && mas[j][1]==lot.par) {
						mas.splice(j, 1); 
					}
				}     
			}
			item.addEventListener(MouseEvent.MOUSE_OVER, showStat); 
			mas.push([item.who, item.par]);
			sorting(sortState);  
		} 
			
		private function sort(e:MouseEvent):void {
			if (e.currentTarget.name == "all") {
				bg.only.gotoAndStop(1);
				bg.all.gotoAndStop(2);
				sortState = "all"; 
			}
			else {
				bg.only.gotoAndStop(2); 
				bg.all.gotoAndStop(1);
				sortState = "only";
			}
		} 
		 
		private function sorting(s:String):void {
			var loot:Loot;
			var i:int;
			var j:int;
			bg.progress.visible = false;
			for (i=0; i < bg.cont.numChildren; i++ ) {
				loot = Loot(bg.cont.getChildAt(i)); 
				if (s != "all") {
					if (loot.who.search(unit._sname) == -1) {
							loot.visible = false;
							j++;
					}
				} 
				else loot.visible = true;  
				loot.x = int((i-j)/4)*52;   
				loot.y = ((i - j) % 4) * 52;
				botom = loot.x + 52;  
			}
			if((bg.cont.numChildren - j)>12){ 
				bg.progress.visible = true;   
				bg.progress.width = (156/botom) * 156; 
			} 
			botom -= 158;
			var rect:Rectangle = bg.cont.scrollRect; 
			rect.x = 0;
			bg.cont.scrollRect = rect;
			bg.progress.x = 33; 
		}
		
		private function startdrag(e:MouseEvent):void {
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, startdrag);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, stopdrag);
			e.currentTarget.addEventListener(MouseEvent.MOUSE_MOVE, drag); 
		} 
		  
		private function stopdrag(e:MouseEvent):void {
			e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, startdrag);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_UP, stopdrag);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
		}
		 
		private function drag(e:MouseEvent):void {
			var pp:Point = bg.globalToLocal(new Point(e.stageX, e.stageY));
			bg.progress.x = pp.x-33;  
			if(bg.progress.x > 190-bg.progress.width) bg.progress.x = 190-bg.progress.width;
			if(bg.progress.x < 33) bg.progress.x = 33;
			var rect:Rectangle = bg.cont.scrollRect; 
			rect.x = (bg.progress.x - 33) / ((156 - bg.progress.width) / botom);
			bg.cont.scrollRect = rect;  
		}
		 
		private function closed(e:MouseEvent):void {
			e.target.removeEventListener(MouseEvent.CLICK, closed);
			kill(); 
		}
		  
		public function kill():void {
			dispatchEvent(new Event("KILL")); 
		}
		
		public function set state(value:String):void {
			_state = value; 
			if (value == "atr") atr_open();
			else if (value == "inv") {
				clear(); 
				inv_open();  
			} 
		}
		
		public function set sortState(value:String):void {
			_sortState = value;
			sorting(value);   
		}
		
		public function get sortState():String {
			return _sortState; 
		}
		
		private function clear():void { 
			while (bg.cont.numChildren>0) { 
				bg.cont.removeChildAt(0);
			}
		}
//-----		
	}
}