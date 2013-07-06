package command {
	import events.MenuEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class FinishCommand implements ICommand {
		
		private var receiver:IReceiver;  
		   
		public function FinishCommand(rec:IReceiver):void {  
			receiver = rec;  
		} 
		
		public function execute(e:MenuEvent):void { 
			receiver.finishMovement(e.tar);     
		}
//-----		
	}
}