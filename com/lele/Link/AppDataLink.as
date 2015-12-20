package com.lele.Link
{
	/**
	 * ...
	 * @author Lele
	 */
	public class AppDataLink 
	{
		private static const SecretDoorApp = "App/SecretDoorApp.swf";
		private static const DialogApp = "App/DialogApp.swf";
		private static const StartApp = "App/StartApp.swf";
		private static const LoginPanelApp = "App/LoginPanelApp.swf";
		private static const ApplyPanelApp = "App/ApplyPanelApp.swf";
		private static const CreateMoleApp = "App/CreateMoleApp.swf";
		private static const FriendsApp = "App/FriendsApp.swf";
		private static const LittleNoteApp = "App/LittleNoteApp.swf";
		private static const InfoPanelApp = "App/InfoPanelApp.swf";
		
		public static function GetUrlByName(name:String):String
		{
			switch(name)
			{
				case "SecretDoorApp":
					return SecretDoorApp;
				case "Dialog":
					return DialogApp;
				case "StartApp":
					return StartApp;
				case "LoginPanelApp":
					return LoginPanelApp;
				case "ApplyPanelApp":
					return ApplyPanelApp;
				case "CreateMoleApp":
					return CreateMoleApp;
				case "FriendsApp":
					return FriendsApp;
				case "LittleNoteApp":case "LittleNote":
					return LittleNoteApp;
				case "InfoPanelApp":
					return InfoPanelApp;
			}
			return null;
		}
	}

}