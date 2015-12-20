package com.lele.LeleSocket
{
	/**
	 * ...
	 * @author Lele
	 */
	public class Param 
	{
		public var _name:String;
		public var _value:String;
		public function Param(name:String,value:String) 
		{
			_name = name;
			_value = value;
		}
		public function ToString():String
		{
			return "name:" + _name+"\n" + "value:" + _value;
		}
		
	}

}