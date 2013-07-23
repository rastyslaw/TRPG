package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import spell.effect.IEffect;
	import spell.IIcon;
	import spell.skill.ISkill;
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
		 
		[Embed(source = "../assets/spell.xml", mimeType = "application/octet-stream")]
		public static const ImgXMLData:Class;
 
		[Embed(source = "../assets/spell.png")]  
		public static const ImgData:Class;
		
		private var main:CharWindow;
		private var unit:Unit; 
		private var bg:CharBg;
		private var _state:String;
		private var lootXml:XML;
		private var spellXml:XML;  
		private var lootMas:Array; 
		private var botom:int;
		private var texture:Bitmap; 
		private var spellgr:Bitmap;
		private var _sortState:String = "all";
		private var cont:Sprite;
		private var contEffect:Sprite;
		
		public function CharacterInfo(tar:Unit, mas:Array) {
			lootMas = mas;
			texture = Bitmap(new TextureData()); 
			lootXml = XML(new TextureXMLData());
			spellgr = Bitmap(new ImgData()); 
			spellXml = XML(new ImgXMLData());  
			unit = tar;  
			main = new CharWindow();   
			addChild(main); 
			bg = main.bg;
			init(); 
			if(!unit.enemy) createPanels();   
			main.close.addEventListener(MouseEvent.CLICK, closed);
			state = "atr";  
		}
		
		private function createPanels():void {  
			cont = new Sprite; 
			var bmpd:BitmapData;
			var bmp:Bitmap;
			var Width:Number;
			var Height:Number;
			var skilmas:*;
			var i:int;
			var ico:String;
			var spe:Sprite;
			var nam:String; 
			if (unit.type != "mage") skilmas = unit.skills;
			else skilmas = MageUnit(unit).spellMas;
			for (i=0; i < skilmas.length; i++) {
				ico = IIcon(skilmas[i]).ico;
			    bmp = new Bitmap;  
				Width = spellXml.SubTexture.(attribute('name') == ico).@width;
				Height = spellXml.SubTexture.(attribute('name') == ico).@height;
				bmpd = new BitmapData(Width, Height);  
				bmpd.copyPixels(spellgr.bitmapData,      
                       new Rectangle(spellXml.SubTexture.(attribute('name') == ico).@x, spellXml.SubTexture.(attribute('name') == ico).@y, Width, Height), 
                       new Point(0, 0)); 
				bmp.bitmapData = bmpd; 
				nam = getQualifiedClassName(skilmas[i]);
				nam = nam.replace("spell.skill::", "");
				nam = nam.replace("spell::", "");
				bmp.name = nam;
				spe = new Sprite; 
				spe.addChild(bmp); 
				cont.addChild(spe); 
				spe.name = IIcon(skilmas[i]).description;  
				spe.x = i*65;     
				spe.scaleX = spe.scaleY = .8;   
			}
			cont.y = 56; 
			cont.x = -10 - cont.width >> 1;
			//
			contEffect = new Sprite; 
			var goodEffect:Sprite = new Sprite;
			var badEffect:Sprite = new Sprite;
			var effectMas:Vector.<IEffect> = unit.effects; 
			for (i=0; i < effectMas.length; i++) {
				ico = IIcon(effectMas[i]).ico; 
			    bmp = new Bitmap;  
				Width = spellXml.SubTexture.(attribute('name') == ico).@width;
				Height = spellXml.SubTexture.(attribute('name') == ico).@height;
				bmpd = new BitmapData(Width, Height);  
				bmpd.copyPixels(spellgr.bitmapData,      
                       new Rectangle(spellXml.SubTexture.(attribute('name') == ico).@x, spellXml.SubTexture.(attribute('name') == ico).@y, Width, Height), 
                       new Point(0, 0)); 
				bmp.bitmapData = bmpd;
				nam = getQualifiedClassName(effectMas[i]);
				nam = nam.replace("spell.skill::", "");
				nam = nam.replace("spell::", "");  
				bmp.name = nam;
				spe = new Sprite;
				spe.addChild(bmp); 
				if (effectMas[i].insalubrity()) badEffect.addChild(spe);
				else goodEffect.addChild(spe);
				spe.name = IIcon(effectMas[i]).description; 
				spe.x = i*30;      
				spe.scaleX = spe.scaleY = .3;  
			} 
			contEffect.addChild(badEffect);
			badEffect.x = 370 - badEffect.width;  
			contEffect.addChild(goodEffect);
			contEffect.y = 120;   
			contEffect.x = -185;
			cont.addEventListener(MouseEvent.MOUSE_OVER, show_spellinfo);
			cont.addEventListener(MouseEvent.MOUSE_OUT, hide_spellinfo); 
			contEffect.addEventListener(MouseEvent.MOUSE_OVER, show_effectinfo);
			contEffect.addEventListener(MouseEvent.MOUSE_OUT, hide_effectinfo);
		}
		
		private function show_spellinfo(e:MouseEvent):void {
			var obg:Sprite = e.currentTarget as Sprite;
			bg.infoSpell.visible = true;
			var p:Point = obg.localToGlobal(new Point(e.target.x, e.target.y));
			p = bg.globalToLocal(p); 
			bg.infoSpell.x = p.x;    
			bg.infoSpell.y = p.y;   
			bg.infoSpell.info.text = e.target.name; 
			bg.infoSpell.nam.text = Sprite(e.target).getChildAt(0).name; 
		}
		
		private function hide_spellinfo(e:MouseEvent):void {
			bg.infoSpell.visible = false; 
		}  
		 
		private function show_effectinfo(e:MouseEvent):void {
			var obg:Sprite = e.currentTarget as Sprite;
			bg.infoEffect.visible = true;
			var p:Point = obg.localToGlobal(new Point(e.target.x, e.target.y));
			p = bg.globalToLocal(p); 
			bg.infoEffect.x = p.x;    
			bg.infoEffect.y = p.y;   
			bg.infoEffect.info.text = e.target.name;
		}
		
		private function hide_effectinfo(e:MouseEvent):void {
			bg.infoEffect.visible = false; 
		} 
		
		private function init():void {
			main.ico.addChildAt(unit.getIco(), 0); 
			main.level.text = String(unit.level); 
			main.infoProgress.text = String(unit.exp);
			main.progress.lod.width = unit.exp * 96 / 100;  
			if (!unit.enemy) main.clas.text = unit.getClassName();
			else main.clas.text = "";  
			main.nam.text = unit.getName(); 
			refreshHpMp();
		}
		 
		private function refreshHpMp():void {  
			var hpadd:int;
			var mpadd:int;
			var mas:Array = unit.getBonus();
			var index:int; 
			var reg:RegExp =/\D+/;
			var ss:String;
			for each (var s:String in mas) {
				ss = reg.exec(s);
				switch(ss) { 
					case "HP":
						hpadd =  int(s.substr(0, s.search(ss)));
					break; 
					case "MP":   
						if (unit.type == "mage") mpadd = int(s.substr(0, s.search(ss)));
					break;
				}
			}
			main.hp.text = String((unit.hp+hpadd) + "/" + (unit.max_hp+hpadd)); 
			if (unit.type == "mage") main.mp.text = String((MageUnit(unit).mp+mpadd) + "/" + (MageUnit(unit).max_mp+mpadd));
			unit.hpBar.tt.text = String(unit.hp);  
		} 
		 
		private function atr_open(e:MouseEvent = null):void {
			main.attributes.removeEventListener(MouseEvent.CLICK, atr_open);
			bg.gotoAndStop(1);
			var mas:Array = unit.getBonus();
			var index:int; 
			var reg:RegExp =/\D+/;
			var ss:String;
			for each (var s:String in mas) {
				ss = reg.exec(s);
				switch(ss) {
					case "AT": 
						bg.at.text = String(int(bg.at.text) + int( s.substr(0, s.search(ss)) ));
					break;
					case "DF":
						bg.df.text = String(int(bg.df.text) + int( s.substr(0, s.search(ss)) ));
					break;
					case "AG": 
						bg.ag.text = String(int(bg.ag.text) + int( s.substr(0, s.search(ss)) ));
					break;
					case "MV":  
						bg.mv.text = String(int(bg.mv.text) + int( s.substr(0, s.search(ss)) ));
					break;
				} 
			}
			bg.df.text = String(unit.def);  
			bg.ag.text = String(unit.agi);  	   
			bg.mv.text = String(unit.speed);
			bg.info.text = unit.description;
			bg.at.text = String(unit.att); 
			bg.infoSpell.visible = bg.infoSpell.mouseEnable = false;
			bg.infoEffect.visible = bg.infoEffect.mouseEnable = false; 
			if(!unit.enemy) {
				bg.addChild(cont); 
				bg.addChild(contEffect);
				bg.setChildIndex(bg.infoSpell, bg.numChildren-1); 
				bg.setChildIndex(bg.infoEffect, bg.numChildren-1);  
			} 
			if (!unit.summon && !unit.enemy) main.inventory.addEventListener(MouseEvent.CLICK, inv_open); 
			else main.inventory.visible = false; 
		}
		
		private function inv_open(e:MouseEvent=null):void { 
			main.inventory.removeEventListener(MouseEvent.CLICK, inv_open);
			bg.removeChild(cont); 
			bg.removeChild(contEffect);
			bg.gotoAndStop(2);
			bg.infoLoot.visible = false;  
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
				place.mas = lootMas[i];  
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
			 
			bg.helm_slot.addEventListener(MouseEvent.CLICK, remove);
			bg.weapon_slot.addEventListener(MouseEvent.CLICK, remove);
			bg.shield_slot.addEventListener(MouseEvent.CLICK, remove);
			bg.boots_slot.addEventListener(MouseEvent.CLICK, remove);
			bg.chest_slot.addEventListener(MouseEvent.CLICK, remove);  
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
				item.mas = mas[j]; 
				if (mas[j][0].search("weapon") != -1) bg.weapon_slot.addChild(item);
				else if (mas[j][0].search("boots") != -1) bg.boots_slot.addChild(item); 
				else if (mas[j][0].search("chest") != -1) bg.chest_slot.addChild(item);
				else if (mas[j][0].search("helm") != -1) bg.helm_slot.addChild(item); 
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
			var item:Loot = Loot(e.currentTarget);
			item.removeEventListener(MouseEvent.MOUSE_OVER, showStat);
			bg.infoLoot.visible = true;
			var p:Point;
			var bol:Boolean = bg.cont.contains(item);
			var slot:Place = Place(bg.getChildByName(item.slot + "_slot"));
			var back:Loot; 
			if (slot.numChildren > 1) back = Loot(slot.getChildAt(1)); 
			if (bol) {   
				p = bg.cont.localToGlobal(new Point(item.x, item.y));
				p = bg.globalToLocal(p); 
			}
			else {  
				p = item.parent.localToGlobal(new Point(item.x, item.y));
				p = bg.globalToLocal(p);
			}
			bg.infoLoot.x = p.x;   
			bg.infoLoot.y = p.y;
			
			for (var i:int=1; i < bg.infoLoot.numChildren; i++) {
				bg.infoLoot.getChildAt(i).visible = false;  
			} 
			bg.infoLoot.at_stat.y = -12;
			bg.infoLoot.df_stat.y = bg.infoLoot.at_stat.y + 24; 
			bg.infoLoot.ag_stat.y = bg.infoLoot.df_stat.y + 24;
			bg.infoLoot.hp_stat.y = bg.infoLoot.ag_stat.y + 24; 
			bg.infoLoot.mp_stat.y = bg.infoLoot.hp_stat.y + 24;
			bg.infoLoot.complect.y = bg.infoLoot.mp_stat.y + 24;
			bg.infoLoot.bg.height = 190;
				 
			var per:int;  
			var iter:int = 24; 
			if (item.att > 0) {   
				bg.infoLoot.at_stat.visible = true;
				bg.infoLoot.at_stat._add.text = "";   
				bg.infoLoot.at_stat.num.text = String(item.att);
				if (bol && back != null) infoLine(bg.infoLoot.at_stat, item.att, back.att);
			}
			else per += iter;
			if (item.def > 0) {
				bg.infoLoot.df_stat.y -= per; 
				bg.infoLoot.df_stat.visible = true; 
				bg.infoLoot.df_stat._add.text = "";   
				bg.infoLoot.df_stat.num.text = String(item.def);   
				if (bol && back != null) if (bol && back != null) infoLine(bg.infoLoot.df_stat, item.def, back.def);
			}
			else per += iter;
			if (item.agi > 0) {
				bg.infoLoot.ag_stat.y -= per; 
				bg.infoLoot.ag_stat.visible = true; 
				bg.infoLoot.ag_stat._add.text = "";   
				bg.infoLoot.ag_stat.num.text = String(item.agi);   
				if (bol && back != null) if (bol && back != null) infoLine(bg.infoLoot.ag_stat, item.agi, back.agi);
			}
			else per += iter;
			if (item.hp > 0) {
				bg.infoLoot.hp_stat.y -= per; 
				bg.infoLoot.hp_stat.visible = true; 
				bg.infoLoot.hp_stat._add.text = "";   
				bg.infoLoot.hp_stat.num.text = String(item.hp);   
				if (bol && back != null) if (bol && back != null) infoLine(bg.infoLoot.hp_stat, item.hp, back.hp);
			}
			else per += iter;
			if (item.mp > 0) {
				bg.infoLoot.mp_stat.y -= per; 
				bg.infoLoot.mp_stat.visible = true; 
				bg.infoLoot.mp_stat._add.text = "";   
				bg.infoLoot.mp_stat.num.text = String(item.mp);   
				if (bol && back != null) if (bol && back != null) infoLine(bg.infoLoot.mp_stat, item.mp, back.mp);
			}
			else per += iter; 
			  
			if (item.sett != null) {
				var s:String = item.sett;
				bg.infoLoot.complect.visible = true;
				bg.infoLoot.complect.y -= per;    
				bg.infoLoot.complect.num.text = s;
				bg.infoLoot.complect.b1.text = Game.setsMas[s][0];
				bg.infoLoot.complect.b2.text = Game.setsMas[s][1];
				bg.infoLoot.complect.b1.textColor = bg.infoLoot.complect.b2.textColor = 0xff0000;
				var k:int;
				var mas:Array = unit.itemMas;
				for (var j:int; j < mas.length; j++) {
					if (mas[j][6]==s) k++;
				}
				if (k > 1) bg.infoLoot.complect.b1.textColor = 0x00ff00;
				if (k > 3) bg.infoLoot.complect.b2.textColor = 0x00ff00; 
			}
			else per += bg.infoLoot.complect.height;  
			bg.infoLoot.bg.height -= per; 
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OUT, hideStat);
		}
		 
		private function infoLine(obg:MovieClip, now:int, prew:int):void {
			if (Math.abs(now - prew) == 0) {
				obg._add.text = "";
				return;
			} 
			obg._add.text = "("+String(now - prew)+")";   
			if (prew < now) obg._add.textColor = "0x00ff00";
			else obg._add.textColor = "0xff0000"; 
		}
		
		private function hideStat(e:MouseEvent):void {
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, hideStat);
			bg.infoLoot.visible = false;  
			e.currentTarget.addEventListener(MouseEvent.MOUSE_OVER, showStat); 
		}
		
		private function equip(e:MouseEvent):void {
			var loot:Loot = Loot(e.currentTarget);
			e.currentTarget.removeEventListener(MouseEvent.CLICK, equip); 
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
				else if( loot.who.search(unit.sname) != -1 ) equipCurItem(loot);    
  			}
			refreshHpMp(); 
		} 
		
		private function remove(e:MouseEvent):void {
			if (e.currentTarget.numChildren > 1) { 
				var item:Loot = e.currentTarget.getChildAt(1);
				e.currentTarget.removeChild(item); 
				bg.cont.addChild(item);
				item.addEventListener(MouseEvent.CLICK, equip);   
				lootMas.push(item.mas);
				var mas:Array = unit.itemMas;
					for (var j:int; j < mas.length; j++) {
						if (mas[j][0]==item.who) {
							mas.splice(j, 1);  
						}
					}     
			}
			sorting(sortState);
			refreshHpMp(); 
		}  
		 
		private function equipCurItem(item:Loot):void {
			for (var i:int; i < bg.cont.numChildren; i++) {
				if (bg.cont.getChildAt(i) == item) {    
					bg.cont.removeChild(item); 
					item.removeEventListener(MouseEvent.CLICK, equip); 
					lootMas.splice(i, 1); 
				}   
			}
			var bol:Boolean;  
			var lot:Loot;
			var place:Place = Place(bg.getChildByName(item.slot + "_slot"));
			if (place.numChildren > 1) {
					lot = Loot(place.getChildAt(1));
					place.removeChild(lot);
					bol = true;  
				}
			place.addChild(item);  
			item.x = item.y = 0;  
			 
			var mas:Array = unit.itemMas;
			if (bol) { 
				bg.cont.addChild(lot);
				lootMas.push(lot.mas);  
				lot.addEventListener(MouseEvent.CLICK, equip); 
				for (var j:int; j < mas.length; j++) {
					if (mas[j][0]==lot.who) {
						mas.splice(j, 1); 
					}
				}      
			}   
			item.addEventListener(MouseEvent.MOUSE_OVER, showStat); 
			mas.push(item.mas);
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
					if (loot.who.search(unit.sname) == -1) {
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