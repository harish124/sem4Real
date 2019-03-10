******************************************************************
rem 1:
create or replace view blue_flavor as
	select p.pid,p.food,p.price from products p where p.flavour='Blueberry';

rem :Before dml cmds...
rem : products table below:
select * from products where pid='pp-9999';
rem : blue_flavor view below:
select * from blue_flavor;

rem:dml cmds. below:

savepoint a;
insert into blue_flavor values('pp-9999','Veg.Puff',15.0);
select * from products where pid='pp-9999';

update blue_flavor set food='Paruppu Vada' where pid='51-BLU';
select * from products where pid='51-BLU';

insert into products(pid,food,flavour) values('pp-dummy','Samosa','Blueberry');
rem: After inserting dummy row
select * from products where pid='pp-dummy';
select * from blue_flavor where pid='pp-dummy';

delete from blue_flavor where pid='pp-dummy';
rem: Dummy row deleted below:
select * from products where pid='pp-dummy';
select * from blue_flavor where pid='pp-dummy';

rollback to a;
******************************************************************
rem 2:

create or replace view cheap_food as
	select pid,flavour,food,price from products
	where price<1.0
	with check option;

rem :Before dml cmds...
rem : products table below:
select * from products where pid='pp-9999';
rem : cheap_food view below:
select * from cheap_food;

rem:dml cmds. below:
savepoint b;

insert into cheap_food values('pp-9999','Tart','Veg.Puff',15.0);
select * from products where pid='pp-9999';

update cheap_food set food='Paruppu Vada' where pid='70-W';
select * from products where pid='70-W';

insert into products(pid,food,price) values('pp-dummy','Samosa',.36);
rem: After inserting dummy row
select * from products where pid='pp-dummy';
select * from cheap_food where pid='pp-dummy';

delete from cheap_food where pid='pp-dummy';
rem: Dummy row deleted below:
select * from products where pid='pp-dummy';
select * from cheap_food where pid='pp-dummy';

rollback to b;
******************************************************************
rem 3:
create or replace view hot_food as
	/*select i.receipt receipt,p.pid pid,count(i.item) count from products p,item_list i*/
	select p.pid pid,count(i.item) count from products p,item_list i
	where p.pid=i.item
	group by i.receipt,p.pid
	having count(i.item)>1
	with check option;

rem :Before dml cmds...
rem : products,item table below:
select p.pid,count(i.item) from products p ,item_list i where p.pid='pp-9999' and p.pid=i.item group by p.pid;
rem : hot_food view below:
select * from hot_food;

rem:dml cmds. below:
savepoint c;
insert into hot_food values('pp-9999',5);
select p.pid,count(i.item) from products p ,item_list i where p.pid='pp-9999' and p.pid=i.item group by p.pid;

update hot_food set count=5 where pid='70-R';
select * from products where pid='70-R';

insert into products(pid,food,price) values('pp-dummy','Samosa',.36);
rem: After inserting dummy row
select * from products where pid='pp-dummy';
select * from hot_food where pid='pp-dummy';

delete from hot_food where pid='pp-dummy';
rem: Dummy row deleted below:
select * from products where pid='pp-dummy';
select * from hot_food where pid='pp-dummy';

rem:################# So dml operations are not legal on this view #####################
rollback to c;


******************************************************************************************
rem 6:
drop sequence ordinal_no_seq;
create sequence ordinal_no_seq
	start with 1
	increment by 1
	minvalue 1
	maxvalue 10
	cycle 
	cache 4
	order;

rem : before dml
select * from customers where cid=9999;
select * from products where pid='pp-dummy';
select * from Receipts where rno=124000;

rem : Note : if there is no receipt with a rno=124000 obviously there will not be an item in item_list with that rno;

rem: dml below
savepoint q6;
insert into customers values(9999,'Sherlock','Harish');
insert into products(pid) values('pp-dummy');
insert into Receipts values(124000,sysdate,9999);

rem: After inserting into customers,Receipts,products:
select * from customers where cid=9999;
select pid from products where pid='pp-dummy';
select * from Receipts where rno=124000;

rem: inserting into item_list below:

insert into item_list values(124000,ordinal_no_seq.nextval,'pp-dummy');
insert into item_list values(124000,ordinal_no_seq.nextval,'pp-dummy');
insert into item_list values(124000,ordinal_no_seq.nextval,'pp-dummy');

rem: displaying item_list below:
select * from item_list where receipt=124000;

rollback to q6;

************************************************************************************************
rem 7:

drop synonym prod_details;
create synonym prod_details for item_list;

rem: sample usage || before dml operations

select * from prod_details where ordinal=3 and rownum <=10;

rem : before dml
select * from customers where cid=9999;
select * from products where pid='pp-dummy';
select * from Receipts where rno=124000;

rem : Note : if there is no receipt with a rno=124000 obviously there will not be an item in item_list with that rno;

rem: dml operations below:

savepoint q7;
insert into customers values(9999,'Sherlock','Harish');
insert into products(pid) values('pp-dummy');
insert into Receipts values(124000,sysdate,9999);

rem: After inserting into customers,Receipts,products:
select * from customers where cid=9999;
select pid from products where pid='pp-dummy';
select * from Receipts where rno=124000;

rem: inserting into prod_details below:

insert into prod_details values(124000,20,'pp-dummy');
insert into prod_details values(124000,24,'pp-dummy');
insert into prod_details values(124000,12,'pp-dummy');

rem: displaying prod_details below:
select * from prod_details where receipt=124000;


rollback to q7;
****************************************************************************************