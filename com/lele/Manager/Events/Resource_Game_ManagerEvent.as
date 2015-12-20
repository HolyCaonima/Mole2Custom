package com.lele.Manager.Events
{
	/**
	 * ...
	 * @author Lele
	 */
	public class Resource_Game_ManagerEvent extends ManagerEventBase
	{
		public static const LOADINGPROCESSEVENT:String = "加载进程";
		public var _process:int;
		public var _type:String;
		public var _isComplete:Boolean;
		
		public function Resource_Game_ManagerEvent(evtType:String)
		{
			super(evtType);
		}
		
	}

}