package com.lele.Data
{
	import com.lele.Manager.Interface.IReport;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IAppData 
	{
		function get App():Sprite;
		function get FileUrl():String;
		function set Repoter(repote:IReport);
		function CleanResource();
		
		function Start(arg:Array=null);//由外部执行
		function Stop();//由外部执行
	}
	
}