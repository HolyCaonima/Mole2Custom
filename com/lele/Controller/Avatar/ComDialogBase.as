package com.lele.Controller.Avatar
{
	import com.lele.Controller.Avatar.Interface.ICommunication;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Lele
	 */
	public class ComDialogBase extends Sprite implements ICommunication
	{
		
		public function ComDialogBase() 
		{
			
		}
		
		public function ShowTxt(text:String){}
		public function GetApp():Sprite { return null; }
		public function Reset(){}
		
	}

}