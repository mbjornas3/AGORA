package logic
{
	import components.ArgSelector;
	
	import mx.utils.ObjectUtil;


	public class ParentArg {
		
	public var myname:String;
	public var _langTypes:Array;
<<<<<<< HEAD
	public var MOD_PON:String = "Modus Ponens";
	public var MOD_TOL:String = "Modus Tollens";
	public var COND_SYLL:String = "Conditional Syllogism";
	public var DIS_SYLL:String = "Disjunctive Syllogism";
	public var NOT_ALL_SYLL:String = "Not-All Syllogism";
	public var CONST_DILEM:String = "Constructive Dilemma";
	public static var EXP_AND:String = "and";
	public static var EXP_OR:String = "or";
	
	public var mySelector:ArgSelector;	// reference to be moved from Inference to here - specific argscheme
	
	public function ParentArg()
	{
		mySelector = new ArgSelector;
	}
	
=======
	public static var MODUS_PONENS:String = "Modus Ponens";
>>>>>>> 0298e1f76e24411ff3d09079b2dc859f66f70ca9
	
	}
}