package com.reygazu.flaptcha.spark
{
	
	import com.reygazu.flaptcha.events.CaptchaSpriteEvent;
	import com.reygazu.flaptcha.events.FlaptchaBoxEvent;
	import com.reygazu.flaptcha.managers.CaptchaSprite;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	
	import spark.components.Button;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	[SkinStates("question","success")]
	
	[Event(name="success", type="com.reygazu.flaptcha.events.FlaptchaBoxEvent")]
	
	
	public class FlaptchaBox extends SkinnableComponent
	{
		[SkinPart(required="false")]
		public var aboutBtn:UIComponent; 
		
		[SkinPart(required="false")]
		public var refreshBtn:UIComponent; 
		
		[SkinPart(required="true")]
		public var textInput:TextInput;
		
		[SkinPart(required="true")]
		public var captcha:UIComponent;
		
		private var _captchaSprite:CaptchaSprite;
		
		private var _text:String;
		
		public function FlaptchaBox()
		{
			super();
		}
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			switch (instance)
			{
				case textInput:
					textInput.addEventListener(KeyboardEvent.KEY_DOWN,onTextInputEnterKeyHandler);
				break;
				
				case captcha:
					_captchaSprite = new CaptchaSprite();
					captcha.addChild(_captchaSprite);
				break;
				
				case refreshBtn:
					refreshBtn.addEventListener(MouseEvent.CLICK,onRefreshBtnHandler);
				break;				
				
				case aboutBtn:
					aboutBtn.addEventListener(MouseEvent.CLICK,onAboutBtnHandler);
				break;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			switch (instance)
			{
				case textInput:
					textInput.removeEventListener(KeyboardEvent.KEY_DOWN,onTextInputEnterKeyHandler);
				break;
				
				case captcha:					
					captcha.removeChild(_captchaSprite);
					_captchaSprite.removeEventListener(CaptchaSpriteEvent.CAPTCHA_RESULT,onCaptchaResult);
					_captchaSprite = null;
				break;
				
				case refreshBtn:
					refreshBtn.removeEventListener(MouseEvent.CLICK,onRefreshBtnHandler);
				break;				
				
				case aboutBtn:
					aboutBtn.removeEventListener(MouseEvent.CLICK,onAboutBtnHandler);
				break;
			}
		}

		// About Button Event Handler
		
		private function onAboutBtnHandler(evt:MouseEvent):void
		{
			var targetURL:URLRequest = new URLRequest("http://www.reygazu.com.ar/");
			
			navigateToURL(targetURL);	
		}
		
		// RefreshButton Event Handler
		
		private function onRefreshBtnHandler(evt:MouseEvent):void
		{
			this.skin.currentState = "question";
			_captchaSprite.refresh();
		}
		
		// TextInput Event Handlers
		
		private function onTextInputEnterKeyHandler(evt:KeyboardEvent):void
		{
			if (textInput.text!="")
			{
				if (evt.keyCode==Keyboard.ENTER)
				{
					// submit word
					_text = textInput.text;
					textInput.text = "";
					sendText(_text);					
				}
			}
		}
		
		private function sendText(text:String):void
		{
			_captchaSprite.addEventListener(CaptchaSpriteEvent.CAPTCHA_RESULT,onCaptchaResult);
			_captchaSprite.sendTry(text);
			textInput.enabled = false;
			//this.skin.currentState = "busy";
		}
		
		private function onCaptchaResult(evt:CaptchaSpriteEvent):void
		{				
			textInput.enabled = true;
			
			if (evt.success)
			{
				this.skin.currentState = "success";				
				var event:FlaptchaBoxEvent= new FlaptchaBoxEvent(FlaptchaBoxEvent.SUCCESS);
				event.word = _text;	
				this.dispatchEvent(event);
			}
			else
			{
				_captchaSprite.refresh();
				this.skin.currentState = "question";
			}
			
			captcha.removeEventListener(CaptchaSpriteEvent.CAPTCHA_RESULT,onCaptchaResult);
		}				
	}	
}