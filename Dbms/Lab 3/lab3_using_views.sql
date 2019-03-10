drop table item_list;
drop table receipts;
drop table customers;
drop table products;
drop view Lab3_Query3;
drop view Lab3_q4;
drop view Lab3_q6;
drop view Lab3_q7;
drop view Lab3_q8;
drop view Lab3_q8_1;
drop view Lab3_q11;

rem Queries 2,4,10 are wrong/not working


create table customers
	(cid number(10),
		lname varchar(25),
		fname varchar(25),
		constraint cid_pk primary key(cid));
desc customers;
create table products
	(pid varchar(25),
		flavour varchar(25),
		food varchar(25),
		price number(10,2),
		constraint pid_pk primary key(pid));
desc products;

create table receipts
	(rno number(10) primary key,
		dateOfPurchase date,
		cid number(10),
		constraint cid_fk foreign key(cid) references customers(cid));
desc receipts;	

create table item_list
	(receipt number(10),
		ordinal number(10),
		item varchar(25),
		constraint item_fk foreign key(item) references products(pid),
		constraint receipt_fk foreign key(receipt) references receipts(rno));
desc item_list;	

rem 1
select * from products
where pid not in
(select item from item_list);

rem 2
select * from customers where cid in 
		(select cid from Receipts group by dateOfPurchase,cid
			having count(rno)>2);


rem 3
rem : Without using all keyword
create view Lab3_Query3 as
    select count(item) "Count",item from item_list group by item order by count(item) desc;
select * from products where pid=
    (select item from Lab3_Query3 where rownum=1);

rem 4
select count(unique receipt) from item_list where item in
	(select p.pid from products p where p.price >
		(select avg(price) from products q where p.food =q.food
	 	group by q.food));

/*
rem method 2
create view Lab3_q4 as
	select food,avg(price) from products group by food;

select unique receipt from item_list where item in
		(select p.pid from products p
		where p.food in
				(select c.food from Lab3_q4 c where p.food=c.food and p.price > c."Price"));


*/

rem 5:
select c.cid,c.lname,c.fname,r.rno,r.dateOfPurchase from
customers c,receipts r where
c.cid=r.cid and dateOfPurchase=last_day(dateOfPurchase);

/*rem using subquery below:
select * from customers where cid in (select cid from Receipts
    where (extract(day from dateofpurchase))=extract(day from last_day(dateofpurchase)));*/

rem 6

create view Lab3_q6 as
 select i.receipt,sum(price) TotalPrice from item_list i ,products p
    where i.item=p.pid
    group by i.receipt having sum(price)>25;
    
select * from Lab3_q6 where receipt in
    (select receipt from item_list,products where item=pid and food='Twist');

rem 7:

create view Lab3_q7 as
	select * from Lab3_Query3 order by "Count";

select c.*,r.rno from customers c,Receipts r,item_list i
where c.cid=r.cid and r.rno=i.receipt
and item = 
		(select item from Lab3_q7 where rownum = 1);


rem 8:

create view Lab3_q8 as
select i.receipt, p.flavour,p.food,p.pid from
   products p,item_list i
   where p.pid=i.item and p.food='Meringue';

create view Lab3_q8_1 as
	select r1.Receipt Receipt_1 ,r1.flavour flavour_1,r2.Receipt Receipt_2,r2.flavour flavour_2 from
	Lab3_q8 r1,Lab3_q8 r2			
	where r1.Receipt=r2.Receipt
	and r1.flavour <> r2.flavour;

select c.*,r.rno from customers c,Receipts r
where c.cid=r.cid and
c.cid in
	(select cid from Receipts where rno in
		(select Receipt_1 from Lab3_q8_1)
		and r.rno in
		(select Receipt_1 from Lab3_q8_1));

rem 9:

select * from products
    where food in ('Pie','Bear Claw');	

rem 10:

insert into customers values(21,'John','David');

select c.* from customers c
	where c.cid in	
	(select cid from customers minus
		select cid from Receipts);

rem 11:

rem You can also use intersect for this case

create view Lab3_q11 as
select m.flavour from products m,products t
where m.food='Meringue' and t.food='Tart'
and m.flavour=t.flavour;

select food from products
    where flavour in
    (select flavour from Lab3_q11);    



