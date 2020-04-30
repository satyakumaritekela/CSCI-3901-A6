use itekela;

create table shipmentdetails(
	shipmentID varchar(40),
	shipmentDate varchar(40),
    origin varchar(40),
    expectedArrival varchar(40),
    destination varchar(40),
    shipNumber int,
    captain varchar(40),
    primary key (shipmentID));
    
create table itemdetails(
	itemNumber int,
	type varchar(40),
    description varchar(40),
    weight varchar(40),
    quantity varchar(40),
    totalWeight int,
    shipmentTotal int,
    primary key (itemNumber));
    
select * from shipmentDetails;
select * from itemDetails;
drop table shipmentDetails;
drop table itemDetails;
INSERT INTO `itekela`.`Shipmentdetails` (`shipmentID`, `shipmentDate`, `origin`, `expectedArrival`, `destination`, `shipNumber`, `captain`) VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert into shipmentDetails(ShipmentID, ShipmentDate, Origin, ExpectedArrival, Destination, ShipNumber, Captain) 
	values ("000-001", "01/10/2008", "Boston", "01/14/2008", "Brazil", "39", "002-15 Henry Moore");

insert into itemDetails(ItemNumber, Type, Description, Weight, Quantity, TotalWeight, ShipmentTotal) 
	values 
    (3223, "BM", "Concrete Form", 500, 100, 50000, 500000),
    (3297, "BM", "Steel Beam", 87, 2000, 174000, 500000);

