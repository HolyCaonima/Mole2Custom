package com.lele.Data
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IClothAnimation
	{
		function get FF():MovieClip;
		function get BB():MovieClip;
		function get BS():MovieClip;
		function get FS():MovieClip;
		function get SS():MovieClip;
		
		function get Name():String;
		function get Place():String;
	}
	
}