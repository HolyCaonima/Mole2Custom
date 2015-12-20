package com.lele.Map.Interface
{
	import com.lele.Manager.Interface.IReport;
	import com.lele.Plugin.RoadFind.Interface.IRoadFinder;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.lele.Map.Enum.Weather;
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import com.lele.Controller.PlayerController;
	import com.lele.Controller.NetWorkController;
	/**
	 * ...
	 * @author Lele
	 */
	public interface IMapDocument 
	{
		function get Map():Object;
		function LoadMap(avatar:IAvatar, avatarPosition:Point, isHit:Boolean, playController:PlayerController,report:IReport):void;
		function AddNetPlayerToMap(avatar:IAvatar,controller:NetWorkController);
		function RemoveNetAvatarFromMap(avatar:IAvatar);
		function Clean();
		function SetWeather(weather:Weather, strength:int);
		function AddToFrontLayer(sp:Sprite);
	}
	
}