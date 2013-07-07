package  {
	/**
	 * ...
	 * @author waltasar
	 */
	public class QSort {
		
		private static var i:int;  
		private static var j:int;
		private static var pivotPoint:Number;
		private static var tempStore:Number;
		private static var tempStore2:*;
		
		public static function quickSort(arrayInput:Vector.<Number>, left:int, right:int, arrayFade:*= null, dual:Boolean = false):Array {
			if (dual) {   
				var timeMas:Vector.<Number> = new Vector.<Number>(arrayInput.length, true);
				for (var s:int; s < arrayInput.length; s++ ) {
					timeMas[s] = arrayInput[s];  
				}
			} 
			
			i = left;    
			j = right;  
			pivotPoint = arrayInput[Math.round((left+right)*.5)]; 
 
			while (i<=j) {  
				while (arrayInput[i]<pivotPoint) {  
					i++;
				}    
				while (arrayInput[j]>pivotPoint) {  
					j--;
				}  
				if (i<=j) { 
					if (arrayFade != null) {
						tempStore2 = arrayFade[i];
						arrayFade[i] = arrayFade[j];
						arrayFade[j] = tempStore2; 
					}  
					tempStore = arrayInput[i];
					arrayInput[i] = arrayInput[j];
					i++;  
					arrayInput[j] = tempStore; 
					j--;
				}
			}   
			if (left<j) arrayFade==null ? quickSort(arrayInput, left, j) : quickSort(arrayInput, left, j, arrayFade); 
			if (i<right) arrayFade==null ? quickSort(arrayInput, i, right) : quickSort(arrayInput, i, right, arrayFade);
			
			var mas:Array;    
			if (!dual) mas = [arrayInput, arrayFade];
				else mas = [timeMas, arrayFade]; 
			return mas;  
		}
//-----		
	}
}