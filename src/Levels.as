package  {
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author waltasar
	 */
	public class Levels {
		
		[Embed(source = '../assets/maps/town.png')]
		private const Tiles_Town1:Class;
		[Embed(source = '../assets/gfx/town.oel', mimeType = "application/octet-stream")]
		private const Town1:Class; 
		
		[Embed(source = '../assets/maps/road1.png')]
		private const Tiles_Road1:Class;
		[Embed(source = '../assets/gfx/road1.oel', mimeType = "application/octet-stream")]
		private const Road1:Class; 
		
		[Embed(source = '../assets/maps/battle1.png')]
		private const Tiles_Battle1:Class;
		[Embed(source = '../assets/gfx/battle1.oel', mimeType = "application/octet-stream")]
		private const Battle1:Class; 
		
		private var gridsise:int; 
		private var cofmas1:Array;   
		private var rawData:ByteArray;
		
		public function Levels():void {
			gridsise = Map.grid_size; 
		} 
		
		public function getLevel(value:String, len:int):Array {
			rawData = getbyte(value);
		    var dataString:String = rawData.readUTFBytes(rawData.length); 
		    var xmlData:XML = new XML(dataString); 
			var mainmas:Array = [];
			var height:int = Math.ceil(xmlData.height / gridsise);
			for (var i:int; i < height; i++) {     
				mainmas.push([]); 
			}
		    var dataList:XMLList; 
		    var dataElement:XML;   
		    dataList = xmlData.grass.tile; 
			var index:int; 
		    for each (dataElement in dataList) {  
				index = int(dataElement.@tx) / gridsise + int(dataElement.@ty) * len / gridsise;
				mainmas[int(dataElement.@y) / gridsise][int(dataElement.@x) / gridsise] = index;
		    }
			return [mainmas, getCofmas(value)];   
		}
		
		private function getbyte(value:String):ByteArray { 
			switch(value) {
				case "town1":
					return new Town1();  
				break;
				case "road1":
					return new Road1();  
				break;
				case "battle1": 
					return new Battle1();  
				break;
			}
			return null;
		} 

		private function getCofmas(value:String):Array {
			var mas:Array;
			switch(value) {
				case "town1":
					mas = [210];  
				break; 
				case "road1":
					mas = [9]; 
				break;
				case "battle1":  
					mas = [5, 10, 13, 20];
				break;
			}
			return mas; 
		} 
		
		public function getTileset(value:String):Bitmap {
			//return Bitmap(new (getDefinitionByName("Tiles_Level"+value)));
			switch(value) {
				case "town1":
					return Bitmap(new Tiles_Town1);
				break;
				case "road1":
					return Bitmap(new Tiles_Road1);
				break;
				case "battle1":  
					return Bitmap(new Tiles_Battle1);
				break;
				default: return null;
			}
		}
//-----		
	}
}