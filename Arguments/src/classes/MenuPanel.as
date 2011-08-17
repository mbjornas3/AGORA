package classes
{
	
	
	/**
	 AGORA - an interactive and web-based argument mapping tool that stimulates reasoning, 
	 reflection, critique, deliberation, and creativity in individual argument construction 
	 and in collaborative or adversarial settings. 
	 Copyright (C) 2011 Georgia Institute of Technology
	 
	 This program is free software: you can redistribute it and/or modify
	 it under the terms of the GNU Affero General Public License as
	 published by the Free Software Foundation, either version 3 of the
	 License, or (at your option) any later version.
	 
	 This program is distributed in the hope that it will be useful,
	 but WITHOUT ANY WARRANTY; without even the implied warranty of
	 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 GNU Affero General Public License for more details.
	 
	 You should have received a copy of the GNU Affero General Public License
	 along with this program.  If not, see <http://www.gnu.org/licenses/>.
	 
	 */

	import flash.events.MouseEvent;
	import Model.ArgumentTypeModel;
	import mx.containers.Panel;
	import mx.controls.Label;
	import mx.core.DragSource;
	import mx.core.IUIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import spark.components.Button;
	import spark.components.HGroup;
	import spark.components.VGroup;
	
	public class MenuPanel extends GridPanel
	{
		private var _model:ArgumentTypeModel;
		public var vgroup:VGroup;
		public var hgroup:HGroup;
		public var addReasonBtn:Button;
		public var changeSchemeBtn:Button;
		public var inference:Inference;
		
		public function MenuPanel()
		{
			super();
			minHeight = 20;
			width = 150;
			this.setStyle("chromeColor",uint("0xdddddd"));
		}

		public function get model():ArgumentTypeModel
		{
			return _model;
		}

		public function set model(value:ArgumentTypeModel):void
		{
			_model = value;
		}

		override protected function createChildren():void
		{
			super.createChildren();
			vgroup = new VGroup;
			vgroup.gap = 0;
			addElement(vgroup);
			hgroup = new HGroup;
			vgroup.addElement(hgroup);
			addReasonBtn = new Button;
			addReasonBtn.label = "add..";
			hgroup.gap = 0;
			vgroup.percentWidth = 100;
			addReasonBtn.percentWidth = 100;
			
			changeSchemeBtn = new Button;
			changeSchemeBtn.label = "Scheme";
			changeSchemeBtn.percentWidth = 100;
			titleDisplay.setStyle("textAlign","center");
			title = Language.lookup("Therefore");
			vgroup.addElement(changeSchemeBtn);
			vgroup.addElement(addReasonBtn);
			this.titleDisplay.addEventListener(MouseEvent.MOUSE_DOWN,beginDrag);
			addEventListener(FlexEvent.PREINITIALIZE, menuPanelCreated);
		}
		
		private function menuPanelCreated(event:FlexEvent):void{
			/*
			try{
				gridX = inference._initXML.connection[0].@x;
				gridY = inference._initXML.connection[1].@y;
			}catch(e:Error){
				trace(e);
			}
			*/
		}
		
		public function beginDrag( mEvent:MouseEvent):void
		{
			try{
				var dInitiator:MenuPanel = mEvent.currentTarget.parent.parent.parent.parent.parent as MenuPanel;
				var ds:DragSource = new DragSource;
				ds.addData(dInitiator.mouseX,"x");
				ds.addData(dInitiator.mouseY,"y");
				ds.addData(dInitiator.gridX,"gx");
				ds.addData(dInitiator.gridY,"gy");
				DragManager.doDrag(dInitiator,ds,mEvent,null);
			}catch (e:Error){
				trace(e);
			}
		}
		
	}
}