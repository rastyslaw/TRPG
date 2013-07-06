package  {
	import command.ICommand;
	import events.MenuEvent;
	/** 
	 * ...
	 * @author waltasar
	 */
	public class Dispatcher {
		
		private var commandList:Vector.<ICommand>;  
		private var eventList:Vector.<String>; 
		private var menu:Menu; 
		private var game:Game;
		
		public function Dispatcher(tar:Menu, main:Game):void {
			menu = tar;
			game = main; 
			commandList = new Vector.<ICommand>();   
			eventList = new Vector.<String>(); 
		}
		
		public function setCommand(event:String, commandClassRef:Class, rec:IReceiver):void {
			commandList.push(new commandClassRef(rec));   
			eventList.push(event);  
			menu.addEventListener(event, run);   
		}
		
		public function removeCommand(command:ICommand):void {
			for (var s:int; s < commandList.length; s++ ) {
				if (commandList[s] == command) {
					commandList.splice(s, 1);
					eventList.splice(s, 1);  
				}
			}
		}
		
		public function run(e:MenuEvent):void {   
			for (var s:String in eventList) { 
				if (eventList[s] == e.type) {
					commandList[s].execute(e);
					break; 
				}
			}
		}
//-----		
	}
}