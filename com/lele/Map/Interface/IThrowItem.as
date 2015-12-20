package com.lele.Map.Interface
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IThrowItem 
	{
		function Start(from:Point,to:Point);
		function SetCallBack(callBack:Function);
		function get From():Point;
		function get To():Point;
	}
	
}