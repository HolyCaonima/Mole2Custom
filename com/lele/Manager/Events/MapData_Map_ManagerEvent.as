package com.lele.Manager.Events
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class MapData_Map_ManagerEvent extends ManagerEventBase
	{
		//换地图事件
		public static const CHANGE_MAP:String = "换地图";
		public var CHANGE_MAP_sourceMap:String;
		public var CHANGE_MAP_spawnPoint:Point;
		public var CHANGE_MAP_targetMap:String;
		
		public static const CALLLOADAPP:String = "加载应用";
		public var CALLLOADAPP_appName:String;
		
		public function MapData_Map_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}