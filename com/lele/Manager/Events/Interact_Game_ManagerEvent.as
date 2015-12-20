package com.lele.Manager.Events
{
	/**
	 * ...
	 * @author Lele
	 */
	public class Interact_Game_ManagerEvent extends ManagerEventBase
	{
		public static const CALLUIMANAGERLOADCLICKMC:String = "UI管理器加载点击动画";
		
		
		public function Interact_Game_ManagerEvent(evtType:String) 
		{
			super(_evtType);
		}
		
	}

}