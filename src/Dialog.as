package  {
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import npc.NPC;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Dialog extends Sprite {
		
		private var heroIco:Bitmap;
		private var tarIco:Bitmap;
		private var heroImg:Bitmap;
		private var words:Array;
		private var replic:Replic;
		private var heroSay:Boolean;
		private var index:int;
		private var _target:NPC;
		private var replicTimer:Timer;
		
		public function Dialog(tar:NPC, bmp:Bitmap) {
			heroImg = bmp;
			_target = tar;
			tarIco = tar.getIco();
			words = DialogResourse.getReplicsMas(tar.type);
			
			replic = new Replic;   
			addChild(replic);
			replic.addChild(tarIco); 
			replic.info.info.text = words[index];
			replic.scrol.visible = false;  
			if (replic.info.info.numLines > 3) replic.scrol.visible = true;
			replic.info.info.height = replic.info.info.textHeight;
				
			TweenLite.to(this, .6, { y:Constants.STAGE_HEIGHT - this.height - 6 } );
			replic.addEventListener(MouseEvent.CLICK, nextWords);
			
			replicTimer = new Timer(4000, 1);
			replicTimer.addEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
			replicTimer.start(); 
		}
		 
		private function nextWords(e:MouseEvent):void {
			if (replic.scrol.visible) { 
				var i:int = replic.info.info.maxScrollV - replic.info.info.bottomScrollV;
				if ( i * 27 != replic.info.info.y) { 
					replic.info.info.y -= 27; 
				}
				else traceNext(); 
			}   
			else traceNext();
		}
		
		private function traceNext():void {
			if (replicTimer.running) {
				replicTimer.stop();
				replicTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
			}
			replic.info.info.y = 0;
			index++;
			if (index >= words.length) {
				kill(); 
				return; 
			}
			if (heroSay) replic.removeChild(heroImg);
			else replic.removeChild(tarIco); 
			replic.info.info.text = words[index];
			replic.scrol.visible = false;  
			if (replic.info.info.numLines > 3) replic.scrol.visible = true;
			replic.info.info.height = replic.info.info.textHeight;
			if (heroSay) replic.addChild(tarIco);
			else replic.addChild(heroImg); 
			heroSay = !heroSay;
			
			replicTimer = new Timer(4000, 1);
			replicTimer.addEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
			replicTimer.start();
		}
		
		private function killreplictick(e:TimerEvent):void {
			replicTimer.stop(); 
			replicTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, killreplictick);
			traceNext();  
		}
		
		private function kill():void {  
			dispatchEvent(new Event("DIALOG_OFF"));
			replic.removeEventListener(MouseEvent.CLICK, nextWords);
			this.parent.removeChild(this);
		}
		
		public function get target():NPC {
			return _target; 
		}
		
//-----		
	}
}