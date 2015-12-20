package com.lele.Manager.Events
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	public class ManagerEventBase extends Event//最终效果是"管理器基事件:balabalabalabala"
	{
		public static const MANAGEREVENTBASE:String = "管理器基事件";
		
		private var _evtType:String;
		
		public function ManagerEventBase(evtType:String) 
		{
			_evtType = evtType;
			super(MANAGEREVENTBASE+":"+evtType);
		}
		
		public function get EvtType():String
		{
			return _evtType;
		}
		
	}

}