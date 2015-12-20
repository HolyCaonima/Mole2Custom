package com.lele.Controller.Avatar.Interface
{
	import com.lele.Controller.Avatar.Enum.AvatarState;
	import com.lele.Manager.Interface.IReport;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IAvatar //Avatar have many layers the Avatar is the main layer,the father of the other layer
	{
		function get Avatar():Sprite;
		//function ChangeDirection(state:AvatarState, direction:String);//当加入其他动画后要重写
		function DoAction(act:String, direction:String,callBack:Function=null);
		function get A_X():Number;
		function get A_Y():Number;
		function set Repoter(repoter:IReport);
		function SetComDialog(dialog:Sprite);
		function ShowDialog(txt:String);
	}
	
}