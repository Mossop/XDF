INSERT INTO Board
(id,rootfolder,timeout)
VALUES
('wswym',0,120);

INSERT INTO Login
(id,password,board,person)
VALUES
('dave',PASSWORD('Tequila8791'),'wswym',1),
('mike',PASSWORD('nma640v'),'wswym',3),
('test',PASSWORD('test'),'wswym',2);

INSERT INTO Person
(id,fullname,email,phone,nickname)
VALUES
(1,'Dave Townsend','dtownsend@iee.org','07909962336','Dave'),
(3,'Mike Brownsword','mbrownsword@iee.org','07855805669','Mike'),
(2,'Test User','flibble@iee.org','','Test');

INSERT INTO Groups
(id)
VALUES
('admin'),
('folderadmin'),
('messageadmin'),
('useradmin'),
('contactadmin'),
('boardadmin');

INSERT INTO UserGroup
(user,group_id)
VALUES
('dave','admin');

INSERT INTO Folder
(id,parent,name)
VALUES
(0,       0 ,   "Wales South West Younger Members"),
(10,      8 ,   "Recruitment"),
(9 ,      8 ,   "Involvement"),
(8 ,      0 ,   "Recruitment and Retention"),
(11,      0 ,   "Organising Events"),
(12,      11,   "SPT 2002 (MB,SA)"),
(15,      11,   "Premiums 2002 (MB,SA)"),
(16,      11,   "Lifeskills 2000/2001 (JB,GE,RA,KE)"),
(17,      11,   "Branch Programme 2001/2002 (MB,DT,KE,NP,SA)"),
(18,      11,   "Egg Race"),
(19,      0 ,   "Schools & Education"),
(20,      19,   "Micromouse"),
(21,      19,   "Resources for Education"),
(22,      0 ,   "Disseminate Information"),
(23,      22,   "Webpages"),
(24,      22,   "PRO Stuff"),
(25,      0 ,   "Organise Self"),
(26,      25,   "Manage Money"),
(27,      26,   "Business Plan 2002/2003"),
(28,      25,   "Manage Committee");
