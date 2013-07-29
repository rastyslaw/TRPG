package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author waltasar
	 */
	public class FaceAssets {
		
		[Embed(source = "../assets/faces.xml", mimeType = "application/octet-stream")]
		public static const TextureFaces:Class;
 
		[Embed(source = "../assets/faces.png")]  
		public static const Faces:Class; 
		
		private static var faceXML:XML; 
		private static var texture:Bitmap; 
		
		public function FaceAssets():void {
			texture = Bitmap(new Faces());  
			faceXML = XML(new TextureFaces());
		}
		  
		public static function getIco(s:String):Bitmap {  
			var Width:Number = faceXML.SubTexture.(attribute('name') == s).@width;;
			var Height:Number = faceXML.SubTexture.(attribute('name') == s).@height;
			var bmpd:BitmapData = new BitmapData(Width, Height);
			var bmp:Bitmap = new Bitmap; 
			bmpd.copyPixels(texture.bitmapData,      
                      new Rectangle(faceXML.SubTexture.(attribute('name') == s).@x, faceXML.SubTexture.(attribute('name') == s).@y, Width, Height), 
                      new Point(0, 0)); 
			bmp.bitmapData = bmpd; 
			return bmp; 
		}
//-----		
	}
}