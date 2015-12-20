package com.lele.Controller.Avatar
{
	/**
	 * ...
	 * @author Lele
	 */
	public class ActionSuggest 
	{
		public static function SuggestAction(actionName:String):String
		{
			switch(actionName)
			{
				case "run":
					return "run";
				case "stand":
					return "stand";
				case "brake":
					return "brake";
				case "swim":case "游泳":
					return "swim";
				case "鄙视你": case "disdain":
					return "disdain";
				case "哈哈哈": case "big_smile":
					return "big_smile";
				case "很酷啊": case "bad_smile":
					return "bad_smile";//这个是有问题的，版本问题吧
				case "害羞呀": case "pudency":
					return "pudency";
				case "洋洋得意": case "complacent":
					return "complacent";
				case "吐~~": case "spit":
					return "spit";
				case "焦虑": case "embarrassed":
					return "embarrassed";
				case "哭": case "cry":
					return "cry";
				case "调皮": case "naughty":
					return "naughty";
				case "吃惊": case "surprised":
					return "surprised";
				case "汗~~": case "sweat":
					return "sweat";
				case "晕晕晕": case "dizzy":
					return "dizzy";
				case "气死了": case "angry":
					return "angry";
				case "想一想": case "think":
					return "think";
				case "你好啊": case "hello":
					return "hello";
				case "委屈": case "feel_wronged":
					return "feel_wronged";
				case "坐": case "sitdown_1":
					return "sitdown_1";
				case "跳舞": case "dance":
					return "dance";
				case "Hi": case "wave":
					return "wave";
				case "super":
					return "superdance";
				case "yawn":case "打哈欠":
					return "yawn";
				case "scratch_buns": case "抓屁股":
					return "scratch_buns";
				case "scratch_nose": case "抓鼻子":
					return "scratch_nose";
				case "look":case "看":
					return "look";
				case "scratch_head": case "抓头":
					return "scratch_head";
				case "throw":case"投掷":
					return "throw";
			}
			return "stand";
		}
	}

}