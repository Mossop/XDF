<?php

	function getDateElement($timestamp)
	{
		$date = new XmlElement;
		$date->setType("Date");
		$today=getdate($timestamp);
		$date->setAttribute("day",$today['mday']);
		$date->setAttribute("month",$today['month']);
		$date->setAttribute("year",$today['year']);
		$date->setAttribute("hour",$today['hours']);
		$date->setAttribute("minute",$today['minutes']);
		$date->setAttribute("second",$today['seconds']);
		return $date;
	}
	
	function getGroupElement($id,$depth)
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
					$date=getDateElement(from_mysql_date($info[$loop]));
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
					$xml->addElement(getLoginElement($subid['user'],$depth-1));
				}
			}
			
			return $xml;
		}
		else
		{
			return false;
		}
	}
	
	function getLoginElement($id,$depth)
	{
		global $persontbl,$logintbl,$usergrptbl;
		
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
					$date=getDateElement(from_mysql_date($info[$loop]));
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
					$xml->addElement(getPersonElement($info[$loop],0));
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
					$xml->addElement(getGroupElement($subid['group_id'],$depth-1));
				}
			}
			
			return $xml;
		}
		else
		{
			return false;
		}
	}

	function getPersonElement($id,$depth)
	{
		global $persontbl,$logintbl;
		
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
					$date=getDateElement(from_mysql_date($info[$loop]));
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
					$xml->addElement(getLoginElement($subid['id'],$depth-1));
				}
			}
			
			return $xml;
		}
		else
		{
			return false;
		}
	}
	
	function getFileElement($id)
	{
		global $filetbl;
		
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
					$date=getDateElement(from_mysql_date($info[$loop]));
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
	
	function getMessageElement($id,$depth)
	{
		global $msgtbl,$filetbl;
		
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
					$date=getDateElement(from_mysql_date($info[$loop]));
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
					$xml->addElement(getFileElement($subid['id']));
				}
			}
			
			return $xml;
		}
		else
		{
			return false;
		}
	}
	
	function getThreadElement($id,$depth)
	{
		global $threadtbl,$msgtbl;
		
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
					$date=getDateElement(from_mysql_date($info[$loop]));
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
					$xml->addElement(getMessageElement($subid['id'],$depth-1));
				}	
			}	
			
			return $xml;
		}
		else
		{
			return false;
		}
	}
	
	function getFolderElement($id,$depth,$folderdepth)
	{
		global $foldertbl,$threadtbl;
		
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
					$date=getDateElement(from_mysql_date($info[$loop]));
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
					$xml->addElement(getFolderElement($subid['id'],$depth,$folderdepth-1));
				}
			}
			
			if ($depth!=0)
			{
				db_lock(array($threadtbl => 'READ'));
				$query=db_query("SELECT id FROM $threadtbl WHERE folder=$id;");
				db_unlock();
				while ($subid=mysql_fetch_array($query))
				{
					$xml->addElement(getThreadElement($subid['id'],$depth-1));
				}
			}
		
			return $xml;
		}
		else
		{
			return false;
		}
	}
	
	function build_folder_hierarchy($folder)
	{
		global $foldertbl,$boardinfo;
		
		$id=$folder->getAttribute("id");
		$current=&$folder;
		while ($id!=$boardinfo['rootfolder'])
		{
			db_lock(array($foldertbl => 'READ'));
			$query=db_query("SELECT parent FROM $foldertbl WHERE id=$id;");
			db_unlock();
			$info=mysql_fetch_array($query);
			$parent=getFolderElement($info['parent'],0,0);
			$parent->addElement($current);
			$current=&$parent;
			$id=$info['parent'];
		}
		return $current;
	}
	
	function process_view_command($number,$command)
	{
		global $displays,$foldertbl,$threadtbl,$msgtbl,$filetbl,$persontbl,$logintbl,$grouptbl;
		
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
			if (isset($command['id']))
			{
				if ($command['class']=="person")
				{
					if ($person=getPersonElement($command['id'],$command['depth']))
					{
						$list = new XmlElement;
						$list->setType("People");
						$xml->addElement($list);
						$list->addElement($person);
					}
				}
				else if ($command['class']=="login")
				{
					if ($login=getLoginElement($command['id'],$command['depth']))
					{
						$list = new XmlElement;
						$list->setType("LoginInfo");
						$xml->addElement($list);
						$list->addElement($login);
					}
				}
				else if ($command['class']=="group")
				{
					if ($group=getGroupElement($command['id'],$command['depth']))
					{
						$list = new XmlElement;
						$list->setType("LoginInfo");
						$xml->addElement($list);
						$list->addElement($group);
					}
				}
				else if ($command['class']=="folder")
				{
					if ($folder=getFolderElement($command['id'],$command['depth'],$command['folderdepth']))
					{
						$xml->addElement(build_folder_hierarchy($folder));
					}
				}
				else if ($command['class']=="thread")
				{
					if ($thread=getThreadElement($command['id'],$command['depth']))
					{
						db_lock(array($threadtbl => 'READ'));
						$query=db_query("select folder from $threadtbl WHERE $threadtbl.id=".$command['id'].";");
						$info=mysql_fetch_array($query);
						db_unlock();
	
						$folder=getFolderElement($info['folder'],0,0);
	
						$folder->addElement($thread);
	
						$xml->addElement(build_folder_hierarchy($folder));
					}
				}
				else if ($command['class']=="message")
				{
					if ($message=getMessageElement($command['id'],$command['depth']))
					{
						db_lock(array($threadtbl => 'READ', $msgtbl => 'READ'));
						$query=db_query("select folder, $threadtbl.id as thread ".
							"from $threadtbl,$msgtbl WHERE ".
							"$msgtbl.thread=$threadtbl.id AND $msgtbl.id=".$command['id'].";");
						$info=mysql_fetch_array($query);
						db_unlock();
	
						$thread=getThreadElement($info['thread'],0);
						$folder=getFolderElement($info['folder'],0,0);
	
						$folder->addElement($thread);
						$thread->addElement($message);
	
						$xml->addElement(build_folder_hierarchy($folder));
					}
				}
				else if ($command['class']=="file")
				{
					if ($file=getFileElement($command['id']))
					{
						db_lock(array($threadtbl => 'READ', $msgtbl => 'READ', $filetbl => 'READ'));
						$query=db_query("select folder,$threadtbl.id as thread,$msgtbl.id as message ".
							"from $threadtbl,$msgtbl,$filetbl WHERE ".
							"$msgtbl.thread=$threadtbl.id AND $filetbl.message=$msgtbl.id AND $filetbl.id=".$command['id'].";");
						$info=mysql_fetch_array($query);
						db_unlock();
	
						$message=getMessageElement($info['message'],0);
						$thread=getThreadElement($info['thread'],0);
						$folder=getFolderElement($info['folder'],0,0);
	
						$folder->addElement($thread);
						$thread->addElement($message);
						$message->addElement($file);
	
						$xml->addElement(build_folder_hierarchy($folder));
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
					$people->addElement(getPersonElement($info['id'],$command['depth']));
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
					$users->addElement(getLoginElement($info['id'],$command['depth']));
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
					$users->addElement(getGroupElement($info['id'],$command['depth']));
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
