package Model
{
	
	import Events.NetworkEvent;
	
	import ValueObjects.AGORAParameters;
	import ValueObjects.UserDataVO;
	
	import com.adobe.crypto.MD5;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	import org.osmf.utils.URL;
	
	public class UserSessionModel extends EventDispatcher
	{
		public var firstName:String;
		public var lastName:String;
		public var uid:int;
		public var password:String;
		public var passHash:String;
		public var email:String;
		public var URL:String;
		
		private var _valueObject:UserDataVO;
		private static var _salt:String = "AGORA";
		

		public function UserSessionModel(target:IEventDispatcher=null)
		{
			_valueObject = new UserDataVO;
			super(target);
		}
		
		//Getters
		public function get valueObject():UserDataVO
		{
			_valueObject.firstName = this.firstName;
			_valueObject.lastName = this.lastName;
			_valueObject.password = this.password;
			_valueObject.email = this.email;
			_valueObject.URL = this.URL;
			return _valueObject;
		}

		//other public functions
		public function loggedIn():Boolean{
			if(uid){
				return true;
			}else{
				return false;
			}
		}
		
		//---------------- Authentication ------------------------//
		public function authenticate(userData:UserDataVO):void{
			var loginRequestService:HTTPService = new HTTPService;
			passHash = MD5.hash(userData.password + _salt);
			loginRequestService.url = AGORAParameters.getInstance().loginURL;
			loginRequestService.request['username'] = userData.userName;
			loginRequestService.request['pass_hash'] = passHash;
			loginRequestService.addEventListener(ResultEvent.RESULT, onLoginRequestServiceResult);
			loginRequestService.addEventListener(FaultEvent.FAULT, onLoginRequestServiceFault);
			loginRequestService.send();
		}
		
		protected function onLoginRequestServiceResult(event:ResultEvent):void{
			event.target.removeEventListener(ResultEvent.RESULT, onLoginRequestServiceResult);
			event.target.removeEventListener(FaultEvent.FAULT, onLoginRequestServiceFault);
			try{
				uid = event.result.login.ID;
				firstName = event.result.login.firstname;
				lastName = event.result.login.lastname;
				dispatchEvent(new NetworkEvent(NetworkEvent.AUTHENTICATED));
			}catch(e:Error){
				trace("In UserSessionModel.onLoginRequestServiceResult: expected attributes were not present either because of invalid credentials or change in server ");
				dispatchEvent(new NetworkEvent(NetworkEvent.USER_INVALID));
			}
		}
		
		protected function onLoginRequestServiceFault(event:FaultEvent):void{
			event.target.removeEventListener(ResultEvent.RESULT, onLoginRequestServiceResult);
			event.target.removeEventListener(FaultEvent.FAULT, onLoginRequestServiceFault);
			dispatchEvent( new NetworkEvent(NetworkEvent.FAULT));
		}
		
		//---------------- Registration-----------------------------//
		public function register(userData:UserDataVO):void{
			var registrationRequestService:HTTPService = new HTTPService;
			passHash = MD5.hash(userData.password + _salt);
			registrationRequestService.url = AGORAParameters.getInstance().registrationURL;
			registrationRequestService.request['username'] = userData.userName;
			registrationRequestService.request['pass_hash'] = passHash;
			registrationRequestService.addEventListener(ResultEvent.RESULT, onRegistrationRequestServiceResult);
			registrationRequestService.addEventListener(FaultEvent.FAULT, onRegistrationRequestServiceFault);
			registrationRequestService.send({username:userData.userName,
											pass_hash:passHash,
											firstname:userData.firstName,
											lastname:userData.lastName,
											email:userData.email,
											url:userData.URL});
		}
		
		protected function onRegistrationRequestServiceResult(event:ResultEvent):void{
			event.target.removeEventListener(ResultEvent.RESULT, onRegistrationRequestServiceResult);
			event.target.removeEventListener(FaultEvent.FAULT, onRegistrationRequestServiceFault);
			if(event.result.login.hasOwnProperty("created")){
				dispatchEvent(new NetworkEvent(NetworkEvent.REGISTRATION_SUCCEEDED));
			}else{
				dispatchEvent(new NetworkEvent(NetworkEvent.REGISTRATION_FAILED));
			}
		}
		
		protected function onRegistrationRequestServiceFault(event:ResultEvent):void{
			event.target.removeEventListener(ResultEvent.RESULT, onRegistrationRequestServiceResult);
			event.target.removeEventListener(FaultEvent.FAULT, onRegistrationRequestServiceFault);
			dispatchEvent(new NetworkEvent(NetworkEvent.FAULT));
		}
	}
}