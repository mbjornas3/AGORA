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
	List of variables for insertion:
	* HTTP Query variables:
		uid: User ID of the user viewing the map
		pass_hash: the hashed password of the user viewing the map
		map: map ID of the map	
	*/
	
	require 'configure.php';
	require 'errorcodes.php';
	require 'establish_link.php';
	require 'utilfuncs.php';
	
	function lastviewed($userID, $pass_hash, $mapID){
		global $dbName, $version;
		header("Content-type: text/xml");	
		$outputstr = "<?xml version='1.0' ?>\n<AGORA version='$version' />";
		$output = new SimpleXMLElement($outputstr);
		$linkID= establishLink();
		if(!$linkID){
			badDBLink($output);
			return $output;
		}
		$status = mysql_select_db($dbName, $linkID);
		if(!$status){
			databaseNotFound($output);
			return $output;
		}
		if(!checkLogin($userID, $pass_hash, $linkID)){
			incorrectLogin($output);
			return $output;
		}
		
		//There are two cases: One where the user has already viewed the map (UPDATE)
		//and one where the user has not (INSERT)
		//Thankfully, "ON DUPLICATE KEY UPDATE" exists :D
		
		$query = "INSERT INTO lastviewed(user_id, map_id, lv_date)
					VALUES ($userID, $mapID, NOW()) ON DUPLICATE KEY UPDATE lv_date=NOW()";
		$resultID = mysql_query($query, $linkID); 
		if(!$resultID){
			insertFailed($output, $query);
			return $output;
		}else{
			$viewed=$output->addChild("viewed");
			$viewed->addAttribute("user", $userID);
			$viewed->addAttribute("map", $mapID);
		}
		
		return $output;
	}
	
	$userID = mysql_real_escape_string($_REQUEST['uid']);
	$pass_hash = mysql_real_escape_string($_REQUEST['pass_hash']);
	$mapID = $_REQUEST['map'];
	$output = lastviewed($userID, $pass_hash, $mapID);
	print($output->asXML());
?>