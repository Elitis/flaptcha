package com.reygazu.flaptcha.events
{
	import com.reygazu.flaptcha.managers.CaptchaSprite;
	
	import flash.events.Event;
	
	public class CaptchaManagerEvent extends Event
	{
		
		public static var CAPTCHA_LOADED:String = "captchaLoaded";
		
		public var sprite:CaptchaSprite;
		
		public function CaptchaManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}