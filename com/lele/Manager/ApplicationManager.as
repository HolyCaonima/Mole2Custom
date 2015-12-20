package com.lele.Manager
{
	import com.lele.Manager.Interface.IApplicationManager;
	import com.lele.Manager.Interface.IApplyAppContainer;
	import com.lele.Manager.Interface.IDialog;
	import com.lele.Link.AppDataLink;
	import com.lele.Data.IAppData;
	import com.lele.Manager.Events.App_Game_ManagerEvent;
	import com.lele.Manager.Events.AppData_App_ManagerEvent;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Manager.Interface.IResourceLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	public class ApplicationManager implements IReport,IDialog,IApplicationManager
	{
		private static var _instance:IDialog;
		
		private var _applyContainer:IApplyAppContainer;
		private var _report:IReport;
		private var _resourceLoader:IResourceLoader;
		private var _AppData:Object;//AppUnit对象集合  //均通过对象URL查询
		private var _AppUrlList:Array;//表集合,一个表示当前加载的应用的集合
		private var _AppParams:Object;//一个参数集合
		
		private var _AppContainer:Object;//AppUnit对象存储容器的临时存储容器
		public function ApplicationManager(resourceloader:IResourceLoader,repoter:IReport,applyContainer:IApplyAppContainer) 
		{
			_AppParams = new Object();
			_AppUrlList = new Array();
			_AppContainer = new Object();
			_AppData = new Object();
			_report = repoter;
			_resourceLoader = resourceloader;
			_instance = this;
			_applyContainer = applyContainer;
		}
		public function StartAppMultiply(app:String,...arg)
		{
			GetAppUnitByUrl(AppDataLink.GetUrlByName(app)).StartAppMultiply(arg);
		}
		public static function GetIDialog():IDialog
		{
			return _instance;
		}
		public function StartApp(app:String, ...arg)
		{
			GetAppUnitByUrl(AppDataLink.GetUrlByName(app)).StartApp(arg);
		}
		public function ShowDialog(...arg)
		{
			try
			{
				GetAppUnitByUrl(AppDataLink.GetUrlByName("Dialog"))._AppContainer = _applyContainer.GetAppContainer();
				GetAppUnitByUrl(AppDataLink.GetUrlByName("Dialog")).StartAppMultiply(arg);
			}
			catch (er:Error) { trace(er.message);//资源未加载完
			}
		}
		public function AddNote(...arg)//[0]:标志位 0为YesNote 1为YNNote [1]为函数位 [2][3][4][5][6] title content mo day time
		{
			GetAppUnitByUrl(AppDataLink.GetUrlByName("LittleNote")).StartApp(arg);
		}
		public function LoadApp(url:String,container:Sprite,useUI:Boolean=false,UIType:String="NULL")
		{
			if (InTheList(url)) { return; }//如果存在就不加载
			_AppContainer[url] = container;
			AddToList(url);//添加到表单
			_resourceLoader.LoadResource("AppManager", url, OnLoadAppComplete, useUI, UIType);
		}
		private function OnLoadAppComplete(evt:Event)
		{
			var tempAppUnit:AppUnit = new AppUnit(evt.target.content, _AppContainer[(evt.target.content as IAppData).FileUrl]);
			tempAppUnit.Report = this;//一定要记着给Report;
			_AppData[tempAppUnit.URL] = tempAppUnit;
		}
		
		public function LoadStartApp(url:String, container:Sprite, useUI:Boolean = false, UIType:String = "NULL",params:Array=null)
		{
			if (InTheList(url)) { trace("App in the list,the loadStart request is refused"); return; }//如果存在就不加载
			_AppContainer[url] = container;
			AddToList(url);//添加到表单
			_AppParams[url] = params;//添加参数
			_resourceLoader.LoadResource("AppManager", url, OnLoadStartAppComplete, useUI, UIType);
		}
		private function OnLoadStartAppComplete(evt:Event)
		{
			var tempAppUnit:AppUnit = new AppUnit(evt.target.content, _AppContainer[(evt.target.content as IAppData).FileUrl]);
			tempAppUnit.Report = this;//一定要记着给Report;
			_AppData[tempAppUnit.URL] = tempAppUnit;
			tempAppUnit.StartApp(_AppParams[tempAppUnit.URL]);
			_AppParams[tempAppUnit.URL] = null;//再清除引用
		}
		private function GetAppUnitByUrl(url:String):AppUnit
		{
			return _AppData[url];
		}
		
		///对List的一些操作
		private function AddToList(url:String)
		{
			if (InTheList(url)) { return; }
			_AppUrlList.push(url);
		}
		private function RemoveFromList(url:String)
		{
			if (!InTheList(url)) { return; }
			for (var a:int = 0; a < _AppUrlList.length; a++ )
			{
				if (_AppUrlList[a] == url) { _AppUrlList.splice(a, 1); return; }
			}
		}
		private function InTheList(url:String):Boolean
		{
			for (var a:int = 0; a < _AppUrlList.length; a++ )
			{
				if (_AppUrlList[a] == url) { return true; }
			}
			return false;
		}
		private function CloseApp(appUrl:String)
		{
			var url:String = appUrl;
			var unit:AppUnit = GetAppUnitByUrl(url);
			_AppData[url] = null;
			unit.StopApp();
			unit.Delete();
			RemoveFromList(url);
			_resourceLoader.UnLoadResource("AppManager", url);
		}
		public function OnReceive(evbbbbt:Event)
		{
			var event:App_Game_ManagerEvent;
			if (evbbbbt is App_Game_ManagerEvent)
			{
				event = evbbbbt as App_Game_ManagerEvent;
				switch(event.EvtType)
				{
					case App_Game_ManagerEvent.CLOSEAPP_GAME:
					{
						CloseApp(AppDataLink.GetUrlByName(event.CLOSEAPP_GAME_name));
						return;
					}
					case App_Game_ManagerEvent.ARGTOAPP_GAME:
					{
						GetAppUnitByUrl(AppDataLink.GetUrlByName(event.ARGTOAPP_GAME_name)).AppDocStart(event.ARGTOAPP_GAME_args);
						return;
					}
					case App_Game_ManagerEvent.CREATACCOUNTRESULT_GAME:
					{
						var tempArray:Array = new Array();
						tempArray.push(event.CREATACCOUNTRESULT_GAME_result);
						tempArray.push(event.CREATACCOUNTRESULT_GAME_id);
						GetAppUnitByUrl(AppDataLink.GetUrlByName("ApplyPanelApp")).AppDocStart(tempArray);
						return;
					}
					case App_Game_ManagerEvent.NCHATLISTDATAS_GAME:
					{
						StartApp("FriendsApp", 6, event.NCHATLISTDATAS_GAME_data);
						return;
					}
				}
			}
		}
		
		public function OnReport(evt:Event):void
		{
			if (evt is AppData_App_ManagerEvent)
			{
				var event:AppData_App_ManagerEvent = evt as AppData_App_ManagerEvent;
				switch(event.EvtType)
				{
					case AppData_App_ManagerEvent.CLOSE:
					{
						CloseApp(event.CLOSE_url);
						return;
					}
					case AppData_App_ManagerEvent.CALLDOACTION:
					{
						var appGame:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.CALLDOACTION);
						appGame.CALLDOACTION_actionName = event.CALLDOACTION_actionName;
						_report.OnReport(appGame);
						return;
					}
					case AppData_App_ManagerEvent.SUBMITARTICLE:
					{
						var subArt:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.SUBMITARTICLE);
						subArt.SUBMITARTICLE_head = event.SUBMITARTICLE_head;
						subArt.SUBMITARTICLE_body = event.SUBMITARTICLE_body;
						_report.OnReport(subArt);
						return;
					}
					case AppData_App_ManagerEvent.SHOWSIMPLEDIALOG:
					{
						//"emoy", "sad", "与服务器的连接断开了，重新登陆吧!", null
						GetIDialog().ShowDialog("emoy", event.SHOWSIMPLEDIALOG_emo, event.SHOWSIMPLEDIALOG_info, event.SHOWSIMPLEDIALOG_callback);
						return;
					}
					case AppData_App_ManagerEvent.GOTOLOGIN:
					{
						var ett:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.GOTOLOGIN);
						_report.OnReport(ett);
						return;
					}
					case AppData_App_ManagerEvent.GOTOREGIST:
					{
						var ett:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.GOTOREGIST);
						_report.OnReport(ett);
						return;
					}
					case AppData_App_ManagerEvent.LOGIN:
					{
						var ettt:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.LOGIN);
						ettt.LOGIN_id = event.LOGIN_id;
						ettt.LOGIN_pwd = event.LOGIN_pwd;
						_report.OnReport(ettt);
						return;
					}
					case AppData_App_ManagerEvent.CREATACCOUNT:
					{
						var ett:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.CREATACCOUNT);
						ett.CREATACCOUNT_pwd = event.CREATACCOUNT_pwd;
						_report.OnReport(ett);
						return;
					}
					case AppData_App_ManagerEvent.OPENAPP:
					{
						var appName:String = event.OPENAPP_name;
						LoadStartApp(AppDataLink.GetUrlByName(appName), _applyContainer.GetAppContainer());
						return;
					}
					case AppData_App_ManagerEvent.CREATEMOLE:
					{
						var cm:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.CREATEMOLE);
						cm.CREATEMOLE_color = event.CREATEMOLE_color;
						cm.CREATEMOLE_name = event.CREATEMOLE_name;
						_report.OnReport(cm);
						return;
					}
					case AppData_App_ManagerEvent.ONTHROWITEM:
					{
						var ot:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.ONTHROWITEM);
						ot.ONTHROWITEM_actionDir = event.ONTHROWITEM_actionDir;
						ot.ONTHROWITEM_actionName = event.ONTHROWITEM_actionName;
						ot.ONTHROWITEM_aimStyle = event.ONTHROWITEM_aimStyle;
						ot.ONTHROWITEM_blood = event.ONTHROWITEM_blood;
						ot.ONTHROWITEM_itemStyle = event.ONTHROWITEM_itemStyle;
						_report.OnReport(ot);
						return;
					}
					case AppData_App_ManagerEvent.FRIENDCHATSEND:
					{
						//直达通路，简化数据传输过程。降低中心管理器负载
						GameManager.NetManagerFuncer.OnReceive(evt);
						return;
					}
					case AppData_App_ManagerEvent.RCHATLISTDATAS:
					{
						GameManager.NetManagerFuncer.OnReceive(evt);
						return;
					}
					case AppData_App_ManagerEvent.NCHATLISTDATAS:
					{
						var nc:App_Game_ManagerEvent = new App_Game_ManagerEvent(App_Game_ManagerEvent.NCHATLISTDATAS);
						_report.OnReport(nc);
						return;
					}
					case AppData_App_ManagerEvent.MAKEFRIEND:
					{
						GameManager.NetManagerFuncer.OnReceive(evt);
						return;
					}
					
				}
				
			}
			
		}//end function
		
	}

}
import com.lele.Data.IAppData;
import com.lele.Manager.Interface.IReport;
import flash.display.Sprite;

class AppUnit //应用单元
{
	private var _AppDoc:IAppData;
	public var _currentApp:Sprite;
	public var _multiplyApp:Array;
	public var _AppContainer:Sprite;
	public function AppUnit(appDoc:IAppData,appContainer:Sprite)
	{
		_multiplyApp = new Array();
		_AppDoc = appDoc;
		_AppContainer = appContainer;
	}
	public function StartApp(arg:Array=null)
	{
		_AppDoc.Start(arg);
		_currentApp = _AppDoc.App;
		_AppContainer.addChild(_currentApp);
	}
	public function StartAppMultiply(arg:Array=null)
	{
		_AppDoc.Start(arg);
		_multiplyApp.push(_AppDoc.App);
		_AppContainer.addChild(_multiplyApp[_multiplyApp.length - 1] as Sprite);
	}
	public function StopApp()
	{
		_AppDoc.Stop();
		_AppContainer.removeChild(_currentApp);
	}
	public function StopAppMultiply()
	{
		_AppDoc.Stop();
		for (var a:int = 0; a < _multiplyApp.length; a++ )
		{
			_AppContainer.removeChild(_multiplyApp[a] as Sprite);
		}
	}
	public function AppDocStart(arg:Array=null)
	{
		_AppDoc.Start(arg);
	}
	public function Delete()
	{
		_AppDoc.CleanResource();
		_AppDoc = null;
		_AppContainer = null;
		_currentApp = null;
		_multiplyApp = null;
	}
	public function get URL():String
	{
		return _AppDoc.FileUrl;
	}
	public function set Report(report:IReport)
	{
		_AppDoc.Repoter = report;
	}
}