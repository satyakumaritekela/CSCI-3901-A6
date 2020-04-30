CREATE PROCEDURE `paymentsMapping` ()
BEGIN
	declare done int default false;
	declare calculatedAmount decimal(10, 2);
    declare a,b decimal(10,2);
    declare c,d varchar(50);
    declare e, f date;
	declare orderCursor cursor for select orderTotal, pairStatus, orderDate from (select * from orders order by customerNumber, orderDate);
	declare paymentCursor cursor for select amount, checkNumber, paymentDate from payments;
    declare continue handler for not found set mapping_done = TRUE;
    
    mapping_loop: loop
		fetch orderCursor into a, c, e;
        fetch paymentCursor into b, d, f;
        if done then
			leave mapping_loop;
		end if;
		if (e <= f) and (remainingAmount <= o.orderTotal) then
			update payments p
				inner join orders o using(customerNumber)
				set p.pairStatus = "orderPaired", o.orderStatus = "orderPaid"
END
