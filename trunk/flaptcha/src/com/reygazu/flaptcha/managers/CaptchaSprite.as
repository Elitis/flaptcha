package com.reygazu.flaptcha.managers
{
	import com.reygazu.flaptcha.events.CaptchaSpriteEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	[Event(name="captchaResult", type="com.reygazu.anticheat.events.CaptchaSpriteEvent")]
	
	
	public class CaptchaSprite extends Sprite
	{
		private var _challenge:String;
		private var loader:Loader;
		private var verify:URLLoader;
		private var request:URLRequest;
		
		private var busy:Boolean = false;
		
		public function CaptchaSprite()
		{
			loader = new Loader();
			verify = new URLLoader();
			request = new URLRequest();
			
			init();
		}
		
		public function init():void
		{
			busy = true;
			
			request.method = URLRequestMethod.GET;
			request.data = null;
			request.url = CaptchaManager.getInstance().getChallengeURL();
			verify.addEventListener(Event.COMPLETE,onChallengeLoad);
			verify.load(request);
		}
		
		public function refresh():void
		{
			init();
		}
		
		private function onChallengeLoad(evt:Event):void
		{
			verify.removeEventListener(Event.COMPLETE,onChallengeLoad);
			this._challenge = CaptchaManager.getInstance().parseState(evt.currentTarget.data);
			loadImage();
		}
		
		public function loadImage():void
		{
			request.method = URLRequestMethod.GET;
			request.data = null;
			request.url = CaptchaManager.getInstance().getImageURL(_challenge);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
			loader.load(request);
		}
		
		private function onLoadComplete(evt:Event):void
		{			
			this.addChild(Bitmap(evt.currentTarget.content));
			var evt:Event = new Event("listo");
			this.dispatchEvent(evt);
		}
		
		public function sendTry(data:String):void
		{
			var variables:URLVariables = new URLVariables();
			variables.privatekey = CaptchaManager.getInstance().getPrivateKey()
			variables.remoteip = "127.0.0.1";
			variables.challenge = _challenge;
			variables.response = data;
			
			request.url = CaptchaManager.getInstance().getVerifyURL();
			
			request.method = URLRequestMethod.POST;
			request.data = variables;
			
			verify.addEventListener(Event.COMPLETE,onVerifyComplete);
			verify.load(request);
		}
		
		private function onVerifyComplete(evt:Event):void
		{
			verify.removeEventListener(Event.COMPLETE,onVerifyComplete);
			
			var results:Array =  verify.data.split("\n");
			var event:CaptchaSpriteEvent = new CaptchaSpriteEvent(CaptchaSpriteEvent.CAPTCHA_RESULT);
			
			event.success = false;
			
			while(results.length>0)
			{
				var str:String = results.pop();
				if (str=="true")
				{
					event.success = true;		
				}
				
				
			}
				
			this.dispatchEvent(event);
		}
		
		
		
		/*
		http://www.google.com/recaptcha/api/verify
			Parameters (sent via POST) 	 
			privatekey (required) 	Your private key
			remoteip (required) 	The IP address of the user who solved the CAPTCHA.
			challenge (required) 	The value of "recaptcha_challenge_field" sent via the form
			response (required) 	The value of "recaptcha_response_field" sent via the form
		*/
		
		
		
	}
}