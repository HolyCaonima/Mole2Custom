package com.lele.Manager
{
	import adobe.utils.CustomActions;
	import com.lele.Container.AppContainer;
	import com.lele.Manager.Interface.IApplicationManager;
	import com.lele.Manager.Interface.IApplyAppContainer;
	import com.lele.Controller.Avatar.ActionSuggest;
	import com.lele.Container.EffectContainer;
	import com.lele.Container.InteractContainer;
	import com.lele.Controller.Avatar.CAvatar;
	import com.lele.Controller.NetWorkController;
	import com.lele.Link.*;
	import com.lele.Data.GloableData;
	import com.lele.Manager.Events.*;
	import com.lele.Manager.Interface.INetManager;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Plugin.FpsTool.Fps;
	import com.lele.Plugin.RoadFind.RoadFinder;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lele
	 */
	public class GameManager extends Sprite implements IReport,IApplyAppContainer//存在加载速度不协调造成的bug
	{
		//管理器
		private var _mapManager:MapManager;
		private var _resourceManager:ResourceManager;
		private var _soundManager:SoundManager;
		private var _uiManager:UIManager;
		private var _playerManager:PlayerManager;
		private static var _appManager:ApplicationManager;
		private static var _netManager:NetManager;
		private var _interactManager:InteractManager;
		//中间数据集
		private var _dataBridge:Object;
		//显示对象容器
		private var _uiContainer:Sprite;
		private var _mapsContainer:Sprite;
		private var _appContainer:AppContainer;
		private var _effectContainer:EffectContainer;
		private var _uiHighContainer:Sprite;//主要是加载进度条
		private var _interactContainer:InteractContainer;
		private var _debugContainer:Sprite;
		//网络配置
		private var _ip:String="127.0.0.1"; //"115.159.27.206"
		private var _port:int = 51888;
		//debug窗口
		private var _textField:TextField;
		//flags
		private var _beginFlag:Boolean = true;//是否首次打开
		public function GameManager() 
		{
			GloableData.Environment = "local";
			GloableData.HasLogin = false;
			GloableData.CurrentMap = "Map001";
			GloableData.CurrentWeather = "Sun";
			GloableData.CurrentWeatherStrength = 0;
			GloableData.Version = "0.4.2";
			GloableData.MasterMode = false;
			if (GloableData.Environment == "net")
			{
				_ip = "121.42.202.168";
			}
						
			_uiContainer = new Sprite();//四只容器管理不同层次
			_mapsContainer = new Sprite();
			_effectContainer = new EffectContainer();
			_uiHighContainer = new Sprite();
			_appContainer = new AppContainer();//应用层
			_debugContainer = new Sprite();
			_interactContainer = new InteractContainer();//交互提示tip
			
			_dataBridge = new Object();
			_resourceManager = new ResourceManager(this);
			_mapManager = new MapManager(_resourceManager, this);
			_soundManager = new SoundManager(_resourceManager,this);
			_uiManager = new UIManager(_resourceManager, this);
			_playerManager = new PlayerManager(_resourceManager, this);
			_appManager = new ApplicationManager(_resourceManager, this,this);
			_netManager = new NetManager(_ip, _port, this);
			_interactManager = new InteractManager(this, _interactContainer);
			
			
			_dataBridge.spawnPoint = new Point(637, 332);//连接出生点状态的数据，以后还有更多
			
			{//创建Debug容器
				_textField = new TextField();
				_textField.width = 100;
				_textField.y = 60;
				var color:uint = 4294967295;
				_textField.text = "摩尔庄园2 \nalpha v"+GloableData.Version+"\nDebug窗口:\n";
				_textField.textColor = color;
				if(GloableData.MasterMode)
				_debugContainer.addChild(_textField);
				
				//创建FPS
				var fps:Fps = new Fps();
				fps.y = 0;
				fps.x = 65;
				if(GloableData.MasterMode)
				_debugContainer.addChild(fps);
			}
			AddAllDisplay();
			
			//初始化加载消息框,登录界面，和摩尔创建界面
			_appManager.LoadApp(AppDataLink.GetUrlByName("Dialog"), _appContainer.GetContainer());
			_appManager.LoadStartApp(AppDataLink.GetUrlByName("StartApp"), _appContainer.GetContainer());
			_appManager.LoadApp(AppDataLink.GetUrlByName("CreateMoleApp"), _appContainer.GetContainer());
			
			//延迟连接
			var tempTimer:Timer = new Timer(400, 1);
			tempTimer.addEventListener(TimerEvent.TIMER,OnConnect);
			//tempTimer.start();
			
			//var clock:Timer = new Timer(4000, 1);
			//clock.addEventListener(TimerEvent.TIMER, OnLogin);
			//clock.start();
		}
		
		public function OnReport(evt:Event):void
		{
			if (evt is ManagerEventBase)
			{
				var event:ManagerEventBase = evt as ManagerEventBase;
				
				switch(event.EvtType)
				{
					case Player_Game_ManagerEvent.PLAYERLOADED:
					{
						TextFieldHandle("玩家资源加载完毕");	
						ShowAndPlay();
						return;
					}
					case Map_Game_ManagerEvent.MAPLOADED:
					{
						TextFieldHandle("地图数据加载完毕");
						ShowAndPlay();//判断加载是否完成，若完成则开始
						return;
					}
					case Sound_Game_ManagerEvent.SOUNDLOADEDEVENT:
					{
						TextFieldHandle("音频数据加载完毕");
						ShowAndPlay();
						return;
					}
					case UI_Game_ManagerEvent.LOADINGBARLOADEDEVENT:
					{
						_uiManager.highUIContainer = _uiHighContainer;//设置最高容器
						_playerManager.LoadAndStart("Animation/AnimationData.swf");
						_uiManager.LoadUI("UI/WorldMap.swf", _uiHighContainer,true,"Map");
						_uiManager.LoadUI("UI/ToolBar.swf", _uiContainer, true, "MAP");//暂时这样放，本身这样就是暂时的
						_mapManager.LoadAndStart(MapDataLink.Map001, _mapsContainer,true,"MAP");//传递进回调函数，当加载完成
						_soundManager.LoadMusic(MediaDataLink.Map001MediaData, true, "MAP");
						return;
					}
					case UI_Game_ManagerEvent.UILOADEDEVENT:
					{
						TextFieldHandle("UI元素加载完毕");
						ShowAndPlay();
						return;
					}
					case Map_Game_ManagerEvent.REMOVE_MAP://移除地图，在换地图之后执行
					{
						_soundManager.UnLoadSound(MediaDataLink.GetUrlByName(GloableData.CurrentMap + "MediaData"));
						_mapsContainer.removeChild((evt as Map_Game_ManagerEvent)._map as DisplayObject);
						return;
					}
					case Resource_Game_ManagerEvent.LOADINGPROCESSEVENT:
					{
						var temp:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.LOADINGPROCESSEVENT);
						temp._isComplete = (event as Resource_Game_ManagerEvent)._isComplete;
						temp._process = (event as Resource_Game_ManagerEvent)._process;
						temp._type = (event as Resource_Game_ManagerEvent)._type;
						_uiManager.OnPostProgess(temp);
						return;
					}
					case Map_Game_ManagerEvent.CHANGE_MAP:
					{
						//发送未在地图上事件即设置服务器的对应Unit  Update为false
						var disEvt:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.DISUPDATE_GAME);
						_netManager.OnReceive(disEvt);
						
						_effectContainer.Shoot(_mapsContainer, _uiContainer);//as3有BUG一旦用容器去绘制图形就会导致对象保存丢失
						_effectContainer.UnShowAndTurnDark();
						RemoveAllDisplay();   //As有奇葩bug会删除所有东西
						AddAllDisplay();
						
						var cme:Map_Game_ManagerEvent = evt as Map_Game_ManagerEvent;
						var target:String = cme.CHANGE_MAP_targetMap;
						_dataBridge.spawnPoint = cme.CHANGE_MAP_spawnPoint;//dataBridge是跨越地图沟通的数据
						_soundManager.SmoothCloseByName(cme.CHANGE_MAP_sourceMap + "MediaData");
						_soundManager.LoadMusic(MediaDataLink.GetUrlByName(target+"MediaData"), true, "MAP");
						_mapManager.UnLoadMap();
						_playerManager.ResetAvatar();
						_mapManager.LoadAndStart(MapDataLink.GetUrlByName(target), _mapsContainer, true, "MAP");
						
						//清除网络玩家
						var callCleanNetPlayer:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.CALLCLEANNETPLAYER);
						_playerManager.OnReceive(callCleanNetPlayer);
						
						GloableData.CurrentMap = cme.CHANGE_MAP_targetMap;
						return;
					}
					case UI_Game_ManagerEvent.CALLMAPMANAGERCHANGEMAP:
					{
						var mapEvt:MapData_Map_ManagerEvent = new MapData_Map_ManagerEvent(MapData_Map_ManagerEvent.CHANGE_MAP);
						mapEvt.CHANGE_MAP_spawnPoint = (evt as UI_Game_ManagerEvent).CALLMAPMANAGERCHANGEMAP_spawnPoint;
						mapEvt.CHANGE_MAP_targetMap = (evt as UI_Game_ManagerEvent).CALLMAPMANAGERCHANGEMAP_targetMap;
						mapEvt.CHANGE_MAP_sourceMap = (evt as UI_Game_ManagerEvent).CALLMAPMANAGERCHANGEMAP_sourceMap;
						_mapManager.OnReport(mapEvt);
						
						GloableData.CurrentMap = mapEvt.CHANGE_MAP_targetMap;
						return;
					}
					case Map_Game_ManagerEvent.CALLLOADAPP:
					{
						_appManager.LoadStartApp(AppDataLink.GetUrlByName((evt as Map_Game_ManagerEvent).CALLLOADAPP_appName), _appContainer.GetContainer());
						return;
					}
					case UI_Game_ManagerEvent.CALLLOADAPP:
					{
						_appManager.LoadStartApp((evt as UI_Game_ManagerEvent).CALLLOADAPP_url, _appContainer.GetContainer(),(evt as UI_Game_ManagerEvent).CALLLOADAPP_useUI,(evt as UI_Game_ManagerEvent).CALLLOADAPP_uiType,(evt as UI_Game_ManagerEvent).CALLLOADAPP_params); 
						return;
					}
					case UI_Game_ManagerEvent.CALLUNLOADAPP:
					{
						var Man:AppData_App_ManagerEvent = new AppData_App_ManagerEvent(AppData_App_ManagerEvent.CLOSE);
						Man.CLOSE_url = (evt as UI_Game_ManagerEvent).CALLUNLOADAPP_url;
						_appManager.OnReport(Man);
						return;
					}
					case UI_Game_ManagerEvent.SHOWFRIENDLIST:
					{
						var param:Array = new Array();
						param[0] = 1;
						_appManager.StartApp("FriendsApp", param);
						return;
					}
					case App_Game_ManagerEvent.CALLDOACTION://向PlayerManager发出做动作指令
					{
						var doAction:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.CALLDOACTION_GAME);
						doAction.CALLDOACTION_GAME_actionName = (evt as App_Game_ManagerEvent).CALLDOACTION_actionName;
						_playerManager.OnReceive(doAction);
						
						//同时向服务器消息动作命令
						var netAcEvt:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.NETDOACTION_GAME);
						netAcEvt.NETDOACTION_GAME_name = ActionSuggest.SuggestAction((evt as App_Game_ManagerEvent).CALLDOACTION_actionName);
						netAcEvt.NETDOACTION_GAME_dir = "dd";
						_netManager.OnReceive(netAcEvt);
						return;
					}
					case App_Game_ManagerEvent.SUBMITARTICLE:
					{
						var subArt:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.SUBMITARTICLE_GAME);
						subArt.SUBMITARTICLE_GAME_head = (evt as App_Game_ManagerEvent).SUBMITARTICLE_head;
						subArt.SUBMITARTICLE_GAME_body = (evt as App_Game_ManagerEvent).SUBMITARTICLE_body;
						_netManager.OnReceive(subArt);
						return;
					}
					case App_Game_ManagerEvent.GOTOLOGIN:
					{
						_appManager.LoadStartApp(AppDataLink.GetUrlByName("LoginPanelApp"), _appContainer.GetContainer());
						return;
					}
					case App_Game_ManagerEvent.GOTOREGIST:
					{
						_appManager.LoadStartApp(AppDataLink.GetUrlByName("ApplyPanelApp"), _appContainer.GetContainer());
						return;
					}
					case App_Game_ManagerEvent.LOGIN://直接连接并尝试登录,远程挂起等待二次登录
					{
						_netManager.Connect();
						GloableData.TempID = (evt as App_Game_ManagerEvent).LOGIN_id;
						GloableData.TempPWD = (evt as App_Game_ManagerEvent).LOGIN_pwd;
						var delate:Timer = new Timer(2000, 1);
						delate.addEventListener(TimerEvent.TIMER, DelateLogin);
						delate.start();
						return;
					}
					case App_Game_ManagerEvent.CREATACCOUNT:
					{
						_netManager.Connect();
						GloableData.TempPWD = (evt as App_Game_ManagerEvent).CREATACCOUNT_pwd;
						var delate:Timer = new Timer(2000, 1);
						delate.addEventListener(TimerEvent.TIMER, DelateCreatAccount);
						delate.start();
						return;
					}
					case App_Game_ManagerEvent.CREATEMOLE:
					{
						var ncm:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.CREATEMOLE_GAME);
						ncm.CREATEMOLE_GAME_color = (evt as App_Game_ManagerEvent).CREATEMOLE_color;
						ncm.CREATEMOLE_GAME_name = (evt as App_Game_ManagerEvent).CREATEMOLE_name;
						_netManager.OnReceive(ncm);
						return;
					}
					case App_Game_ManagerEvent.ONTHROWITEM:
					{
						var top:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.ONTHROWITEM_GAME);
						top.ONTHROWITEM_GAME_owner = "this";
						top.ONTHROWITEM_GAME_actionDir = (evt as App_Game_ManagerEvent).ONTHROWITEM_actionDir;
						top.ONTHROWITEM_GAME_actionName = (evt as App_Game_ManagerEvent).ONTHROWITEM_actionName;
						top.ONTHROWITEM_GAME_aimStyle = (evt as App_Game_ManagerEvent).ONTHROWITEM_aimStyle;
						top.ONTHROWITEM_GAME_blood = (evt as App_Game_ManagerEvent).ONTHROWITEM_blood;
						top.ONTHROWITEM_GAME_itemStyle = (evt as App_Game_ManagerEvent).ONTHROWITEM_itemStyle;
						_playerManager.OnReceive(top);
						return;
					}
					case App_Game_ManagerEvent.NCHATLISTDATAS:
					{
						var targetArray:Array;
						var te:Array=_playerManager.GetNetPlayerData();
						if (te.length > 4) 
						{
							targetArray = new Array(); 
							var select:int;
							for (var a:int = 0; a < 4; a++ )
							{
								select = Math.round((Math.random() * (te.length - 1)));
								targetArray.push(te[select]);
								te.splice(select, 1);
							}
						}
						else { targetArray = te; }
						var dataBack:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.NCHATLISTDATAS_GAME);
						dataBack.NCHATLISTDATAS_GAME_data = targetArray;
						_appManager.OnReceive(dataBack);
						return;
					}
					case Player_Game_ManagerEvent.LOADSTARTAPP:
					{
						_appManager.LoadStartApp(AppDataLink.GetUrlByName((evt as Player_Game_ManagerEvent).LOADSTARTAPP_name),
						_appContainer.GetContainer(), (evt as Player_Game_ManagerEvent).LOADSTARTAPP_useUI,
						(evt as Player_Game_ManagerEvent).LOADSTARTAPP_uiType, (evt as Player_Game_ManagerEvent).LOADSTARTAPP_params);
						return;
					}
					case Player_Game_ManagerEvent.LOCALPLAYERDOACTION://同上的网络部分
					{
						//向服务器消息动作命令
						var netAcEvt:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.NETDOACTION_GAME);
						netAcEvt.NETDOACTION_GAME_name = (evt as Player_Game_ManagerEvent).LOCALPLAYERDOACTION_name;
						netAcEvt.NETDOACTION_GAME_dir = (evt as Player_Game_ManagerEvent).LOCALPLAYERDOACTION_dir;
						_netManager.OnReceive(netAcEvt);
						return;
					}
					case Player_Game_ManagerEvent.CALLADDNETPLAYERTOMAP:
					{
						_mapManager.AddNetPlayerToMap((evt as Player_Game_ManagerEvent).CALLADDNETPLAYERTOMAP_iavatar,(evt as Player_Game_ManagerEvent).CALLADDNETPLAYERTOMAP_controller);
						return;
					}
					case Player_Game_ManagerEvent.LOCALPLAYERMOVE:
					{
						var ng:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.LOCALPLAYERMOVE_GAME);
						ng.LOCALPLAYERMOVE_GAME_target = (evt as Player_Game_ManagerEvent).LOCALPLAYERMOVE_target;
						_netManager.OnReceive(ng);
						return;
					}
					case Player_Game_ManagerEvent.CALLMAPREMOVENETPLAYER:
					{
						_mapManager.RemoveNetAvatarFromMap((evt as Player_Game_ManagerEvent).CALLMAPREMOVENETPLAYER_avatar);
						return;
					}
					case Player_Game_ManagerEvent.INTERACTMOUSECLICK:
					{
						_interactManager.MouseClickMode((evt as Player_Game_ManagerEvent).INTERACTMOUSECLICK_style, (evt as Player_Game_ManagerEvent).INTERACTMOUSECLICK_callBack);
						return;
					}
					case Player_Game_ManagerEvent.ADDITEMTOMAPFRONT:
					{
						_mapManager.AddItemToMapFront((evt as Player_Game_ManagerEvent).ADDITEMTOMAPFRONT_sprite);
						return;
					}
					case Player_Game_ManagerEvent.CALLNETTHROWITEM:
					{
						var netThrow:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.CALLNETTHROWITEM_GAME);
						netThrow.CALLNETTHROWITEM_GAME_action = (evt as Player_Game_ManagerEvent).CALLNETTHROWITEM_action;
						netThrow.CALLNETTHROWITEM_GAME_blood = (evt as Player_Game_ManagerEvent).CALLNETTHROWITEM_blood;
						netThrow.CALLNETTHROWITEM_GAME_dir = (evt as Player_Game_ManagerEvent).CALLNETTHROWITEM_dir;
						netThrow.CALLNETTHROWITEM_GAME_itemStyle = (evt as Player_Game_ManagerEvent).CALLNETTHROWITEM_itemStyle;
						netThrow.CALLNETTHROWITEM_GAME_position = (evt as Player_Game_ManagerEvent).CALLNETTHROWITEM_position;
						_netManager.OnReceive(netThrow);
						return;
					}
					case Net_Game_ManagerEvent.DOACTION:
					{
						var tempToPlayer:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.NETAVATARACTION_GAME);
						tempToPlayer.NETAVATARACTION_GAME_ID = (evt as Net_Game_ManagerEvent)._playerID;
						tempToPlayer.NETAVATARACTION_GAME_name = (evt as Net_Game_ManagerEvent).DOACTION_name;
						tempToPlayer.NETAVATARACTION_GAME_direction = (evt as Net_Game_ManagerEvent).DOACTION_direction;
						_playerManager.OnReceive(tempToPlayer);
						return;
					}
					case Net_Game_ManagerEvent.ADDNETPLAYER:
					{
						var toPlayer:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.ADDNETPLAYER_GAME);
						toPlayer.ADDNETPLAYER_GAME_color = (evt as Net_Game_ManagerEvent).ADDNETPLAYER_color;
						toPlayer.ADDNETPLAYER_GAME_name = (evt as Net_Game_ManagerEvent).ADDNETPLAYER_name;
						toPlayer.ADDNETPLAYER_GAME_ID = (evt as Net_Game_ManagerEvent)._playerID;
						toPlayer.ADDNETPLAYER_GAME_spownPoint = (evt as Net_Game_ManagerEvent).ADDNETPLAYER_spownPoint;
						toPlayer.ADDNETPLAYER_GAME_map = (evt as Net_Game_ManagerEvent).ADDNETPLAYER_map;
						_playerManager.OnReceive(toPlayer);
						return;
					}
					case Net_Game_ManagerEvent.REMOVENETPLAYER:
					{
						var toPlayer:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.REMOVENETPLAYER_GAME);
						toPlayer.REMOVENETPLAYER_GAME_ID = (evt as Net_Game_ManagerEvent)._playerID;
						_playerManager.OnReceive(toPlayer);
						return;
					}
					case Net_Game_ManagerEvent.LOGINRESULT:
					{
						TextFieldHandle("登录信息:");
						if ((evt as Net_Game_ManagerEvent).LOGINRESULT_result == "true")
						{
							TextFieldHandle("登录成功!");
							GloableData.HasLogin = true;
							//加载数据
							//UI进度条加载
							//返回结果数据
							var tempArray:Array = new Array();
							tempArray.push(false);
							var appBack:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.ARGTOAPP_GAME);
							appBack.ARGTOAPP_GAME_name = "LoginPanelApp";
							appBack.ARGTOAPP_GAME_args = tempArray;
							_appManager.OnReceive(appBack);
							//关闭登录应用
							var closeAppEvt:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.CLOSEAPP_GAME);
							closeAppEvt.CLOSEAPP_GAME_name = "LoginPanelApp";
							_appManager.OnReceive(closeAppEvt);
							//请求摩尔登录基础数据
							var moleLogin:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.APPLYMOLELOGININFO);
							_netManager.OnReceive(moleLogin);
						}
						else
						{
							var tempArray:Array = new Array();
							tempArray.push(false);
							var appBack:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.ARGTOAPP_GAME);
							appBack.ARGTOAPP_GAME_name = "LoginPanelApp";
							appBack.ARGTOAPP_GAME_args = tempArray;
							_appManager.OnReceive(appBack);
							ApplicationManager.GetIDialog().ShowDialog("emoy", "sad", "登录失败，用户名或密码错误!", null);
							TextFieldHandle("登录失败，用户名或密码错误");
						}
						return;
					}
					case Net_Game_ManagerEvent.NETPLAYERMOVE://网络玩家移动
					{
						var plevm:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.NETPLAYERMOVE_GAME);
						plevm.NETPLAYERMOVE_GAME_ID = (evt as Net_Game_ManagerEvent)._playerID;
						plevm.NETPLAYERMOVE_GAME_target = (evt as Net_Game_ManagerEvent).NETPLAYERMOVE_point;
						_playerManager.OnReceive(plevm);
						return;
					}
					case Net_Game_ManagerEvent.NETCHATMSG://网络玩家说
					{
						var pla:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.SHOWMSG_GAME);
						pla.SHOWMSG_GAME_id = (evt as Net_Game_ManagerEvent)._playerID;
						pla.SHOWMSG_GAME_msg = (evt as Net_Game_ManagerEvent).NETCHATMSG_msg;
						_playerManager.OnReceive(pla);
						return;
					}
					case Net_Game_ManagerEvent.CHANGEWEATHER://改变天气
					{
						_mapManager.ChangeWeather((evt as Net_Game_ManagerEvent).CHANGEWEATHER_weather, (evt as Net_Game_ManagerEvent).CHANGEWEATHER_strength);
						GloableData.CurrentWeather = (evt as Net_Game_ManagerEvent).CHANGEWEATHER_weather;
						GloableData.CurrentWeatherStrength = (evt as Net_Game_ManagerEvent).CHANGEWEATHER_strength;
						OnWeatherChange();
						return;
					}
					case Net_Game_ManagerEvent.CREATACCOUNTRESULT:
					{
						var backEvt:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.CREATACCOUNTRESULT_GAME);
						backEvt.CREATACCOUNTRESULT_GAME_id = (evt as Net_Game_ManagerEvent).CREATACCOUNTRESULT_id;
						backEvt.CREATACCOUNTRESULT_GAME_result = (evt as Net_Game_ManagerEvent).CREATACCOUNTRESULT_result;
						_appManager.OnReceive(backEvt);
						return;
					}
					case Net_Game_ManagerEvent.MOLEBASEINFO:
					{
						if ((evt as Net_Game_ManagerEvent).MOLEBASEINFO_num == 0)//需要注册
						{
							_appManager.StartApp("CreateMoleApp");
							return;
						}
						//此时为正常登录
						GloableData.MoleColor = (evt as Net_Game_ManagerEvent).MOLEBASEINFO_color;
						GloableData.MoleName = (evt as Net_Game_ManagerEvent).MOLEBASEINFO_name;
						_uiManager.LoadUI("UI/LoadingBar.swf", _uiHighContainer);//先加载进度条，然后加载其余ui和玩家，再加载地图，最后加载音频
						return;
					}
					case Net_Game_ManagerEvent.NETTHROWITEM:
					{
						var top:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.ONTHROWITEM_GAME);
						top.ONTHROWITEM_GAME_actionDir = (evt as Net_Game_ManagerEvent).NETTHROWITEM_dir;
						top.ONTHROWITEM_GAME_actionName = (evt as Net_Game_ManagerEvent).NETTHROWITEM_action;
						top.ONTHROWITEM_GAME_blood = (evt as Net_Game_ManagerEvent).NETTHROWITEM_blood;
						top.ONTHROWITEM_GAME_itemStyle = (evt as Net_Game_ManagerEvent).NETTHROWITEM_itemStyle;
						top.ONTHROWITEM_GAME_owner = (evt as Net_Game_ManagerEvent).NETTHROWITEM_id;
						top.ONTHROWITEM_GAME_position = (evt as Net_Game_ManagerEvent).NETTHROWITEM_position;
						_playerManager.OnReceive(top);
						return;
					}
					case Net_Game_ManagerEvent.CREATEMOLEBACK:
					{
						if ((evt as Net_Game_ManagerEvent).CREATEMOLEBACK_result)
						{
							//关闭创建摩尔页面
							var close:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.CLOSEAPP_GAME);
							close.CLOSEAPP_GAME_name = "CreateMoleApp";
							_appManager.OnReceive(close);
							//请求MoleBaseInfo
							var moleLogin:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.APPLYMOLELOGININFO);
							_netManager.OnReceive(moleLogin);
							return;
						}
						//否则失败的话
						/*var back:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.ARGTOAPP_GAME);
						var temps:Array = new Array();
						temps.push(false);
						back.ARGTOAPP_GAME_name = "CreateMoleApp";
						back.ARGTOAPP_GAME_args = temps;
						_appManager.OnReceive(back);*/
						_appManager.ShowDialog("emoy", "sad", "创建摩尔失败，请稍后再试", null);
						return;
					}
					case UI_Game_ManagerEvent.PASSDIALOGSTYLE:
					{
						var pgm:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.PASSDIALOGSTYLE_GAME);
						pgm.PASSDIALOGSTYLE_GAME_body = (evt as UI_Game_ManagerEvent).PASSDIALOGSTYLE_body;
						_playerManager.OnReceive(pgm);
						return;
					}
					case UI_Game_ManagerEvent.SHOWMSG:
					{
						var pl:Player_Game_ManagerEvent = new Player_Game_ManagerEvent(Player_Game_ManagerEvent.SHOWMSG_GAME);
						pl.SHOWMSG_GAME_id = "local";
						pl.SHOWMSG_GAME_msg = (evt as UI_Game_ManagerEvent).SHOWMSG_msg;
						_playerManager.OnReceive(pl);
						
						//同时向网络播报
						var mss:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.NETCHATMSG_GAME);
						mss.NETCHATMSG_GAME_msg = (evt as UI_Game_ManagerEvent).SHOWMSG_msg;
						_netManager.OnReceive(mss);
						return;
					}
				}
			}			
			if (evt is DebugEvent)
			{
				TextFieldHandle((evt as DebugEvent).Log);
			}
		}
		private function OnConnect(evt:TimerEvent)
		{
			_netManager.Connect();
			(evt.target as Timer).removeEventListener(TimerEvent.TIMER, OnConnect);
		}
		
		private function DelateCreatAccount(evt:TimerEvent)
		{
			CreatAccount(GloableData.TempPWD);
			(evt.target as Timer).removeEventListener(TimerEvent.TIMER, DelateLogin);
		}
		private function CreatAccount(pwd:String)
		{
			var evttt:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.CREATACCOUNT_GAME);
			evttt.CREATACCOUNT_GAME_pwd = pwd;
			_netManager.OnReceive(evttt);
		}
		private function OnLogin(evt:TimerEvent)
		{
			Login( ((uint)(Math.random() * 100000000)).toString(), ((uint)(Math.random() * 100000000)).toString());
			(evt.target as Timer).removeEventListener(TimerEvent.TIMER, OnLogin);
		}
		private function DelateLogin(evt:TimerEvent)
		{
			Login(GloableData.TempID, GloableData.TempPWD);
			(evt.target as Timer).removeEventListener(TimerEvent.TIMER, DelateLogin);
		}
		private function Login(id:String,pwd:String)
		{
			//测试代码
			if (GloableData.HasLogin) { TextFieldHandle("重复登录!"); return; }
			var evtTEmp:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.LOGININ);
			evtTEmp.LOGININ_GAME_playerKey = id;
			evtTEmp.LOGININ_GAME_playerSecret = pwd;
			_netManager.OnReceive(evtTEmp);
			TextFieldHandle("发送连接请求");
		}
		private function OnDelayStart()//在开始时基础组件加载完成调用
		{
			_appManager.LoadStartApp(AppDataLink.GetUrlByName("FriendsApp"), _appContainer.GetContainer());//加载聊天玩家信息应用组件
			_appManager.LoadStartApp(AppDataLink.GetUrlByName("LittleNoteApp"), _appContainer.GetContainer());//加载小纸条基础应用组件
		}
		public function GetAppContainer():Sprite
		{
			return _appContainer.GetContainer();
		}
		public function RemoveAllDisplay()
		{
			for (var a:int = 0; a < this.numChildren; a++ )
			{
				this.removeChildAt(a);
			}
		}
		public function AddAllDisplay()
		{
			this.addChild(_mapsContainer);
			this.addChild(_uiContainer);
			this.addChild(_appContainer);
			this.addChild(_effectContainer);
			this.addChild(_uiHighContainer);
			this.addChild(_interactContainer);
			this.addChild(_debugContainer);
		}
		public function ShowAndPlay()//called when change map
		{
			if (_resourceManager.IsLoading) { return; }
			//游戏的基础实现部分
			_effectContainer.ShowAndTurnBright();
			//这里只先播放音乐，背景音在天气数据加载后播放
			_soundManager.SmoothOnMusic();
			_uiManager.StartUIByUrl("UI/ToolBar.swf");
			_playerManager.ResetPlayer();
			_mapManager.AddPlayerToMap(_playerManager.playerAvatar, _dataBridge.spawnPoint, false, _playerManager.playerController);
			//发送基础数据
			var evtos:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.NETUPDATE_GAME);
			evtos.NETUPDATE_GAME_map =GloableData.CurrentMap;
			evtos.NETUPDATE_GAME_position = _dataBridge.spawnPoint;
			_netManager.OnReceive(evtos);
			//请求地图天气
			var callWeather:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.WEATHER_GAME);
			_netManager.OnReceive(callWeather);
			//请求所有区域玩家数据
			var evtapply:Net_Game_ManagerEvent = new Net_Game_ManagerEvent(Net_Game_ManagerEvent.NETPLAYERLISTAPPLY_GAME);
			evtapply.NETPLAYERLISTAPPLY_GAME_map = GloableData.CurrentMap;
			_netManager.OnReceive(evtapply);
			//执行大型组件初始化
			if (_beginFlag) { OnDelayStart(); }
			_beginFlag = false;
		}
		private function OnWeatherChange()//当天气改变
		{
			_soundManager.SmoothOnSound();
		}
		
		private function TextFieldHandle(str:String)
		{
			if (!GloableData.MasterMode) { return; }
			var txF:TextField = (_debugContainer.getChildAt(0) as TextField);
			txF.text = _textField.text + "\n" + str;
		}
		
		public static function get NetManagerFuncer():INetManager
		{
			return _netManager;
		}
		public static function get ApplicationManagerFuncer():IApplicationManager
		{
			return _appManager;
		}
	}

}