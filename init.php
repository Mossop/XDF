<?php

	# Initialisation for the board. This must be changed for each board
	# implemented.
	
	function db_setup()
	{
		$connection=mysql_pconnect("localhost","xdf","xdf379");
		mysql_select_db("xdf",$connection);
		return $connection;
	}
	
	# The following set variables to the names of the tables in the database.
	# Change these to use different table names.
	
	$boardtbl="Board";
	$logintbl="Login";
	$persontbl="Person";
	$grouptbl="Groups";
	$foldertbl="Folder";
	$threadtbl="Thread";
	$msgtbl="Message";
	$filetbl="File";
	$usergrptbl="UserGroup";
	$unreadtbl="UnreadMessage";
	$editedtbl="EditedMessage";
	$sessiontbl="Session";

	$board="wswym";			# Hard code board if necessary
?>
