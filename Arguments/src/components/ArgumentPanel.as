package components
{
	import Controller.ArgumentController;
	import Controller.ViewController;
	
	import Events.AGORAEvent;
	
	import Model.AGORAModel;
	import Model.SimpleStatementModel;
	import Model.StatementModel;
	
	import ValueObjects.AGORAParameters;
	
	import classes.Language;
	
	import com.mengyun.*;
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.core.DragSource;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.DynamicEvent;
	import mx.events.FlexEvent;
	import mx.events.MenuEvent;
	import mx.managers.DragManager;
	
	public class ArgumentPanel extends GridPanel
	{
		//
		private var tmp_top:MovieClip;
		private var tmp_middle:bg1_middle;
		private var tmp_buttom:MovieClip;
		private var closer:bg_close;
		private var downer:Triangle_down;
		private var upArrow:Triangle_up;
		private var addBtn:add_button;
		private var deleteBtn:delete_button;
		
		private var moveUp:Triangle_up_blue;
		private var moveDown:Triangle_down_blue;
		
		
		private var buttonPanel:MovieClip;
		
		public var displayTxt:TextField;
		
		[Bindable]
		private var _model:StatementModel;
		
		private var agoraLabels:AGORAParameters;
		public var inputs:Vector.<DynamicTextArea>;
		public var changeWatchers:Vector.<ChangeWatcher>;
		
		
		public var negatedLbl:Label;
		//Displays the type of this statment
		public var stmtTypeLbl:Label;
		//Displays the user id
		public var userIdLbl:Label;
		
		//banch option control
		public var branchControl:Option;
		
		//State Variables
		private var _state:String;
		
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
		private var _optionsShownDF:Boolean;
		
		
		//constants
		//connecting string constants required for multistatements
		public static const IF_THEN:String = "If-then";
		public static const IMPLIES:String = "Implies";	
		public static const EDIT:String = "Edit";
		public static const DISPLAY:String = "Display";
		
		//References to other objects
		public var addArgumentsInfo:InfoBox;
		public var changeTypeInfo:InfoBox;
		
		//A reference to the current map diplayed to the user
		public static var parentMap:AgoraMap;
		
		//Menu data
		//XML string holding the menu data for the menu that pops up when user hits the done button
		public var constructArgData:XML;
		
		//other instance variables
		public var connectingStr:String;
		
		public function ArgumentPanel()
		{
			super();
			agoraLabels = AGORAParameters.getInstance();
			constructArgData = agoraLabels.CONSTRUCT_ARG_DATA;
			inputs = new Vector.<DynamicTextArea>;
			changeWatchers = new Vector.<ChangeWatcher>;
			minHeight = 100;
			state = DISPLAY;
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function get optionsShownDF():Boolean
		{
			return _optionsShownDF;
		}
		
		public function set optionsShownDF(value:Boolean):void
		{
			_optionsShownDF = value;
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
		
		public function get model():StatementModel
		{
			return _model;
		}
		
		public function set model(value:StatementModel):void{
			if(model == null){
				_model = value;
				//bind variables
				if(value.statementFunction == StatementModel.STATEMENT || value.statementFunction == StatementModel.INFERENCE){ 
					BindingUtils.bindProperty(this, "statementType", this, ["model","statementType"]);
				}
				else if(value.statementFunction == StatementModel.OBJECTION){
					BindingUtils.bindProperty(this, "statementType", this, ["model","statementFunction"]);
				}
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
		
		private function closeClick(envet:MouseEvent):void{
			Alert.show("this is the sign for moving the box!","MessageBox");
		}
		private function downClick(envet:MouseEvent):void{
			Alert.show(" this is the button!","MessageBox");
		}
		
		override protected function createChildren():void{
			super.createChildren();
			if(panelType != StatementModel.INFERENCE){
				tmp_top=new bg1_top();
			}else{
				tmp_top = new bg2_top;
			}
			tmp_top.x=0;
			tmp_top.y=0;
			
			tmp_middle=new bg1_middle();
			tmp_middle.x=7;
			tmp_middle.y=tmp_top.height;
			
			if(panelType != StatementModel.INFERENCE){
				tmp_buttom=new bg1_buttom();
			}else{
				tmp_buttom = new bg2_buttom();
			}
			tmp_buttom.x=7;
			tmp_buttom.y=tmp_top.height+tmp_middle.height;
			
			closer=new bg_close();
			closer.width = 15;
			closer.height = 15;
			closer.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			if(!downer){
				downer=new Triangle_down();
				downer.addEventListener(MouseEvent.MOUSE_OVER, showOptions);
				downer.width=15;
				downer.height=10;
			}
			
			if(!upArrow){
				upArrow = new Triangle_up;
				upArrow.addEventListener(MouseEvent.CLICK, hideOptions);
				upArrow.width = 15;
				upArrow.height = 10;
				upArrow.visible = false;
				addChild(upArrow);
			}
			
			
			displayTxt = new TextField();
			displayTxt.selectable=false;
			displayTxt.x=30;
			displayTxt.y=40;
			displayTxt.width=160;
			displayTxt.height=80; 
			displayTxt.multiline=true;
			displayTxt.wordWrap=true;
			displayTxt.autoSize=TextFieldAutoSize.LEFT;
			
			closer.x= 2;
			closer.y= 9;
			
			closer.addEventListener(MouseEvent.CLICK,closeClick);
			
			
			if(!moveUp){
				moveUp = new Triangle_up_blue;
				moveUp.width = 5;
				moveUp.height = 5;
				moveUp.addEventListener(MouseEvent.CLICK, onStmtTypeClicked);
				if(panelType != StatementModel.INFERENCE && panelType != StatementModel.OBJECTION){
					addChild(moveUp);
				}
			}
			
			if(!moveDown){
				moveDown = new Triangle_down_blue;
				moveDown.width = 5;
				moveDown.height = 5;
				moveDown.addEventListener(MouseEvent.CLICK, onStmtTypeClicked);
				if(panelType != StatementModel.INFERENCE && panelType != StatementModel.OBJECTION){
					addChild(moveDown);
				}
			}
			
			this.addChild(tmp_top);
			this.addChild(tmp_middle);
			this.addChild(tmp_buttom);			
			this.addChild(displayTxt);
			this.addChild(closer);
			this.addChild(downer);
			
			userIdLbl = new Label;
			
			stmtTypeLbl = new Label;
			
			stmtTypeLbl.toolTip = Language.lookup("ParticularUniversalClarification");
			BindingUtils.bindProperty(stmtTypeLbl, "text",this, ["statementType"]);
			
			BindingUtils.bindSetter(setDisplayStatement, model, ["statement", "text"]);
			this.displayTxt.addEventListener(MouseEvent.CLICK, lblClicked);
			
			
			userIdLbl.text = "AU: " + author;
			var userInfoStr:String = Language.lookup("Username")+ ": " +
				AGORAModel.getInstance().userSessionModel.firstName + "\n" +
				"User ID: " + AGORAModel.getInstance().userSessionModel.uid
			userIdLbl.toolTip = userInfoStr;
			
			
			if(panelType != StatementModel.INFERENCE){
				addChild(userIdLbl);
				if(panelType != StatementModel.OBJECTION){
					addChild(stmtTypeLbl);
				}
			}
			
			
			negatedLbl = new Label;
			negatedLbl.text = Language.lookup("ArgNotCase");
			negatedLbl.visible = true;
			
			addBtn = new add_button;
			deleteBtn = new delete_button;
			addBtn.visible = false;
			deleteBtn.visible = false;
			addBtn.addEventListener(MouseEvent.CLICK, onAddBtnClicked);
			deleteBtn.addEventListener(MouseEvent.CLICK,onDeleteBtnClicked);
			
			if(!buttonPanel){
				buttonPanel = new MovieClip();
				buttonPanel.graphics.beginFill(0x28aae2, 1);
				buttonPanel.graphics.drawRoundRect(0,0, 140, 23, 15, 15);
				buttonPanel.graphics.endFill();
				buttonPanel.visible = false;
			}
			
			addChild(buttonPanel);
			addChild(addBtn);
			addChild(deleteBtn);
			
			
		}
		
		override protected function measure():void{
			super.measure();
			
			var tmpHeight:int = 0;
			tmpHeight += tmp_top.height;
			//for computing tmp_middle height
			for each(var dta:DynamicTextArea in inputs){
				tmpHeight += dta.getExplicitOrMeasuredHeight() + 20;
			}
			tmpHeight += tmp_buttom.height + 50;
			measuredHeight = tmpHeight;
			measuredWidth = 220;
		}
		
		override protected function commitProperties():void{
			super.commitProperties();
			if(panelType == StatementModel.INFERENCE){
				
			}
			else if(panelType == StatementModel.OBJECTION){
			}else{
				//remove all the text areas
				var dta:DynamicTextArea;
				var simpleStatement:SimpleStatementModel;
				statementsAddedDF = true;
				
				//check if new statements were added
				//associate every statement in statments vector with a new dynamc text area
				if(statementsAddedDF){
					//clear flag
					statementsAddedDF = false;
					//remove inputs
					for each(dta in inputs){
						try{
							this.removeChild(dta);
						}catch(error:Error){
							//trace("error: Trying to remove an element that is not present");
						}
					}
					inputs.splice(0,inputs.length);
					
					//for each statement add an input text
					for each(simpleStatement in model.statements){
						dta = new DynamicTextArea;
						//add model
						dta.model = simpleStatement;
						//push that into inputs
						inputs.push(dta);
					}	
				}
				
				//This should not be here. Should be set in 
				//update display list
				userIdLbl.width = this.explicitWidth - 60;
				
				if(statementTypeChangedDF){
					statementTypeChangedDF = false;
					try{
						removeChild(tmp_top);
					}catch(e:Error){
						trace("ArgumentPanel::commitProperties: trying to remove tmp_top which is not a child");
					}
					try{
						removeChild(tmp_buttom);
					}catch(e:Error){
						trace("ArgumentPanel::commitProperties: trying to remove tmp_buttom, which is not a child of ArgumentPanel");
					}
					if(statementType == StatementModel.UNIVERSAL){	
						tmp_top = new bg2_top;
						addChild(tmp_top);			
						tmp_buttom = new bg2_buttom;
						addChild(tmp_buttom);
					}
					else{
						tmp_top = new bg1_top;
						addChild(tmp_top);
						tmp_buttom = new bg1_buttom;
						addChild(tmp_buttom);
					}
				}
				//State changed
				if(stateDF){
					stateDF = false;
					if(state == EDIT){
						try{
							removeChild(displayTxt);
						}catch(error:Error){
							trace("ArgumentPanel::commitProperties: trying to remove displayTxt, which is not a child");	
						}
						if(statementNegated){
							addChild(negatedLbl);
						}
						for each(dta in inputs){
							addChild(dta);
							stage.focus = dta;
						}	
					}
					else if(state == DISPLAY){
						//remove inputs
						//group.removeAllElements();
						//remove buttons
						//btnG.removeAllElements();
						//add label
						//add the changed text.
						//needed in case if the 
						//node was changed from positive
						//to negative
						for each(dta in inputs){
							try{
								removeChild(dta);
							}catch(error:Error){
								trace("ArgumentPanel::commitProperties: trying to remove a child that is not present");
							}
						}
						setDisplayStatement(model.statement.text);
						this.addChild(displayTxt);
					}
				}		
			}
			setChildIndex(downer, numChildren - 1);
			setChildIndex(closer, numChildren - 1);
			if(panelType != StatementModel.INFERENCE){
				setChildIndex(userIdLbl, numChildren -1);
				if(panelType != StatementModel.OBJECTION){
					setChildIndex(stmtTypeLbl, numChildren -1);
					setChildIndex(moveUp, numChildren -1);
					setChildIndex(moveDown, numChildren - 1);		
				}
			}
			
			setChildIndex(buttonPanel, numChildren - 1);
			setChildIndex(addBtn, numChildren - 1);
			setChildIndex(deleteBtn, numChildren -1);
			setChildIndex(upArrow, numChildren -1);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var tmp_middleheight:int;
			if(state == DISPLAY){
				tmp_middleheight = displayTxt.height;
			}
			else{
				tmp_middleheight = 0;
				for each(var dta:DynamicTextArea in inputs){
					tmp_middleheight += dta.getExplicitOrMeasuredHeight() + 20;
				}
				
			}
			tmp_middle.height = tmp_middleheight;
			tmp_middle.y = tmp_top.height;
			displayTxt.y = tmp_middle.y;
			tmp_top.width = 220;
			tmp_buttom.width = 215;
			tmp_middle.width = 215;
			tmp_middle.x = 5;
			tmp_buttom.x = 5;
			tmp_buttom.y=tmp_top.height+tmp_middle.height;
			
			if(statementType == StatementModel.UNIVERSAL){
				downer.x=159;
				downer.y=tmp_top.height+tmp_middle.height+52;
			}else{
				downer.x= 159;
				downer.y=tmp_top.height+tmp_middle.height+22;
			}
			
			//place dtas
			var tmpHeight:int = tmp_middle.y;
			for each(dta in inputs){
				dta.move(30, tmpHeight);
				tmpHeight += dta.getExplicitOrMeasuredHeight() + 20;
				dta.setActualSize(dta.getExplicitOrMeasuredWidth(), dta.getExplicitOrMeasuredHeight());
			}
			
			//add username and panel type
			if(panelType != StatementModel.INFERENCE){ // position username
				userIdLbl.move(getExplicitOrMeasuredWidth() /2, 20);
				userIdLbl.setActualSize(getExplicitOrMeasuredWidth() /2 - 20 , userIdLbl.getExplicitOrMeasuredHeight() );
				if(panelType != StatementModel.OBJECTION){
					//position statement type and the arrows
					stmtTypeLbl.setActualSize(stmtTypeLbl.getExplicitOrMeasuredWidth(), stmtTypeLbl.getExplicitOrMeasuredHeight());
					stmtTypeLbl.move(20, 20);//stmtTypeLbl.x = 50;
					moveUp.x = stmtTypeLbl.x + stmtTypeLbl.getExplicitOrMeasuredWidth() + 5;
					moveUp.y = 23;
					moveDown.x = moveUp.x;
					moveDown.y = moveUp.y + moveUp.height + 1;
				}
			}
			
			buttonPanel.x = 70;
			buttonPanel.y = tmp_buttom.y + tmp_buttom.height - 17;
			
			upArrow.x = buttonPanel.x + 5;
			upArrow.y = buttonPanel.y + 7;
			
			addBtn.x = 120;
			addBtn.y = tmp_buttom.y + tmp_buttom.height - 6;
			deleteBtn.x = addBtn.x + addBtn.width + 5;
			deleteBtn.y = tmp_buttom.y + tmp_buttom.height - 6;

		}
		
		//------------------ Event Listeners -------------------------------//
		protected function showOptions(event:MouseEvent):void{
			addBtn.visible = true;
			deleteBtn.visible = true;
			downer.visible = false;
			upArrow.visible = true;
			buttonPanel.visible = true;
			optionsShownDF = true;
		}

		protected function hideOptions(event:MouseEvent):void{
			optionsShownDF = false;
			addBtn.visible = false;
			deleteBtn.visible = false;
			upArrow.visible = false;
			buttonPanel.visible = false;
			downer.visible = true;
		}
		
		protected function onCreationComplete(event:FlexEvent):void{
			//Event Listeners that are appropriate only after the component is 
			//created
			addEventListener(KeyboardEvent.KEY_DOWN, keyEntered);
		}
		protected function onDeleteBtnClicked(event:MouseEvent):void{
			//ArgumentController.getInstance().deleteNodes(this);
		}
		
		protected function onStmtTypeClicked(event:MouseEvent):void{
			ArgumentController.getInstance().changeType(model.ID);
		}
		
		protected function onAddBtnClicked(event:MouseEvent):void{
			ArgumentController.getInstance().showAddMenu(this);
		}
		
		protected function lblClicked(event:MouseEvent):void
		{
			ViewController.getInstance().changeToEdit(this);	
		}
		
		protected function doneBtnClicked(event:MouseEvent):void{
			ArgumentController.getInstance().saveText(model);
		}
		
		protected function keyEntered(event: KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)	
			{				
				if(state == EDIT){
					ArgumentController.getInstance().saveText(model);
				}
			}
		}
		
		public function beginDrag(mouseEvent: MouseEvent ):void
		{
			try{
				var dPInitiator:ArgumentPanel = this;
				var ds:DragSource = new DragSource();
				var tmpx:int = int(dPInitiator.mouseX);
				var tmpy:int = int(dPInitiator.mouseY);
				ds.addData(tmpx,"x");
				ds.addData(tmpy,"y");
				ds.addData(dPInitiator.model.xgrid,"gx");
				ds.addData(dPInitiator.model.ygrid,"gy");
				DragManager.doDrag(dPInitiator,ds,mouseEvent,null);
			}
			catch(error:Error)
			{
				Alert.show(error.toString());
			}
		}
		
		protected function optionClicked(event:MouseEvent):void
		{
		}
		
		protected function hideOption(event:KeyboardEvent):void
		{
		}
		
		protected function argConstructionMenuClicked(menuEvent:MenuEvent):void{
			if(menuEvent.label == "add another reason"){
				ArgumentController.getInstance().addReason(model.argumentTypeModel);
			}else{
				ArgumentController.getInstance().constructArgument(model.argumentTypeModel);
			}
		}
		
		public function addMenuClicked(event:MenuEvent):void{
			if(event.label == agoraLabels.ADD_SUPPORTING_STATEMENT){
				ArgumentController.getInstance().addSupportingArgument(model);
			}else if(event.label == agoraLabels.ADD_OBJECTION){
				ArgumentController.getInstance().addAnObjection(model);
			}
		}
		
		//----------------------- Bind Setters -------------------------------------------------//
		protected function setDisplayStatement(value:String):void{
			if(value == null){
				if(model.statementFunction == StatementModel.STATEMENT){
					if(model.firstClaim){
						displayTxt.text = "[" + Language.lookup("EnterClaim") +"]";
					}else{
						displayTxt.text = "[" + Language.lookup("EnterReason")+ "]";
					}
				}
				else if(model.statementFunction == StatementModel.INFERENCE){
					displayTxt.text = AGORAParameters.getInstance().SUPPORT_SELECT_ARG_SCHEME;
				}
			}
			else if(value.split(" ").join("").length == 0){
				if(model.statementFunction == StatementModel.STATEMENT){
					if(model.firstClaim){
						displayTxt.text = "[" + Language.lookup("EnterClaim") +"]";
					}else{
						displayTxt.text = "[" + Language.lookup("EnterReason")+ "]";
					}
				}else if(model.statementFunction == StatementModel.INFERENCE){
					displayTxt.text =  AGORAParameters.getInstance().SUPPORT_SELECT_ARG_SCHEME;
				}
			}
			else{
				displayTxt.text = value;
			}
			invalidateSize();
			invalidateDisplayList();
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
		
		//------------- Other public functions ------------//
		public function enableDelete():void{
			//remove button
			if(AGORAModel.getInstance().leafDelete){
				/*
				if(model.supportingArguments.length != 0 || ( model.argumentTypeModel && model.argumentTypeModel.inferenceModel.supportingArguments.length != 0)){
				if(deleteBtn){
				deleteBtn.enabled = false;
				}			
				}
				*/
			}
		}
		
		public function showMenu():void
		{
			var constructArgData:XML = agoraLabels.CONSTRUCT_ARG_DATA;
			var menu:mx.controls.Menu = mx.controls.Menu.createMenu(null,constructArgData,false);
			menu.labelField = "@label";
			menu.addEventListener(MenuEvent.ITEM_CLICK, argConstructionMenuClicked);
			var globalPosition:Point = localToGlobal(new Point(0,this.height));
			menu.show(globalPosition.x,globalPosition.y);	
		}
		
		public function toEditState():void{
			if(panelType != StatementModel.INFERENCE){
				state = EDIT;
				dispatchEvent(new AGORAEvent(AGORAEvent.STATEMENT_STATE_TO_EDIT, null, this));
			}
		}
	}
}