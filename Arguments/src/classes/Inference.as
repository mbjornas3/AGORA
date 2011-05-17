package classes
{
	import components.ArgSelector;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import logic.*;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.listClasses.ListData;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.SkinnableContainer;
	import spark.components.VGroup;
	
	public class Inference extends ArgumentPanel
	{
		public static var connections:int;
		public var reasons:Vector.<ArgumentPanel>;
		public var input:Vector.<DynamicTextArea>;
		public var argumentClass:String;
		public var vgroup:VGroup;
		public var claim:ArgumentPanel;
		public var _argType:DisplayArgType;
		public var myschemeSel:ArgSelector;
		public var myArg:ParentArg;		
		public var _displayStr:String;
		public var isExp:Boolean;
		public var connectionID:int;
		public var connectionIDs:Vector.<int>;
		public var formedBool:Boolean;
		
		public function Inference()
		{
			super();
			connectionID = connections++;
			connectionIDs = new Vector.<int>(0,false);
			panelType = ArgumentPanel.INFERENCE;
			state = 0; // Inference is always a Universal statement
			addEventListener(FlexEvent.CREATION_COMPLETE, displayArgumentType);
			input = new Vector.<DynamicTextArea>(0,false);
			reasons = new Vector.<ArgumentPanel>(0,false);
			//This is a place for overhead. Constructors are not JIT compiled,
			//and therefore, the below creation of a child component must be
			//moved to createChildren()
			myschemeSel = new ArgSelector();
			this.setStyle("cornerRadius",30);	
			//displayStr = "";
			formedBool = false;
		}
		
		
		public function set displayStr(value:String):void
		{
			//trace(input1);
			_displayStr = value;
			input1.text = _displayStr;
			displayTxt.text = _displayStr;
			displayTxt.height = input1.height;
		}
		
		public function get displayStr():String
		{
			return _displayStr;
		}
		
		public function get argType():DisplayArgType
		{
			return _argType;
		}
		
		public function set argType(value:DisplayArgType):void
		{
			_argType = value;
			_argType.addEventListener(FlexEvent.CREATION_COMPLETE,addToMap);
		}
		
		public function addToMap(fe:FlexEvent):void
		{
			argType.addReasonBtn.addEventListener(MouseEvent.CLICK,addReasonHandler);
			argType.changeSchemeBtn.addEventListener(MouseEvent.CLICK,changeScheme);
		}
		
		public function changeScheme(event:MouseEvent):void
		{
			changeHandler(event);
		}
		
		private function displayArgumentType(e: FlexEvent) : void
		{
			//parentMap.addElement(argType);
		}
		
		
		public function addReason():void
		{
			var tmp:ArgumentPanel = new ArgumentPanel();
			parentMap.addElement(tmp);
			try{
				reasons.push(tmp);
				connectionIDs.push(connections++);
				tmp.inference = this;
				parentMap.layoutManager.registerPanel(tmp);
				
				//create an invisible box in the inference rule
				var tmpInput:DynamicTextArea = new DynamicTextArea();
				//visual
				parentMap.addElement(tmpInput);
				tmpInput.visible = false;
				
				//logical
				var inferenceRule:Inference = this;
				tmpInput.panelReference = inferenceRule;
				inferenceRule.input.push(tmpInput);		
				
				//set the id
				tmpInput.id = tmp.input1.id;
				
				//binding
				tmpInput.forwardList.push(inferenceRule.input1);	//invisible box input forwards to the visible box input1 in inference
				tmp.input1.forwardList.push(tmpInput);				//this new reason's input1 text forwards to that invisible box.
				
			}catch (e:Error)
			{
				Alert.show(e.toString());
			}
		}
		
		public function addReasonHandler(event:MouseEvent):void
		{
			addReason();	
		}
		
		override public function onArgumentPanelCreate(e:FlexEvent):void
		{
			super.onArgumentPanelCreate(e);
			doneBtn.removeEventListener(MouseEvent.CLICK,makeUnEditable);
			displayTxt.removeEventListener(MouseEvent.CLICK,makeEditable);
			displayTxt.visible = true;
			displayTxt.toolTip = "The statement in this text box is called the \"enabler\". An \"enabler\" is the premise in an argument that guarantees that the reason provided (or a combination of reasons) is sufficient to justify the claim. The enabler is always a universal statement. It guarantees that an argument is logically valid."
			bottomHG.visible = true;
			doneHG.visible = false;
			input1.visible = false;
			
			stmtTypeLbl.removeEventListener(MouseEvent.CLICK,toggle);
		}
		
		public function buildInference():void
		{
			
			myschemeSel.visible=true;
			myschemeSel.x = this.gridY*parentMap.layoutManager.uwidth + this.width;
			myschemeSel.y = this.gridX*parentMap.layoutManager.uwidth;
			parentMap.parent.addChild(myschemeSel);
			myschemeSel.depth = parentMap.parent.numChildren;
			var rootlist:List = myschemeSel.mainSchemes;
			if(myArg!=null) 
			{
				rootlist.dataProvider = myArg.myname;	
				argType.changeSchemeBtn.toolTip = "Only change in language type is allowed";
			}
			var sublist:List = myschemeSel.typeSelector;
			var oplist:List = myschemeSel.andor;
			rootlist.addEventListener(ListEvent.ITEM_ROLL_OVER,displayTypes);
			sublist.addEventListener(ListEvent.ITEM_CLICK,setType);
			sublist.addEventListener(ListEvent.ITEM_ROLL_OVER,displayOption);
			oplist.addEventListener(ListEvent.ITEM_CLICK,setOption);
			myschemeSel.addEventListener(MouseEvent.MOUSE_OVER,bringForward);
			myschemeSel.addEventListener(MouseEvent.MOUSE_OUT,goBackward);
		}
		
		public function changeHandler(e:MouseEvent):void
		{
			buildInference();
		}
		
		public function setType(le:ListEvent):void
		{
			argType.schemeText = le.itemRenderer.data.toString();
			if(myschemeSel.andor.visible==false)
			{
				//myschemeSel.visible = false;
				parentMap.parent.removeChild(myschemeSel);
			}
			//input1.visible=true;
			//input1.update();
		}
		
		public function displayTypes(le:ListEvent):void
		{
			var myclassindex:int = le.rowIndex;
			var sublist:List = myschemeSel.typeSelector;
			sublist.visible=true;
			switch(myclassindex)
			{
				case 0: myArg = new ModusPonens; break;
				case 1: myArg = new ModusTollens; break;
				case 2: myArg = new ConditionalSyllogism; break;
				case 3: myArg = new DisjunctiveSyllogism; break;
				case 4: myArg = new NotAllSyllogism; break;
				case 5: myArg = new ConstructiveDilemma;
					
			}
			sublist.dataProvider = myArg._langTypes;
			//argType.title = myArg.myname;
			argType.changeSchemeBtn.label = myArg.myname;//set scheme
		}
		
		public function displayOption(le:ListEvent):void
		{
			var oplist:List = myschemeSel.andor;
			var typeText:String=le.itemRenderer.data.toString();
			argType.schemeText = typeText;
			argType.schemeTextIndex = le.rowIndex;
			if(myArg.myname == ParentArg.MOD_TOL)
				if(typeText == "Only if") {
					oplist.visible=true; isExp = true; }
				else
					oplist.visible=false;
				else if(myArg.myname == ParentArg.MOD_PON)
					for(var i:int;i<myArg._expLangTypes.length;i++)
						if(myArg._expLangTypes[i] == typeText) {
							argType.connText = ParentArg.EXP_AND;	// Modus Ponens expanded only with AND
							isExp = true; }
			
			displayStr = myArg.correctUsage(argType.schemeTextIndex,this.claim.input1.text,this.reasons,isExp);
		}
		
		public function setOption(le:ListEvent):void
		{
			var andor:String = le.itemRenderer.data.toString();
			if(andor=="And") argType.connText = ParentArg.EXP_AND;
			else if(andor=="Or") argType.connText = ParentArg.EXP_OR;
			myschemeSel.visible = false;
			input1.forwardUpdate();
		}
		
		
		
		public function bringForward(e:MouseEvent):void
		{
		}
		
		public function goBackward(e:MouseEvent):void
		{
		}
		
		override public function getString():String
		{
			var s:String;
			for(var i:int = 0; i < input.length; i++)
			{
				s = s + input[i].text;
			}
			return s;
		}
		
		public function formClaim ():void
		{
			
		}
		
		public function makeVisible():void{
			this.visible = true;
			this.argType.visible = true;
		}
		
	}
}