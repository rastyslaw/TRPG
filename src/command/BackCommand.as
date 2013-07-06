package command {
	import events.MenuEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class BackCommand implements ICommand {
		
		private var receiver:IReceiver;  
		   
		public function BackCommand(rec:IReceiver):void {  
			receiver = rec;  
		} 
		
		public function execute(e:MenuEvent):void { 
			receiver.backMovement(e.tar);      
		}
//-----		
	}
}