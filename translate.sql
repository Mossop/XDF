insert into xdf.Folder (id,parent,name) select id,parent,name from Folder where board="wswym";
insert into xdf.Folder (parent,name) select -1,name from Board;
update xdf.Folder set parent=LAST_INSERT_ID() where parent=0;

insert into xdf.Board (id,rootfolder,timeout,defaulttheme) select id,LAST_INSERT_ID(),timeout,"wswym" from Board where id="wswym";

insert into xdf.Thread (id,folder,name,owner,created) select id,folder,name,owner,created from Thread where board="wswym";
update xdf.Thread set folder=LAST_INSERT_ID() where folder=0;

insert into xdf.Message (id,thread,owner,created,content) select id,thread,author,created,content from Message;

insert into xdf.Person (id,fullname,email,nickname,mobilephone) select id,fullname,email,nickname,phone from People;
insert into xdf.File (id,name,filename,message,description,mimetype) select id,name,filename,message,description,mimetype from File;
insert into xdf.Login (id,password,board,lastaccess,person) select id,password,board_id,lastaccess,person from User;
insert into xdf.EditedMessage (message,person,altered) select message_id,person,altered from EditedMessage;
insert into xdf.UnreadMessage (message,person) select distinct message_id,person from UnreadMessage,User where user_id=id;

insert into xdf.Groups
(id) values
("admin"),
("personadd"),
("folderadd"),
("messageadd"),
("loginadd"),
("personadmin"),
("folderadmin"),
("messageadmin"),
("loginadmin"),
("personview"),
("folderview"),
("messageview"),
("loginview");

insert into xdf.UserGroup (user,group_id) values ('dave','admin');

insert into xdf.Theme
(id,name) values
('wswym','Snazzy theme');
