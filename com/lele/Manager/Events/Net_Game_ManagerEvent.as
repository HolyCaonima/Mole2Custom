package com.lele.Manager.Events
{
	import flash.geom.Point;
	import flash.globalization.StringTools;
	/**
	 * ...
	 * @author Lele
	 */
	public class Net_Game_ManagerEvent extends ManagerEventBase
	{
		public var _playerID:String;
		
		public static const DOACTION = "玩家Avatar做动作";
		public var DOACTION_name:String;//标识动作的名称
		public var DOACTION_direction:String;//标识动作方向
		
		public static const ADDNETPLAYER = "添加网络玩家";
		public var ADDNETPLAYER_color:String;//玩家颜色
		public var ADDNETPLAYER_name:String;//名字
		public var ADDNETPLAYER_spownPoint:Point;//出生点
		public var ADDNETPLAYER_map:String;
		
		public static const LOGININ = "登录";
		public var LOGININ_GAME_playerKey:String;//账号
		public var LOGININ_GAME_playerSecret:String;//密码
		
		public static const LOGINRESULT = "登录结果";
		public var LOGINRESULT_result:String;//结果
		
		public static const NETPLAYERMOVE = "网络玩家移动";
		public var NETPLAYERMOVE_point:Point;
		
		public static const LOCALPLAYERMOVE_GAME = "本地的玩家移动";
		public var LOCALPLAYERMOVE_GAME_target:Point;
		
		public static const NETUPDATE_GAME = "更新网络基础信息";
		public var NETUPDATE_GAME_map:String;
		public var NETUPDATE_GAME_position:Point;
		
		public static const NETPLAYERLISTAPPLY_GAME = "请求更新所有当前区域玩家";
		public var NETPLAYERLISTAPPLY_GAME_map:String;//再次更新基础地图数据确保无误
		
		public static const DISUPDATE_GAME = "请求远程服务端disUpdate";
		
		public static const REMOVENETPLAYER = "移除网络玩家";
		
		public static const NETDOACTION_GAME = "同步动作";//同步动作，各种动态表情
		public var NETDOACTION_GAME_name:String;
		public var NETDOACTION_GAME_dir:String;
		
		public static const SUBMITARTICLE_GAME = "提交文章";
		public var SUBMITARTICLE_GAME_head:String;
		public var SUBMITARTICLE_GAME_body:String;
		
		public static const NETCHATMSG_GAME = "聊天信息";//不是那个专门的
		public var NETCHATMSG_GAME_msg:String; 
		
		public static const NETCHATMSG = "聊天";
		public var NETCHATMSG_msg:String;
		
		public static const WEATHER_GAME = "请求天气";//获取天气数据
		
		public static const CHANGEWEATHER = "改变天气";
		public var CHANGEWEATHER_weather:String;
		public var CHANGEWEATHER_strength:int;
		
		public static const CREATACCOUNT_GAME = "创建账号";
		public var CREATACCOUNT_GAME_pwd:String;
		
		public static const CREATEMOLE_GAME = "创建摩尔";
		public var CREATEMOLE_GAME_color:String;
		public var CREATEMOLE_GAME_name:String;
		
		public static const CREATACCOUNTRESULT = "创建账号结果";
		public var CREATACCOUNTRESULT_result:Boolean;
		public var CREATACCOUNTRESULT_id:String;
		
		public static const APPLYMOLELOGININFO = "请求摩尔登录数据";
		
		public static const MOLEBASEINFO = "摩尔本玩家基础数据"//返回
		public var MOLEBASEINFO_num:int;
		public var MOLEBASEINFO_name:String;
		public var MOLEBASEINFO_color:String;
		
		public static const CREATEMOLEBACK = "创建摩尔信息反馈";
		public var CREATEMOLEBACK_result:Boolean;
		
		public static const CALLNETTHROWITEM_GAME = "传播网络投掷信息";
		public var CALLNETTHROWITEM_GAME_itemStyle:String;
		public var CALLNETTHROWITEM_GAME_position:Point;
		public var CALLNETTHROWITEM_GAME_action:String;
		public var CALLNETTHROWITEM_GAME_dir:String;
		public var CALLNETTHROWITEM_GAME_blood:Number;
		
		public static const NETTHROWITEM = "投掷信息返回";
		public var NETTHROWITEM_itemStyle:String;
		public var NETTHROWITEM_position:Point;
		public var NETTHROWITEM_action:String;
		public var NETTHROWITEM_dir:String;
		public var NETTHROWITEM_blood:Number;
		public var NETTHROWITEM_id:String;
		
		
		public function Net_Game_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}