package com.lele.LeleSocket
{
	/**
	 * ...
	 * @author Lele
	 */
	public class Command
	{
		public var _commandName:String;
		
		public var _paramArray:Array;
		
		public function Command(commandName:String) 
		{
			_commandName = commandName;
			_paramArray = new Array();
		}
		public function GetValueByName(name:String):String
		{
			for (var a:int = 0; a < _paramArray.length; a++ )
			{
				if ((_paramArray[a] as Param)._name == name)
				{
					return (_paramArray[a] as Param)._value;
				}
			}
			throw("no Params found");
		}
		public function PushParam(param:Param)
		{
			_paramArray.push(param);
		}
		public function ToString():String
		{
			var str:String = "CommandName:" +_commandName+"\n";
			for (var a:int = 0; a < _paramArray.length; a++ )
			{
				str=str + "param" + a + ":\n" + (_paramArray[a] as Param).ToString()+"\n";
			}
			return str;
		}
		
	}

}