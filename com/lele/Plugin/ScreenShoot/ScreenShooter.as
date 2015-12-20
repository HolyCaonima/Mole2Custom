package com.lele.Plugin.ScreenShoot
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Lele
	 */
	public class ScreenShooter 
	{
		
		public function ScreenShooter() 
		{
			
		}
		
		public function ShootScreen(tempContainer:Sprite):Sprite
		{
			var myBitmapData:BitmapData = new BitmapData(tempContainer.width,tempContainer.height);
			myBitmapData.draw(tempContainer);
			var bmp:Bitmap = new Bitmap(myBitmapData);
			var outSprite:Sprite = new Sprite();
			outSprite.addChild(bmp);
			return outSprite;
		}
		
	}

}