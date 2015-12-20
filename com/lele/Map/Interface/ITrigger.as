package com.lele.Map.Interface
{
	import com.lele.Map.Enum.TriggerType;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public interface ITrigger
	{
		function OnTrigge():void;
		function IsMeetTerm(point:Point):Boolean;
		function get _x():Number;
		function get _y():Number;
		function get _height():Number;
		function get _width():Number;
		function get _triggerType():TriggerType;
	}
	
}