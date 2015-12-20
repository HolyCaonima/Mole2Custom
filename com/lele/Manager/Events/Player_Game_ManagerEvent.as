package com.lele.Manager.Events
{
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import com.lele.Controller.NetWorkController;
	import com.lele.Map.ThrowItemBase;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.globalization.StringTools;
	/**
	 * ...
	 * @author Lele
	 */
	public class Player_Game_ManagerEvent extends ManagerEventBase
	{
		public static const PLAYERLOADED:String = "玩家加载完成";
		
		public static const CALLDOACTION_GAME = "请求做动画";//后面加了GAME说明是反向;
		public var CALLDOACTION_GAME_actionName:String;
		
		public static const NETAVATARACTION_GAME = "网络玩家动画";
		public var NETAVATARACTION_GAME_ID:String;//玩家ID
		public var NETAVATARACTION_GAME_name:String;//Action Name
		public var NETAVATARACTION_GAME_direction:String;//标识动作方向
		
		public static const ADDNETPLAYER_GAME = "添加网络玩家";
		public var ADDNETPLAYER_GAME_color:String;
		public var ADDNETPLAYER_GAME_name:String;
		public var ADDNETPLAYER_GAME_ID:String;
		public var ADDNETPLAYER_GAME_spownPoint:Point;
		public var ADDNETPLAYER_GAME_map:String;
		
		public static const CALLCLEANNETPLAYER = "请求清楚网络玩家";
		
		public static const CALLADDNETPLAYERTOMAP = "请求将网络玩家加入地图";
		public var CALLADDNETPLAYERTOMAP_iavatar:IAvatar;
		public var CALLADDNETPLAYERTOMAP_controller:NetWorkController;
		
		public static const NETPLAYERMOVE_GAME = "网络玩家移动";
		public var NETPLAYERMOVE_GAME_ID:String;
		public var NETPLAYERMOVE_GAME_target:Point;
		
		public static const LOCALPLAYERMOVE = "本地玩家移动";//通知网络分支
		public var LOCALPLAYERMOVE_target:Point;
		
		public static const REMOVENETPLAYER_GAME = "移除网络玩家";
		public var REMOVENETPLAYER_GAME_ID:String;
		
		public static const CALLMAPREMOVENETPLAYER = "请求地图管理器移除网络玩家";
		public var CALLMAPREMOVENETPLAYER_avatar:IAvatar;
		
		public static const PASSDIALOGSTYLE_GAME = "传递样式";//聊天时那个小的
		public var PASSDIALOGSTYLE_GAME_body:Class;
		
		public static const SHOWMSG_GAME = "显示消息";
		public var SHOWMSG_GAME_msg:String;
		public var SHOWMSG_GAME_id:String;//local代表本玩家
		
		public static const LOCALPLAYERDOACTION = "本地玩家做动作";
		public var LOCALPLAYERDOACTION_name:String;
		public var LOCALPLAYERDOACTION_dir:String;
		
		public static const ONTHROWITEM_GAME = "丢东西";//
		public var ONTHROWITEM_GAME_owner:String;
		public var ONTHROWITEM_GAME_actionName:String;
		public var ONTHROWITEM_GAME_actionDir:String;
		public var ONTHROWITEM_GAME_blood:Number;
		public var ONTHROWITEM_GAME_itemStyle:String;
		public var ONTHROWITEM_GAME_aimStyle:Sprite;
		public var ONTHROWITEM_GAME_position:Point;
		
		public static const CALLNETTHROWITEM = "传播网络投掷信息";
		public var CALLNETTHROWITEM_itemStyle:String;
		public var CALLNETTHROWITEM_position:Point;
		public var CALLNETTHROWITEM_action:String;
		public var CALLNETTHROWITEM_dir:String;
		public var CALLNETTHROWITEM_blood:Number;
		
		public static const INTERACTMOUSECLICK = "交互管理器点击";
		public var INTERACTMOUSECLICK_style:Sprite;
		public var INTERACTMOUSECLICK_callBack:Function;
		
		public static const ADDITEMTOMAPFRONT = "添加对象到地图front层";
		public var ADDITEMTOMAPFRONT_sprite:Sprite;
		
		public static const LOADSTARTAPP = "加载运行App";
		public var LOADSTARTAPP_name:String;
		public var LOADSTARTAPP_useUI:Boolean;
		public var LOADSTARTAPP_uiType:String;
		public var LOADSTARTAPP_params:Array;
		
		public function Player_Game_ManagerEvent(evtType:String) 
		{
			super(evtType);
		}
		
	}

}