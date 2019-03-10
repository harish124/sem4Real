--******************************************************************
set echo on
set colsep " || "
set linesize 256
set pagesize 3000
set trimout on
set wrap on
-- 1:
create or replace view blue_flavor as
	select p.pid,p.food,p.price from products p where p.flavour='Blueberry';

-- :Before dml cmds...
-- : products table below:
select * from products where pid='pp-9999';
-- : blue_flavor view below:

select * from blue_flavor;

--dml cmds. below:

savepoint a;
insert into blue_flavor values('pp-9999','Veg.Puff',15.0);
select * from products where pid='pp-9999';

update blue_flavor set food='Paruppu Vada' where pid='51-BLU';
select * from products where pid='51-BLU';

insert into products(pid,food,flavour) values('pp-dummy','Samosa','Blueberry');
-- After inserting dummy row
select * from products where pid='pp-dummy';
select * from blue_flavor where pid='pp-dummy';

delete from blue_flavor where pid='pp-dummy';
--: Dummy row deleted below:
select * from products where pid='pp-dummy';
select * from blue_flavor where pid='pp-dummy';

rollback to a;
--******************************************************************
-- 2:

create or replace view cheap_food as
	select pid,flavour,food,price from products
	where price<1.0
	with check option;

-- :Before dml cmds...
-- : products table below:
select * from products where pid='pp-9999';
-- : cheap_food view below:
select * from cheap_food;

--:dml cmds. below:
savepoint b;

insert into cheap_food values('pp-9999','Tart','Veg.Puff',15.0);
select * from products where pid='pp-9999';

update cheap_food set food='Paruppu Vada' where pid='70-W';
select * from products where pid='70-W';

insert into products(pid,food,price) values('pp-dummy','Samosa',.36);
--: After inserting dummy row
select * from products where pid='pp-dummy';
select * from cheap_food where pid='pp-dummy';

delete from cheap_food where pid='pp-dummy';
--: Dummy row deleted below:
select * from products where pid='pp-dummy';
select * from cheap_food where pid='pp-dummy';

rollback to b;
--******************************************************************
-- 3:
set echo on
create or replace view hot_food as	
	select p.pid pid,count(i.item) count from products p,item_list i
	where p.pid=i.item
	group by i.receipt,p.pid
	having count(i.item)>1;

-- :Before dml cmds...
-- : hot_food view below:
select * from hot_food;

--:dml cmds. below:
savepoint q3;

insert into hot_food values('pp-9999',5);
select p.pid,count(i.item) from products p,item_list i
	where p.pid=i.item
	and p.pid='pp-9999'
  group by p.pid;
  
update hot_food set count=5 where pid='70-R';
select * from products where pid='70-R';

insert into products(pid,food,price) values('pp-dummy','Samosa',.36);

INSERT INTO Receipts(rno) VALUES
  (
      9999
  );
INSERT INTO item_list(receipt,item) VALUES
  (
      9999,'pp-dummy'
  );
INSERT INTO item_list(receipt,item) VALUES
  (
      9999,'pp-dummy'
  );
--inserting two times  because view has been created for more than two orders

--: After inserting dummy row
select * from products where pid='pp-dummy';
select * from hot_food where pid='pp-dummy';

delete from hot_food where pid='pp-dummy';
--: Dummy row not deleted below:
select * from products where pid='pp-dummy';
select * from hot_food where pid='pp-dummy';

--:################# So dml operations are not legal on this view #####################
rollback to q3;


--******************************************************************************************
-- 4:

create or replace view pie_food as	
	select c.lname,p.flavour,r.rno,r.dateofPurchase,i.ordinal
	from customers c,products p,Receipts r,item_list i
	where r.rno=i.receipt and
	r.cid=c.cid and
	i.item = p.pid
	and p.food='Pie' ; 
	--and rownum<=10;



-- :Before dml cmds...

-- : pie_food view below:
select * from pie_food;

--:dml cmds. below:
savepoint q4;
insert into pie_food values('shakthimaan','strawberry',9999,sysdate,3);
select c.lname,p.flavour,r.rno,r.dateofPurchase,i.ordinal
	from customers c,products p,Receipts r,item_list i
	where r.rno=i.receipt and
	r.cid=c.cid and
	i.item = p.pid	
	and c.lname='shaktimaan'
	and r.rno=9999;

update pie_food set lname='Balaji' where lname='ARNN';
select * from products where lname='Balaji';

--using existing cid below
insert into Receipts(rno,dateofPurchase,cid) values(9999,sysdate-5,5);
insert into products(pid,flavour,food) values ('pp-dummy','APPY','Pie');
insert into item_list(receipt,ordinal,item) values(9999,3,'pp-dummy');
--: After inserting dummy row
select * from pie_food where rno=9999;

delete from pie_food where rno=9999;
--: Dummy row deleted below:
select * from item_list where item='pp-dummy';
select * from pie_food where rno=9999;

--:################# So only deletion is legal on this view #####################
rollback to q4;

--*********************************************************************************************
-- 5:
create or replace view cheap_view as
	select pid,flavour,food from cheap_food;

-- :Before dml cmds...

-- : pie_food view below:
select * from cheap_view;

--:dml cmds. below:
savepoint q5;
insert into cheap_view values('pp-dummy','strawberry','Pav Bhaji');
select * from cheap_food;

update cheap_view set flavour='ORange' where pid='70-W';
select * from products where flavour='ORange';

insert into products values('pp-dummy','strawberry','Paruppu Vada',.36);
--: After inserting dummy row
select * from cheap_view where pid='pp-dummy';

delete from cheap_view where pid='pp-dummy';
--: Dummy row deleted below:
select * from products where pid='pp-dummy';
select * from cheap_view where pid='pp-dummy';

--:################# Updation & Deletion are legal in this view #####################
rollback to q5;
--*********************************************************************************************
-- 6:

drop sequence ordinal_no_seq;
create sequence ordinal_no_seq
	start with 1
	increment by 1
	minvalue 1
	maxvalue 10
	cycle 
	cache 4
	order;

---- : before dml item_list
select * from item_list where receipt = 124000;

--: dml below
savepoint q6;
insert into products(pid) values('pp-dummy');
insert into Receipts values(124000,sysdate,5);

--: inserting into item_list below:

insert into item_list values(124000,ordinal_no_seq.nextval,'pp-dummy');
insert into item_list values(124000,ordinal_no_seq.nextval,'pp-dummy');
insert into item_list values(124000,ordinal_no_seq.nextval,'pp-dummy');

--: displaying item_list below:
select * from item_list where receipt=124000;

rollback to q6;

--************************************************************************************************
-- 7:

drop synonym prod_details;
create synonym prod_details for item_list;

--: sample usage || before dml operations

select * from prod_details where ordinal=3 and rownum <=10;

-- : before dml

--: dml operations below:

savepoint q7;
insert into products(pid) values('pp-dummy');
insert into Receipts values(124000,sysdate,5);

--: inserting into prod_details below:

insert into prod_details values(124000,20,'pp-dummy');
insert into prod_details values(124000,24,'pp-dummy');
insert into prod_details values(124000,12,'pp-dummy');

--: displaying prod_details below:
select * from prod_details where receipt=124000;

--: displaying base table below:
select * from item_list where item='pp-dummy';


rollback to q7;
--****************************************************************************************