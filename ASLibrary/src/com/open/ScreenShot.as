package com.open
{
	import flash.external.ExtensionContext;
	
	import flashx.textLayout.formats.Float;
	
	import mx.messaging.channels.StreamingAMFChannel;

	public class ScreenShot
	{
		public var extContext:ExtensionContext;
		
		
		public function ScreenShot()
		{
			extContext = ExtensionContext.createExtensionContext("com.open.ScreenShotNE","type");
			
		}
		public function getScreenShotPNG(pngName:String):int{
			
			var modpng:String = pngName +".png";
			return extContext.call("getScreenShotPNG",modpng) as int;
			
			
		}
		public function getScreenShotJPEG(jpgName:String, compressionQuality:Number):int{
			
			var modjpeg:String = jpgName +".jpeg";
			return extContext.call("getScreenShotJPEG",modjpeg,compressionQuality) as int;
			
			
		}
		
		
		public function disposeNative():void
		{
			extContext.dispose();	
		}
	}
}