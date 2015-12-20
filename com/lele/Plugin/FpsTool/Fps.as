package com.lele.Plugin.FpsTool
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.system.System;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
     
    public class Fps extends Sprite
    {
        private var fps:TextField; 
        private var mem:TextField;
        private var instance:Fps; 
        private var bitmapdata:BitmapData;
        private var i:int = 0;
        private var n:int = 10; 
        private var diagramTimer:int; 
        private var tfTimer:int; 
        private var skins:int = -1; 
        private var skinsChanged:int = 0; 
        private static const diagramHeight:uint = 40; 
        private static const diagramWidth:uint = 60; 
        private static const maxMemory:uint = 500000000;
        public function Fps()
        {
            this.addEventListener(Event.ADDED_TO_STAGE,init); 
        }
         
        public function init(evt:Event):void 
        { 
			trace("init");
            var bitmap:Bitmap = null; 
            this.removeEventListener(Event.ADDED_TO_STAGE,init); 
            fps = new TextField(); 
            mem = new TextField();
            if(instance == null) {
                fps.defaultTextFormat = new TextFormat("Tahoma", 10, 16711680); 
                fps.autoSize = TextFieldAutoSize.LEFT;
                fps.text = "FPS:" + Number(stage.frameRate).toFixed(2);
                fps.x = -diagramWidth - 2;
                addChild(fps);
                 
                mem.defaultTextFormat = new TextFormat("Tahoma", 10, 65280);
                mem.autoSize = TextFieldAutoSize.LEFT; 
                mem.text = "MEM:" + byteToString(System.totalMemory);
                mem.x = -diagramWidth - 2; 
                mem.y = fps.y + 10;
                addChild(mem); 
                bitmapdata = new BitmapData(diagramWidth,diagramHeight,true,255);
                bitmap = new Bitmap(bitmapdata);
                bitmap.y = 24;
                bitmap.x = -diagramWidth;
                addChildAt(bitmap,0);
                 
                addEventListener(Event.ENTER_FRAME,onEnterFrame);
                diagramTimer = getTimer();
                tfTimer = getTimer(); 
            }  
        } 
        private function onEnterFrame(e:Event):void
        {  
            i++;
            if(i >= n)   {  
                i = 0; 
                fps.text = "FPS: " + Number(1000 * n / (getTimer() - tfTimer)).toFixed(2);
                tfTimer = getTimer(); 
            }
            var _loc_2:* = 1000 / (getTimer() - diagramTimer); 
            var _loc_3:* = _loc_2 > stage.frameRate ? (1) : (_loc_2 / stage.frameRate);
            diagramTimer = getTimer();
            bitmapdata.scroll(1, 0);
            bitmapdata.fillRect(new Rectangle(0, 0, 1, bitmapdata.height), 2852126720);
            bitmapdata.setPixel32(0, diagramHeight * (1 - _loc_3), 4294901760);
            mem.text = "MEM: " + byteToString(System.totalMemory);
            var ski:int = skins == 0 ? (0) : (skinsChanged / skins);
            bitmapdata.setPixel32(0, diagramHeight * (1 - ski), 4294967295);
            var meoryPer:Number = System.totalMemory / maxMemory; 
            bitmapdata.setPixel32(0, diagramHeight * (1 - meoryPer), 4278255360); 
        }
         
        private function byteToString(byte:uint):String 
        {
            var byteStr:String = null; 
            if (byte < 1024)
            {
                byteStr = String(byte) + "b";  94.   } 
            else if (byte < 10240)
            {    byteStr = Number(byte / 1024).toFixed(2) + "kb";
            }  else if (byte < 102400) 
            { 
                byteStr = Number(byte / 1024).toFixed(1) + "kb"; 
            }
            else if (byte < 1048576)    {
                byteStr = Math.round(byte / 1024) + "kb"; 
            } 
            else if (byte < 10485760)
            {
                byteStr = Number(byte / 1048576).toFixed(2) + "mb";
            }
            else if (byte < 104857600)
            {
                byteStr = Number(byte / 1048576).toFixed(1) + "mb"; 
            } 
            else
            { 
                byteStr = Math.round(byte / 1048576) + "mb"; 
            }
            return byteStr; 
        } 
         
    }
}