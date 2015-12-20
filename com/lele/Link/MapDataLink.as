package com.lele.Link
{
	/**
	 * ...
	 * @author Lele
	 */
	public class MapDataLink 
	{
		public static const Map001 = "Map/Map001.swf";
		public static const Map002 = "Map/Map002.swf";
		public static const Map004 = "Map/Map004.swf";
		public static const Map005 = "Map/Map005.swf";
		public static const Map006 = "Map/Map006.swf";
		public static const Map007 = "Map/Map007.swf";
		public static const Map008 = "Map/Map008.swf";
		public static const Map009 = "Map/Map009.swf";
		public static const Map017 = "Map/Map017.swf";
		public static const Map019 = "Map/Map019.swf";
		public static const Map022 = "Map/Map022.swf";
		
		public static function GetUrlByName(name:String)
		{
			switch (name)
			{
				case "Map001":
				{
					return Map001;
				}
				case "Map002":
				{
					return Map002;
				}
				case "Map004":
				{
					return Map004;
				}
				case "Map005":
				{
					return Map005;
				}
				case "Map008":
				{
					return Map008;
				}
				case "Map009":
				{
					return Map009;
				}
				case "Map017":
				{
					return Map017;
				}
				case "Map019":
				{
					return Map019;
				}
				case "Map006":
				{
					return Map006;
				}
				case "Map007":
				{
					return Map007;
				}
				case "Map022":
				{
					return Map022;
				}
			}
		}
		
	}

}