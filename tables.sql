DROP TABLE IF EXISTS Board;
DROP TABLE IF EXISTS Login;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS UserGroup;
DROP TABLE IF EXISTS Folder;
DROP TABLE IF EXISTS Thread;
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS File;
DROP TABLE IF EXISTS UnreadMessage;
DROP TABLE IF EXISTS EditedMessage;

CREATE TABLE Board (
	id		VARCHAR(8) NOT NULL,
	rootfolder	INTEGER NOT NULL,
	timeout		INTEGER,
	PRIMARY KEY (id)
);

CREATE TABLE Login (
	id		VARCHAR(15) NOT NULL,
	password	CHAR(16),
	board		VARCHAR(8) NOT NULL,
	lastaccess	DATETIME,
	person		INTEGER NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Person (
	id		INTEGER AUTO_INCREMENT NOT NULL,
	fullname	VARCHAR(30),
	email		VARCHAR(30),
	nickname	VARCHAR(20),
	phone		VARCHAR(20),
	PRIMARY KEY (id)
);

CREATE TABLE Groups (
	id		VARCHAR(20) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE UserGroup (
	user		VARCHAR(15) NOT NULL,
	group_id	VARCHAR(20) NOT NULL,
	PRIMARY KEY (user, group_id)
);

CREATE TABLE Folder (
	id		INTEGER AUTO_INCREMENT NOT NULL,
	parent		INTEGER,
	name		VARCHAR(50),
	PRIMARY KEY (id)
);

CREATE TABLE Thread (
	id		INTEGER AUTO_INCREMENT NOT NULL,
	folder		INTEGER,
	name		VARCHAR(40),
	created		DATETIME,
	owner		INTEGER,
	PRIMARY KEY (id)
);

CREATE TABLE Message (
	id		INTEGER AUTO_INCREMENT NOT NULL,
	thread		INTEGER,
	author		INTEGER,
	created		DATETIME,
	content		TEXT,
	PRIMARY KEY (id)
);

CREATE TABLE File (
	id		INTEGER AUTO_INCREMENT NOT NULL,
	name		VARCHAR(30) NOT NULL,
	filename	VARCHAR(30),
	message		INTEGER,
	description	VARCHAR(30),
	mimetype	VARCHAR(30),
	PRIMARY KEY (id)
);

CREATE TABLE UnreadMessage (
	message		INTEGER NOT NULL,
	person		VARCHAR(15) NOT NULL,
	PRIMARY KEY (message, person)
);

CREATE TABLE EditedMessage (
	message		INTEGER NOT NULL,
	person		INTEGER NOT NULL,
	altered		DATETIME NOT NULL,
	PRIMARY KEY (message, person, altered)
);
