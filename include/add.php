<?php

	function process_add_command($number,$command)
	{
		global $unreadtbl,$logintbl,$board,$userinfo,$editedtbl,$filetbl;
		
		if ((isset($command['class']))&&(can_add($command['class'])))
		{
			if (($command['class']=="file")&&(isset($command['message'])))
			{
				if (is_uploaded_file($_FILES["file$number"]['tmp_name']))
				{
					$newname=$_FILES["file$number"]['name'];
					if (preg_match("/(.*?)\.(.*)/",$newname,$regs))
					{
						$start=$regs[1];
						$end=".".$regs[2];
					}
					else
					{
						$start=$newname;
						$end="";
					}
					$count=0;
					$extra="";
					while (file_exists("files/".$start.$extra.$end))
					{
						$count++;
						$extra="$count";
						while (strlen($extra)<3)
						{
							$extra="0".$extra;
						}
					}
					$fullname=$start.$extra.$end;
					db_lock(array($filetbl => 'WRITE'));
					db_query("INSERT INTO $filetbl (name,message,mimetype,description,filename) "
						."VALUES (\"$fullname\",".$command['message'].",\"".$_FILES["file$number"]['type']."\",\"".$command['description']."\",\"$newname\");");
					move_uploaded_file($_FILES["file$number"]['tmp_name'],"files/".$fullname);
					db_unlock();
					return true;
				}
				else
				{
					return false;
				}
			}
			else if ($table=get_table_for_class($command['class']))
			{
				if (($command['class']=="message")||($command['class']=="thread"))
				{
					$command['created']='NOW()';
					$command['owner']=$userinfo['id'];
				}
				db_lock(array($table => 'WRITE'));
				$result = db_query("SELECT * FROM $table;");
				$rows = mysql_num_fields($result);
				$sql="";
				$doupdate=false;
				$values="";
				for ($count = 0; $count < $rows; $count++)
				{
					$name=mysql_field_name($result, $count);
					if (($name!="command")&&($name!="class")&&(isset($command[$name])))
					{
						$value=$command[$name];
						$doupdate=true;
						$sql=$sql.$name.",";
						$type=mysql_field_type($result, $count);
						if (($type=="string")||($type=="blob"))
						{
							$values=$values."'".$value."',";
						}
						else
						{
							if (($type=="int")&&($value=="lastid"))
							{
								$value=db_last_id();
							}
							$values=$values.$value.",";
						}
					}
				}
				$sql=substr($sql,0,-1);
				$values=substr($values,0,-1);
				$sql="INSERT INTO $table ($sql) VALUES ($values);";
				if ($doupdate)
				{
					if (db_query($sql))
					{
						db_unlock();
						if (($command['class']=="message")&&(mysql_affected_rows()>0))
						{
							if (isset($command['id']))
							{
								$id=$command['id'];
							}
							else
							{
								$id=mysql_insert_id();
							}
							db_lock(array($unreadtbl => 'WRITE',$logintbl => 'READ'));
							db_query("INSERT INTO $unreadtbl (person,message) "
								."SELECT DISTINCT person,$id FROM "
								."$logintbl WHERE board=\"$board\" AND person!=\"".$userinfo['id']."\";");
							db_unlock();
						}
						return true;
					}
					else
					{
						db_unlock();
						return false;
					}
				}
				else
				{
					db_unlock();
					return true;
				}
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
	
?>
