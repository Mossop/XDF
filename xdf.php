<?php

	# This is the main php file of the board system. Almost all the
	# intelligent code is included here, and this is the only page that
	# is ever called by the web server. Its main tasks are to handle the
	# logging in and out of the board and creating the functions needed
	# by the display pages.

	# Sends the header to the browser.
  function send_http_header()
  {
		# Convince browsers not to cache the page.
		header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
		header("Last-Modified: ".gmdate("D, d m y H:i:s")." GMT");
		header("Cache-Control: no-cache, must-revalidate");
		header("Pragma: no-cache");
  }
	
	function isSessionVariable($name)
	{
		return isset($_SESSION[$name]);
	}
	
	function getSessionVariable($name,$default)
	{
		if (isSessionVariable($name))
		{
			return $_SESSION[$name];
		}
		else
		{
			return $default;
		}
	}
	
	function setSessionVariable($name,$value)
	{
		$_SESSION[$name]=$value;
	}

	# Converts a timestamp to a nice display date.
	function to_nice_date($timestamp)
	{
		return date("g:ia D, jS F, Y",$timestamp);
	}
	
	# Coverts a timestamp to something we can pass to mysql.
	function to_mysql_date($timestamp)
	{
		return date("Y-m-d H:i:s",$timestamp);
	}
	
	# Converts a date from mysql to a timestamp.
	function from_mysql_date($datestr)
	{
		if (ereg("([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})",$datestr,$regs))
		{
			return mktime($regs[4],$regs[5],$regs[6],$regs[2],$regs[3],$regs[1]);
		}
		else
		{
			return time();
		}
	}
	
	# Converts a mysql date to a nice date, convenience method.
	function mysql_to_nice($datestr)
	{
		return to_nice_date(from_mysql_date($datestr));
	}
	
	# Check the login credentials and present with login pages if necessary.
	#
	# Returns true if everything is ok to continue.
	function check_login()
	{
		global $logintbl,$username,$password,$board;
		
		if (isSessionVariable('loginid'))
		{
			#print ("Already logged in");
			return getSessionVariable('loginid','');
		}
		else
		{
			if ((isset($username))&&(isset($password)))
			{
				$username=strtolower($username);
				$query=db_query("SELECT id FROM $logintbl WHERE id=\"$username\" AND password=PASSWORD(\"$password\") AND board=\"$board\";");
				if (mysql_num_rows($query)==1)
				{
					#print ("New login");
					setSessionVariable('loginid',$username);
					setSessionVariable('board',$board);
					return $username;
				}
				else
				{
					#print ("Bad username/password");
					return null;
				}
			}
			else
			{
				#print ("No login info");
				return null;
			}
		}
	}
	
	function db_query($sql)
	{
		global $connection;
		
		$query=mysql_query($sql,$connection);
		if ($query==null)
		{
			print ("Error runnng query $sql<br>");
			print (mysql_error()."<br>");
		}
		return $query;
	}
	
	function expire_sessions()
	{
	}
	
	function get_board_info()
	{
		$query=db_query("SELECT $boardtbl.id,timeout,name,rootfolder FROM ".
			"$boardtbl,$foldertbl WHERE $boardtbl.id=\"$board\" AND rootfolder=$foldertbl.id;");
	
		if ($boardinfo=mysql_fetch_array($query))
		{
			return $boardinfo;
		}
		else
		{
			return null;
		}
	}
	
	# Load the board information
  include "init.php";

	session_start();
	
	send_http_header();

	if (isSessionVariable('board'))
	{
		$board=getSessionVariable('board','');
	}
	
	if (isset($board))
	{
		# Opens a db connection, then fetches the board information.
		
		$connection=db_setup();
		
		$boardinfo=get_board_info;
		
		if ($boardinfo!=null)
		{	
			expire_sessions();
	
			$loginid=check_login();
			
			if ($loginid!=null)
			{
				# Update the users last access.
				db_query("UPDATE $logintbl SET lastaccess=NOW() WHERE id=\"$loginid\" AND board=\"$board\";");
				$query=db_query("SELECT $persontbl.* FROM $persontbl,$logintbl WHERE $logintbl.person=$persontbl.id AND $logintbl.id=\"$loginid\" AND $logintbl.board=\"$board\";");
				$userinfo=mysql_fetch_array($query);
				
				print ("Hello ".$userinfo['fullname']);
			}
			else
			{
				print ("Eeek an intruder!");
			}
		}
		else
		{
			# Couldn't get the board details. Something is screwed.
			include "badsetup.php";
		}
	}
	else
	{
		# Board wasn't specified
		include "badsetup.php";
	}

?>
