create table emp(eno varchar(25) constraint eno_pk primary key,
	name varchar(25),
	dob date,
	pin_code number(20),
	city varchar(25)
);


desc emp;

create table customers(cno varchar(25) constraint cno_pk primary key,
	name varchar(25),
	streetName varchar(25),
	pin_code number(20),
	city varchar(25),
	dob date,
	phoneNo number(10)
);

desc customers;

create table parts(partNo varchar(25) constraint partNo_pk primary key,
	name varchar(25),
	price number,
	qty number
);

desc parts;

create table orders(ordNo varchar(25) constraint ordNo_pk primary key,
	qty number,
	rcd date,
	shd date
);

desc orders;

//Query 2
alter table emp add constraint eno_ck check(eno like 'e%');
alter table customers add constraint cno_ck check(cno like 'c%');
alter table parts add constraint partNo_ck check(partNo like 'p%');
alter table orders add constraint ordNo_ck check(ordNo like 'o%');

//Query 3
alter table customers add constraint phoneNo_un unique(phoneNo);

//Query 4
alter table parts add constraint qty_ck check(qty>0);

//Query 5
alter table orders add constraint rcd_shd_ck check(rcd < shd);

//Query 6
alter table parts modify price number not null;

//Query 7
alter table parts add reorderLvl number(10);
alter table emp add hierdate date;

//Query 8
alter table customers modify name varchar(50);

//Query 9
alter table customers drop(dob);

//Query 10
alter table orders modify rcd date not null;