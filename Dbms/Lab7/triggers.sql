--1
cl scr
create or replace trigger insTrigger
	before insert on products
	for each row

declare
	x_food products.food%type :=:new.food;
	x_flavour products.flavour%type :=:new.flavour;

	x_qty number(2);

	myException	  exception;

begin
		

	select count(*) into x_qty from products
	where food=x_food and flavour= x_flavour;

	dbms_output.put_line('Food = '||:new.food||' flavour = '||:new.flavour||' Qty: '||x_qty);
	if(x_qty=1) then
		raise myException;
	end if;
	
exception

	when  myException then
		raise_application_error(-20600,'Given combination of food and flavour already exists'||chr(10)||'So the row was not inserted');
	when others then
		dbms_output.put_line('');
end;
/

show errors
insert into products values('pp-dummy','Apple','Tart',30.5);
delete from products where pid='pp-dummy';