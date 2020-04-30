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
	add orderStatus varchar(15) not null;
    
alter table payments 
	add pairStatus varchar(15) not null;
    
SET SQL_SAFE_UPDATES=0;    
update orders o
	inner join(
		select orderNumber, sum(quantityOrdered  *  priceEach) as orderTotal 
			from orderdetails 
			group by orderNumber 
		) od using (orderNumber)
	set o.orderTotal = od.orderTotal;
    
update payments p
	inner join orders o using(customerNumber)
    set p.pairStatus = "orderPaired", o.orderStatus = "orderPaid"
    where o.orderdate <= p.paymentDate;

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
set orderStatus = "orderPaid"
where orderNumber = 10400;