package com.lele.Data
{
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface ISoundData 
	{
		function GetMusic():Sound;
		function GetSound(weather:String="sun",strength:int=0):Sound;//
		function get FileUrl():String;
	}
	
}