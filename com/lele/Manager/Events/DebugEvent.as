package com.lele.Manager.Events
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	public class DebugEvent extends Event
	{
		public static const DEBUG:String = "showDebug";
		private var _log:String;
		
		public function DebugEvent(log:String) 
		{
			_log = log;
			super(DEBUG);
		}
		
		public function get Log():String
		{
			return _log;
		}
		
	}

}