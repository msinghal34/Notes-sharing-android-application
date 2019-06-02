drop table if exists files cascade;
drop table if exists users cascade;
drop table if exists subj_disc cascade;
drop table if exists institutes cascade;
drop table if exists tags cascade;
drop table if exists file_tags cascade;
drop table if exists history cascade;
drop table if exists likes cascade;
drop table if exists favourites cascade;
create table subj_disc
(
    course_id		varchar(8), 
    subject			varchar(50), 
    discipline		varchar(30),
    primary key (subject, discipline)
);
create table institutes
(
    institute			varchar(50),
    primary key (institute)
);
create table users
(
    user_id		varchar(15), 
    name		varchar(50), 
    email_id varchar(50),
    reputation numeric(20,0),
    salt        varchar(20),
    hash        numeric(20,0),
    primary key (user_id)
);
create table files
(
    fid		varchar(15),
    filename		varchar(50),
    year		numeric(4,0),
    uploaded_by varchar(15),
    likes numeric(20,0),
    views numeric(20,0),
    extension varchar(10),
    institute varchar(50),
    discipline varchar(30),
    subject varchar(30),
    primary key (fid),
    foreign key (uploaded_by) references users(user_id)
    on delete set null,
    foreign key (institute) references institutes
    on delete set null,
    foreign key (subject, discipline) references subj_disc
    on delete set null
);

create table tags       
(
    tag			varchar(30),
    primary key (tag)
);
create table file_tags
(
    fid varchar(15),
    tag varchar(30),
    primary key(fid,tag),
    foreign key(fid) references files
    on delete cascade,
    foreign key(tag) references tags
    on delete cascade
);
create table history
(
    user_id varchar(15),
    fid varchar(15),
    time_stamp timestamp,
    primary key(user_id,fid,timestamp),
    foreign key (user_id) references users
    on delete cascade,
    foreign key(fid) references files
    on delete cascade
);
create table likes
(
    user_id		varchar(15),
    fid			varchar(15), 
    primary key (user_id,fid),
    foreign key (user_id) references users
    on delete cascade,
    foreign key (fid) references files
    on delete cascade
);
create table favourites
(
    user_id		varchar(15),
    fid			varchar(15), 
    primary key (user_id,fid),
    foreign key (user_id) references users
    on delete cascade,
    foreign key (fid) references files
    on delete cascade
);