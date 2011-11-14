package com.mengyun
{
	import com.mengyun.*;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	
	public class myUIComponent extends UIComponent
	{
		private var tmp_bg:bg1;
		private var closer:bg_close;
		private var downer:Triangle_down;
		private var _text:TextField;
		
		public function myUIComponent()
		{
			tmp_bg=new bg1();
			closer=new bg_close();
			downer=new Triangle_down();
			_text=new TextField();
			
			tmp_bg.x=0;
			tmp_bg.y=0;
			
			closer.x=4;
			closer.y=4;
			closer.addEventListener(MouseEvent.CLICK,closeClick);
			
			downer.x=227;
			downer.y=170;
			downer.width=15;
			downer.height=10;
			downer.addEventListener(MouseEvent.CLICK,downClick);
			
			_text.selectable=false;
			_text.x=30;
			_text.y=40;
			_text.width=260;
			_text.height=100; 
			_text.multiline=true;
			_text.wordWrap=true;
			_text.text="Enter your claim! Enter your claim! Enter your claim! Enter your claim! Enter your claim! Enter your claim! Enter your claim! Enter your claim!";
			
			this.addChild(tmp_bg);
			this.addChild(_text);
			this.addChild(closer);
			this.addChild(downer);
			
			super();
		}
		private function closeClick(envet:MouseEvent):void{
		   Alert.show("this is the sign for moving the box!","MessageBox");
		}
		private function downClick(envet:MouseEvent):void{
			Alert.show(" this is the button!","MessageBox");
		}
		public function setText(value:String):void{
			this._text.text=value;
		}
		public function getText():String{
			return this._text.text;
		}
	}
}