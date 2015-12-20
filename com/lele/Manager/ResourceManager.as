package com.lele.Manager
{
	import adobe.utils.CustomActions;
	import com.lele.Manager.Events.DebugEvent;
	import com.lele.Manager.Events.Resource_Game_ManagerEvent;
	import com.lele.Manager.Interface.IResourceLoader;
	import com.lele.Manager.Interface.IReport;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Lele
	 */
	public class ResourceManager implements IResourceLoader
	{
		private var _loaders:Object;
		private var _loadLefts:int;
		private var _repoter:IReport;
		private var _urlArray:Array;
		
		//加载效果用
		private var _currentStyle:String;//"MAP","ITEM","NULL"
		private var _loadingCount:int;
		
		public function ResourceManager(report:IReport) 
		{
			_loadLefts = 0;
			_loadingCount = 0;
			_urlArray = new Array();
			_loaders = new Object();
			_repoter = report;
		}
		
		public function LoadResource(hostId:String, url:String,OnComplete:Function,useUI:Boolean=false,UIType:String="NULL",isPrivate:Boolean=false):void//这个OnComplete必须是基于事件
		{
			if (_loaders[hostId+ "_"+url] != null)
			{//说明资源存在却请求重复加载
				trace("资源存在:" + "hostID:" + hostId + "  url:" + url + "卸载资源并重新加载");
				var DebugEvt:DebugEvent = new DebugEvent("资源存在:" + "hostID:" + hostId + "  url:" + url + "卸载资源并重新加载");
				_repoter.OnReport(DebugEvt);
				UnLoadResource(hostId, url);
			}
			CheckAdd(hostId + "_" + url);
			var urlRequest:URLRequest= new URLRequest(url);//Map/Map002.swf
			var currentLoader:Loader = new Loader();
			if (useUI)
			{
				_currentStyle = UIType;
				currentLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, OnProgress);
				_loadingCount++;
			}
			currentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function() { if (!isPrivate) { _loadLefts--; }} );//涉及到侦听顺序，所以本地优先
			currentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnComplete);
			currentLoader.load(urlRequest);
			_loaders[hostId + "_" + url] = currentLoader;
			_loaders[hostId + "_" + url + "_state"] = false;
			if(!isPrivate)
				_loadLefts++;
		}
		public function UnLoadResource(hostId:String,url:String):void
		{
			CheckRemove(hostId + "_" + url);
			if ((_loaders[hostId+"_"+url] as Loader) == null) { return; }
			(_loaders[hostId+"_"+url] as Loader).unloadAndStop(true);
			_loaders[hostId + "_" + url] = null;
			_loaders[hostId + "_" + url + "_state"] = null;
		}
		public function GetContentByID(hostID:String,url:String):Object
		{
			return _loaders[hostID+"_"+url];
		}
		/*private function OnLoaded(evt:Event)
		{
			_loadLefts--;
		}*/
		
		public function get IsLoading():Boolean//全局的 public 型
		{
			if (_loadLefts == 0)
			return false;
			return true;
		}
		
		public function get CurrentResourceLength():int
		{
			return _urlArray.length;
		}
		
		
		
		private function OnProgress(evt:ProgressEvent)//加载是否完成是看
		{
			if (evt.bytesLoaded / evt.bytesTotal == 1) { _loadingCount--; }
			if (_loadingCount == 0)
			{
				var loadedEvt:Resource_Game_ManagerEvent = new Resource_Game_ManagerEvent(Resource_Game_ManagerEvent.LOADINGPROCESSEVENT);
				loadedEvt._isComplete = true;
				loadedEvt._type = "MAP";
				_repoter.OnReport(loadedEvt);
				(evt.target as LoaderInfo).removeEventListener(ProgressEvent.PROGRESS, OnProgress);
				//trace("加载完毕")
			}
			else
			{
				var loadedEvt:Resource_Game_ManagerEvent = new Resource_Game_ManagerEvent(Resource_Game_ManagerEvent.LOADINGPROCESSEVENT);
				loadedEvt._isComplete = false;
				loadedEvt._type = "MAP";
				loadedEvt._process = (evt.bytesLoaded / evt.bytesTotal)*100;
				_repoter.OnReport(loadedEvt);
			}
			//trace(evt.bytesLoaded/evt.bytesTotal);
		}
		
		
		
		private function CheckRemove(urlTip:String):void
		{
			for (var a:int = 0; a < _urlArray.length; a++ )
			{
				if (_urlArray[a] == urlTip)
				{
					_urlArray.splice(a, 1);
					return;
				}
			}
		}
		private function CheckAdd(urlTip:String):void
		{
			for (var a:int = 0; a < _urlArray.length; a++ )
			{
				if (_urlArray[a] == urlTip)
				{
					return;
				}	
			}
			_urlArray.push(urlTip);
		}
		
	}

}