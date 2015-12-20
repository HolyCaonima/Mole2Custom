package com.lele.Manager.Events
{
	import com.lele.Map.ThrowItemBase;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Lele
	 */
	public class App_Game_ManagerEvent extends ManagerEventBase
	{
		public static const CALLDOACTION = "请求做动作";
		public var CALLDOACTION_actionName:String;
		
		public static const SUBMITARTICLE = "提交文章";
		public var SUBMITARTICLE_head:String;
		public var SUBMITARTICLE_body:String;
		
		public static const GOTOLOGIN = "跳转登录";
		
		public static const GOTOREGIST = "跳转注册";
		
		public static const LOGIN = "登录";
		public var LOGIN_id:String;
		public var LOGIN_pwd:String;
		
		public static const CLOSEAPP_GAME = "关闭应用";
		public var CLOSEAPP_GAME_name:String;
		
		public static const ARGTOAPP_GAME = "数据返回App";
		public var ARGTOAPP_GAME_args:Array;
		public var ARGTOAPP_GAME_name:String;
		
		public static const CREATACCOUNT = "创建账户";
		public var CREATACCOUNT_pwd:String;
		
		public static const CREATEMOLE = "创建摩尔";
		public var CREATEMOLE_name:String;
		public var CREATEMOLE_color:String;
		
		public static const CREATACCOUNTRESULT_GAME = "创建账号callBack";
		public var CREATACCOUNTRESULT_GAME_result:Boolean;
		public var CREATACCOUNTRESULT_GAME_id:String;
		
		public static const ONTHROWITEM = "丢东西";//
		public var ONTHROWITEM_aimStyle:Sprite;
		public var ONTHROWITEM_itemStyle:String;
		public var ONTHROWITEM_actionName:String;
		public var ONTHROWITEM_actionDir:String;
		public var ONTHROWITEM_blood:Number;
		
		public static const NCHATLISTDATAS = "请求附近玩家数据";//某地图内(好友列表里的推荐)
		
		public static const NCHATLISTDATAS_GAME = "返回附近玩家数据";
		public var NCHATLISTDATAS_GAME_data:Array;
		
		public function App_Game_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}