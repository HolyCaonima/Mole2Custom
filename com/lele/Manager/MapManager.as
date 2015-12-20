package com.lele.Manager
{
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import com.lele.Controller.PlayerController;
	import com.lele.Controller.NetWorkController;
	import com.lele.Map.Enum.Weather;
	import com.lele.Manager.Events.ManagerEventBase;
	import com.lele.Manager.Events.Map_Game_ManagerEvent;
	import com.lele.Manager.Events.MapData_Map_ManagerEvent;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Manager.Interface.IResourceLoader; 
	import com.lele.Plugin.RoadFind.Interface.IRoadFinder;
	import com.lele.Map.Interface.IMapDocument;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class MapManager extends Sprite implements IReport
	{
		private var _currentMapDoc:IMapDocument;
		private var _currentContainer:Sprite;
		private var _resourceLoader:IResourceLoader;
		private var _currentUrl:String;
		private var _repoter:IReport;
		
		public function MapManager(resourceLoader:IResourceLoader,report:IReport) 
		{
			_repoter = report;
			_resourceLoader = resourceLoader;
		}
		public function LoadAndStart(url:String, container:Sprite,useUI:Boolean=false,UIType:String="NULL")
		{
			_currentUrl = url;
			_currentContainer = container;
			_resourceLoader.LoadResource("MapManager",url, OnLoadStartMapComplete,useUI,UIType);
		}
		
		public function UnLoadMap()
		{
			//清除地图资源
			_currentMapDoc.Clean();
			{//移除地图, 先移除地图再卸载资源
				var evt:Map_Game_ManagerEvent = new Map_Game_ManagerEvent(Map_Game_ManagerEvent.REMOVE_MAP);
				evt._map = _resourceLoader.GetContentByID("MapManager", _currentUrl).content;
				_repoter.OnReport(evt);
			}
			_resourceLoader.UnLoadResource("MapManager",_currentUrl);
		}
		
		private function OnLoadStartMapComplete(evt:Event)
		{
			_currentMapDoc = evt.target.content as IMapDocument;
			_currentContainer.addChild(evt.target.content);
			
			var loaded:Map_Game_ManagerEvent = new Map_Game_ManagerEvent(Map_Game_ManagerEvent.MAPLOADED);//回传地图加载完成事件
			_repoter.OnReport(loaded);
		}
		private function OnLoadMapComplete(evt:Event)
		{
			_currentMapDoc = evt.target.content as IMapDocument;
			
			var loaded:Map_Game_ManagerEvent = new Map_Game_ManagerEvent(Map_Game_ManagerEvent.MAPLOADED);//回传地图加载完成事件
			_repoter.OnReport(loaded);
		}
		
		public function AddItemToMapFront(sp:Sprite)
		{
			_currentMapDoc.AddToFrontLayer(sp);
		}
		public function AddPlayerToMap(myAvatar:IAvatar,swapPo:Point,isHit:Boolean,playController:PlayerController)
		{
			_currentMapDoc.LoadMap(myAvatar, swapPo,isHit, playController,this);//向本级汇报
		}
		public function AddNetPlayerToMap(avatar:IAvatar,contorller:NetWorkController)
		{
			_currentMapDoc.AddNetPlayerToMap(avatar,contorller);
		}
		public function RemoveNetAvatarFromMap(avatar:IAvatar)
		{
			_currentMapDoc.RemoveNetAvatarFromMap(avatar);
		}
		public function ChangeWeather(weather:String,strength:int)
		{
			switch(weather)
			{
				case "rain":
					_currentMapDoc.SetWeather(Weather.RAIN,strength);
					break;
				case "sun":
					_currentMapDoc.SetWeather(Weather.SUN,0);
					break;
			}
		}
		public function OnReport(evt:Event):void//这个函数其实还要调用高层的函数，这里由于上层没写，暂时这样,本质是一个事件向上传递的过程
		{
			if (evt is ManagerEventBase)
			{
				var event:ManagerEventBase = evt as ManagerEventBase;
				switch(event.EvtType)
				{
					case MapData_Map_ManagerEvent.CHANGE_MAP://如果是修改地图事件,,这里如果不重新new一个过去，会出问题，脑残的AS
					{
						var evvt:Map_Game_ManagerEvent = new Map_Game_ManagerEvent(Map_Game_ManagerEvent.CHANGE_MAP);
						evvt.CHANGE_MAP_spawnPoint = (event as MapData_Map_ManagerEvent).CHANGE_MAP_spawnPoint;
						evvt.CHANGE_MAP_targetMap = (event as MapData_Map_ManagerEvent).CHANGE_MAP_targetMap;
						evvt.CHANGE_MAP_sourceMap = (event as MapData_Map_ManagerEvent).CHANGE_MAP_sourceMap;
						_repoter.OnReport(evvt);
						return;
					}
					case MapData_Map_ManagerEvent.CALLLOADAPP:
					{
						var evvt:Map_Game_ManagerEvent = new Map_Game_ManagerEvent(Map_Game_ManagerEvent.CALLLOADAPP);
						evvt.CALLLOADAPP_appName = (event as MapData_Map_ManagerEvent).CALLLOADAPP_appName;
						_repoter.OnReport(evvt);
						return;
					}
				}
			}
		}
	}

}