set echo on
set wrap on
set trimout on
set linesize 256
set pagesize 3000
set colsep " | "
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

-- insert values into table
@E:\B.Harish\Sem 4\Dbms\Lab 3\bakery
/

--3,7 not working
--8 - used views

--1: Display the food details that is not purchased by any of customers.
select * from products
where pid not in
(select item from item_list);

--********************************************************************
--2:Show the customer details who 
--had placed more than 2 orders on the same date

select * from customers where cid in 
		(select cid from Receipts group by dateOfPurchase,cid
			having count(rno)>2);
--********************************************************************

--3:Display the products details that has been 
--ordered maximum by the customers. (use ALL)

select item,count(item) from item_list
	where receipt in 
	(select rno from Receipts)
	group by item order by count(item) desc;

--********************************************************************

--4:Show the number of receipts that contain 
--the product whose price is more than the
--average price of its food type.

select count(unique receipt) from item_list where item in
	(select p.pid from products p where p.price >
		(select avg(price) from products q where p.food =q.food
	 	group by q.food));
--********************************************************************

--5:Display the customer details along with receipt number and 
--date for the receipts that are dated on the last day of the receipt month.

select c.cid,c.lname,c.fname,r.rno,r.dateOfPurchase from
customers c,receipts r where
c.cid=r.cid and dateOfPurchase=last_day(dateOfPurchase);

--********************************************************************
--6:Display the receipt number(s) and its total price for the 
--receipt(s) that contain Twist as one among five items. Include 
--only the receipts with total price more than $25.

select i.receipt,sum(price) TotalPrice from item_list i ,products p
    where i.item=p.pid and i.receipt in
    (select receipt from item_list,products where item=pid and food='Twist')
    group by i.receipt having sum(price)>25;
--********************************************************************
--7:Display the details (customer details, receipt number, item)
--for the product that was purchased by the least number of customers.

select c.*,r.rno from customers c,Receipts r,item_list i
where c.cid=r.cid and r.rno=i.receipt
and i.item in	(select item from item_list 	group by item order by count(item)
	where rownum=1)
		
;--and rownum=1;

--********************************************************************
--8:Display the customer details along with the receipt 
--number who ordered all the
--flavors of Meringue in the same receipt.

create or replace view Lab3_q8 as
select i.receipt, p.flavour,p.food,p.pid from
   products p,item_list i
   where p.pid=i.item and p.food='Meringue';

create or replace view Lab3_q8_1 as
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
--********************************************************************
--9:Display the product details of both Pie and Bear Claw.
select * from products
    where food in ('Pie','Bear Claw');
--********************************************************************
--10:Display the customers details who haven't placed any orders.
insert into customers values(21,'John','David');

select c.* from customers c
	where c.cid in	
	(select cid from customers minus
		select cid from Receipts);
--********************************************************************
--11:Display the food that has the same flavor as that
-- of the common flavor between the Meringue and Tart.
select food from products
where flavour in 
(select flavour from products where food='Meringue'
	intersect
	select flavour from products where food = 'Tart');

--********************************************************************
