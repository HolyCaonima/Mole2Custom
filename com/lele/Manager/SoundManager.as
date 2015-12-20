package com.lele.Manager
{
	import com.lele.Data.GloableData;
	import com.lele.Link.MediaDataLink;
	import com.lele.Manager.Events.Sound_Game_ManagerEvent;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Manager.Interface.IResourceLoader;
	import com.lele.Data.ISoundData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Lele
	 */
	public class SoundManager extends Sprite implements IReport
	{
		private var _repoter:IReport;
		private var _resourceLoader:IResourceLoader;
		private var _soundData:Object;//一个音频资源对象的集合
		private var _dataList:Array;//一个地址集合
		
		public function SoundManager(resourceLoader:IResourceLoader,report:IReport) 
		{
			_dataList = new Array();
			_soundData = new Object();
			_repoter = report;
			_resourceLoader = resourceLoader;
		}
		public function LoadMusic(url:String,useUI:Boolean=false,UIType:String="NULL"):void//加载音频
		{
			AddToList(url);
			_resourceLoader.LoadResource( "SoundManager",url, OnLoadComplete,useUI,UIType);
		}
		private function OnLoadComplete(evt:Event)
		{
			var tempData:ISoundData = evt.target.content as ISoundData;
			_soundData[tempData.FileUrl] = new DataUnit(tempData);
			//发送信息加载完毕
			var tempEVT:Sound_Game_ManagerEvent = new Sound_Game_ManagerEvent(Sound_Game_ManagerEvent.SOUNDLOADEDEVENT);
			_repoter.OnReport(tempEVT);
		}
		
		public function LoadAndStart(url:String,useUI:Boolean=false,UIType:String="NULL"):void//加载并播放
		{
			AddToList(url);
			_resourceLoader.LoadResource( "SoundManager",url, OnLoadPlayComplete,useUI,UIType);
		}
		private function OnLoadPlayComplete(evt:Event)
		{
			var tempData:ISoundData = evt.target.content as ISoundData;
			_soundData[tempData.FileUrl] = new DataUnit(tempData);
			(_soundData[tempData.FileUrl] as DataUnit).SmoothPlayAll(false, true);
			
			//发送信息加载完毕
			var tempEVT:Sound_Game_ManagerEvent = new Sound_Game_ManagerEvent(Sound_Game_ManagerEvent.SOUNDLOADEDEVENT);
			_repoter.OnReport(tempEVT);
		}
		
		public function UnLoadSound(dataUrl:String)
		{
			RemoveFromList(dataUrl);
			(_soundData[dataUrl] as DataUnit).Delete();
			_soundData[dataUrl] = null;
			_resourceLoader.UnLoadResource("SoundManager",dataUrl);
		}
		public function SmoothOnAll()//开始最新的
		{
			(_soundData[_dataList[_dataList.length-1]] as DataUnit).SmoothPlayAll(false, true);
		}
		public function SmoothOnMusic()//开始最新的
		{
			(_soundData[_dataList[_dataList.length - 1]] as DataUnit).SmoothPlayMusic();
		}
		public function SmoothOnSound()
		{
			(_soundData[_dataList[_dataList.length - 1]] as DataUnit).SmoothPlaySound(GloableData.CurrentWeather, GloableData.CurrentWeatherStrength);
		}
		public function SmoothCloseAll()//停止最新的
		{
			(_soundData[_dataList[_dataList.length - 1]] as DataUnit).SmoothStopAll();
		}
		public function SmoothCloseByName(name:String)
		{
			(_soundData[MediaDataLink.GetUrlByName(name)] as DataUnit).SmoothStopAll();
		}
		
		private function InTheList(url:String):Boolean
		{
			for (var a:int = 0; a < _dataList.length; a++ )
			{
				if (_dataList[a] == url) { return true; }
			}
			return false;
		}
		private function AddToList(url:String)
		{
			if (InTheList(url)) { return; }
			_dataList.push(url);
		}
		private function RemoveFromList(url:String)
		{
			for (var a:int = 0; a < _dataList.length; a++ )
			{
				if (_dataList[a] == url) { _dataList.splice(a, 1); return; }
			}
		}
		
		public function OnReport(evt:Event):void
		{
			
		}
	}

}
import com.lele.Data.ISoundData;
class DataUnit
{
	private var _doc:ISoundData;
	private var _soundUnit:SoundUnit;
	private var _musicUnit:SoundUnit;
	
	public function DataUnit(doc:ISoundData)
	{
		_doc = doc;
	}
	public function SmoothPlayAll(musicLoop:Boolean=false,soundLoop:Boolean=false)
	{
		if (_soundUnit == null)
		{
			_soundUnit = new SoundUnit(_doc.GetSound());
		}
		if (_musicUnit == null)
		{
			_musicUnit = new SoundUnit(_doc.GetMusic());
		}
		try
		{_soundUnit.SmoothOn(soundLoop); }
		catch (er:Error) { trace("Sound为空"); }
		try
		{_musicUnit.SmoothOn(musicLoop); }
		catch (er:Error) { trace("Music为空"); }
	}
	public function SmoothStopAll()
	{
		if (_soundUnit != null)
		{
			_soundUnit.SmoothOff();
		}
		if (_musicUnit != null)
		{
			_musicUnit.SmoothOff();
		}
	}
	public function SmoothPlaySound(weather:String,strength:int,loop:Boolean = true)//,
	{
		if (_soundUnit == null)
		{
			_soundUnit = new SoundUnit(_doc.GetSound(weather, strength));
		}
		else
		{
			_soundUnit.SmoothOff();
			_soundUnit = new SoundUnit(_doc.GetSound(weather, strength));
		}
		try
		{_soundUnit.SmoothOn(loop); }
		catch (er:Error) { trace("Sound为空"); }
	}
	public function SmoothPlayMusic(loop:Boolean = false)
	{
		if (_musicUnit == null)
		{
			_musicUnit = new SoundUnit(_doc.GetMusic());
		}
		try
		{_musicUnit.SmoothOn(loop); }
		catch (er:Error) { trace("Music为空"); }
	}
	public function PlayAll(musicLoop:Boolean=false,soundLoop:Boolean=false)
	{
		if (_soundUnit == null)
		{
			_soundUnit = new SoundUnit(_doc.GetSound());
		}
		if (_musicUnit == null)
		{
			_musicUnit = new SoundUnit(_doc.GetMusic());
		}
		_soundUnit.Play(soundLoop);
		_musicUnit.Play(musicLoop);
	}
	public function StopAll()
	{
		if (_soundUnit != null)
		{
			_soundUnit.Stop();
		}
		if (_musicUnit != null)
		{
			_musicUnit.Stop();
		}
	}
	public function Delete()
	{
		_doc = null;
		_soundUnit = null;
		_musicUnit = null;
	}
	public function get URL():String
	{
		return _doc.FileUrl;
	}
}

import flash.display.Sprite;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.events.Event;
class SoundUnit extends Sprite
{
	private var _triggeTime:Number
	public var _sound:Sound;
	private var _currentSoundChanel:SoundChannel;
	
	function SoundUnit(sound:Sound)
	{
		_sound = sound;
	}
	public function Play(loop:Boolean=false)
	{
		var isLoop:int = loop == true? 9999999: 0;
		_currentSoundChanel = _sound.play(0,isLoop);
	}
	public function Stop()
	{
		_currentSoundChanel.stop();
		_sound.close();
	}
	public function SmoothOn(loop:Boolean=false):void
	{
		var isLoop:int = loop == true? 9999999: 0;
		_triggeTime = (new Date()).time;				//创建初始时间
		_currentSoundChanel = _sound.play(0,isLoop);		//获取音频通道
		var tempSTF:SoundTransform = new SoundTransform();
		tempSTF.volume = 0;
		_currentSoundChanel.soundTransform = tempSTF;//设置无音量
		this.addEventListener(Event.ENTER_FRAME, OnSmoothOnFrameEnter);
	}
	private function OnSmoothOnFrameEnter(evt:Event)//声音渐起的调用
	{
		var tempTime:Date = new Date();
		if (_triggeTime+1000 > tempTime.time)//当在工作范围内
		{
			var sc:SoundTransform = new SoundTransform();
			sc.volume = 1 - ((_triggeTime+1000) - tempTime.time) / 1000;
			_currentSoundChanel.soundTransform = sc;
		}
		else
		{
			this.removeEventListener(Event.ENTER_FRAME, OnSmoothOnFrameEnter);//终止这个函数
		}
	}
	public function SmoothOff():void
	{
		if (_currentSoundChanel == null) { return; }
		_triggeTime = (new Date()).time;				//创建初始时间
		this.addEventListener(Event.ENTER_FRAME,OnSmoothOffFrameEnter);
	}
	private function OnSmoothOffFrameEnter(evt:Event)
	{
		var tempTime:Date = new Date();
		if (_triggeTime+1000 > tempTime.time)//当在工作范围内
		{
			var sc:SoundTransform = new SoundTransform();
			sc.volume =((_triggeTime+1000) - tempTime.time) / 1000;
			_currentSoundChanel.soundTransform = sc;
		}
		else
		{
			this.removeEventListener(Event.ENTER_FRAME, OnSmoothOffFrameEnter);//终止这个函数
			try
			{
				_currentSoundChanel.stop();
				_sound.close();
			}
			catch (er:Error) {}
		}
	}
}