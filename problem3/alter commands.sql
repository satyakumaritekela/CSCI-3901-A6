/** Altering the payments table by adding the pair status column for mapping the status with the orders **/
/** adding the constraint unique to the check numbers **/

alter table payments
	add pairStatus varchar(15) default null,
	add constraint unique_checkNumber unique(checkNumber);

/** Altering the orders table by adding the orderTotal, checkNumber columns for mapping the check numbers in the payments **/
/** adding the constraint foreign key check number referencing check numbers from the orders table **/

alter table orders 
	add orderTotal decimal(10,2) not null,
	add checkNumber varchar(50) default null,
	add constraint fk_ordersPayments foreign key (`checkNumber`) references payments (`checkNumber`)
	on update cascade
	on delete cascade;
    
/** update the orderTotal by joing the each order with the order details table **/
/** set the sql_safe_update to 0 if any **/
SET SQL_SAFE_UPDATES=0;    
update orders o
	inner join(
		select orderNumber, sum(quantityOrdered  *  priceEach) as orderTotal 
			from orderdetails 
			group by orderNumber 
		) od using (orderNumber)
	set o.orderTotal = od.orderTotal;