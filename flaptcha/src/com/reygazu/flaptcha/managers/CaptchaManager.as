package com.reygazu.flaptcha.managers
{

	import com.reygazu.flaptcha.events.CaptchaManagerEvent;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event(name="captchaLoaded", type="com.reygazu.anticheat.events.CaptchaManagerEvent")]
	
	
	public class CaptchaManager extends EventDispatcher
	{
		private var private_key:String = "6LddBcYSAAAAAIRHFRXC-UeIHb7GC2sdQ8eiu10b";		
		private var public_key:String = "6LddBcYSAAAAAOlNecChvFfB0S8iN8Jzd476jhff";
		
		private var api_url:String = "http://www.google.com/recaptcha/api/challenge?k=";
		private var image_url:String = "http://www.google.com/recaptcha/api/image?c=";
		private var verify_url:String = "http://www.google.com/recaptcha/api/verify";
		
		
		protected static var _instance:CaptchaManager;
		
		private var loader:URLLoader;
		private var request:URLRequest;
		
		public function CaptchaManager(caller :Function = null)
		{
			if (caller != CaptchaManager.getInstance)
			{
				throw new Error ("CaptchaManager is a singleton class, use getInstance() instead");
			}
			
			if ( CaptchaManager._instance != null )
			{
				throw new Error( "Only one CaptchaManager instance should be instantiated" );
			} 
			
		}
		
		private function init():void
		{		
			// does nothing!
			loader = new URLLoader();
			request = new URLRequest();
		}
		
		public static function getInstance():CaptchaManager		
		{
			if (_instance == null)
			{
				_instance = new CaptchaManager(arguments.callee);
				_instance.init();
			}
			return _instance;	
		}
		
		public function getState():void
		{
			request.url = api_url+public_key;
			loader.addEventListener(Event.COMPLETE,onStateLoadComplete);
			loader.load( request );
			
		}
		
		private function onStateLoadComplete(evt:Event):void
		{
			trace(evt.currentTarget);
			var data:String = evt.currentTarget.data;
			
			
		}
		
		public function parseState(data:String):String
		{
			var begin:int = data.indexOf("challenge : '");
			
			data = data.substr(begin+13);
			
			var end:int = data.indexOf("'");
			
			var challenge = data.substring(0,end);
			
			
			return challenge;	
		}
		
		private function onSpriteLoaded(evt:Event):void
		{
			var event:CaptchaManagerEvent = new CaptchaManagerEvent(CaptchaManagerEvent.CAPTCHA_LOADED);
			event.sprite = evt.currentTarget as CaptchaSprite;
			this.dispatchEvent(event);
		}
			
		public function getImageURL(challenge:String):String
		{
			return this.image_url+challenge;
		}
		
		public function getVerifyURL():String
		{
			return this.verify_url;
		}
		
		public function getPrivateKey():String
		{
			return this.private_key;
		}
		
		public function getChallengeURL():String
		{
			return api_url+public_key;
		}
		
	}
}