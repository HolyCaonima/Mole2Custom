package com.lele.LeleSocket
{
	import com.lele.Data.GloableData;
	import com.lele.Manager.ApplicationManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Lele
	 */
	public class LeleSocketBasic 
	{
		private var _socket:Socket;
		private var _remoteIP:String;
		private var _remotePort:int;
		
		private var _buffer:String;
		
		private var _onSocketClose:Function;
		private var _onCommand:Function;
		
		public function LeleSocketBasic(onCommand:Function,onSocketClose:Function = null) 
		{
			_socket = new Socket();
			_onSocketClose = onSocketClose;
			_onCommand = onCommand;
		}
		
		public function Connect(IP:String, port:int)
		{
			_remoteIP = IP;
			_remotePort = port;
			_socket.addEventListener(Event.CONNECT, OnConnect);
			_socket.addEventListener(Event.CLOSE, OnClose);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, OnDataEnter);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, OnSocketIOError);
			_socket.connect(_remoteIP, _remotePort);
		}
		public function Send(message:String)
		{
			trace(message);
			var byteToSend:ByteArray = new ByteArray();
			byteToSend.writeUTFBytes(message);
			byteToSend.position = 0;
			try
			{
			_socket.writeBytes(byteToSend, 0, byteToSend.length);
			_socket.flush();
			}
			catch (er:Error) 
			{
				ApplicationManager.GetIDialog().ShowDialog("emoy", "sad", "与服务器的连接断开了，重新登陆吧!", null);
				trace("与服务器连接断开"); 
			}
		}
		private function OnSocketIOError(evt:Event)
		{
			ApplicationManager.GetIDialog().ShowDialog("emoy", "sad", "服务器维修中!", null);
			trace("服务器未上线");
		}
		private function OnDataEnter(evt:Event)
		{
			var _bufferArray:ByteArray = new ByteArray();
			_socket.readBytes(_bufferArray, 0, _socket.bytesAvailable);
			_buffer =_buffer+_bufferArray.toString();//从缓冲区中读取创建本地缓存,并拼接之前的缓冲
			CreatAndDispactCommand();
		}
		private function CreatAndDispactCommand()
		{
			while (true)
			{
				if (_buffer.indexOf(">") == -1) { return; }
				if (_buffer.charAt(0) != "<") //处理成首项为<
				{
					_buffer = _buffer.slice(_buffer.indexOf("<"), _buffer.length);
				}
				var commandString:String = _buffer.slice(0, _buffer.indexOf(">") + 1);
				trace(commandString);
				_buffer = _buffer.slice(_buffer.indexOf(">") + 1, _buffer.length);
				_onCommand(BuildCommand(commandString));
			}
		}
		private function BuildCommand(command:String):Command
		{
			if (command.charAt(0) != "<" || command.charAt(command.length - 1) != ">")
			{
				return null;//非法命令结构
			}
			var dataArray:Array = command.slice(1, command.length - 1).split(";");
			var tempCommand:Command = new Command(dataArray[0] as String);
			for (var a:int = 0; a < (int)(dataArray[1])*2; a+=2 )
			{
				var tempParam:Param = new Param(dataArray[a + 2] as String, dataArray[a + 3] as String);
				tempCommand.PushParam(tempParam);
			}
			return tempCommand;
		}
		private function OnConnect(evt:Event)
		{
			trace("Connected");
		}
		private function OnClose(evt:Event)
		{
			if (_onSocketClose != null)
			{
				_onSocketClose();
			}
		}
		
	}

}