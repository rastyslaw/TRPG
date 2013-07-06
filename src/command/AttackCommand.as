package command {
	import events.MenuEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public class AttackCommand implements ICommand {
		
		private var receiver:IReceiver;  
		  
		public function AttackCommand(rec:IReceiver):void {  
			receiver = rec;
		}
		
		public function execute(e:MenuEvent):void { 
			receiver.attack(e.tar);     
		}
//-----		
	}
}