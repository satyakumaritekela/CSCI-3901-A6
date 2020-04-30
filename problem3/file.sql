select * from payments where customerNumber = 166 order by  paymentDate;

select * from orders where customerNumber =166 order by customerNumber, orderDate;

update orders set checkNumber = null;
update payments set pairStatus = null;

select * from orders where status not in ('Cancelled', 'Disputed') and checkNumber is null;
select * from orders where checkNumber is null order by customerNumber, orderDate;

select * from orders where customerNumber = 166;

select orderTotal, customerNumber from orders where orderNumber = 10412 and checkNumber is null;

select * from payments where checkNumber = "AC131256";

select * from orders where orderNumber = 10412;

select * from payments where pairStatus is null;
select * from orders where checkNumber is null;