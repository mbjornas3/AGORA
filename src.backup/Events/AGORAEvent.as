package Events
{
	import flash.events.Event;
	
	public class AGORAEvent extends Event
	{
		static public const FAULT:String = "Fault";
		static public const MAP_LIST_FETCHED:String = "MapListFetched";
		static public const MY_MAPS_LIST_FETCHED:String = "MyMapsListFetched";
		public static const AUTHENTICATED:String = "Authenticated";
		public static const USER_INVALID:String = "UserInvalid";
		public static const REGISTRATION_SUCCEEDED:String = "RegistrationSucceeded";
		public static const REGISTRATION_FAILED:String = "RegistrationFailed";
		public static const MAPS_DELETED:String = "MapsDeleted";
		public static const MAPS_DELETION_FAILED:String = "MapsDeletionFailed";
		public static const APP_STATE_SET:String = "AppStateSet";
		public static const SINGNED_OUT:String = "SignedOut";
		public static const LOGIN_STATUS_SET:String = "LogInStatus";
		public static const MAP_CREATED:String = "MapCreated";
		public static const MAP_CREATION_FAILED:String = "MapCreationFailed";
		public static const FIRST_CLAIM_ADDED:String = "FirstClaimAdded";
		public static const MAP_LOADED:String = "MapLoaded";
		public static const MAP_LOADING_FAILED:String = "MapLoadingFailed";
		public static const STATEMENT_TYPE_TOGGLED:String = "StatementTypeToggled";
		public static const POSITIONS_UPDATED:String = "PositionsUpdated";
		public static const TEXT_SAVED:String = "TextSaved";
		public static const TEXT_SAVE_FAILED:String = "TextSaveFailed";
		public static const STATEMENT_ADDED:String = "StatementAdded";
		public static const ARGUMENT_CREATED:String = "ArgumentCreated";
		public static const STATEMENT_STATE_TO_EDIT:String = "StatementStateToEdit";
		public static const REASON_ADDED:String = "ReasonAdded";
		public static const ARGUMENT_TYPE_ADDED:String = "ArgumentTypeAdded";
		public static const ARGUMENT_SCHEME_SET:String = "ArgumentSchemeSet";
		public static const ARGUMENT_SAVED:String = "ArgumentSaved";
		public static const STATEMENTS_DELETED:String = "StatementsDeleted";
		public static const STATEMENTS_DELETED_FAILED:String = "StatementsDeletedFailed";
		public static const REASON_ADDITION_NOT_ALLOWED:String = "ReasonAdditionNotAllowed";
		
		public var xmlData:XML;
		public var eventData:Object;
		
		public function AGORAEvent(type:String, xmlData:XML=null, eventData:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.xmlData = xmlData;
			this.eventData = eventData;	
		}
	}
}