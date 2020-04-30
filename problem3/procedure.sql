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
        declare orderCursor cursor for select orderTotal, checkNumber, orderDate, customerNumber from (select * from orders order by customerNumber, orderDate);
		declare continue handler for not found set mapping_done2 = TRUE;
        
        open orderCursor;
        mapping_loop2: loop
			fetch orderCursor into a, c, e, g;
			if mapping_done2 then
				close paymentCursor;
				leave mapping_loop1;
			end if;
			if (e <= f) and (g = h) and (b <= a) then
				set c = d;
			end if;
		end loop mapping_loop2;
        end block2;
    end loop mapping_loop1;
end
