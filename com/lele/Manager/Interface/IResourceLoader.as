package com.lele.Manager.Interface
{
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IResourceLoader 
	{
		function LoadResource(hostId:String,url:String,OnComplete:Function,useUI:Boolean=false,uiType:String="NULL",isPrivate:Boolean=false):void;
		function UnLoadResource(hostId:String,url:String):void;
		function GetContentByID(hostID:String,url:String):Object;
	}
	
}