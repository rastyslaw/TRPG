package  {
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Levels {
		
		[Embed(source = '../assets/maps/town.png')]
		private const Tiles_Level1:Class;
		
		[Embed(source = '../assets/gfx/town.oel', mimeType = "application/octet-stream")]
		private const Level1:Class; 
		
		[Embed(source = '../assets/maps/level.png')]
		private const Tiles_Level2:Class;
		
		[Embed(source = '../assets/gfx/level.oel', mimeType = "application/octet-stream")]
		private const Level2:Class;   
		 
		private var gridsise:int; 
		private var cofmas1:Array;   
		private var rawData:ByteArray;
		
		public function Levels():void {
			gridsise = Map.grid_size; 
		} 
		
		public function getLevel(value:int, len:int):Array {
			rawData = getbyte(value); 
		    var dataString:String = rawData.readUTFBytes(rawData.length); 
		    var xmlData:XML = new XML(dataString); 
			var mainmas:Array = [];
			var width:int = xmlData.width/gridsise;
			var height:int = xmlData.height/gridsise;
			var mas:Array = [];
			for (var i:int; i < height; i++) {
				mas = []; 
				for (var j:int; j < width; j++) {
					mas.push(0);  
				}
				mainmas.push(mas);
			} 
		    var dataList:XMLList; 
		    var dataElement:XML;  
		    dataList = xmlData.grass.tile; 
			var index:int;
			   
		    for each (dataElement in dataList) {  
				index = int(dataElement.@tx) / gridsise + int(dataElement.@ty) * len / gridsise;
				mainmas[int(dataElement.@y)/gridsise][int(dataElement.@x)/gridsise] = index; 
		    }
			
			return [mainmas, getCofmas(value)];   
		}
		
		private function getbyte(value:int):ByteArray { 
			switch(value) {
				case 1:
					return new Level1();  
				break;
				case 2:
					return new Level2();  
				break;
			}
			return null;
		}
		
		private function getCofmas(value:int):Array {
			var mas:Array;
			switch(value) {
				case 1:
					mas = [210];  
				break; 
				case 2:
					mas = [5, 50, 66, 72];
				break;
			}
			return mas; 
		}
		
		public function getTileset(value:int):Bitmap {
			//return Bitmap(new (getDefinitionByName("Tiles_Level"+value)));
			switch(value) {
				case 1:
					return Bitmap(new Tiles_Level1);
				break;
				case 2:
					return Bitmap(new Tiles_Level2);
				break;
				default: return null;
			}
		}
//-----		
	}
}