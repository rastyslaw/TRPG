package units {
	/**
	 * ...
	 * @author waltasar
	 */ 
	public interface ISubject { 
		function subscribeObserver(o:IObserver):void; 
		function unsubscribeObserver(o:IObserver):void; 
		function notifyObserver():void;   
	}
//-----	
} 