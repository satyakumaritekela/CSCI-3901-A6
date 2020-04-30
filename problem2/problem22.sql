
-- -----------------------------------------------------
-- Table `itekela`.`studentdetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `itekela`.`studentdetails` ;

CREATE TABLE IF NOT EXISTS `itekela`.`studentdetails` (
  `st_ID` INT NOT NULL,
  `l_Name` VARCHAR(45) NOT NULL,
  `f_Name` VARCHAR(45) NOT NULL,
  `phone_No` VARCHAR(45) NOT NULL,
  `st_Lic` VARCHAR(45) NOT NULL,
  `lic_No` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`st_ID`));


-- -----------------------------------------------------
-- Table `itekela`.`ticketlines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `itekela`.`ticketlines` ;

CREATE TABLE IF NOT EXISTS `itekela`.`ticketlines` (
  `code` INT NOT NULL,
  `fine` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`code`));


-- -----------------------------------------------------
-- Table `itekela`.`ticketdetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `itekela`.`ticketdetails` ;

CREATE TABLE IF NOT EXISTS `itekela`.`ticketdetails` (
  `ticket#` INT NOT NULL,
  `st_ID` INT NOT NULL,
  `date` VARCHAR(45) NOT NULL,
  `code` INT NOT NULL,
  PRIMARY KEY (`ticket#`),
  CONSTRAINT `st_ID`
    FOREIGN KEY (`st_ID`)
    REFERENCES `itekela`.`studentdetails` (`st_ID`),
  CONSTRAINT `code`
    FOREIGN KEY (`code`)
    REFERENCES `itekela`.`ticketlines` (`code`));

    
SELECT * FROM `studentdetails`;
SELECT * FROM `ticketdetails`;
SELECT * FROM `ticketlines`;

INSERT INTO `itekela`.`studentdetails` (`st_ID`, `l_Name`, `f_Name`, `phone_No`, `st_Lic`, `lic_No`) 
	VALUES (38249, "Brown", "Thomas", "111-7804", "FL", "BRY123");
    
INSERT INTO `itekela`.`ticketdetails` (`ticket#`, `st_ID`,  `date`, `code`) 
	VALUES 
    (15634, 38249, "10/17/08", 2),
    (16017, 38249, "11/13/08", 1);

INSERT INTO `itekela`.`ticketlines` (`code`, `fine`) 
	VALUES 
    (1, "$15"),
    (2, "$25"),
    (3, "$100");