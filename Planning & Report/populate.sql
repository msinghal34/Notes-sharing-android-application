delete from favourites;
delete from likes;
delete from history;
delete from file_tags;
delete from tags; 
delete from institutes; 
delete from subj_disc; 
delete from users;
delete from files;


insert into users values('aniarpu','Anirudh','anirudh.arputham@gmail.com','1');
insert into users values('sriram','SriramB','bee.sriram1998@gmail.com','1');
insert into users values('mayank','Mayank','mayanksinghal308@gmail.com','1');
insert into users values('ashutosh','Ashutosh','ashutosh1598@gmail.com','1');

insert into institutes values('IIT Bombay');
insert into institutes values('IIT Madras');
insert into institutes values('IIT Delhi');
insert into institutes values('IIT Kanpur');
insert into institutes values('IIT Kharagpur');
insert into institutes values('IIT Roorkee');
insert into institutes values('IIT Guwahati');
insert into institutes values('Stanford University');
insert into institutes values('Harvard University');
insert into institutes values('UC Los Angeles');
insert into institutes values('UC Berkley');
insert into institutes values('UC San Diego');
insert into institutes values('UC Santa Barbara');
insert into institutes values('UC Santa Cruz');
insert into institutes values('UC Irvine');
insert into institutes values('MIT');
insert into institutes values('Caltech');
insert into institutes values('ETH Zurich');
insert into institutes values('University of Pennsylvania');
insert into institutes values('New York University');
insert into institutes values('Cornell University');


insert into tags values('Computer Science');
insert into tags values('Data Science');
insert into tags values('Software Development');
insert into tags values('Mobile and Web Development');
insert into tags values('Algorithms');
insert into tags values('Computer Systems');
insert into tags values('Theoretical Computer Science');
insert into tags values('Electrical Engineering');
insert into tags values('Mechanical Engineering');
insert into tags values('Physics');
insert into tags values('Mathematics');
insert into tags values('Chemistry');
insert into tags values('Chemical Engineering');
insert into tags values('Engineering Physics');
insert into tags values('Biology');
insert into tags values('Civil Engineering');
insert into tags values('Aerospace Engineering');
insert into tags values('Statistics');
insert into tags values('Humanities and Social Science');
insert into tags values('Energy Science and Engineering');
insert into tags values('Economics');
insert into tags values('Philosophy');
insert into tags values('Literature');
insert into tags values('Psychology');


insert into subj_disc values('CS101','Introduction to CS','Computer Science');
insert into subj_disc values('CS251','Data Analysis and Visulization','Computer Science');
insert into subj_disc values('CS152','Abstractions and Paradigms of Programming','Computer Science');
insert into subj_disc values('CS317','DBIS','Computer Science');
insert into subj_disc values('PH107','Quantum Mechanics','Physics');
insert into subj_disc values('MA105','Calculus','Mathematics');
insert into subj_disc values('CH107','Physical Chemistry','Chemistry');
insert into subj_disc values('HS101','Economics','Humanities and Social Science');
insert into subj_disc values('BB101','Biology','Biology');
insert into subj_disc values('MA106','Linear Algebra','Mathematics');
