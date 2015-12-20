package com.lele.Manager.Events
{
	/**
	 * ...
	 * @author Lele
	 */
	public class Sound_Game_ManagerEvent extends ManagerEventBase
	{
		public static const SOUNDLOADEDEVENT:String = "音频数据加载完成";
		
		public function Sound_Game_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}