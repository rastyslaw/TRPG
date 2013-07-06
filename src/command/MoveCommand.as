package command {
	import events.MenuEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class MoveCommand implements ICommand {
		
		private var receiver:IReceiver;  
		  
		public function MoveCommand(rec:IReceiver):void {  
			receiver = rec;  
		}
		
		public function execute(e:MenuEvent):void { 
			receiver.getPath(e.tar.speed);    
		}
//-----		
	}
}