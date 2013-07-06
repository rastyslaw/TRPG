package command {
	import events.MenuEvent;
	/**
	 * ...
	 * @author waltasar
	 */
	public interface ICommand {
		function execute(e:MenuEvent):void;
	}
//-----	
} 