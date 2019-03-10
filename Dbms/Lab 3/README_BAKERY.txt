*********************************************************
			Data Base mangement System Lab
			Dept of Computer Science & Engineering
        		SSN College of Engineering 
*********************************************************
		  BAKERY DATASET
                   Version 1.0
                January 27, 2014
************************************************************
Sources:  this is a synthesized dataset. 

*************************************************************

The dataset contains information about one month worth
of sales information for a small bakery shop. The sales
are made to known customers. The dataset contains
information about the customers, the assortments of
baked goods offered for sale and the purchases made.

General Conventions.

 1. All files in the dataset are script(SQL) files.
 2. First line of each file provides the names of
    columns. Second line may be empty, or may contain
    the first row of the data.
 3. All string values are enclosed in single quotes (')


  The dataset consists of the following relations:

   - customers  : information about the bakery's customers
   - products   : information about the baked goods offered
                     for sale by the bakery
   - item_list  : itemized reciept infromation for purchases
   - receipts   : general receipt information for purchases


 reciepts stores information about individual reciepts
(purchases by customers). Each purchase may contain from
one to five items, regardless of whether any items
purchased are of the same kind (e.g., two "chocolate cakes"
will be billed as two separate items on the reciept).
item_list contains itemized reciept information.


 Individual relations have the following description.

**************************************************************************

 customers

        Id: unique identifier of the customer
  LastName: last name of the customer
 FirstName: first name of the customer


**************************************************************************


 products

     Id : unique identifier of the baked product
  Flavor: flavor/type of the product (e.g., "chocolate", "lemon")
    Food: category of the product (e.g., "cake", "tart")
   Price: price (in dollars) 


**************************************************************************

item_list

    Receipt : receipt number (see receipts.ReceiptNumber)
    Ordinal : position of the purchased item on the
              reciepts. (i.e., first purchased item,
              second purchased item, etc...)
    Item    : identifier of the item purchased (see product.Id)
    

**************************************************************************

receipts

ReceiptNumber : unique identifier of the reciept
         Date : date of the purchase. The date is
                in  DD-Mon-YYY format, which is the
                default Oracle's format for DATE data type.
   CustomerId : id of the customer (see customers.Id)


**************************************************************************
**************************************************************************

Permission granted to use and distribute this dataset in its current form, 
provided this file  is kept unchanged and is distributed together with the 
data.

Permission granted to modify and expand this dataset, provided this
file is updated accordingly with new information.

**************************************************************************
**************************************************************************
