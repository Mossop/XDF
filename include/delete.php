<?php

	function delete_file($id)
	{
	}
	
	function delete_person($id)
	{
	}
	
	function delete_login($id)
	{
	}
	
	# Deletes a message and all files associated with it.
	function delete_message($message)
	{
		global $msgtbl,$unreadtbl,$filetbl;
		
		db_lock(array($msgtbl => 'WRITE', $unreadtbl => 'WRITE', $filetbl => 'WRITE'));
		db_query("DELETE FROM $unreadtbl WHERE message=$message;");
		db_query("DELETE FROM $msgtbl WHERE id=$message;");
		$query=db_query("SELECT name FROM $filetbl WHERE message=$message;");
		while ($msg=mysql_fetch_array($query))
		{
			unlink("files/".$msg['name']);
		}
		db_query("DELETE FROM $filetbl WHERE message=$message;");
		db_unlock();
	}
	
	# Deletes a thread and all messages associated with it.
	function delete_thread($thread)
	{
		global $threadtbl,$msgtbl;

		db_lock(array($threadtbl => 'WRITE', $msgtbl => 'READ'));
		db_query("DELETE FROM $threadtbl WHERE id=$thread;");
		$query=db_query("SELECT id FROM $msgtbl WHERE thread=$thread;");
		db_unlock();
		while ($msg=mysql_fetch_array($query))
		{
			delete_message($msg['id']);
		}
	}
	
	# Deletes a folder and all threads and messages associated with it.
	function delete_folder($folder)
	{
		global $foldertbl,$threadtbl;

		db_lock(array($foldertbl => 'WRITE', $threadtbl => 'READ'));
		db_query("DELETE FROM $foldertbl WHERE id=$folder;");
		$query=db_query("SELECT id FROM $threadtbl WHERE folder=$folder;");
		db_unlock();
		while ($thread=mysql_fetch_row($query))
		{
			delete_thread($thread[0]);
		}
		db_lock(array($foldertbl => 'READ'));
		$query=db_query("SELECT id FROM $foldertbl WHERE parent=$folder;");
		db_unlock();
		while ($sub=mysql_fetch_row($query))
		{
			delete_folder($sub[0]);
		}
	}
	
	function process_delete_command($number,$command)
	{
		if ((isset($command['class']))&&(isset($command['id']))&&(can_edit($command['class'],$command['id'])))
		{
			if ($command['class']=='folder')
			{
				delete_folder($command['id']);
			}
			else if ($command['class']=='message')
			{
				delete_message($command['id']);
			}
			else if ($command['class']=='thread')
			{
				delete_thread($command['id']);
			}
			else if ($command['class']=='file')
			{
				delete_file($command['id']);
			}
			else if ($command['class']=='person')
			{
				delete_person($command['id']);
			}
			else if ($command['class']=='login')
			{
				delete_login($command['id']);
			}
			else
			{
				return false;
			}
			return true;
		}
		else
		{
			return false;
		}
	}
	
?>
