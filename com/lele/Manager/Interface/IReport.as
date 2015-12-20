package com.lele.Manager.Interface
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IReport 
	{
		function OnReport(evt:Event):void//下级向上级，这个函数在上级执行
	}
	
}