package com.lele.Application
{
	import com.lele.Data.IAppData;
	import com.lele.Data.IAppChildData;
	import com.lele.Manager.Interface.IReport;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Lele
	 */
	public class ApplicationBase extends Sprite implements IAppData 
	{
		//App内的App管理
		private var _childResources:Array;
		private var _loadingStyle:MovieClip;
		private var _tempContainer:Object;
		private var _tempLoadStyle:Object;
		protected var _repoter:IReport;
		
		private function AddToResources(app:IAppChildData)
		{
			if (InResourcesList(app))
			{
				_childResources.push(app);
			}
		}
		private function RemoveFromResources(app:IAppChildData)
		{
			if (InResourcesList(app))
			{
				_childResources.splice(GetIndexOfApp(app), 1);
			}
		}
		private function InResourcesList(app:IAppChildData):Boolean
		{
			for (var a = 0; a < _childResources.length; a++ )
			{
				if ((_childResources[a] as IAppChildData).Name == app.Name)
				{
					return true;
				}
			}
			return false;
		}
		private function GetIndexOfApp(app:IAppChildData):int
		{
			for (var a = 0; a < _childResources.length; a++ )
			{
				if ((_childResources[a] as IAppChildData).Name == app.Name)
				{
					return a;
				}
			}
			return -1;
		}
		private function GetAppByName(name:String):IAppChildData
		{
			for (var a = 0; a < _childResources.length; a++ )
			{
				if ((_childResources[a] as IAppChildData).Name == name)
				{
					return (_childResources[a] as IAppChildData);
				}
			}
			return null;
		}
		protected function set LoadingStyle(styleMc:MovieClip)//设置加载图样
		{
			_loadingStyle = styleMc;
		}
		protected function StartByName(name:String)
		{
			var temp:IAppChildData = GetAppByName(name);
			if (temp != null)
			{
				temp.Start();
			}
		}
		protected function StopByName(name:String)
		{
			var temp:IAppChildData = GetAppByName(name);
			if (temp != null)
			{
				temp.Stop();
			}
		}
		protected function StartAll()
		{
			for (var a = 0; a < _childResources.length; a++ )
			{
				(_childResources[a] as IAppChildData).Start();
			}
		}
		protected function StopAll()
		{
			for (var a = 0; a < _childResources.length; a++ )
			{
				(_childResources[a] as IAppChildData).Stop();
			}
		}
		protected function UnloadAll()
		{
			StopAll();
			for (var a = 0; a < _childResources.length; a++ )
			{
				(_childResources[a] as IAppChildData).CleanResource();//调用子资源的资源回收方法
				RemoveFromResources(_childResources[a]);//这里也取消引用
				break;
			}
		}
		protected function UnloadByName(name:String)
		{
			StopByName(name);//先停止再删除
			var temp:IAppChildData = GetAppByName(name);
			if (temp != null)
			{
				temp.CleanResource();
				RemoveFromResources(temp);
			}
		}
		protected function UnloadApp(app:IAppChildData)
		{
			app.CleanResource();
			RemoveFromResources(app);
		}
		protected function OnLoadedInChildComplete(appData:IAppChildData,container:Sprite){}//子类重写调用
		protected function LoadWithStyle(container:Sprite, positionX:int, positionY:int, url:String,childAppName:String)
		{
			var request:URLRequest = new URLRequest(url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
			//通过反射获取_loadingStyle的类
			var loadingStyleClass:Class = getDefinitionByName(getQualifiedClassName(_loadingStyle)) as Class;
			//通过类创建对象
			var loadingStyle:MovieClip = new loadingStyleClass();
			
			container.addChild(loadingStyle);
			_loadingStyle.x = positionX;
			_loadingStyle.y = positionY;
			_tempContainer[childAppName] = container;
			_tempLoadStyle[childAppName] = loadingStyle;
			loader.load(request);
		}
		private function OnLoadComplete(evt:Event)//基类中的完成
		{
			var childAppData:IAppChildData = evt.target.content;
			(_tempContainer[childAppData.Name] as Sprite).removeChild(_tempLoadStyle[childAppData.Name] as MovieClip);//移除加载样式
			AddToResources(childAppData);
			OnLoadedInChildComplete(childAppData,_tempContainer[childAppData.Name] as Sprite);
			_tempContainer[childAppData.Name] = null;//清除临时资源
			_tempLoadStyle[childAppData.Name] = null;
		}
		
		//本App对外
		public function ApplicationBase() 
		{
			_childResources = new Array();
			_loadingStyle = new MovieClip();
			_tempContainer = new Object();
			_tempLoadStyle = new Object();
		}
		public function set Repoter(repote:IReport)
		{
			_repoter = repote;
		}
		public function CleanResource()
		{
			CleanResourceAddition();
			UnloadAll();
			_childResources = null;
			_loadingStyle = null;
			_tempContainer = null;
			_repoter = null;
		}
		protected function CleanResourceAddition(){}//由子类重写
		public function Stop()//由外部执行
		{
			StopAll();
		}
		public function Start(arg:Array=null)//由外部执行
		{
			StartAll();
		}
		public function get App():Sprite { return null; }
		public function get FileUrl():String { return null; }
		
	}

}