package com.lele.Controller.Avatar.Events
{
	import com.lele.Manager.Events.ManagerEventBase;
	/**
	 * ...
	 * @author Lele
	 */
	public class Avatar_PlayerController_Event extends ManagerEventBase
	{
		public static const CALLOFFROTATEAROUND = "请求停止任意旋转";
		
		public static const CALLONROTATEAROUND = "请求开始旋转";
		
		public static const BECLICKED = "被点击";
		
		public function Avatar_PlayerController_Event(evtType:String) 
		{
			super(evtType);
		}
		
	}

}