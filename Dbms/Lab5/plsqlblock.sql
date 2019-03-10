set serveroutput on
--1:Check whether the given combination of food and flavor is available. If any one or
--both are not available, display the relevant message.
declare
    x_food  products.food%type;
    x_flavour   products.flavour%type;
    
    type  Combo is
    record (tfood  products.food%type,
                tflavour  products.flavour%type);
    
    cR   Combo;   
    
    food_temp  number(1) :=0;
    flavour_temp  number(1) :=0;
    combo_temp number(1):=0;
    
    cursor c1 is
    ( select food,flavour
    from products);
    
begin    
    x_food:= '&food_name';
    x_flavour:='&flavour_name';
    
  open c1;
        loop
            fetch c1 into cR;
            exit when c1%NOTFOUND;
            if(x_food=cR.tfood) then
                food_temp:=1;
            elsif(x_flavour=cR.tflavour) then
                flavour_temp:=1;
            end if;
            if(x_food=cR.tfood and x_flavour=cR.tflavour) then
                  --dbms_output.put_line('Food : '||x_food||' exists '||chr(10));
                  combo_temp:=1;
                  exit;
            end if;
        end loop;
  close c1;
  
  dbms_output.put_line(chr(10)||'User_food = '||x_food||' , User_Flavour = '||x_flavour);
  if(combo_temp=1) then      
      dbms_output.put_line('Given Combination of food exists'||chr(10));
  elsif(food_temp = 1 or flavour_temp = 1) then
          if(food_temp=1) then
              dbms_output.put_line('Food: '||x_food||' exists but flavour: '||x_flavour||' does not'||chr(10));
          else
              dbms_output.put_line('Flavour: '||x_flavour||' exists but food: '||x_food||' does not'||chr(10));
          end if;
  else
      dbms_output.put_line('Neither Food: '||x_food||' nor Flavour:'||x_flavour||' exists'||chr(10));
  end if;

end;
--*****************************"OPUTPUT BELOW"**********************************
/
/
/

--2:On a given date, find the number of items sold (Use Implicit cursor).
declare
  x_date  Receipts.dateOfPurchase%type :='28-OCT-07';
  x_sold  Number(4);
  
begin
  select count(item) into x_sold
  from item_list i,
  products p,Receipts r
  where i.item=p.pid
  and r.rno=i.receipt
  and r.dateofpurchase=x_date;
  
  dbms_output.put_line('No.of items sold: '||x_sold);
end;
--*****************************"OPUTPUT BELOW"**********************************
/

--3:An user desired to buy the product with the specific price. Ask the user for a price,
--find the food item(s) that is equal or closest to the desired price. Print the product
--number, food type, flavor and price. Also print the number of items that is equal or
--closest to the desired price.
declare
  x_price products.price%type :=&User_Price;
  
  type rtype is
  record
  (pid products.pid%type,
  food products.food%type,
  flavour products.flavour%type,
  price products.price%type);
  
  temp rtype;
  
  cursor c1 is
  select * from products;
  
begin
  open c1;
  loop
      fetch c1 into temp;
      exit when c1%notfound;            
      
      if(temp.price between (x_price-x_price/4.0) and (x_price+x_price/4.0)) then
          dbms_output.put_line('User_Price: $'||x_price);
          dbms_output.put_line('Pid : '||temp.pid||' | Food: '||temp.food||' | Flavour: '||temp.flavour||' | Price: $'||temp.price||chr(10));
      end if;
  end loop  ;
end;
--*****************************"OPUTPUT BELOW"**********************************
/
  
--4:Display the customer name along with the details of item and its quantity ordered for
--the given order number. Also calculate the total quantity ordered as shown below:
declare
    x_tot_qty   number(2) :=0;
    x_rno Receipts.rno%type :=51991;
    type rType is
    record
    (cfname customers.fname%type,
    clname customers.lname%type,
    food products.food%type,
    flavour products.flavour%type,
    qty number(2));
    
    rec rType;
    
    cursor c1 is
    select c.fname,c.lname,p.food,p.flavour,count(i.item)
    from products p,customers c,Receipts r,item_list i
    where c.cid=r.cid and i.receipt=r.rno
    and i.item=p.pid
    and r.rno=x_rno
    group by c.fname,c.lname,p.food,p.flavour;
    
    x_flag  number(1) :=0;
    
begin
    open c1;        
    loop
        fetch c1 into rec;
        exit when c1%notfound;    
        if(x_flag=0) then
            dbms_output.put_line(chr(10)||'Customer Name: '||rec.cfname||' '||rec.clname||chr(10));
            dbms_output.put_line(chr(10)||'Ordered the following items'||chr(10));
            dbms_output.put_line('Food         Flavour           Qty');
            x_flag:=1;
        end if;
        
        dbms_output.put_line(rec.food||'          '||rec.flavour||'           '||rec.qty);
        
        x_tot_qty :=x_tot_qty+rec.qty;
    end loop;
    close c1;
    dbms_output.put_line('-----------------------------------------');
    dbms_output.put_line(chr(10)||'Total Qty: '||x_tot_qty);
end;
--*****************************"OPUTPUT BELOW"**********************************
/

  
    