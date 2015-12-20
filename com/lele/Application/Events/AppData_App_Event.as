package com.lele.Application.Events
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	public class AppData_App_Event extends Event
	{
		public static const ONMOUSEOVER = "当鼠标经过";
		public var ONMOUSEOVER_describtion:String;
		
		
		public function AppData_App_Event(evtType:String) 
		{
			super(evtType);
		}
		
	}

}