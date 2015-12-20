package com.lele.Manager.Events
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class Map_Game_ManagerEvent extends ManagerEventBase
	{
		public static const MAPLOADED:String = "地图加载完成";
		
		public static const REMOVE_MAP:String = "移除地图";
		public var _map:Object
		
		public static const CHANGE_MAP:String = "换地图";
		public var CHANGE_MAP_sourceMap:String;
		public var CHANGE_MAP_spawnPoint:Point;
		public var CHANGE_MAP_targetMap:String;
		
		public static const CALLLOADAPP:String = "加载应用";
		public var CALLLOADAPP_appName:String;
		
		public function Map_Game_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}