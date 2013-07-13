package command {
	import events.MenuEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class CastCommand implements ICommand {
		
		private var receiver:IReceiver;  
		  
		public function CastCommand(rec:IReceiver):void {  
			receiver = rec;  
		}
		
		public function execute(e:MenuEvent):void { 
			receiver.castNow(e.tar);      
		}
//-----		
	}
}