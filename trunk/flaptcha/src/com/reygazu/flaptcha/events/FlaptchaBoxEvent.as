package com.reygazu.flaptcha.events
{
	import flash.events.Event;
	
	public class FlaptchaBoxEvent extends Event
	{
		
		public static var SUCCESS:String = "success";
		public var word:String;
		
		public function FlaptchaBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}