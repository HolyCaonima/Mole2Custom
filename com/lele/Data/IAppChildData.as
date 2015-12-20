package com.lele.Data
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IAppChildData 
	{
		function get Name():String;
		function get ChildApp():Sprite;
		function CleanResource();
		function Start();
		function Stop();
	}
	
}