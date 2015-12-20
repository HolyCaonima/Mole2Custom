package com.lele.Manager
{
	import com.lele.Data.GloableData;
	import com.lele.Manager.Events.DebugEvent;
	import com.lele.Manager.Events.ManagerEventBase;
	import com.lele.Manager.Events.UI_Game_ManagerEvent;
	import com.lele.Manager.Events.UIData_UI_ManagerEvent;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Manager.Interface.IResourceLoader;
	import com.lele.Data.IUIData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	//这个特别废啊，当初没考虑好，这东西完全可以被AppManager取代
	//UIManager存放和管理UI及层次关系，但具体的方法内容，核心由对应的管理器管理
	public class UIManager extends Sprite implements IReport//必须继承Sprite不然得自己实现事件系统
	{
		private static var _resourceCount:int;
		
		private var _resourceLoader:IResourceLoader;
		private var _resourceData:Array;//因为UI元素非常多
		private var _repoter:IReport;
		//UI资源集
		private var _container:Object;//定义成OBj通过URL访问，实现跨函数访问，存储容器
		private var _loadingItems:int;
		
		//加载条
		private var _mapLoadingBarDoc:IUIData;
		private var _mapLoadingBar:MovieClip;
		private var _itemLoadingBar:MovieClip;
		private var _loadingBarContainer:Sprite;
		
		//点击特性
		private var _clickStyleContainer:Sprite;
		private var _clickStyle:MovieClip;
		
		public function UIManager(resourceLoader:IResourceLoader,repote:IReport) 
		{
			_loadingItems = 0;
			_resourceCount = 0;
			_container = new Object();
			_resourceData = new Array();
			_repoter = repote;
			_resourceLoader = resourceLoader;
		}
		public function LoadUI(url:String, container:Sprite,useUI:Boolean=false,UIType:String="NULL")
		{
			_loadingItems++;
			_container[url] = container;//用资源地址做标识存放资源存放容器，
			_resourceLoader.LoadResource("UIManager", url, OnLoadUIComplete,useUI,UIType);
		}
		public function StartUIByUrl(url:String)
		{
			var tempUnit:UIUnit = GetUIUnitByURL(url);
			if (tempUnit != null) { tempUnit.StartUI(); }
		}
		public function StartLastestUI()
		{
			(_resourceData[_resourceData.length - 1] as UIUnit).StartUI();
		}
		public function set highUIContainer(container:Sprite)
		{
			_loadingBarContainer = container;
		}
		
		public function OnPostProgess(evt:UI_Game_ManagerEvent)
		{
			if (evt._type == "MAP")
			{
				if (evt._isComplete) 
				{
					_mapLoadingBar.gotoAndPlay(101); //当完成时从101帧播放
					_mapLoadingBar.addFrameScript(130, function() 
					{
						_mapLoadingBar.stop();
						OnPostProcessOver();
					});
					return;
				}
				if (_loadingBarContainer.numChildren == 0) { _loadingBarContainer.addChild(_mapLoadingBar); }//当无内部对象时加载
				_mapLoadingBar.gotoAndStop(evt._process);
			}
		}
		private function OnPostProcessOver()
		{
			_loadingBarContainer.removeChildAt(0);
			_mapLoadingBar.gotoAndStop(0);
		}
		
		private function GetUIUnitByURL(url:String):UIUnit
		{
			for (var a:int = 0; a < _resourceData.length; a++ )
			{
				if ((_resourceData[a] as UIUnit).IsEqual(url))
				{
					return _resourceData[a] as UIUnit;
				}
			}
			return null;
		}
		private function OnLoadUIComplete(evt:Event)
		{
			_loadingItems--;
			_resourceCount++;
			var tempData:IUIData = evt.target.content as IUIData;
			var newUIUnit:UIUnit = new UIUnit(tempData, _container[tempData.FileUrl] as Sprite);
			tempData.Repoter = this;
			_resourceData.push(newUIUnit);
			//发送事件
			if (_loadingItems > 0) { return; }//说明还在加载
			if (tempData.FileUrl == "UI/LoadingBar.swf")
			{
				_mapLoadingBar = tempData.UI as MovieClip;
				_mapLoadingBar.x += 960 / 2;
				_mapLoadingBar.y += 540 / 2;
				_mapLoadingBarDoc = tempData;
				
				//向上级发送事件
				var tempEVT:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.LOADINGBARLOADEDEVENT);
				_repoter.OnReport(tempEVT);
			}
			else
			{
				var tempEVT:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.UILOADEDEVENT);
				_repoter.OnReport(tempEVT);
			}
		}
		public function LoadAndStart( url:String,container:Sprite,useUI:Boolean=false,UIType:String="NULL")
		{
			_loadingItems++;
			_container[url] = container;
			_resourceLoader.LoadResource( "UIManager", url, OnLoadStartUIComplete,useUI,UIType);
		}
		private function OnLoadStartUIComplete(evt:Event)
		{
			_loadingItems--;
			_resourceCount++;
			var tempData:IUIData = evt.target.content as IUIData;
			var newUIUnit:UIUnit = new UIUnit(tempData, _container[tempData.FileUrl] as Sprite);
			tempData.Repoter = this;
			_resourceData.push(newUIUnit);
			newUIUnit.StartUI();
			
			//发送事件
			if (_loadingItems > 0) { return; }
			var tempEVT:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.UILOADEDEVENT);
			_repoter.OnReport(tempEVT);
		}
		public function UnLoadUI(url:String)//卸载UI
		{
			var temp:UIUnit = GetUIUnitByURL(url);
			temp.Delete();
			_resourceLoader.UnLoadResource("UIManager", url);
			for (var a:int = 0; a < _resourceData.length; a++ )
			{
				if (_resourceData[a] == temp)
				{
					_resourceData.splice(a, 1);//移除
					
					var tempEvt:DebugEvent = new DebugEvent("UI:" + url + "卸载"); 
					_repoter.OnReport(tempEvt);
					return;
				}
			}
		}
				
		public function OnReport(evt:Event):void
		{
			if (evt is ManagerEventBase)
			{
				var event:ManagerEventBase = evt as ManagerEventBase;
				switch(event.EvtType)
				{
					case UIData_UI_ManagerEvent.SHOWUIBYURL:
					{
						var unit:UIUnit = GetUIUnitByURL((evt as UIData_UI_ManagerEvent).SHOWUIBYURL_url);
						unit.StartUI();
						return;
					}
					case UIData_UI_ManagerEvent.CHANGEMAP:
					{
						var uitomap:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.CALLMAPMANAGERCHANGEMAP);
						uitomap.CALLMAPMANAGERCHANGEMAP_spawnPoint = (evt as UIData_UI_ManagerEvent).CHANGEMAP_point;
						uitomap.CALLMAPMANAGERCHANGEMAP_targetMap = (evt as UIData_UI_ManagerEvent).CHANGEMAP_mapname;
						uitomap.CALLMAPMANAGERCHANGEMAP_sourceMap = GloableData.CurrentMap;
						if (uitomap.CALLMAPMANAGERCHANGEMAP_targetMap == uitomap.CALLMAPMANAGERCHANGEMAP_sourceMap) { return; }//如果地图相同则直接退出
						_repoter.OnReport(uitomap);
						return;
					}
					case UIData_UI_ManagerEvent.STOPUI:
					{
						var unit:UIUnit = GetUIUnitByURL((evt as UIData_UI_ManagerEvent).STOPUI_url);
						unit.StopUI();
						return;
					}
					case UIData_UI_ManagerEvent.CALLLOADAPP:
					{
						var loadAppEvt:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.CALLLOADAPP);
						loadAppEvt.CALLLOADAPP_url = (evt as UIData_UI_ManagerEvent).CALLLOADAPP_url;
						loadAppEvt.CALLLOADAPP_params = (evt as UIData_UI_ManagerEvent).CALLLOADAPP_params;
						loadAppEvt.CALLLOADAPP_useUI = (evt as UIData_UI_ManagerEvent).CALLLOADAPP_useUI;
						loadAppEvt.CALLLOADAPP_uiType = (evt as UIData_UI_ManagerEvent).CALLLOADAPP_uiType;
						_repoter.OnReport(loadAppEvt);
						return;
					}
					case UIData_UI_ManagerEvent.CALLUNLOADAPP:
					{
						var unload:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.CALLUNLOADAPP);
						unload.CALLUNLOADAPP_url = (evt as UIData_UI_ManagerEvent).CALLUNLOADAPP_url;
						_repoter.OnReport(unload);
						return;
					}
					case UIData_UI_ManagerEvent.PASSDIALOGSTYLE:
					{
						var evts:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.PASSDIALOGSTYLE);
						evts.PASSDIALOGSTYLE_body = (evt as UIData_UI_ManagerEvent).PASSDIALOGSTYLE_body;
						_repoter.OnReport(evts);
						return;
					}
					case UIData_UI_ManagerEvent.SHOWMSG:
					{
						var ev:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.SHOWMSG);
						ev.SHOWMSG_msg = (evt as UIData_UI_ManagerEvent).SHOWMSG_msg;
						_repoter.OnReport(ev);
						return;
					}
					case UIData_UI_ManagerEvent.SHOWFRIENDLIST:
					{
						var t:UI_Game_ManagerEvent = new UI_Game_ManagerEvent(UI_Game_ManagerEvent.SHOWFRIENDLIST);
						_repoter.OnReport(t);
						return;
					}
				}
			}
		}
		
	}

}
import com.lele.Data.IUIData;
import flash.display.Sprite;

class UIUnit extends Sprite//UI单元。包含了UI的存在层次和UI数据
{
	public var _UIData:IUIData;
	public var _UIContainer:Sprite;
	private var _isStarted:Boolean;//标识加载完了以后是否显示出来
	
	public function UIUnit(UIData:IUIData,UIContainer:Sprite)
	{
		_isStarted = false;
		_UIContainer = UIContainer;
		_UIData = UIData;
	}
	public function StartUI()
	{
		if (_isStarted) { return; }//如果开启了就不要重复开启
		_isStarted = true;
		_UIContainer.addChild(_UIData.UI);
	}
	public function StopUI()
	{
		_isStarted = false;
		_UIContainer.removeChild(_UIData.UI);
	}
	public function Delete()
	{
		_isStarted = false;
		_UIContainer.removeChild(_UIData.UI);
		_UIData.CleanResource();
		_UIData = null;
		_UIContainer = null;
	}
	public function IsEqual(url:String):Boolean
	{
		if (url == _UIData.FileUrl) { return true; }
		return false;
	}
	public function get IsStarted():Boolean
	{
		return _isStarted;
	}
}