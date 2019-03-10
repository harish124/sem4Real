set serveroutput on

--*****************************************************************************
insert into receipts values(99999,sysdate,21);

declare 
  x_rno receipts.rno%type :=84665;      
  --select r.rno from receipts r,item_list i where  r.rno=i.receipt group by r.rno having  count(i.item)>1 ;  use 99994
  --select r.rno from receipts r,item_list i where  r.rno=i.receipt group by r.rno having  count(i.item)=1 ; use 84665
  --select r.rno from receipts r,item_list i where  r.rno=i.receipt group by r.rno having  count(i.item)=0;
  x_qty number(2):=1;
begin
  x_rno:=&Rno;
  
  select (i.item) into x_qty
  from item_list i,receipts r
  where r.rno=i.receipt
  and r.rno=x_rno;
    
Exception
  when no_data_found then
    --dbms_output.put_line(chr(10)||'Error_Code: '||sqlcode||chr(10)||'Msg: '||sqlerrm);
    dbms_output.put_line(chr(10)||'Receipt '||x_rno||' contains no item');
  when too_many_rows then    
    dbms_output.put_line(chr(10)||'Receipt '||x_rno||' contains more than one item');
  when others then  
    dbms_output.put_line(chr(10)||'Receipt '||x_rno||' contains a single item only'||chr(10)||'Qty: '||x_qty);

end;
--*****************************"OPUTPUT BELOW"**********************************
/
/
/
delete from receipts where rno = 99999;
--*****************************************************************************

--2:

--add these line and don't forget to undo the changes after pl/sql block;
alter table receipts add today date default sysdate;
alter table receipts modify dateOfPurchase date add constraint
  ck_date check(dateOfPurchase<=today);
--"Dont forget to execute the stms. below this pl/sql block"  

declare 
  insExcept   Exception;
  pragma exception_init (insExcept,-2290);
  
begin    
  insert into receipts(rno,dateofpurchase) values (99995,sysdate+2);
Exception
  when insExcept then
    dbms_output.put_line(chr(10)||q'!#### You are trying to insert a date that is greater than today's date #####!');
  when others then
    dbms_output.put_line('Error Code: '||sqlcode||chr(10)||'Error Msg: '||sqlerrm);
end;
--*****************************"OPUTPUT BELOW"**********************************
/
--"Dont forget to execute the stms. below"  
alter table receipts drop constraint ck_date;
alter table receipts drop column today;
--*****************************************************************************    