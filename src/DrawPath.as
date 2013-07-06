package  {
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * ...
	 * @author waltasar 
	 */
	public class DrawPath extends Shape implements IDrawPath { 
		  
		private var _masPath:Vector.<Point>; 
		
		public function scanAndDraw():void { 
			var grid_size:int = Map.grid_size; 
			this.graphics.clear(); 
			this.graphics.lineStyle(8, 0xff0000, 0.7); 
			var len:int = masPath.length;  
			this.graphics.moveTo(masPath[len-1].x*grid_size+(grid_size>>1), masPath[len-1].y*grid_size+(grid_size>>1));  
			for (var s:int=len-2; s >= 0; s--) {  
				this.graphics.lineTo(masPath[s].x*grid_size+(grid_size>>1), masPath[s].y*grid_size+(grid_size>>1));
			}
			this.graphics.moveTo(masPath[0].x*grid_size+16, masPath[0].y*grid_size+16);  
			this.graphics.lineTo(masPath[0].x*grid_size+grid_size-17, masPath[0].y*grid_size+grid_size-17);
			this.graphics.moveTo(masPath[0].x*grid_size+grid_size-17, masPath[0].y*grid_size+16);  
			this.graphics.lineTo(masPath[0].x*grid_size+16, masPath[0].y*grid_size+grid_size-17);
		}
		
		public function clear():void { 
			this.graphics.clear(); 
		}
		 
		public function get masPath():Vector.<Point> { return _masPath; }
		public function set masPath(value:Vector.<Point>):void { _masPath = value; }
//-----		
	}
}