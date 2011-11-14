package com.mengyun
{   
	import com.mengyun.*;
	import com.mengyun.bg3;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import mx.controls.Alert;
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	
	public class AgoraPanel extends UIComponent
	{
		private var tmp_top:bg3_top;
		private var tmp_middle:bg3_middle;
		private var tmp_buttom:bg3_buttom;
		private var closer:bg_close;
		private var downer:Triangle_down;
		private var _text:TextField;
		private var _anotherText:TextField;
		private var _textArea:DynamicTextArea;
		
		
		public function AgoraPanel()
		{			
			tmp_top=new bg3_top();
			tmp_top.x=0;
			tmp_top.y=0;
			
			tmp_middle=new bg3_middle();
			tmp_middle.x=6;
			tmp_middle.y=tmp_top.height;
			
			tmp_buttom=new bg3_buttom();
			tmp_buttom.x=6;
			tmp_buttom.y=tmp_top.height+tmp_middle.height;
			
			closer=new bg_close();
			
			downer=new Triangle_down();
			
			_text=new TextField();
			_anotherText = new TextField;
			_anotherText.selectable = false;
			_anotherText.x = 50;
			_anotherText.y = 40;
			_anotherText.width=200;
			_anotherText.height = 80;
			_anotherText.multiline = true;
			_anotherText.wordWrap = true;
			_anotherText.autoSize = TextFieldAutoSize.LEFT;
			_anotherText.text = "blah";
			
			_textArea = new DynamicTextArea;
			//_textArea.verticalScrollPolicy = "off";
			_textArea.width = 100;
			_textArea.minHeight = 80;
			_textArea.addEventListener(Event.CHANGE, setHeight);
			_textArea.text = "default";
			_textArea.x = 30;
			_textArea.y = 40;
			
			closer.x=4;
			closer.y=4;
			closer.addEventListener(MouseEvent.CLICK,closeClick);
			
			downer.x=227;
			downer.y=tmp_top.height+tmp_middle.height+22;
			downer.width=15;
			downer.height=10;
			downer.addEventListener(MouseEvent.CLICK,downClick);
			
			_text.selectable=false;
			_text.x=30;
			_text.y=40;
			_text.width=260;
			_text.height=80; 
			_text.multiline=true;
			_text.wordWrap=true;
			_text.autoSize=TextFieldAutoSize.LEFT;
			super();
		}
		
		private function setHeight(event:Event):void{
			
			invalidateSize();
		}
		
		public function setText(value:String):void{
			this._text.text=value;	
		}
		
		public function getText():String{
			return this._text.text;
		}
		
		private function closeClick(envet:MouseEvent):void{
			Alert.show("this is the sign for moving the box!","MessageBox");
		}
		
		private function downClick(envet:MouseEvent):void{
			Alert.show(" this is the button!","MessageBox");
		}
		
		override protected function createChildren():void{
			this.addChild(tmp_top);
			this.addChild(tmp_middle);
			this.addChild(tmp_buttom);			
			this.addChild(_textArea);
			this.addChild(closer);
			this.addChild(downer);
			this.addChild(_anotherText);
		}
		
		override protected function measure():void{
			super.measure();
			_textArea.height = _textArea.textHeight + 10;
			tmp_middle.height = this._textArea.textHeight + 10;
			tmp_buttom.y = tmp_top.height+tmp_middle.height;
			downer.y = tmp_top.height+tmp_middle.height+22;	
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
	}
}