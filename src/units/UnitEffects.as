package units {
	/**
	 * ...
	 * @author waltasar
	 */
	public class UnitEffects implements ISubject {
		
		private var duplicate:Boolean;
		private var observers:Vector.<IObserver> = new Vector.<IObserver>;
		 
		public function subscribeObserver(newObs:IObserver):void {
			duplicate = false;
			for each(var o:IObserver in observers) { 
				if (o == newObs) {
					duplicate = true;
					break;
				}
			}
			if (!duplicate) observers.push(newObs);    
		} 
		
		public function unsubscribeObserver(del:IObserver):void {
			for (var o:int; o < observers.length; o++ ) {
				if (observers[o] == del) { 
					observers.splice(o, 1);    
				} 
			} 
		} 
		 
		public function notifyObserver():void {
			for each(var o:IObserver in observers) {
				o.update();       
			}
		}
//-----		
	}
}