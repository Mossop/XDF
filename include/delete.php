<?php

	# Deletes a message and all files associated with it.
	function delete_message($message)
	{
		db_lock(array($msgtbl => 'WRITE', $unreadtbl => 'WRITE', $filetbl => 'WRITE'));
		global $msgtbl,$filetbl,$unreadtbl;
		do_query("DELETE FROM $unreadtbl WHERE message=$message;");
		do_query("DELETE FROM $msgtbl WHERE id=$message;");
		$query=do_query("SELECT name FROM $filetbl WHERE message=$message;");
		while ($msg=mysql_fetch_array($query))
		{
			unlink("files/".$msg['name']);
		}
		do_query("DELETE FROM $filetbl WHERE message=$message;");
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
		$query=mysql_query("SELECT id FROM $foldertbl WHERE parent=$folder;",$connection);
		db_unlock();
		while ($sub=mysql_fetch_row($query))
		{
			delete_folder($sub[0]);
		}
	}
	
	function process_delete_command($number,$command)
	{
		return true;
	}
	
?>
