USE `itekela` ;

-- -----------------------------------------------------
-- Table `itekela`.`shipmentdetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `itekela`.`shipmentdetails` ;

CREATE TABLE IF NOT EXISTS `itekela`.`shipmentdetails` (
  `shipmentID` VARCHAR(45) NOT NULL,
  `shipmentDate` VARCHAR(45) NOT NULL,
  `origin` VARCHAR(45) NOT NULL,
  `expectedArrival` VARCHAR(45) NOT NULL,
  `destination` VARCHAR(45) NOT NULL,
  `shipNumber` INT NOT NULL,
  `captain` VARCHAR(45) NOT NULL,
  `shipmentTotal` INT NOT NULL,
  PRIMARY KEY (`shipmentID`));


-- -----------------------------------------------------
-- Table `itekela`.`itemdetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `itekela`.`itemdetails` ;

CREATE TABLE IF NOT EXISTS `itekela`.`itemdetails` (
  `itemNumber` INT NOT NULL,
  `shipmentID` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  `weight` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`itemNumber`),
  CONSTRAINT `shipmentID1`
    FOREIGN KEY (`shipmentID`)
    REFERENCES `itekela`.`shipmentdetails` (`shipmentID`));


-- -----------------------------------------------------
-- Table `itekela`.`itemline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `itekela`.`itemlines` ;

CREATE TABLE IF NOT EXISTS `itekela`.`itemlines` (
  `itemNumber` INT NOT NULL,
  `shipmentID` VARCHAR(45) NOT NULL,
  `totalWeight` INT NOT NULL,
  PRIMARY KEY (`itemNumber`),
  CONSTRAINT `shipmentID2`
    FOREIGN KEY (`shipmentID`)
    REFERENCES `itekela`.`shipmentdetails` (`shipmentID`));

SELECT * FROM `shipmentdetails`;
SELECT * FROM `itemdetails`;
SELECT * FROM `itemlines`;

INSERT INTO `itekela`.`shipmentdetails` (`shipmentID`, `shipmentDate`, `origin`, `expectedArrival`, `destination`, `shipNumber`, `captain`, `shipmentTotal`) 
	VALUES ("000-001", "01/10/2008", "Boston", "01/14/2008", "Brazil", "39", "002-15 Henry Moore", 224000);
    
INSERT INTO `itekela`.`itemdetails` (`itemNumber`, `shipmentID`, `type`, `description`, `weight`, `quantity`) 
	VALUES 
    (3223, "000-001", "BM", "Concrete Form", 500, 100),
    (3297, "000-001", "BM", "Steel Beam", 87, 2000);

INSERT INTO `itekela`.`itemlines` (`itemNumber`, `shipmentID`, `totalWeight`) 
	VALUES 
    (3223, "000-001", 50000),
    (3297, "000-001", 174000);
