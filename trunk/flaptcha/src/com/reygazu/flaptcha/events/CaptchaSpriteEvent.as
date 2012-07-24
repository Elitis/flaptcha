package com.reygazu.flaptcha.events
{
	import com.reygazu.flaptcha.managers.CaptchaSprite;
	
	import flash.events.Event;
	
	public class CaptchaSpriteEvent extends Event
	{
		
		public static var CAPTCHA_RESULT:String = "captchaResult";
		
		public var success:Boolean = false;
	
		
		public function CaptchaSpriteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}