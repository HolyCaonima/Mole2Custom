package com.lele.Data
{
	/**
	 * ...
	 * @author Lele
	 */
	public class GloableData //这个一定不能放在资源里，否则破坏面向对象
	{
		public static var CurrentMap:String;
		public static var CurrentWeather:String;
		public static var CurrentWeatherStrength:int;
		public static var Version:String;
		public static var HasLogin:Boolean;
		public static var Environment:String;
		public static var MasterMode:Boolean;
		public static var TempID:String;
		public static var TempPWD:String;
		public static var MoleColor:String;
		public static var MoleName:String;
		public static var FriendData:Array;
		
		//放这里是出于效率而不是结构考虑
		public static var MoleDress_Hat:String;
		public static var MoleDress_Hair:String;
		public static var MoleDress_Eyes:String;
		public static var MoleDress_Necklace:String;
		public static var MoleDress_Hand:String;
		public static var MoleDress_Shoes:String;
		public static var MoleDress_Cloth:String;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static function AddFriend(id:String, color:String, name:String, type:int)//这个是不安全的
		{
			if (FriendData == null) { FriendData = new Array(); }
			var tempF:FriendDataUnit = new FriendDataUnit();
			tempF.Color = color;
			tempF.Name = name;
			tempF.Type = type;
			tempF.ID = id;
			var addFlag:Boolean = true;
			for (var a:int = 0; a < FriendData.length; a++ )
			{
				if ((FriendData[a] as FriendDataUnit).ID == tempF.ID)
				{
					(FriendData[a] as FriendDataUnit).Color = tempF.Color;
					(FriendData[a] as FriendDataUnit).Name = tempF.Name;
					(FriendData[a] as FriendDataUnit).Type = tempF.Type;
					addFlag = false;
					break;
				}
			}
			if(addFlag)
				FriendData.push(tempF);
		}
	}

}