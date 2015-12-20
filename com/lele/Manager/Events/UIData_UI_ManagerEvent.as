package com.lele.Manager.Events
{
	import com.lele.Controller.Avatar.Interface.ICommunication;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class UIData_UI_ManagerEvent extends ManagerEventBase
	{
		public static const SHOWUIBYURL = "显示地图";
		public var SHOWUIBYURL_url:String;
		
		public static const CALLLOADAPP = "加载应用";
		public var CALLLOADAPP_url:String;
		public var CALLLOADAPP_params:Array;
		public var CALLLOADAPP_useUI:Boolean = false;
		public var CALLLOADAPP_uiType:String;
		
		public static const CALLUNLOADAPP = "卸载应用";
		public var CALLUNLOADAPP_url:String;
		
		public static const CHANGEMAP = "换地图";
		public var CHANGEMAP_mapname:String;
		public var CHANGEMAP_point:Point
		
		public static const STOPUI = "停止UI显示";
		public var STOPUI_url:String;
		
		public static const SHOWMSG = "显示聊天窗";
		public var SHOWMSG_msg:String;
		
		public static const PASSDIALOGSTYLE = "传递消息窗";
		public var PASSDIALOGSTYLE_body:Class;
		
		public static const SHOWFRIENDLIST = "显示好友列表";
		
		public function UIData_UI_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}