package com.lele.Manager.Events
{
	import com.lele.Controller.Avatar.Interface.ICommunication;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class UI_Game_ManagerEvent extends ManagerEventBase
	{
		public static const UILOADEDEVENT:String = "UI加载完成";
		
		public static const LOADINGBARLOADEDEVENT:String = "加载条加载完成";
		public var loadingType:String;
		
		public static const LOADINGPROCESSEVENT:String = "加载进程";
		public var _process:int;
		public var _type:String;
		public var _isComplete:Boolean;
		
		public static const CALLMAPMANAGERCHANGEMAP:String = "使MapManager加载地图";
		public var CALLMAPMANAGERCHANGEMAP_spawnPoint:Point;
		public var CALLMAPMANAGERCHANGEMAP_targetMap:String;
		public var CALLMAPMANAGERCHANGEMAP_sourceMap:String;
		
		public static const CALLLOADAPP:String = "请求加载应用";
		public var CALLLOADAPP_url:String;
		public var CALLLOADAPP_params:Array;//可选
		public var CALLLOADAPP_useUI:Boolean = false;
		public var CALLLOADAPP_uiType:String;
		
		public static const CALLUNLOADAPP:String = "请求卸载应用";
		public var CALLUNLOADAPP_url:String;
		
		public static const PASSDIALOGSTYLE:String = "消息窗口";//就是在底下发信息时弹出的那个
		public var PASSDIALOGSTYLE_body:Class;
		
		public static const SHOWMSG:String = "显示消息";
		public var SHOWMSG_msg:String;
		
		public static const SHOWFRIENDLIST:String = "显示好友列表";
		
		public function UI_Game_ManagerEvent(evtType:String) 
		{
			loadingType = evtType;
			super(evtType);
		}
		
	}

}