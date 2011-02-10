package unittests
{
	public class TestEquivalence
	{		
		import logic.Equivalence;
		import org.flexunit.Assert;
		
		private var eq:Equivalence;
		
		[Before]
		public function setUp():void
		{
			//Cannot use a single inference text for all functions.
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			trace("Setting up Equivalence testing...");
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		//Not asserting anything because it's currently pointless
		[Test(order=1)]
		public function testIfOnlyIfPTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfP(true);
			trace("~~ Printing all reasons in IfOnlyIfPTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfP"));
		}
		[Test(order=2)]
		public function testIfOnlyIfPFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfP(false);
			trace("~~ Printing all reasons in IfOnlyIfPFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfP"));
		}
		[Test(order=3)]
		public function testIfOnlyIfQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfQ(true);
			trace("~~ Printing all reasons in IfOnlyIfQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfQ"));
		}
		[Test(order=4)]
		public function testIfOnlyIfQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfQ(false);
			trace("~~ Printing all reasons in IfOnlyIfQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfQ"));
		}
		[Test(order=5)]
		public function testIfOnlyIfNotPTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfNotP(true);
			trace("~~ Printing all reasons in IfOnlyIfNotPTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfNotP"));
		}
		[Test(order=6)]
		public function testIfOnlyIfNotPFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfNotP(false);
			trace("~~ Printing all reasons in IfOnlyIfNotPFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfNotP"));
		}
		[Test(order=7)]
		public function testIfOnlyIfNotQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfNotQ(true);
			trace("~~ Printing all reasons in IfOnlyIfNotQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfNotQ"));
		}
		[Test(order=8)]
		public function testIfOnlyIfNotQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo if and only if Bar", false);
			eq.ifOnlyIfNotQ(false);
			trace("~~ Printing all reasons in IfOnlyIfNotQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("ifOnlyIfNotQ"));
		}
		[Test(order=9)]
		public function testJustInCasePTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseP(true);
			trace("~~ Printing all reasons in JustInCasePTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseP"));
		}
		[Test(order=10)]
		public function testJustInCasePFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseP(false);
			trace("~~ Printing all reasons in JustInCasePFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseP"));
		}
		[Test(order=11)]
		public function testJustInCaseQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseQ(true);
			trace("~~ Printing all reasons in JustInCaseQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseQ"));
		}
		[Test(order=12)]
		public function testJustInCaseQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseQ(false);
			trace("~~ Printing all reasons in JustInCaseQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseQ"));
		}
		[Test(order=13)]
		public function testJustInCaseNotPTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseNotP(true);
			trace("~~ Printing all reasons in JustInCaseNotPTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseNotP"));
		}
		[Test(order=14)]
		public function testJustInCaseNotPFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseNotP(false);
			trace("~~ Printing all reasons in JustInCaseNotPFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseNotP"));
		}
		[Test(order=15)]
		public function testJustInCaseNotQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseNotQ(true);
			trace("~~ Printing all reasons in JustInCaseNotQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseNotQ"));
		}
		[Test(order=16)]
		public function testJustInCaseNotQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo just in case Bar", false);
			eq.justInCaseNotQ(false);
			trace("~~ Printing all reasons in JustInCaseNotQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("justInCaseNotQ"));
		}
		[Test(order=17)]
		public function testNecessaryPTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryP(true);
			trace("~~ Printing all reasons in NecessaryPTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryP"));
		}
		[Test(order=18)]
		public function testNecessaryPFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryP(false);
			trace("~~ Printing all reasons in NecessaryPFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryP"));
		}
		[Test(order=19)]
		public function testNecessaryQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryQ(true);
			trace("~~ Printing all reasons in NecessaryQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryQ"));
		}
		[Test(order=20)]
		public function testNecessaryQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryQ(false);
			trace("~~ Printing all reasons in NecessaryQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryQ"));
		}
		[Test(order=21)]
		public function testNecessaryNotPTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryNotP(true);
			trace("~~ Printing all reasons in NecessaryNotPTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryNotP"));
		}
		[Test(order=22)]
		public function testNecessaryNotPFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryNotP(false);
			trace("~~ Printing all reasons in NecessaryNotPFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryNotP"));
		}
		[Test(order=23)]
		public function testNecessaryNotQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryNotQ(true);
			trace("~~ Printing all reasons in NecessaryNotQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryNotQ"));
		}
		[Test(order=24)]
		public function testNecessaryNotQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo is a necessary and sufficient condition for Bar", false);
			eq.necessaryQ(false);
			trace("~~ Printing all reasons in NecessaryNotQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("necessaryNotQ"));
		}
		[Test(order=25)]
		public function testEquivalentPTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentP(true);
			trace("~~ Printing all reasons in EquivalentPTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentP"));
		}
		[Test(order=18)]
		public function testEquivalentPFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentP(false);
			trace("~~ Printing all reasons in EquivalentPFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentP"));
		}
		[Test(order=19)]
		public function testEquivalentQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentQ(true);
			trace("~~ Printing all reasons in EquivalentQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentQ"));
		}
		[Test(order=20)]
		public function testEquivalentQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentQ(false);
			trace("~~ Printing all reasons in EquivalentQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentQ"));
		}
		[Test(order=21)]
		public function testEquivalentNotPTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentNotP(true);
			trace("~~ Printing all reasons in EquivalentNotPTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentNotP"));
		}
		[Test(order=22)]
		public function testEquivalentNotPFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentNotP(false);
			trace("~~ Printing all reasons in EquivalentNotPFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentNotP"));
		}
		[Test(order=23)]
		public function testEquivalentNotQTrue():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentNotQ(true);
			trace("~~ Printing all reasons in EquivalentNotQTrue");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentNotQ"));
		}
		[Test(order=24)]
		public function testEquivalentNotQFalse():void{
			eq= new Equivalence("Basic Claim", ["Reason 1", "Reason 2"], false, "Foo and Bar are equivalent", false);
			eq.equivalentQ(false);
			trace("~~ Printing all reasons in EquivalentNotQFalse");
			for each (var reason:String in eq.getReason()){
				trace(reason);
			}
			trace("The claim is: ", eq.getClaim());
			trace("The inference is: ", eq.getInference("equivalentNotQ"));
		}
	}
}