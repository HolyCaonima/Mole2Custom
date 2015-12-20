package com.lele.Manager.Events
{
	import flash.automation.AutomationAction;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class NetData_Net_ManagerEvent extends ManagerEventBase
	{
		public var _playerID:String;//玩家ID必填
		
		public static const DOACTION = "玩家Avatar做动作";
		public var DOACTION_name:String;//标识动作的名称
		public var DOACTION_direction:String;//标识动作方向
		
		public static const ADDNETPLAYER = "添加网络玩家";
		public var ADDNETPLAYER_color:String;//玩家颜色
		public var ADDNETPLAYER_name:String;//名字
		public var ADDNETPLAYER_spownPoint:Point;
		public var ADDNETPLAYER_map:String;
		
		public static const LOGINRESULT = "登录结果";
		public var LOGINRESULT_result:String;
		
		public static const NETPLAYERMOVE = "网络玩家移动";
		public var NETPLAYERMOVE_target:Point;
		
		public static const REMOVENETPLAYER = "移除网络玩家";
		
		public static const NETPLAYERSAY = "网络玩家说";
		public var NETPLAYERSAY_msg:String;
		
		public static const CHANGEWEATHER = "改变天气";
		public var CHANGEWEATHER_weather:String;
		public var CHANGEWEATHER_strength:int;
		
		public static const CREATACCOUNTRESULT = "创建账户CallBack";
		public var CREATACCOUNTRESULT_result:Boolean;
		public var CREATACCOUNTRESULT_id:String;
		
		public static const FRIENDCHATRECEIVE = "好友聊天接收";
		public var FRIENDCHATRECEIVE_from:String;
		public var FRIENDCHATRECEIVE_msg:String;
		public var FRIENDCHATRECEIVE_time:String;
		
		public static const MOLEBASEINFO = "摩尔基础数据";
		public var MOLEBASEINFO_num:int;
		public var MOLEBASEINFO_name:String;
		public var MOLEBASEINFO_color:String;
		
		public static const CREATEMOLEBACK = "创建摩尔信息反馈";
		public var CREATEMOLEBACK_result:Boolean;
		
		public static const NETTHROWITEM = "投掷信息返回";
		public var NETTHROWITEM_itemStyle:String;
		public var NETTHROWITEM_position:Point;
		public var NETTHROWITEM_action:String;
		public var NETTHROWITEM_dir:String;
		public var NETTHROWITEM_blood:Number;
		public var NETTHROWITEM_id:String;
		
		public static const CHATLISTDATABACK = "聊天列表信息返回";
		public var CHATLISTDATABACK_dataField:String;
		public var CHATLISTDATABACK_isAppend:Boolean;
		public var CHATLISTDATABACK_totalNum:int;
		public var CHATLISTDATABACK_num:int;
		public var CHATLISTDATABACK_colors:String;
		public var CHATLISTDATABACK_ids:String;
		public var CHATLISTDATABACK_isOnlines:String;
		public var CHATLISTDATABACK_names:String;
		public var CHATLISTDATABACK_stys:String;
		
		public static const FRIENDLOGIN = "好友登录";
		public var FRIENDLOGIN_id:String;
		
		public static const FRIENDOFFLINE = "好友离线";
		public var FRIENDOFFLINE_id:String;
		
		public static const XMFRIEND = "加好友请求";
		public var XMFRIEND_id:String;
		public var XMFRIEND_name:String;
		
		public static const NOTEY = "小纸条";
		public var NOTEY_title:String;
		public var NOTEY_content:String;
		
		public function NetData_Net_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}