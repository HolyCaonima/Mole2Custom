package com.lele.Plugin.RoadFind.Interface
{
	import flash.geom.Point;
	import com.lele.Map.Interface.IBitMapUtil;
	/**
	 * ...
	 * @author Lele
	 */
	public interface IRoadFinder 
	{
		function GetBlock():int;
		function IsRoadNodeAvilable():Boolean;
		function FindRoad(poSource:Point, poTarget:Point);
		function GetState(point:Point):int
		function get RoadNode():Array;
		function get ChangeNode():Array;
		function get IniOptimizatimes():int;
		function set IniOptimizatimes(times:int);
		function CreatRoadDataFromMapData(bitMapUtil:IBitMapUtil)
	}
	
}