<?php
	/**
	* Check-Login function separated out for widespread use.
	*/
	function checkLogin($userID, $pass_hash, $linkID)
	{
		$userclause = mysql_real_escape_string("$userID");
		$passclause = mysql_real_escape_string("$pass_hash");
		$query = "SELECT * FROM users WHERE user_ID='$userID' AND password='$passclause'";
		$resultID = mysql_query($query, $linkID) or die("Data not found."); 
		if(mysql_num_rows($resultID)>0){
			return true;
		}else{
			return false;
		}
	}
?>