<?php

	# This is the main php file of the board system. Almost all the
	# intelligent code is included here, and this is the only page that
	# is ever called by the web server. Its main tasks are to handle the
	# logging in and out of the board and creating the functions needed
	# by the display pages.

	$locks=0;
	$queries=0;
	$querylog=fopen("queries.log","w");
	$lastid=0;

	# Sends the header to the browser.
  function send_http_header()
  {
		# Convince browsers not to cache the page.
		header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
		header("Last-Modified: ".gmdate("D, d m y H:i:s")." GMT");
		header("Cache-Control: no-cache, must-revalidate");
		header("Pragma: no-cache");
  }
	
	function openSession()
	{
		session_start();
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

	function unsetSessionVariable($name)
	{
		unset($_SESSION[$name]);
	}
	
	function closeSession()
	{
		$_SESSION=array();
		session_destroy();
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
	
	# Asks if the current user is in the specified group.
	function is_in_group($group, $user="")
	{
		global $usergrptbl,$loginid;
		if (strlen($user)==0)
		{
			$user=$loginid;
		}
		db_lock(array($usergrptbl => 'READ'));
		$query=db_query("SELECT user_id FROM $usergrptbl WHERE user=\"$user\" AND (group_id=\"$group\" OR group_id=\"admin\");");
		db_unlock();
		if (mysql_num_rows($query)>0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	function can_view($class, $id="")
	{
		global $usergrptbl,$loginid,$userinfo,$msgtbl,$filetbl,$logintbl,$persontbl;
		
		$realclass=$class;
		if (($class=="thread")||($class=="file"))
		{
			$realclass=$class;
			$class="message";
		}
		
		db_lock(array($usergrptbl => 'READ'));
		$query=db_query("SELECT user FROM $usergrptbl WHERE user=\"$loginid\" AND ".
			"(group_id=\"admin\" OR group_id=\"".$class."admin\" OR group_id=\"".$class."view\");");
		db_unlock();
		if (mysql_num_rows($query)>0)
		{
			return true;
		}
		else if (strlen($id)>0)
		{
			if (($realclass=="thread")||($realclass=="message"))
			{
				$table=get_table_for_class($realclass);
				db_lock(array($table => 'READ'));
				$query=db_query("SELECT owner FROM $table WHERE id=$id AND owner=".$userinfo['id'].";");
				db_unlock();
				return (mysql_num_rows($query)>0);
			}
			else if ($realclass=="file")
			{
				db_lock(array($msgtbl => 'READ', $filetbl => 'READ'));
				$query=db_query("SELECT owner FROM $msgtbl,$filetbl WHERE $filetbl.id=$id AND ".
					"message=$msgtbl.id AND owner=".$userinfo['id'].";");
				db_unlock();
				return (mysql_num_rows($query)>0);
			}
			else if ($class=="login")
			{
				if ($loginid==$id)
				{
					return true;
				}
				else
				{
					db_lock(array($logintbl => 'READ'));
					$query=db_query("SELECT id FROM $logintbl WHERE id='$id' AND person=".$userinfo['id'].";");
					db_unlock();
					return (mysql_num_rows($query)>0);
				}
			}
			else if ($class=="person")
			{
				return ($id==$userinfo['id']);
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	
	function can_add($class)
	{
		global $usergrptbl,$loginid;

		$realclass=$class;
		if (($class=="thread")||($class=="file"))
		{
			$realclass=$class;
			$class="message";
		}
		
		db_lock(array($usergrptbl => 'READ'));
		$query=db_query("SELECT user FROM $usergrptbl WHERE user=\"$loginid\" AND ".
			"(group_id=\"admin\" OR group_id=\"".$class."add\");");
		db_unlock();
		return (mysql_num_rows($query)>0);
	}
	
	function can_edit($class,$id="")
	{
		global $usergrptbl,$loginid,$userinfo,$msgtbl,$filetbl,$logintbl,$persontbl;

		$realclass=$class;
		if (($class=="thread")||($class=="file"))
		{
			$realclass=$class;
			$class="message";
		}
		
		db_lock(array($usergrptbl => 'READ'));
		$query=db_query("SELECT user FROM $usergrptbl WHERE user=\"$loginid\" AND ".
			"(group_id=\"admin\" OR group_id=\"".$class."admin\");");
		db_unlock();
		if (mysql_num_rows($query)>0)
		{
			return true;
		}
		else if (strlen($id)>0)
		{
			if (($realclass=="thread")||($realclass=="message"))
			{
				$table=get_table_for_class($realclass);
				db_lock(array($table => 'READ'));
				$query=db_query("SELECT owner FROM $table WHERE id=$id AND owner=".$userinfo['id'].";");
				db_unlock();
				return (mysql_num_rows($query)>0);
			}
			else if ($realclass=="file")
			{
				db_lock(array($msgtbl => 'READ', $filetbl => 'READ'));
				$query=db_query("SELECT owner FROM $msgtbl,$filetbl WHERE $filetbl.id=$id AND ".
					"message=$msgtbl.id AND owner=".$userinfo['id'].";");
				db_unlock();
				return (mysql_num_rows($query)>0);
			}
			else if ($class=="login")
			{
				if ($loginid==$id)
				{
					return true;
				}
				else
				{
					db_lock(array($logintbl => 'READ'));
					$query=db_query("SELECT id FROM $logintbl WHERE id=$id AND person=".$userinfo['id'].";");
					db_unlock();
					return (mysql_num_rows($query)>0);
				}
			}
			else if ($class=="person")
			{
				return ($id==$userinfo['id']);
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	
	function get_table_for_class($class)
	{
		global $boardtbl,$foldertbl,$threadtbl,$msgtbl,$filetbl,$logintbl,$persontbl;
		
		if ($class=="board")
		{
			return $boardtbl;
		}
		else if ($class=="folder")
		{
			return $foldertbl;
		}
		else if ($class=="thread")
		{
			return $threadtbl;
		}
		else if ($class=="message")
		{
			return $msgtbl;
		}
		else if ($class=="file")
		{
			return $filetbl;
		}
		else if ($class=="login")
		{
			return $logintbl;
		}
		else if ($class=="person")
		{
			return $persontbl;
		}
		else
		{
			return false;
		}
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
				db_lock(array($logintbl => 'READ'));
				$query=db_query("SELECT id FROM $logintbl WHERE id=\"$username\" AND password=PASSWORD(\"$password\") AND board=\"$board\";");
				db_unlock();
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
	
	function db_lock($tables)
	{
		global $locks;
		
		$sql="";
		$locks++;
		if ($locks>1)
		{
			print ("Warning, re-locking database<br>\n");
		}
		while (list($table,$lock)=each($tables))
		{
			$sql=$sql."$table $lock,";
		}
		$sql=substr($sql,0,-1);
		db_query("LOCK TABLES $sql;");
	}
	
	function db_unlock()
	{
		global $locks;
		
		db_query("UNLOCK TABLES;");
		$locks--;
		if ($locks<0)
		{
			print ("Warning, unlocked too many times<br>\n");
		}
	}
	
	function db_last_id()
	{
		global $lastid;
		
		return $lastid;
	}
	
	function db_query($sql)
	{
		global $connection,$locks,$queries,$querylog,$lastid;
		
		if ($locks<=0)
		{
			print ("Warning, querying without first locking - $sql<br>\n");
		}
		#print ($sql."<br>\n");
		fwrite($querylog,$sql."\n");
		$query=mysql_query($sql,$connection);
		$queries++;
		if ($query==null)
		{
			print ("Error runnng query $sql<br>");
			print (mysql_error()."<br>");
			return false;
		}
		$check=mysql_insert_id($connection);
		if ($check!=0)
		{
			$lastid=$check;
		}
		return $query;
	}
	
	function expire_sessions()
	{
	}
	
	function get_board_info()
	{
		global $boardtbl,$foldertbl,$board;
		
		db_lock(array($boardtbl => 'READ',$foldertbl => 'READ'));
		$query=db_query("SELECT $boardtbl.id,name,rootfolder,defaulttheme FROM ".
			"$boardtbl,$foldertbl WHERE $boardtbl.id=\"$board\" AND rootfolder=$foldertbl.id;");
		db_unlock();
	
		if ($boardinfo=mysql_fetch_array($query))
		{
			return $boardinfo;
		}
		else
		{
			return null;
		}
	}
	
	function error($message)
	{
	}
	
	# Include the main functions.
	require "include/view.php";
	require "include/add.php";
	require "include/update.php";
	require "include/delete.php";
	require "include/xml.php";
	
	function process_command($number,$command)
	{
		if (!isset($command['command']))
		{
			return false;
		}
		else if ($command['command']=="view")
		{
			return process_view_command($number,$command);
		}
		else if ($command['command']=="add")
		{
			return process_add_command($number,$command);
		}
		else if ($command['command']=="update")
		{
			return process_update_command($number,$command);
		}
		else if ($command['command']=="delete")
		{
			return process_delete_command($number,$command);
		}
		else if ($command['command']=="logout")
		{
			closeSession();
			return false;
		}
		else
		{
			return false;
		}
	}
	
	$start=time();
	
	# Load the board information
  include "init.php";

	openSession();
	
	send_http_header();

	if (isSessionVariable('board'))
	{
		$board=getSessionVariable('board','');
	}
	
	if (isset($board))
	{
		# Opens a db connection, then fetches the board information.
		
		$connection=db_setup();
		
		$boardinfo=get_board_info();
		
		if ($boardinfo!=null)
		{	
			expire_sessions();
			$init=time();
	
			$loginid=check_login();
			
			if ($loginid!=null)
			{
				# Update the users last access.
				db_lock(array($logintbl => 'WRITE',$persontbl => 'READ'));
				db_query("UPDATE $logintbl SET lastaccess=NOW() WHERE id=\"$loginid\" AND board=\"$board\";");
				$query=db_query("SELECT $persontbl.* FROM $persontbl,$logintbl WHERE $logintbl.person=$persontbl.id AND $logintbl.id=\"$loginid\" AND $logintbl.board=\"$board\";");
				$userinfo=mysql_fetch_array($query);
				db_unlock();
				
				$login=time();
				$max=-1;
				if ($_SERVER['REQUEST_METHOD']=='GET')
				{
					$http_vars=&$_GET;
				}
				else if ($_SERVER['REQUEST_METHOD']=='POST')
				{
					$http_vars=&$_POST;
				}
				else
				{
					$http_vars=array();
				}
				
				if (isset($http_vars['command']))
				{
					if (($http_vars['command']=="downloadfile")&&(isset($file)))
					{
						db_lock(array($filetbl => 'READ'));
						$query=db_query("SELECT * FROM $filetbl WHERE id=$file;");
						if ($fileinfo=mysql_fetch_array($query))
						{
							Header("Content-type: ".$fileinfo['mimetype']);
							Header("Content-Disposition: attachment; filename=\"".$fileinfo['name']."\"");
							$fn=fopen("files/".$fileinfo['name'],"r");
							fpassthru($fn);
						}
						else
						{
							error("Failed trying to download that file");
						}
						db_unlock();
					}
				}
				else
				{
					$othercommands=array();
					while (list($key,$val)=each($http_vars))
					{
						if (ereg("([_a-zA-Z]+)([0-9]+)",$key,$regs))
						{
							if (isset($command[$regs[2]]))
							{
								$thiscommand=&$command[$regs[2]];
								$thiscommand[$regs[1]]=$val;
							}
							else
							{
								$command[$regs[2]]=array($regs[1] => $val);
							}
							if ($max<$regs[2])
							{
								$max=$regs[2];
							}
						}
						else
						{
							$othercommands[$key]=$val;
						}
					}
					$parse=time();
					
					$xml = new XmlDoc;
					$root=&$xml->getRootElement();
					$root->setAttributes($othercommands);
					$root->setType("DisplaySet");
					$root->setAttribute("board",$boardinfo['id']);
					$userelement=&getLoginElement($loginid,1);
					$boardelement = new XmlElement;
					$boardelement->setType("Board");
					$boardelement->setAttribute("id",$boardinfo['id']);
					$boardelement->setAttribute("name",$boardinfo['name']);
					$boardelement->setAttribute("rootfolder",$boardinfo['rootfolder']);
					$root->addElement($boardelement);
					$root->addElement($userelement);
					$info = new XmlElement;
					$info->setType("Info");
					$info->setAttribute("queries",$queries);
					$info->setAttribute("locks",$locks);
					$root->addElement($info);
					$displays=0;
					
					$loop=0;
					$continue=true;
					while (($loop<=$max)&&($continue))
					{
						if (isset($command[$loop]))
						{
							if ($continue=&process_command($loop,$command[$loop]))
							{
								$root->addElement($continue);
							}
						}
						$loop++;
					}
					
					$execute=time();
					
					if ($continue)
					{
						header("Content-Type: text/html");
						
						if (isset($othercommands['stylesheet']))
						{
							$stylesheet=$othercommands['stylesheet'];
						}
						else
						{
							$stylesheet="default";
						}
						db_lock(array($logintbl => 'READ'));
						$query=db_query("SELECT theme FROM $logintbl WHERE id='$loginid';");
						$gettheme=mysql_fetch_array($query);
						db_unlock();
						if ($gettheme['theme']==null)
						{
							$stylesheet=$boardinfo['defaulttheme'].'/'.$stylesheet;
						}
						else
						{
							$stylesheet=$gettheme['theme'].'/'.$stylesheet;
						}
						$xh=xslt_create();
						print(xslt_process($xh,'arg:/_xml','themes/'.$stylesheet.'.xsl',NULL,array('/_xml' => $xml->toString())));
						xslt_free($xh);

						$style=time();
						
						$info->setAttribute("style",($style-$execute)."ms");
						$info->setAttribute("execute",($execute-$parse)."ms");
						$info->setAttribute("parse",($parse-$login)."ms");
						$info->setAttribute("login",($login-$init)."ms");
						$info->setAttribute("init",($init-$start)."ms");
						$info->setAttribute("total",($style-$start)."ms");
						
						$fp=fopen("output.xml","w");
						fwrite($fp,$xml->toString());
						fclose($fp);
						
						#print($xml->toString());
					}
					else
					{
						print ("Failed");
					}
				}
			}
			else
			{
				print ("Eeek an intruder!");
			}
			#db_unlock();
		}
		else
		{
			# Couldn't get the board details. Something is screwed.
			header("Location: badsetup.php");
		}
	}
	else
	{
		# Board wasn't specified
		header("Location: badsetup.php");
	}
	fclose($querylog);

?>