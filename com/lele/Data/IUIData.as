package com.lele.Data
{
	import com.lele.Manager.Interface.IReport;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IUIData
	{
		function get UI():Sprite;
		function get FileUrl():String;
		function set Repoter(repote:IReport);
		function CleanResource();
		function OnClick(position:Point);
		function GoToAndPlay(frame:Object);
		function GoToAndStop(frame:Object);
	}
	
}