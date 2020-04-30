use itekela;

drop table if exists orders;
drop table if exists customers;
drop table if exists payments;
drop table if exists orderdetails;

create table if not exists orders (
	orderNumber int(11) not null,
	orderDate date not null,
	requiredDate date not null,
	shippedDate date default null,
	status varchar(15) not null,
	comments text default null,
	customerNumber int(11) not null,
	primary key (orderNumber),
	key customerNumber (customerNumber),
	constraint orders_ibfk_1 foreign key (customerNumber) references customers(customerNumber)
);

create table if not exists  orderdetails  (
	orderNumber int(11) not null,
	productCode varchar(15) not null,
	quantityOrdered int(11) not null,
	priceEach decimal(10,2) not null,
	orderLineNumber smallint(6) not null,
	primary key(orderNumber, productCode),
	key productCode(productCode),
	constraint orderdetails_ibfk_1 foreign key(orderNumber) references orders(orderNumber)
);

create table if not exists payments(
	customerNumber int(11) not null,
	checkNumber varchar(50) not null,
	paymentDate date not null,
	amount decimal(10,2) not null,
	primary key(customerNumber, checkNumber),
	constraint payments_ibfk_1 foreign key (customerNumber) references customers(customerNumber)
);

create table customers (
	customerNumber int(11) not null,
	customerName varchar(50) not null,
	contactLastName varchar(50) not null,
	contactFirstName varchar(50) not null,
	phone varchar(50) not null,
	addressLine1 varchar(50) not null,
	addressLine2 varchar(50) default null,
	city varchar(50) not null,
	state varchar(50) default null,
	postalCode varchar(15) default null,
	country varchar(50) not null,
	salesRepEmployeeNumber int(11) default null,
	creditLimit decimal(10,2) default null,
	primary key (customerNumber)
);

CREATE TABLE `course` (
  `course_key` int(11) NOT NULL,
  `name` char(50) DEFAULT NULL,
  `web_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`course_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

alter table payments drop foreign key payments_ibfk_1;
alter table payments add constraint customerNumber1 foreign key(customerNumber) references orders(customerNumber);

alter table orders drop foreign key orders_ibfk_1;

select * from orders;
select * from payments;
select * from orderdetails;

insert into itekela.orders select * from csci3901.orders; 
insert into itekela.payments select * from csci3901.payments;
insert into itekela.orderdetails select * from csci3901.orderdetails; 
    
alter table orders 
	add orderTotal decimal(10,2) not null,
	add checkNumber varchar(50) default null;

alter table orders drop column checkNumber;
alter table payments drop column pairStatus;
alter table orders 
	add checkNumber varchar(50) default null;
    
alter table payments 
	add pairStatus varchar(15) default null;
    
SET SQL_SAFE_UPDATES=0;    
update orders o
	inner join(
		select orderNumber, sum(quantityOrdered  *  priceEach) as orderTotal 
			from orderdetails 
			group by orderNumber 
		) od using (orderNumber)
	set o.orderTotal = od.orderTotal;
    
select * from orders order by customerNumber, orderDate;
select * from payments order by customerNumber, paymentDate;

update payments p
	inner join orders o using(customerNumber)
    set p.pairStatus = "orderPaired", o.orderStatus = p.checkNumber
    where o.orderdate <= p.paymentDate;
    
delimiter $$
create procedure paymentsMapping()
begin
	declare mapping_done1, mapping_done2 int default false;
	declare calculatedAmount decimal(10, 2);
    declare a, b decimal(10,2);
    declare c, d varchar(50);
    declare e, f date;
    declare g, h int;
    declare paymentCursor cursor for select amount, checkNumber, paymentDate, customerNumber from payments;
    declare continue handler for not found set mapping_done1 = TRUE;
    
    open paymentCursor;
    mapping_loop1: loop
        fetch paymentCursor into b, d, f, h;
        if mapping_done1 then
			close paymentCursor;
			leave mapping_loop1;
		end if;
        
        block2: begin
        declare orderCursor cursor for select orderTotal, checkNumber, orderDate, customerNumber from (select * from orders order by customerNumber, orderDate) as o;
		declare continue handler for not found set mapping_done2 = TRUE;
        
        open orderCursor;
		set calculatedAmount = b;
        mapping_loop2: loop
			fetch orderCursor into a, c, e, g;
			if mapping_done2 then
				close paymentCursor;
				leave mapping_loop2;
			end if;
			if (e <= f) and (g = h) and (a <= calculatedAmount) then
				update orders
                set c = d;
                set calculatedAmount = calculatedAmount - a;
			else leave mapping_loop2;
			end if;
		end loop mapping_loop2;
        end block2;
    end loop mapping_loop1;
end$$
delimiter ; 	

drop procedure paymentsMapping;
call paymentsMapping();
    
select *
	from orders where orderStatus = "";
select *
	from payments where pairStatus = "";
    
select *
	from orders 
    where orderStatus = "" and status != 'Cancelled' and status != 'Disputed';
    
select *
	from payments 
    where pairStatus = "";

select *
	from (
		select orderNumber, orderTotal, orderDate, customerNumber
			from orders 
			where status != 'Cancelled' and status != 'Disputed'
			order by customerNumber, orderDate 
		) o left join (
		select *
			from payments 
			order by customerNumber, paymentDate 
	) p on o.orderTotal = p.amount and o.customerNumber = p.customerNumber
	where p.amount is null
	order by  orderNumber asc, paymentDate asc;
    
select *
	from (
		select orderNumber, orderTotal, orderDate, customerNumber
			from orders 
			order by customerNumber, orderDate 
		) o right join (
		select *
			from payments 
			order by customerNumber, paymentDate 
	) p on o.orderTotal = p.amount and o.customerNumber = p.customerNumber
	where orderNumber is null
	order by  orderNumber asc, paymentDate asc;
    
select orderTotal from orders where orderNumber = 10400;

update orders
set checkNumber = "";
