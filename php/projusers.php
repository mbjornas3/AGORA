<?php
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
	
	/**
		List of variables for project creation:
		uid: ID number for the user
		pass_hash: The hash of the user's password
		projID: The ID of the project.
		userID: The ID of the user to be added or removed.
		action: "add" or "remove". Pretty self-explanatory, really.
		
		THIS IS NOT THE CODE FOR A USER JOINING THE PROJECT WITH THE PASSWORD!
	**/
	require 'configure.php';
	require 'errorcodes.php';
	require 'establish_link.php';
	require 'utilfuncs.php';
	
	/**
	* Convenience function.
	* Selects the last auto-generated ID (AUTO_INCREMENT) from the Database.
	* See the following for the function that this uses:
	* http://php.net/manual/en/function.mysql-insert-id.php
	*/
	function getLastInsert($linkID)
	{
		$query = "SELECT LAST_INSERT_ID()";
		$resultID = mysql_query($query, $linkID);
		$row = mysql_fetch_assoc($resultID);
		return $row['LAST_INSERT_ID()'];
	}
	
	function addUser($otheruserID, $projID, $userID, $level, $pass_hash, $output){
		$output->addAttribute("ID", $projID);
		global $dbName, $version;
		header("Content-type: text/xml");
		$xmlstr = "<?xml version='1.0'?>\n<project version='$version'></project>";
		$output = new SimpleXMLElement($xmlstr);
		$linkID= establishLink();
		if(!$linkID){
			badDBLink($output);
			return $output;
		}
		$status=mysql_select_db($dbName, $linkID);
		if(!$status){
			 databaseNotFound($output);
			 return $output;
		}
		if(!checkLogin($userID, $pass_hash, $linkID)){
			print $userID;
			print $pass_hash;
			print $dbName;
			incorrectLogin($output);
			return $output;
		}
		//Basic boilerplate is done.

		if(!checkForAdmin($projID, $userID, $linkID)){
			notProjectAdmin($output);
			return $output;
		}
		$query = "INSERT INTO projusers (proj_id, user_id, user_level) VALUES ($projID, $otheruserID, $level)";
		$success = mysql_query($query, $linkID);
		if($success){
			$otheruser=$output->addChild("user");
			$otheruser->addAttribute("ID", $otheruserID);
			$otheruser->addAttribute("added", true);
			return $output;
		}else{
			$otheruser=$output->addChild("user");
			$otheruser->addAttribute("ID", $otheruserID);
			$otheruser->addAttribute("added", false);
			updateFailed($output, $query);
			//Note that the UNIQUE pu_combo field ensures that a user can't be added to a project twice.
			return $output;
		}
		
		return $output;
	}
	
	function removeUser($otheruserID, $projID, $userID, $pass_hash, $output){
		$output->addAttribute("ID", $projID);
		global $dbName, $version;
		header("Content-type: text/xml");
		$xmlstr = "<?xml version='1.0'?>\n<project version='$version'></project>";
		$output = new SimpleXMLElement($xmlstr);
		$linkID= establishLink();
		if(!$linkID){
			badDBLink($output);
			return $output;
		}
		$status=mysql_select_db($dbName, $linkID);
		if(!$status){
			 databaseNotFound($output);
			 return $output;
		}
		if(!checkLogin($userID, $pass_hash, $linkID)){
			incorrectLogin($output);
			return $output;
		}
		//Basic boilerplate is done.
		if(!checkForAdmin($projID, $userID, $linkID)){
			notProjectAdmin($output);
			return $output;
		}
		mysql_query("START TRANSACTION");
		$query = "DELETE FROM projusers WHERE proj_id=$projID AND user_id=$otheruserID";
		
		$success = mysql_query($query, $linkID);
		if($success){
			//Remove all of this user's maps from the project and make a new project for them.
			
			$query = "INSERT INTO projects (user_id, title, password, is_hostile) VALUES
										($otheruserID, 'Automatically created project', NULL, 1)";
			$status = mysql_query($query, $linkID);
			$newID = getLastInsert($linkID);
			if(!$status){
				mysql_query("ROLLBACK");
				rolledBack($output);
				return $output;
			}
			
			$uquery = "UPDATE maps SET proj_id=$newID WHERE user_id=$otheruserID AND proj_id=$projID";
			$status = mysql_query($uquery, $linkID);
			if(!$status){
				mysql_query("ROLLBACK");
				rolledBack($output);
				return $output;
			}
			$otheruser=$output->addChild("user");
			$otheruser->addAttribute("ID", $otheruserID);
			$otheruser->addAttribute("removed", true);
			mysql_query("COMMIT");
			return $output;
		}else{
			$otheruser=$output->addChild("user");
			$otheruser->addAttribute("ID", $otheruserID);
			$otheruser->addAttribute("removed", false);
			updateFailed($output, $query);
			mysql_query("ROLLBACK");
			rolledBack($output);
			return $output;
		}		
		return $output;
	}

	function modifyUser($otheruserID, $projID, $userID, $level, $pass_hash, $output){
		$output->addAttribute("ID", $projID);
		global $dbName, $version;
		header("Content-type: text/xml");
		$xmlstr = "<?xml version='1.0'?>\n<project version='$version'></project>";
		$output = new SimpleXMLElement($xmlstr);
		$linkID= establishLink();
		if(!$linkID){
			badDBLink($output);
			return $output;
		}
		$status=mysql_select_db($dbName, $linkID);
		if(!$status){
			 databaseNotFound($output);
			 return $output;
		}
		if(!checkLogin($userID, $pass_hash, $linkID)){
			incorrectLogin($output);
			return $output;
		}
		//Basic boilerplate is done.
		if(!checkForAdmin($projID, $userID, $linkID)){
			notProjectAdmin($output);
			return $output;
		}
		$query = "UPDATE projusers SET user_level=$level WHERE proj_id=$projID AND user_id=$otheruserID";
		
		$success = mysql_query($query, $linkID);
		if($success){
			$otheruser=$output->addChild("user");
			$otheruser->addAttribute("ID", $otheruserID);
			$otheruser->addAttribute("modified", true);
			return $output;
		}else{
			$otheruser=$output->addChild("user");
			$otheruser->addAttribute("ID", $otheruserID);
			$otheruser->addAttribute("modified", false);
			updateFailed($output, $query);
			return $output;
		}		
		return $output;
	}
	
	$userID = mysql_real_escape_string($_REQUEST['uid']);
	$pass_hash = mysql_real_escape_string($_REQUEST['pass_hash']);
	$projID = mysql_real_escape_string($_REQUEST['projID']);
	$otheruserID =  mysql_real_escape_string($_REQUEST['otheruserID']);
	$level = mysql_real_escape_string($_REQUEST['level']);
	$action = $_REQUEST['action'];
	
	header("Content-type: text/xml");
	$xmlstr = "<?xml version='1.0'?>\n<project version='$version'></project>";
	$output = new SimpleXMLElement($xmlstr);

	if($action=="add"){
		$output=addUser($otheruserID, $projID, $userID, $level, $pass_hash, $output);
	}else if($action=="remove"){
		$output=removeUser($otheruserID, $projID, $userID, $pass_hash, $output);
	}else if($action=="modify"){
		$output=modifyUser($otheruserID, $projID, $userID, $level, $pass_hash, $output);
	}else{
		meaninglessQueryVariables($output, "The 'action' variable must be set to either add or remove.");
	}
	print $output->asXML();
	
?>