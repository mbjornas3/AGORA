package components
{   
	import com.mengyun.*;
	import com.mengyun.bg3;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import mx.controls.Alert;
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	
	import ValueObjects.AGORAParameters;
	
	
	import Controller.ArgumentController;
	import Controller.UpdateController;
	import Controller.ViewController;
	import Controller.logic.ConditionalSyllogism;
	import Controller.logic.ParentArg;
	
	import Events.AGORAEvent;
	
	import Model.AGORAModel;
	import Model.SimpleStatementModel;
	import Model.StatementModel;
	
	import ValueObjects.AGORAParameters;
	
	import classes.Language;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.Menu;
	import mx.controls.Text;
	import mx.controls.TextInput;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.EventListenerRequest;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.DragManager;
	import mx.skins.Border;
	
	import org.osmf.events.GatewayChangeEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Panel;
	import spark.components.TextArea;
	import spark.components.VGroup;
	import spark.effects.Resize;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout
	
	
	public class ArgumentPanel extends GridPanel //Grid Panel extends UIComponent
	{
		private var tmp_top:bg3_top;
		private var tmp_middle:bg3_middle;
		private var tmp_buttom:bg3_buttom;
		private var closer:bg_close;
		private var downer:Triangle_down;
		private var _text:TextField;
		private var _anotherText:TextField;
		private var _textArea:DynamicTextArea;
		private var _startx:int;
		private var _starty:int;
		private var _width:int;
		
		
		
		//model class
		[Bindable]
		private var _model:StatementModel;
		
		//Input boxes
		public var inputs:Vector.<DynamicTextArea>;
		
		private var _state:String;
		
		
		
		public var negatedLbl:Label;
		//Displays the type of this statment
		public var stmtTypeLbl:Label;
		//Displays the user id
		public var userIdLbl:Label;
		
		public var branchControl:Option;
		
		//Takes either INFERENCE or ARGUMENT_PANEL
		private var _panelType:String;
		[Bindable]
		private var _statementNegated:Boolean;
		[Bindable]
		private var _statementType:String;
		[Bindable]
		private var _author:String;
		
		
		//dirty flags
		private var _statementNegatedDF:Boolean;		
		private var _statementsAddedDF:Boolean;
		private var _stateDF:Boolean;
		private var _statementTypeChangedDF:Boolean;
		
		public static const EDIT:String = "Edit";
		public static const DISPLAY:String = "Display";
		
		//References to other objects
		//A reference to the current map diplayed to the user
		public static var parentMap:AgoraMap;

		
		//------------------------getters and setters-----------------------------//
		
		public function ArgumentPanel()
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
			
			_startx = 30;
			_starty = 30;
	
			/*
			_textArea = new DynamicTextArea;
			//_textArea.verticalScrollPolicy = "off";
			_textArea.width = 100;
			_textArea.minHeight = 80;
			_textArea.addEventListener(Event.CHANGE, setHeight);
			_textArea.text = "default";
			_textArea.x = 30;
			_textArea.y = 40;
			*/
			
			inputs = new Vector.<DynamicTextArea>;
			
			closer.x=4;
			closer.y=4;
			closer.addEventListener(MouseEvent.CLICK,closeClick);
			
			downer.x=227;
			downer.y=tmp_top.height+tmp_middle.height+22;
			downer.width=15;
			downer.height=10;
			downer.addEventListener(MouseEvent.CLICK,downClick);
			
			_text=new TextField();
			_text.selectable=false;
			_text.x=30;
			_text.y=40;
			_text.width=260;
			_text.height=80; 
			_text.multiline=true;
			_text.wordWrap=true;
			_text.autoSize=TextFieldAutoSize.LEFT;
			
		
			minHeight = 100;
			state = DISPLAY;
			super();
		}
		
		public function get text():TextField
		{
			return _text;
		}

		public function set text(value:TextField):void
		{
			_text = value;
		}

		public function get panelType():String{
			return _panelType;
		}
		
		public function set panelType(value:String):void{
			_panelType = value;
		}
		
		public function get author():String
		{
			return _author;
		}
		
		public function set author(value:String):void
		{
			_author = value;
		}
		
		public function get statementNegated():Boolean
		{
			return _statementNegated;
		}
		
		public function set statementNegated(value:Boolean):void
		{
			_statementNegated = value;
			statementNegatedDF = true;
			stateDF = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		public function get statementType():String
		{
			return _statementType;
		}
		
		[Bindable]
		public function set statementType(value:String):void
		{
			_statementType = value;
			statementTypeChangedDF = true;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
			stateDF = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get stateDF():Boolean
		{
			return _stateDF;
		}
		
		public function set stateDF(value:Boolean):void
		{
			_stateDF = value;
		}
		
		public function get statementsAddedDF():Boolean
		{
			return _statementsAddedDF;
		}
		
		public function set statementsAddedDF(value:Boolean):void
		{
			_statementsAddedDF = value;
		}
		
		public function get statementNegatedDF():Boolean
		{
			return _statementNegatedDF;
		}
		
		public function set statementNegatedDF(value:Boolean):void
		{
			_statementNegatedDF = value;
		}
		
		public function get model():StatementModel{
			return _model;
		}
		
		public function set model(value:StatementModel):void{
			
			if(model == null){
				_model = value;
				//bind variables
				BindingUtils.bindProperty(this, "statementType", this, ["model","statementType"]);
				BindingUtils.bindProperty(this, "statementNegated", model, ["negated"]);
				BindingUtils.bindProperty(this, "gridX", model, ["xgrid"]);
				BindingUtils.bindSetter(this.setX,model, ["xgrid"]);
				BindingUtils.bindSetter(this.setY, model, ["ygrid"]);
				BindingUtils.bindProperty(this, "panelType", model, ["statementFunction"]);
				BindingUtils.bindSetter(this.setVisibility, model, ["argumentTypeModel","reasonsCompleted"]);
				
				author = model.author;
				statementsAddedDF = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
				
			}else{
				trace("Error (ArgumentPanel.as, set model): attempted to reassign the model of statement view. Not allowed.");
			}
		}
		
		public function get statementTypeChangedDF():Boolean
		{
			return _statementTypeChangedDF;
		}
		
		public function set statementTypeChangedDF(value:Boolean):void
		{
			_statementTypeChangedDF = value;
		}
		
			
		//----------------------- bind setters -------------------------------------------//
		protected function setDisplayStatement(value:String):void{
			if(value == null){
				if(model.statementFunction == StatementModel.STATEMENT){
					if(model.firstClaim){
						text.text = "[" + Language.lookup("EnterClaim") +"]";
					}else{
						text.text = "[" + Language.lookup("EnterReason")+ "]";
					}
				}
				else if(model.statementFunction == StatementModel.INFERENCE){
					text.text = AGORAParameters.getInstance().SUPPORT_SELECT_ARG_SCHEME;
				}
			}
			else if(value.split(" ").join("").length == 0){
				if(model.statementFunction == StatementModel.STATEMENT){
					if(model.firstClaim){
						text.text = "[" + Language.lookup("EnterClaim") +"]";
					}else{
						text.text = "[" + Language.lookup("EnterReason")+ "]";
					}
				}else if(model.statementFunction == StatementModel.INFERENCE){
					text.text =  AGORAParameters.getInstance().SUPPORT_SELECT_ARG_SCHEME;
				}
			}
			else{
				text.text = value;
			}
		}
		
		protected function setVisibility(value:Boolean):void{
			if(model.statementFunction == StatementModel.INFERENCE){
				if(!model.argumentTypeModel.reasonsCompleted){
					this.visible = false;
				}
				else{
					this.visible = true;
				}
			}
		}
	
		//----------- other public functions ----------------//
		
		public function showMenu():void
		{
			var constructArgData:XML = <root><menuitem label="add another reason" type="TopLevel"/><menuitem label="construct argument" 

type="TopLevel"/></root>; 
			var menu:mx.controls.Menu = mx.controls.Menu.createMenu(null,constructArgData,false);
			menu.labelField = "@label";
			//menu.addEventListener(MenuEvent.ITEM_CLICK, argConstructionMenuClicked);
			var globalPosition:Point = localToGlobal(new Point(0,this.height));
			menu.show(globalPosition.x,globalPosition.y);	
		}
		//---------------------- functions required for the function of the component----------//	
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
			this.addChild(closer);
			this.addChild(downer);
		}
		
		override protected function measure():void{
			super.measure();	
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			tmp_middle.height = 80;//this._textArea.textHeight + 10;
			tmp_buttom.y = tmp_top.height+tmp_middle.height;
			downer.y = tmp_top.height+tmp_middle.height+22;	
		}
	}
}