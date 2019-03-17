set pagesize 3000
set linesize 256
set colsep " | "
set trimout on
set wrap on
set serveroutput on

drop table emp_payroll;
create table emp_payroll
(eid number(4) ,
ename varchar(20),
dob date,
sex char(1),
designation varchar(20),
basic number(8,2),
da number(8,2),
hra number(8,2),
pf number(8,2),
mc number(8,2),
gross number(8,2),
ded number(8,2),
net_pay number(8,2),
constraint  eid_pk primary key(eid)
);

create or replace procedure calc
(x_eid in emp_payroll.eid%type ,
x_basic in emp_payroll.basic%type,
x_name in emp_payroll.ename%type,
x_sex in emp_payroll.ename%type,
x_dob in emp_payroll.ename%type,
x_des in emp_payroll.ename%type,
opt in number
)
as

x_da  emp_payroll.basic%type;
x_hra  emp_payroll.basic%type;
x_pf  emp_payroll.basic%type;
x_mc  emp_payroll.basic%type;
x_gross  emp_payroll.basic%type;
x_ded  emp_payroll.basic%type;
x_net_pay  emp_payroll.basic%type;

begin
  
	x_da:=.6* x_basic;
	x_hra:=.11* x_basic;
	x_pf:=.04* x_basic;
	x_mc:=.03* x_basic;
	x_gross:=x_basic+x_da+x_hra;
	x_ded:=x_pf+x_mc;
	x_net_pay:=x_gross-x_ded;
  
  if(opt=1) then
      insert into emp_payroll values(x_eid,x_name,x_dob,x_sex,x_des,x_basic,x_da,x_hra,x_pf,x_mc,x_gross,x_ded,x_net_pay) ;
  else
      update emp_payroll set ename =x_name,dob =x_dob,sex=x_sex,designation=x_des,basic =x_basic where eid=x_eid;
  end if;
end calc;
/
show errors

exec calc(123,50000,'Har','m','12-apr-2000','student');
select * from emp_payroll;
insert into emp_payroll(eid) values(123);
delete from emp_payroll ;
