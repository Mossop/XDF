<?php

	function &getDateElement($timestamp)
	{
		$date = new XmlElement;
		$date->setType("Date");
		$today=getdate($timestamp);
		$date->setAttribute("hour",$today['hours']);
		$date->setAttribute("hour12",date("g",$timestamp));
		$date->setAttribute("minute",$today['minutes']);
		$date->setAttribute("second",$today['seconds']);
		$date->setAttribute("day",$today['mday']);
		$date->setAttribute("wday",$today['weekday']);
		$date->setAttribute("wd",date("D",$timestamp));
		$date->setAttribute("suffix",date("S",$timestamp));
		$date->setAttribute("month",$today['mon']);
		$date->setAttribute("longmonth",$today['month']);
		$date->setAttribute("mon",date("M",$timestamp));
		$date->setAttribute("year",$today['year']);
		return $date;
	}
	
	function &getGroupElement($id,$depth)
	{
		global $grouptbl,$usergrptbl;
		
		$table=$grouptbl;
		
		$xml = new XmlElement;
		$xml->setType("Group");
		
		db_lock(array($table => 'READ'));
		$query=db_query("SELECT * FROM $table WHERE id=\"$id\";");
		db_unlock();
		if ($info=mysql_fetch_array($query))
		{	
			$fields=mysql_num_fields($query);
			for ($loop=0; $loop<$fields; $loop++)
			{
				$name=mysql_field_name($query,$loop);
				$type=mysql_field_type($query,$loop);
				if ($type=="datetime")
				{
					$date=&getDateElement(from_mysql_date($info[$loop]));
					$date->setAttribute("name",$name);
					$xml->addElement($date);
				}
				else if ($type=="blob")
				{
					$text = new XmlElement;
					$text->setType("Text");
					$text->setAttribute("name",$name);
					$text->setContent($info[$loop]);
					$xml->addElement($text);
				}
				else
				{
					$xml->setAttribute($name,$info[$loop]);
				}
			}
					
			if ($depth!=0)
			{
				db_lock(array($usergrptbl => 'READ'));
				$query=db_query("SELECT user FROM $usergrptbl WHERE group_id=\"$id\";");
				db_unlock();
				while ($subid=mysql_fetch_array($query))
				{
					$login=&getLoginElement($subid['user'],$depth-1);
					$xml->addElement($login);
				}
			}
			
			return $xml;
		}
		else
		{
			return false;
		}
	}
	
	function &getLoginElement($id,$depth)
	{
		global $persontbl,$logintbl,$usergrptbl;
		
		if (can_view("login",$id))
		{
			$table=$logintbl;
			
			$xml = new XmlElement;
			$xml->setType("Login");
			
			db_lock(array($table => 'READ'));
			$query=db_query("SELECT * FROM $table WHERE id=\"$id\";");
			db_unlock();
			if ($info=mysql_fetch_array($query))
			{
				$fields=mysql_num_fields($query);
				for ($loop=0; $loop<$fields; $loop++)
				{
					$name=mysql_field_name($query,$loop);
					$type=mysql_field_type($query,$loop);
					if ($type=="datetime")
					{
						$date=&getDateElement(from_mysql_date($info[$loop]));
						$date->setAttribute("name",$name);
						$xml->addElement($date);
					}
					else if ($type=="blob")
					{
						$text = new XmlElement;
						$text->setType("Text");
						$text->setAttribute("name",$name);
						$text->setContent($info[$loop]);
						$xml->addElement($text);
					}
					else if ($name=="person")
					{
						$person=&getPersonElement($info[$loop],0);
						$xml->addElement($person);
					}
					else if (($name!="password")&&($name!="board"))
					{
						$xml->setAttribute($name,$info[$loop]);
					}
				}
					
				if ($depth!=0)
				{
					db_lock(array($usergrptbl => 'READ'));
					$query=db_query("SELECT group_id FROM $usergrptbl WHERE user=\"$id\";");
					db_unlock();
					while ($subid=mysql_fetch_array($query))
					{
						$group=&getGroupElement($subid['group_id'],$depth-1);
						$xml->addElement($group);
					}
				}
				
				return $xml;
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

	function &getPersonElement($id,$depth)
	{
		global $persontbl,$logintbl;
		
		if (can_view("person",$id))
		{
			$table=$persontbl;
				
			$xml = new XmlElement;
			$xml->setType("Person");
		
			db_lock(array($table => 'READ'));
			$query=db_query("SELECT * FROM $table WHERE id=$id;");
			db_unlock();
			if ($info=mysql_fetch_array($query))
			{
				$fields=mysql_num_fields($query);
				for ($loop=0; $loop<$fields; $loop++)
				{
					$name=mysql_field_name($query,$loop);
					$type=mysql_field_type($query,$loop);
					if ($type=="datetime")
					{
						$date=&getDateElement(from_mysql_date($info[$loop]));
						$date->setAttribute("name",$name);
						$xml->addElement($date);
					}
					else if ($type=="blob")
					{
						$text = new XmlElement;
						$text->setType("Text");
						$text->setAttribute("name",$name);
						$text->setContent($info[$loop]);
						$xml->addElement($text);
					}	
					else
					{
						$xml->setAttribute($name,$info[$loop]);
					}
				}
						
				if ($depth!=0)
				{
					db_lock(array($logintbl => 'READ'));
					$query=db_query("SELECT id FROM $logintbl WHERE person=$id;");
					db_unlock();
					while ($subid=mysql_fetch_array($query))
					{
						$login=&getLoginElement($subid['id'],$depth-1);
						$xml->addElement($login);
					}
				}
				
				return $xml;
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
	
	function &getFileElement($id)
	{
		global $filetbl;
		
		if (can_view("file"))
		{
			$table=$filetbl;
			
			$xml = new XmlElement;
			$xml->setType("File");
			
			db_lock(array($table => 'READ'));
			$query=db_query("SELECT * FROM $table WHERE id=$id;");
			db_unlock();
			if ($info=mysql_fetch_array($query))
			{
				$fields=mysql_num_fields($query);
				for ($loop=0; $loop<$fields; $loop++)
				{
					$name=mysql_field_name($query,$loop);
					$type=mysql_field_type($query,$loop);
					if ($type=="datetime")
					{	
						$date=&getDateElement(from_mysql_date($info[$loop]));
						$date->setAttribute("name",$name);
						$xml->addElement($date);
					}
					else if ($type=="blob")
					{
						$text = new XmlElement;
						$text->setType("Text");
						$text->setAttribute("name",$name);
						$text->setContent($info[$loop]);
						$xml->addElement($text);
					}
					else if ($name=="owner")
					{
						$owner=&getPersonElement($info[$loop],0);
						$xml->addElement($owner);
					}
					else if ($name!="message")
					{
						$xml->setAttribute($name,$info[$loop]);
					}
				}
						
				return $xml;
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
	
	function &getMessageElement($id,$depth)
	{
		global $msgtbl,$filetbl;
		
		if (can_view("message"))
		{
			$table=$msgtbl;
			
			$xml = new XmlElement;
			$xml->setType("Message");
			
			db_lock(array($table => 'READ'));
			$query=db_query("SELECT * FROM $table WHERE id=$id;");
			db_unlock();
			if ($info=mysql_fetch_array($query))
			{	
				$fields=mysql_num_fields($query);
				for ($loop=0; $loop<$fields; $loop++)
				{
					$name=mysql_field_name($query,$loop);
					$type=mysql_field_type($query,$loop);
					if ($type=="datetime")
					{
						$date=&getDateElement(from_mysql_date($info[$loop]));
						$date->setAttribute("name",$name);
						$xml->addElement($date);
					}
					else if ($type=="blob")
					{
						$text = new XmlElement;
						$text->setType("Text");
						$text->setAttribute("name",$name);
						$text->setContent($info[$loop]);
						$xml->addElement($text);
					}
					else if ($name=="owner")
					{
						$owner=&getPersonElement($info[$loop],0);
						$xml->addElement($owner);
					}
					else if ($name!="thread")
					{
						$xml->setAttribute($name,$info[$loop]);
					}
				}
						
				if ($depth!=0)
				{
					db_lock(array($filetbl => 'READ'));
					$query=db_query("SELECT id FROM $filetbl WHERE message=$id;");
					db_unlock();
					while ($subid=mysql_fetch_array($query))
					{
						$file=&getFileElement($subid['id']);
						$xml->addElement($file);
					}
				}
				
				return $xml;
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
	
	function &getThreadElement($id,$depth)
	{
		global $threadtbl,$msgtbl;
		
		if (can_view("thread"))
		{
			$table=$threadtbl;
			
			$xml = new XmlElement;
			$xml->setType("Thread");
			
			db_lock(array($table => 'READ'));
			$query=db_query("SELECT * FROM $table WHERE id=$id;");
			db_unlock();
			if ($info=mysql_fetch_array($query))
			{
				$fields=mysql_num_fields($query);
				for ($loop=0; $loop<$fields; $loop++)
				{
					$name=mysql_field_name($query,$loop);
					$type=mysql_field_type($query,$loop);
					if ($type=="datetime")
					{
						$date=&getDateElement(from_mysql_date($info[$loop]));
						$date->setAttribute("name",$name);
						$xml->addElement($date);
					}
					else if ($type=="blob")
					{
						$text = new XmlElement;
						$text->setType("Text");
						$text->setAttribute("name",$name);
						$text->setContent($info[$loop]);
						$xml->addElement($text);
					}
					else if ($name=="owner")
					{
						$owner=&getPersonElement($info[$loop],0);
						$xml->addElement($owner);
					}
					else if ($name!="folder")
					{
						$xml->setAttribute($name,$info[$loop]);
					}
				}
						
				if ($depth!=0)
				{
					db_lock(array($msgtbl => 'READ'));
					$query=db_query("SELECT id FROM $msgtbl WHERE thread=$id;");
					db_unlock();
					while ($subid=mysql_fetch_array($query))
					{
						$message=&getMessageElement($subid['id'],$depth-1);
						$xml->addElement($message);
					}	
				}	
				
				return $xml;
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
	
	function &getFolderElement($id,$depth,$folderdepth)
	{
		global $foldertbl,$threadtbl;
		
		if (can_view("folder"))
		{
			$table=$foldertbl;
			
			$xml = new XmlElement;
			$xml->setType("Folder");
			
			db_lock(array($table => 'READ'));
			$query=db_query("SELECT * FROM $table WHERE id=$id;");
			db_unlock();
			if ($info=mysql_fetch_array($query))
			{
				$fields=mysql_num_fields($query);
				for ($loop=0; $loop<$fields; $loop++)
				{
					$name=mysql_field_name($query,$loop);
					$type=mysql_field_type($query,$loop);
					if ($type=="datetime")
					{
						$date=&getDateElement(from_mysql_date($info[$loop]));
						$date->setAttribute("name",$name);
						$xml->addElement($date);
					}
					else if ($type=="blob")
					{
						$text = new XmlElement;
						$text->setType("Text");
						$text->setAttribute("name",$name);
						$text->setContent($info[$loop]);
						$xml->addElement($text);
					}
					else if ($name=="owner")
					{
						$xml->addElement(getPersonElement($info[$loop],0));
					}
					else if ($name!="parent")
					{
						$xml->setAttribute($name,$info[$loop]);
					}
				}
						
				if ($folderdepth!=0)
				{
					db_lock(array($table => 'READ'));
					$query=db_query("SELECT id FROM $table WHERE parent=$id;");
					db_unlock();
					while ($subid=mysql_fetch_array($query))
					{
						$folder=&getFolderElement($subid['id'],$depth,$folderdepth-1);
						$xml->addElement($folder);
					}
				}
				
				if ($depth!=0)
				{
					db_lock(array($threadtbl => 'READ'));
					$query=db_query("SELECT id FROM $threadtbl WHERE folder=$id;");
					db_unlock();
					while ($subid=mysql_fetch_array($query))
					{
						$thread=&getThreadElement($subid['id'],$depth-1);
						$xml->addElement($thread);
					}
				}
			
				return $xml;
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
	
	function &build_folder_hierarchy(&$folder)
	{
		global $foldertbl,$boardinfo;
		
		$id=$folder->getAttribute("id");
		$current=&$folder;
		$done=false;
		
		while (!$done)
		{
			db_lock(array($foldertbl => 'READ'));
			$query=db_query("SELECT parent FROM $foldertbl WHERE id=$id;");
			db_unlock();
			$info=mysql_fetch_array($query);
			if ($parent=&getFolderElement($info['parent'],0,0))
			{
				$parent->addElement($current);
				$current=&$parent;
				$id=$info['parent'];
				if ($id==$boardinfo['rootfolder'])
				{
					$done=true;
				}
			}
			else
			{
				$done=true;
			}
		}
		return $current;
	}
	
	function &process_view_command($number,$command)
	{
		global $boardinfo,$displays,$foldertbl,$threadtbl,$msgtbl,$filetbl,$persontbl,$logintbl,$grouptbl;
		
		if (isset($command['class']))
		{
			$displays++;
			$xml = new XmlElement;
			$xml->setType("Display");
			$xml->setAttribute("id",$displays);
			if (isset($command['name']))
			{
				$xml->setAttribute("name",$command['name']);
			}
			if (!isset($command['depth']))
			{
				$command['depth']=0;
			}
			if ($command['class']=="board")
			{
				$command['class']="folder";
				$command['id']=$boardinfo['rootfolder'];
				$command['folderdepth']=-1;
			}
			if (isset($command['id']))
			{
				if ($command['class']=="person")
				{
					if ($person=&getPersonElement($command['id'],$command['depth']))
					{
						$list = new XmlElement;
						$list->setType("People");
						$xml->addElement($list);
						$list->addElement($person);
					}
				}
				else if ($command['class']=="login")
				{
					if ($login=&getLoginElement($command['id'],$command['depth']))
					{
						$list = new XmlElement;
						$list->setType("LoginInfo");
						$xml->addElement($list);
						$list->addElement($login);
					}
				}
				else if ($command['class']=="group")
				{
					if ($group=&getGroupElement($command['id'],$command['depth']))
					{
						$list = new XmlElement;
						$list->setType("LoginInfo");
						$xml->addElement($list);
						$list->addElement($group);
					}
				}
				else if ($command['class']=="folder")
				{
					if ($folder=&getFolderElement($command['id'],$command['depth'],$command['folderdepth']))
					{
						$list=&build_folder_hierarchy($folder);
						$xml->addElement($list);
					}
				}
				else if ($command['class']=="thread")
				{
					if ($thread=&getThreadElement($command['id'],$command['depth']))
					{
						db_lock(array($threadtbl => 'READ'));
						$query=db_query("select folder from $threadtbl WHERE $threadtbl.id=".$command['id'].";");
						$info=mysql_fetch_array($query);
						db_unlock();
	
						$folder=&getFolderElement($info['folder'],0,0);
	
						$folder->addElement($thread);
	
						$list=&build_folder_hierarchy($folder);
						$xml->addElement($list);
					}
				}
				else if ($command['class']=="message")
				{
					if ($message=&getMessageElement($command['id'],$command['depth']))
					{
						db_lock(array($threadtbl => 'READ', $msgtbl => 'READ'));
						$query=db_query("select folder, $threadtbl.id as thread ".
							"from $threadtbl,$msgtbl WHERE ".
							"$msgtbl.thread=$threadtbl.id AND $msgtbl.id=".$command['id'].";");
						$info=mysql_fetch_array($query);
						db_unlock();
	
						$thread=&getThreadElement($info['thread'],0);
						$folder=&getFolderElement($info['folder'],0,0);
	
						$folder->addElement($thread);
						$thread->addElement($message);
	
						$list=&build_folder_hierarchy($folder);
						$xml->addElement($list);
					}
				}
				else if ($command['class']=="file")
				{
					if ($file=&getFileElement($command['id']))
					{
						db_lock(array($threadtbl => 'READ', $msgtbl => 'READ', $filetbl => 'READ'));
						$query=db_query("select folder,$threadtbl.id as thread,message ".
							"from $threadtbl,$msgtbl,$filetbl WHERE ".
							"$msgtbl.thread=$threadtbl.id AND $filetbl.message=$msgtbl.id AND $filetbl.id=".$command['id'].";");
						$info=mysql_fetch_array($query);
						db_unlock();
	
						$message=&getMessageElement($info['message'],0);
						$thread=&getThreadElement($info['thread'],0);
						$folder=&getFolderElement($info['folder'],0,0);
	
						$folder->addElement($thread);
						$thread->addElement($message);
						$message->addElement($file);
	
						$list=&build_folder_hierarchy($folder);
						$xml->addElement($list);
					}
				}
			}
			else if ($command['class']=="people")
			{
				$people = new XmlElement;
				$people->setType("People");
				db_lock(array($persontbl => 'READ'));
				$query=db_query("SELECT id FROM $persontbl;");
				db_unlock();
				while ($info=mysql_fetch_array($query))
				{
					$person=&getPersonElement($info['id'],$command['depth']);
					$people->addElement($person);
				}
				$xml->addElement($people);
			}
			else if ($command['class']=="users")
			{
				$users = new XmlElement;
				$users->setType("LoginInfo");
				db_lock(array($logintbl => 'READ'));
				$query=db_query("SELECT id FROM $logintbl;");
				db_unlock();
				while ($info=mysql_fetch_array($query))
				{
					$user=&getLoginElement($info['id'],$command['depth']);
					$users->addElement($user);
				}
				$xml->addElement($users);
			}
			else if ($command['class']=="groups")
			{
				$users = new XmlElement;
				$users->setType("LoginInfo");
				db_lock(array($grouptbl => 'READ'));
				$query=db_query("SELECT id FROM $grouptbl;");
				db_unlock();
				while ($info=mysql_fetch_array($query))
				{
					$group=&getGroupElement($info['id'],$command['depth']);
					$users->addElement($group);
				}
				$xml->addElement($users);
			}
			return $xml;
		}
		else
		{
			return false;
		}
	}
	
?>
