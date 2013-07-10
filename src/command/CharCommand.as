package command {
	import events.MenuEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class CharCommand implements ICommand {
		
		private var receiver:IReceiver;  
		   
		public function CharCommand(rec:IReceiver):void {  
			receiver = rec;  
		}
		
		public function execute(e:MenuEvent):void { 
			receiver.showChar(e.tar);     
		}
//-----		
	}
}