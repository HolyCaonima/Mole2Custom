package  com.lele.Controller.Avatar.Events
{
	import com.lele.Manager.Events.ManagerEventBase;
	/**
	 * ...
	 * @author Lele
	 */
	public class NetWorkController_NetPlayerUnit_Event extends ManagerEventBase
	{
		public static const SHOWOTHERPLAYERINFO = "显示其他玩家面板";
		
		
		public function NetWorkController_NetPlayerUnit_Event(evtType:String) 
		{
			super(evtType);
		}
		
	}

}