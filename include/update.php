<?php

	function process_update_command($number,$command)
	{
		global $unreadtbl,$logintbl,$board,$userinfo,$editedtbl;
		
		if ((isset($command['class']))&&(isset($command['id']))&&(can_edit($command['class'],$command['id'])))
		{
			if (($command['class']!="file")&&($table=get_table_for_class($command['class'])))
			{
				db_lock(array($table => 'WRITE'));
				$result = db_query("SELECT * FROM $table;");
				$rows = mysql_num_fields($result);
				$sql="UPDATE $table SET ";
				$doupdate=false;
				for ($count = 0; $count < $rows; $count++)
				{
					$name=mysql_field_name($result, $count);
					if (($name!="id")&&($name!="command")&&($name!="class")&&(isset($command[$name])))
					{
						$value=$command[$name];
						$doupdate=true;
						$sql=$sql.$name."=";
						$type=mysql_field_type($result, $count);
						if (($type=="string")||($type=="blob"))
						{
							$sql=$sql."'".$value."',";
						}
						else
						{
							if (($type=="int")&&($value=="lastid"))
							{
								$value=db_last_id();
							}
							$sql=$sql.$value.",";
						}
					}
				}
				$sql=substr($sql,0,-1);
				$sql=$sql." WHERE id=".$command['id'].";";
				if ($doupdate)
				{
					if (db_query($sql))
					{
						db_unlock();
						if (($command['class']=="message")&&(mysql_affected_rows()>0))
						{
							db_lock(array($unreadtbl => 'WRITE',$logintbl => 'READ', $editedtbl => 'WRITE'));
							db_query("INSERT INTO $editedtbl (message,person,altered) VALUES "
								."(".$command['id'].",".$userinfo['id'].",NOW());");
							db_query("INSERT INTO $unreadtbl (person,message) "
								."SELECT DISTINCT person,".$command['id']." FROM "
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
