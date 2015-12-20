package com.lele.Manager.Events
{
	import com.lele.Manager.Events.ManagerEventBase;
	import com.lele.Map.ThrowItemBase;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Lele
	 */
	public class AppData_App_ManagerEvent extends ManagerEventBase
	{
		public static const CLOSE = "关闭APP";
		public var CLOSE_url:String;
		
		public static const CALLDOACTION = "请求做动作";
		public var CALLDOACTION_actionName:String;
		
		public static const SUBMITARTICLE = "提交文章";
		public var SUBMITARTICLE_head:String;
		public var SUBMITARTICLE_body:String;
		
		public static const GOTOLOGIN = "跳往登录页面";
		
		public static const GOTOREGIST = "跳往注册页面";
		
		public static const SHOWSIMPLEDIALOG = "显示简单dialog";
		public var SHOWSIMPLEDIALOG_emo:String;
		public var SHOWSIMPLEDIALOG_info:String;
		public var SHOWSIMPLEDIALOG_callback:Function;
		
		public static const LOGIN = "登录";
		public var LOGIN_id:String;
		public var LOGIN_pwd:String;
		
		public static const CREATACCOUNT = "创建账户";
		public var CREATACCOUNT_pwd:String;
		
		public static const CREATEMOLE = "创建摩尔";
		public var CREATEMOLE_name:String;
		public var CREATEMOLE_color:String;
		
		public static const OPENAPP = "打开App";
		public var OPENAPP_name:String;
		
		public static const ONTHROWITEM = "丢东西";//
		public var ONTHROWITEM_aimStyle:Sprite;
		public var ONTHROWITEM_itemStyle:String;
		public var ONTHROWITEM_actionName:String;
		public var ONTHROWITEM_actionDir:String;
		public var ONTHROWITEM_blood:Number;
		
		public static const FRIENDHANDLE = "好友事务";
		public var FRIENDHANDLE_id:String;
		public var FRIENDHANDLE_mode:int;
		
		public static const ASKFRIENDLIST = "请求列表";
		public var ASKFRIENDLIST_mode:int;
		
		public static const SEARCHFRIEND = "搜索好友";
		public var SEARCHFRIEND_name:String;
		
		public static const WHEREFRIEND = "查找好友位置";
		public var WHEREFRIEND_id:String;
		
		public static const FRIENDCHATSEND = "好友聊天";
		public var FRIENDCHATSEND_friendID:String;
		public var FRIENDCHATSEND_msg:String;
		public var FRIENDCHATSEND_time:String;
		
		public static const RCHATLISTDATAS = "请求聊天列表";
		public var RCHATLISTDATAS_field:String;//列表类型
		public var RCHATLISTDATAS_block:int;
		
		public static const NCHATLISTDATAS = "请求附近玩家数据";//某地图内
		
		public static const MAKEFRIEND = "加好友";
		public var MAKEFRIEND_id:String;
		
		public function AppData_App_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}