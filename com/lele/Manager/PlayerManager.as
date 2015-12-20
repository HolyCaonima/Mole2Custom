package com.lele.Manager
{
	import com.lele.Controller.Avatar.Enum.AvatarState;
	import com.lele.Data.IClothAnimation;
	import com.lele.Data.IThrowItemAnimationData;
	import com.lele.Map.ThrowItemBase;
	import com.lele.MathTool.LeleMath;
	import com.lele.Data.GloableData;
	import com.lele.Controller.Avatar.CAvatar;
	import com.lele.Controller.Avatar.Events.Avatar_PlayerController_Event;
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import com.lele.Controller.Avatar.Interface.ICommunication;
	import com.lele.Controller.NetWorkController;
	import com.lele.Controller.PlayerController;
	import com.lele.Data.IAnimationData;
	import com.lele.Manager.Events.App_Game_ManagerEvent;
	import com.lele.Manager.Events.ManagerEventBase;
	import com.lele.Manager.Events.Player_Game_ManagerEvent;
	import com.lele.Manager.Events.PLC_Player_ManagerEvent;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Manager.Interface.IResourceLoader;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lele
	 */
	public class PlayerManager extends Sprite implements IReport
	{
		private var _chatStyle:Class;
		private var _resourceLoader:IResourceLoader;
		private var _repoter:IReport;
		
		private var _playerController:PlayerController;
		private var _playerAvatar:CAvatar;
		private var _animationData:IAnimationData;
		
		private var _moleData:Object;
		private var _multiplyPlayer:Array;
		
		private const _stateCheckTime:int = 5000;//这里是毫秒
		private var _stateCheckTimer:Timer;
		
		private var _throwItemAnimationData:IThrowItemAnimationData;
		
		
		public function PlayerManager(resourceLoader:IResourceLoader,report:IReport) 
		{
			_moleData = new Object();
			_multiplyPlayer = new Array();
			_playerController = new PlayerController(this);
			_resourceLoader = resourceLoader;
			_repoter = report;
			_stateCheckTimer = new Timer(_stateCheckTime);
			_stateCheckTimer.addEventListener(TimerEvent.TIMER, AvatarStateCheck);
			_stateCheckTimer.start();
			_playerController.GetNetAvatarArray = GetNetAvatars;
		}
		public function get playerController():PlayerController
		{
			return _playerController;
		}
		public function get playerAvatar():CAvatar
		{
			return _playerAvatar;
		}
		public function ResetAvatar():void//重置本玩家的Avatar
		{
			_playerAvatar.Reset();
		}
		public function LoadAndStart(url:String,useUI:Boolean=false,UIType:String="NULL")
		{
			_resourceLoader.LoadResource("PlayerManager", "Animation/ThrowItemAnimation.swf", OnLoadThrowItemAnimationComplete);
			_resourceLoader.LoadResource("PlayerManager", url, OnLoadComplete, useUI, UIType);
			_resourceLoader.LoadResource("PlayerManager", "Animation/skin.swf", OnLoadSkinComplete, useUI, UIType);
			_resourceLoader.LoadResource("PlayerManager", "Animation/bone.swf", OnLoadBoneComplete, useUI, UIType);
			_resourceLoader.LoadResource("PlayerManager", "Animation/effect.swf", OnLoadEffectComplete, useUI, UIType);
		}
		public function ResetPlayer()
		{
			if(_playerController!=null)
			_playerController.Reset();
		}
		private function OnLoadComplete(evt:Event)
		{
			_animationData = evt.target.content as IAnimationData;
			LoadedCheck();
		}
		private function OnLoadSkinComplete(evt:Event)
		{
			_moleData.skin = evt.target.content;
			LoadedCheck();
		}
		private function OnLoadBoneComplete(evt:Event)
		{
			_moleData.bone = evt.target.content;
			LoadedCheck();
		}
		private function OnLoadEffectComplete(evt:Event)
		{
			_moleData.effect = evt.target.content;
			LoadedCheck();
		}
		private function OnLoadThrowItemAnimationComplete(evt:Event)//加载投掷物品动画
		{
			_throwItemAnimationData = evt.target.content as IThrowItemAnimationData;
		}
		
		private function GetPlayerByID(ID:String):NetPlayerUnit
		{
			for (var a:int = 0; a < _multiplyPlayer.length; a++ )
			{
				if (ID == (_multiplyPlayer[a] as NetPlayerUnit).PlayerID)
				{
					return _multiplyPlayer[a];
				}
			}
			return null;
		}
		
		private function LoadedCheck()
		{
			if (_animationData != null && _moleData.skin != null && _moleData.bone != null && _moleData.effect != null)
			{
				_playerAvatar = new CAvatar(_moleData, _animationData, true,GloableData.MoleColor,GloableData.MoleName);
				if (_chatStyle != null)
				{
					_playerAvatar.SetComDialog(new _chatStyle());
				}
				var loadedEvt:ManagerEventBase =new Player_Game_ManagerEvent(Player_Game_ManagerEvent.PLAYERLOADED)//向上级发送事件
				_repoter.OnReport(loadedEvt);
				
				
				
				//临时代码 test 2015/12/19
				{
					_resourceLoader.LoadResource("Animation_Cloth", "Animation/Cloth/10001.swf", function(evt:Event)
					{
						 _playerAvatar.OnClothLoaded(evt.target.content as IClothAnimation);
					},false,"NULL",true);
				}
				
				
				
				
			}
		}
		//获取所有网络玩家信息列表
		public function GetNetPlayerData():Array//双层Array 第二层 1 id 2 color 3 name
		{
			var result:Array = new Array();
			for (var a:int = 0; a < _multiplyPlayer.length; a++ )
			{
				var temp:Array = new Array();
				temp.push((_multiplyPlayer[a] as NetPlayerUnit).PlayerID);
				temp.push((_multiplyPlayer[a] as NetPlayerUnit).PlayerColor);
				temp.push((_multiplyPlayer[a] as NetPlayerUnit).PlayerName);
				result.push(temp);
			}
			return result;
		}
		public function GetNetAvatarByID(id:String):IAvatar
		{
			return GetPlayerByID(id).Avatar;
		}
		private function GetNetAvatars(array:Array)
		{
			if (_multiplyPlayer == null) { return; }
			for (var a:int = 0; a < _multiplyPlayer.length; a++)
			{
				if ((_multiplyPlayer[a] as NetPlayerUnit).Avatar != null)
				{
					array.push((_multiplyPlayer[a] as NetPlayerUnit).Avatar);
				}
			}
		}
		private function MapAddThrowItem(mc:MovieClip)
		{
			var addto:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.ADDITEMTOMAPFRONT);
			addto.ADDITEMTOMAPFRONT_sprite = mc;
			_repoter.OnReport(addto);
		}
		private function CheckAndDoAction(exp:Point, action:String, dir:String)
		{
			for (var a:int = 0; a < _multiplyPlayer.length; a++ )
			{
				if ((_multiplyPlayer[a] as NetPlayerUnit).GetAvatarState() == AvatarState.SWIM)
				{
					continue;
				}
				var tempAvatar:IAvatar = (_multiplyPlayer[a] as NetPlayerUnit).Avatar;
				if (LeleMath.CheckArea(exp.x, tempAvatar.A_X - tempAvatar.Avatar.width / 2, tempAvatar.A_X + tempAvatar.Avatar.width / 2))
				{
					if (LeleMath.CheckArea(exp.y, tempAvatar.A_Y - tempAvatar.Avatar.height / 2, tempAvatar.A_Y + tempAvatar.Avatar.height / 2))
					{
						tempAvatar.DoAction(action, dir);
					}
				}
			}
			if (_playerController.AState != AvatarState.SWIM)
			{
				if (LeleMath.CheckArea(exp.x, _playerAvatar.A_X - _playerAvatar.Avatar.width / 2, _playerAvatar.A_X + _playerAvatar.Avatar.width / 2))
				{
					if (LeleMath.CheckArea(exp.y, _playerAvatar.A_Y - _playerAvatar.Avatar.height / 2, _playerAvatar.A_Y + _playerAvatar.Avatar.height / 2))
					{
						_playerAvatar.DoAction(action, dir);
					}
				}
			}
		}
		private function AvatarStateCheck(evt:Event)
		{
			for (var i:int = 0; i < _multiplyPlayer.length; i++ )
			{
				(_multiplyPlayer[i] as NetPlayerUnit).AvatarStateCheck();
			}
			_playerController.AvatarStateCheck();
		}
		public function OnReport(evt:Event):void
		{
			var event:PLC_Player_ManagerEvent = evt as PLC_Player_ManagerEvent;
			switch(event.EvtType)
			{
				case PLC_Player_ManagerEvent.LOCALPLAYERMOVE:
				{
					var eventToSend:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.LOCALPLAYERMOVE);
					eventToSend.LOCALPLAYERMOVE_target = event.LOCALPLAYERMOVE_target;
					_repoter.OnReport(eventToSend);
					break;
				}
				case PLC_Player_ManagerEvent.LOCALPLAYERDOACTION:
				{
					var ets:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.LOCALPLAYERDOACTION);
					ets.LOCALPLAYERDOACTION_dir = event.LOCALPLAYERDOACTION_dir;
					ets.LOCALPLAYERDOACTION_name = event.LOCALPLAYERDOACTION_name;
					_repoter.OnReport(ets);
					break;
				}
			}
		}
		public function OnReceive(evt:Event):void//接收上级命令
		{
			var recEvt:Player_Game_ManagerEvent = evt as Player_Game_ManagerEvent;
			
			switch(recEvt.EvtType)
			{
				case Player_Game_ManagerEvent.ONTHROWITEM_GAME:
				{
					if ((recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_owner == "this")
					{
						if (_playerController.AState == AvatarState.SWIM) { return; }
						
						//创建投掷物品实例
						var itemStyle:ThrowItemBase = _throwItemAnimationData.GetThrowItemByName((recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_itemStyle);
						//3级回调
						var tempFunc3:Function=function(position:Point){
							CheckAndDoAction(position, (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_actionName, (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_actionDir);
						}
						//设置回调
						var tempFunc:Function = function(position:Point):void
						{
							//传播网络事件
							var callNet:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.CALLNETTHROWITEM);
							callNet.CALLNETTHROWITEM_action = (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_actionName;
							callNet.CALLNETTHROWITEM_blood = (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_blood;
							callNet.CALLNETTHROWITEM_dir = (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_actionDir;
							callNet.CALLNETTHROWITEM_itemStyle = (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_itemStyle;
							callNet.CALLNETTHROWITEM_position = new Point(position.x, position.y);
							_repoter.OnReport(callNet);
							
							MapAddThrowItem(itemStyle);
							itemStyle.SetCallBack(tempFunc3);
							//2级回调
							var tempFunc2:Function = function() {
								itemStyle.Start(new Point(_playerAvatar.x, _playerAvatar.y - 60), position);
							}
							_playerAvatar.DoAction("throw",LeleMath.GetDirectionSimple(LeleMath.DealRDifference(LeleMath.GetDigree(new Point(_playerAvatar.x, _playerAvatar.y - 60), position))),tempFunc2);
						}
						var interact:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.INTERACTMOUSECLICK);
						interact.INTERACTMOUSECLICK_callBack = tempFunc;
						interact.INTERACTMOUSECLICK_style = (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_aimStyle;
						_repoter.OnReport(interact);
					}
					else
					{
						var throwCallback:Function=function(position:Point){
							CheckAndDoAction(position, (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_actionName, (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_actionDir);
						}
						if (GetPlayerByID((recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_owner).GetAvatarState() == AvatarState.SWIM)
						{
							return;
						}
						//创建投掷物品实例
						var itemStyle:ThrowItemBase = _throwItemAnimationData.GetThrowItemByName((recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_itemStyle);
						MapAddThrowItem(itemStyle);
						itemStyle.SetCallBack(throwCallback);
						//获取控制器
						var plut:NetPlayerUnit = GetPlayerByID((recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_owner);
						//创建点
						var source:Point = new Point(plut.Avatar.Avatar.x, plut.Avatar.Avatar.y-60);
						var newPo:Point = (recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_position;
						var func2:Function = function() {
							itemStyle.Start(source,newPo);
						}
						GetPlayerByID((recEvt as Player_Game_ManagerEvent).ONTHROWITEM_GAME_owner).DoAction("throw", LeleMath.GetDirectionSimple(LeleMath.DealRDifference(LeleMath.GetDigree(source, newPo))),func2);
					}
					return;
				}
				case Player_Game_ManagerEvent.CALLDOACTION_GAME:
				{
					_playerController.SetStatePlay();
					_playerController.DoAction((recEvt as Player_Game_ManagerEvent).CALLDOACTION_GAME_actionName, "dd", function() { _playerController.SetStateIdle(); } );
					return;
				}
				case Player_Game_ManagerEvent.CALLCLEANNETPLAYER:
				{
					for (var a:int = 0; a < _multiplyPlayer.length; a++ )
					{
						(_multiplyPlayer[a] as NetPlayerUnit).Clean();
					}
					_multiplyPlayer = new Array();
					return;
				}
				case Player_Game_ManagerEvent.NETAVATARACTION_GAME:
				{
					var netPl:NetPlayerUnit = GetPlayerByID((recEvt as Player_Game_ManagerEvent).NETAVATARACTION_GAME_ID);
					if (netPl != null)
					netPl.DoAction((recEvt as Player_Game_ManagerEvent).NETAVATARACTION_GAME_name,(recEvt as Player_Game_ManagerEvent).NETAVATARACTION_GAME_direction);
					return;
				}
				case Player_Game_ManagerEvent.ADDNETPLAYER_GAME:
				{
					if (GloableData.CurrentMap != (recEvt as Player_Game_ManagerEvent).ADDNETPLAYER_GAME_map) {trace("refuse Add"); return ; }
					if (GetPlayerByID((recEvt as Player_Game_ManagerEvent).ADDNETPLAYER_GAME_ID) != null ) { trace("refuse Add"); return; }//已经有了
					var tempNetUnit:NetPlayerUnit = new NetPlayerUnit((recEvt as Player_Game_ManagerEvent).ADDNETPLAYER_GAME_color, (recEvt as Player_Game_ManagerEvent).ADDNETPLAYER_GAME_spownPoint, _repoter, (recEvt as Player_Game_ManagerEvent).ADDNETPLAYER_GAME_ID,(recEvt as Player_Game_ManagerEvent).ADDNETPLAYER_GAME_name).LoadAndStart();
					_multiplyPlayer.push(tempNetUnit);
					tempNetUnit._styleClass = _chatStyle;
					return;
				}
				case Player_Game_ManagerEvent.NETPLAYERMOVE_GAME:
				{
					var netPlayer:NetPlayerUnit = GetPlayerByID((recEvt as Player_Game_ManagerEvent).NETPLAYERMOVE_GAME_ID);
					if(netPlayer!=null)
					netPlayer.Move((recEvt as Player_Game_ManagerEvent).NETPLAYERMOVE_GAME_target);
					return;
				}
				case Player_Game_ManagerEvent.REMOVENETPLAYER_GAME:
				{
					try
					{
					var tempUnit:NetPlayerUnit = GetPlayerByID((recEvt as Player_Game_ManagerEvent).REMOVENETPLAYER_GAME_ID);
					var toGame:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.CALLMAPREMOVENETPLAYER);
					toGame.CALLMAPREMOVENETPLAYER_avatar = tempUnit.Avatar;
					_repoter.OnReport(toGame);
					}
					catch (er:Error)
					{
						//这个try必报错，问题未知待修复 2015/7/4
					}
					tempUnit.Clean();
					_multiplyPlayer.splice(_multiplyPlayer.indexOf(tempUnit), 1);
					return;
				}
				case Player_Game_ManagerEvent.PASSDIALOGSTYLE_GAME:
				{
					_chatStyle = (recEvt as Player_Game_ManagerEvent).PASSDIALOGSTYLE_GAME_body;
					_playerController.SetMsgDialog(new _chatStyle());
					for (var a:int = 0; a < _multiplyPlayer.length; a++ )
					{
						(_multiplyPlayer[a] as NetPlayerUnit).Avatar.SetComDialog(new _chatStyle());
					}
					return;
				}
				case Player_Game_ManagerEvent.SHOWMSG_GAME:
				{
					if ((recEvt as Player_Game_ManagerEvent).SHOWMSG_GAME_id == "local")
					{
						//本地
						_playerController.SetMsgDialog(new _chatStyle());
						_playerController.ShowMsgDialog((recEvt as Player_Game_ManagerEvent).SHOWMSG_GAME_msg);
						return;
					}
					else
					{
						var tempp:NetPlayerUnit=GetPlayerByID((recEvt as Player_Game_ManagerEvent).SHOWMSG_GAME_id);
						if (tempp != null)
						{
							tempp.Avatar.ShowDialog((recEvt as Player_Game_ManagerEvent).SHOWMSG_GAME_msg);
						}
					}
					return;
				}
			}
		}
		
	}

}
import com.lele.Controller.Avatar.Enum.AvatarState;
import com.lele.Controller.Avatar.Events.NetWorkController_NetPlayerUnit_Event;
import com.lele.Controller.Avatar.Interface.IAvatar;
import com.lele.Controller.NetWorkController;
import com.lele.Data.FriendDataUnit;
import com.lele.Data.IAnimationData;
import com.lele.Manager.Events.Player_Game_ManagerEvent;
import com.lele.Manager.Interface.IReport;
import com.lele.Data.GloableData;
import flash.display.Loader;
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLRequest;

class NetPlayerUnit implements IReport//玩家单元
{
	private var _color:String;
	private var _name:String;
	private var _spownPoint:Point;
	
	private var _unitAnimationData:IAnimationData;
	private var _unitMoleData:Object;
	private var _unitController:NetWorkController;
	
	private var _repoter:IReport;//直接向外界的report
	
	private var _playerID:String;
	
	public var _styleClass:Class;
	
	public function NetPlayerUnit(color:String, spownPoint:Point,repoter:IReport,playerID:String,name:String)
	{
		_color = color;
		_name = name;
		_spownPoint = spownPoint;
		_unitMoleData = new Object();
		_repoter = repoter;
		_playerID = playerID;
	}
	public function LoadAndStart():NetPlayerUnit
	{
		var skinLoader:Loader = new Loader();
		var boneLoader:Loader = new Loader();
		var effectLoader:Loader = new Loader();
		var animationLoader:Loader = new Loader();
		skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnSkinLoaded);
		boneLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnBoneLoaded);
		effectLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnEffectLoaded);
		animationLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnAnimationLoaded);
		skinLoader.load(new URLRequest("Animation/skin.swf"));
		boneLoader.load(new URLRequest("Animation/bone.swf"));
		effectLoader.load(new URLRequest("Animation/effect.swf"));
		animationLoader.load(new URLRequest("Animation/AnimationData.swf"));
		return this;
	}
	public function get PlayerID():String
	{
		return _playerID;
	}
	public function get PlayerColor():String
	{
		return _color;
	}
	public function get PlayerName():String
	{
		return _name;
	}
	public function GetAvatarState():AvatarState
	{
		return _unitController.AState;
	}
	public function AvatarStateCheck()
	{
		if (_unitController == null) { return; }
		try
		{
			_unitController.AvatarStateCheck();
		}
		catch (er:Error) { trace(er.message); }
	}
	private function OnSkinLoaded(evt:Event)
	{
		_unitMoleData.skin = evt.target.content;
		LoadedCheck();
	}
	private function OnBoneLoaded(evt:Event)
	{
		_unitMoleData.bone = evt.target.content;
		LoadedCheck();
	}
	private function OnEffectLoaded(evt:Event)
	{
		_unitMoleData.effect = evt.target.content;
		LoadedCheck();
	}
	private function OnAnimationLoaded(evt:Event)
	{
		_unitAnimationData = evt.target.content;
		LoadedCheck();
	}
	private function LoadedCheck()
	{
		if (_unitMoleData.skin != null && _unitMoleData.bone != null && _unitMoleData.effect != null && _unitAnimationData != null)
		{
			_unitController = new NetWorkController(_unitMoleData, _unitAnimationData, _color, _spownPoint, _name);
			_unitController.Repoter = this;
			var evtToStart:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.CALLADDNETPLAYERTOMAP);
			evtToStart.CALLADDNETPLAYERTOMAP_iavatar = _unitController._netAvatar;
			evtToStart.CALLADDNETPLAYERTOMAP_controller = _unitController;
			if (_styleClass != null)
			{
				Avatar.SetComDialog(new _styleClass());
			}
			_repoter.OnReport(evtToStart);
		}
	}
	public function get Avatar():IAvatar
	{
		return _unitController._netAvatar;
	}
	public function DoAction(actName:String, actDir:String,callback:Function=null)
	{
		_unitController.DoAction(actName, actDir,callback);
	}
	public function Move(target:Point)
	{
		_unitController.Move(target);
	}
	public function OnReport(evt:Event):void
	{
		var event:NetWorkController_NetPlayerUnit_Event = evt as NetWorkController_NetPlayerUnit_Event;
		switch(event.EvtType)
		{
			case NetWorkController_NetPlayerUnit_Event.SHOWOTHERPLAYERINFO:
				var showInfoPanelEvt:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.LOADSTARTAPP);
				showInfoPanelEvt.LOADSTARTAPP_name = "InfoPanelApp";
				var teF:Array = GloableData.FriendData;
				var isFriend:Boolean = false;
				for (var b:int = 0; b < teF.length; b++)
				{
					if ((teF[b] as FriendDataUnit).ID == _playerID)
					{
						isFriend = true;
						break;
					}
				}
				var params:Array = new Array();
				params.push(_color);
				params.push(_name);
				params.push(_playerID);
				params.push("0");
				params.push("0");
				params.push("0");
				params.push("0");
				params.push(isFriend);
				showInfoPanelEvt.LOADSTARTAPP_params = params;
				showInfoPanelEvt.LOADSTARTAPP_uiType = "";
				showInfoPanelEvt.LOADSTARTAPP_useUI = false;
				_repoter.OnReport(showInfoPanelEvt);
				break;
		}
	}
	public function Clean()
	{
		_spownPoint = null;
		_unitAnimationData = null;
		_unitController.Clean();
		_unitController = null;
		_unitMoleData = null;
	}
}