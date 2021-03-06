set serveroutput on;
SET ECHO ON
DBMS_OUTPUT.ENABLE(500000);

--1. For the given receipt number, calculate the Discount as follows: 

drop sequence ordinal_no_seq;
create sequence ordinal_no_seq
    start with 1
    increment by 1
    minvalue 1
    maxvalue 10
    cycle 
    cache 4
    order;

CREATE OR REPLACE PROCEDURE discountCalc(x_rno IN receipts.rno%TYPE) AS

  x_date receipts.dateOfPurchase%type :='19-OCT-2007';
        
  CURSOR cursorOne IS
    SELECT  p.food, p.flavour, c.fname, c.lname, p.price
    FROM products p, item_list i, receipts r, customers c
    WHERE p.pid = i.item AND i.receipt = x_rno AND r.dateOfPurchase = x_date
    AND r.rno=i.receipt AND c.cid = r.cid
    GROUP BY p.flavour, p.food, p.price, c.fname, c.lname;

  type discountClass IS RECORD(    
    a_food products.food%type,
    a_flavour products.flavour%type,
    a_fname customers.fname%type,
    a_lname customers.lname%type,
    price products.price%type
  );
  discObj discountClass;
  discount number(2,2);  
  totalVal number := 0;  
  amt number := 0;  

BEGIN 

  SELECT  sum(p.price) into totalVal
      FROM products p, item_list i, receipts r, customers c
      WHERE p.pid = i.item AND i.receipt = x_rno AND r.dateOfPurchase = x_date      
      AND r.rno=i.receipt AND c.cid = r.cid;       
  
  IF (totalVal BETWEEN 10 AND 25 )THEN
        discount := 0.05;
      ELSIF (totalVal BETWEEN 25 AND 50) THEN
        discount := 0.10;
      ELSIF (totalVal > 50) THEN
        discount := 0.20;
      ELSE
        discount := 0;
      END IF;

  OPEN cursorOne;
    LOOP
      FETCH cursorOne into discObj;
      EXIT WHEN cursorOne%NOTFOUND;

      IF ordinal_no_seq.nextval = 1 THEN
        DBMS_OUTPUT.PUT_LINE('*******************************************************************************');
        DBMS_OUTPUT.PUT_LINE('Receipt Number: ' || x_rno || '             Customer Name: ' || discObj.a_fname || ' ' || discObj.a_lname);
        DBMS_OUTPUT.PUT_LINE('Receipt Date: ' || x_date);
        DBMS_OUTPUT.PUT_LINE('*******************************************************************************');
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Sno       Flavour       Food       Price');
      END IF;

        

    DBMS_OUTPUT.PUT_LINE(ordinal_no_seq.nextval/2 || '          ' || discObj.a_flavour || '        ' || discObj.a_food || '         ' ||discObj.price);
    
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total Amount:   $' || totalVal);
    DBMS_OUTPUT.PUT_LINE('Total Discount:   (' || discount*100 || '% )            :$' || discount*totalVal);
    amt:=totalVal - discount*totalVal;
    DBMS_OUTPUT.PUT_LINE('Amount to be paid:   $' || amt);
  CLOSE cursorOne;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Sqlcode:  '||sqlcode||' SqlerrMsg:  '||sqlerrm);
END discountCalc;
/

exec discountCalc(13355);

--######################################################################################################################

--4:Write a stored function to display the customer name who ordered maximum for the
--given food and flavor.

create or replace function Max_Customer
  (x_food products.food%type,
   x_flavour products.flavour%type
  )
  return varchar

  IS

  x_cust_fname customers.fname%type;
  x_cust_lname customers.lname%type;

BEGIN


select * into x_cust_fname,x_cust_lname from
(select c.fname,c.lname from customers c,products p,receipts r,item_list i
where c.cid=r.cid and r.rno=i.receipt and p.pid=i.item 
and p.food =x_food and p.flavour = x_flavour 
group by c.fname,c.lname order by count(i.item) desc) where rownum=1;

DBMS_OUTPUT.PUT_LINE(chr(10)||'Customer Name: '||x_cust_fname||'  '||x_cust_lname);

return concat(concat(x_cust_fname,' '),x_cust_lname);

end Max_Customer;
/

declare
  op varchar(50);
BEGIN

  op:=Max_Customer('&Food','&Flavour');

end;
/