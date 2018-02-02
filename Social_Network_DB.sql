-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema social_network_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema social_network_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `social_network_db` DEFAULT CHARACTER SET latin1 ;
USE `social_network_db` ;

-- -----------------------------------------------------
-- Table `social_network_db`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_network_db`.`user` (
  `user_id` INT(11) NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(65) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `country_of_birth` VARCHAR(45) NOT NULL,
  `email_address` VARCHAR(65) NOT NULL,
  `user_name` VARCHAR(45) NOT NULL,
  `short_biography` TEXT NULL DEFAULT NULL,
  `personal_picture` BLOB NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `idx_name` (`last_name` ASC, `first_name` ASC),
  INDEX `idx_country` (`country_of_birth` ASC),
  FULLTEXT INDEX `idx_short_biography` (`short_biography` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `social_network_db`.`friendships`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_network_db`.`friendships` (
  `friendships_id` INT(11) NOT NULL AUTO_INCREMENT,
  `friendships_list` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  PRIMARY KEY (`friendships_id`),
  INDEX `fk3_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk3_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `social_network_db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `social_network_db`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_network_db`.`status` (
  `status_id` INT(11) NOT NULL AUTO_INCREMENT,
  `post` TEXT NOT NULL,
  `post_title` VARCHAR(45) NOT NULL,
  `post_date_time` DATETIME NOT NULL,
  PRIMARY KEY (`status_id`),
  FULLTEXT INDEX `idx_post` (`post` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `social_network_db`.`user_friendships`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_network_db`.`user_friendships` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `friendships_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk2_friendships_id_idx` (`friendships_id` ASC),
  CONSTRAINT `fk2_friendships_id`
    FOREIGN KEY (`friendships_id`)
    REFERENCES `social_network_db`.`friendships` (`friendships_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `social_network_db`.`user_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_network_db`.`user_status` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `status_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  INDEX `fk_status_id_idx` (`status_id` ASC),
  CONSTRAINT `fk_status_id`
    FOREIGN KEY (`status_id`)
    REFERENCES `social_network_db`.`status` (`status_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `social_network_db`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `social_network_db` ;

-- -----------------------------------------------------
-- Placeholder table for view `social_network_db`.`user_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social_network_db`.`user_view` (`first_name` INT, `last_name` INT, `date_of_birth` INT, `country_of_birth` INT);

-- -----------------------------------------------------
-- procedure delete_user_procedure
-- -----------------------------------------------------

DELIMITER $$
USE `social_network_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user_procedure`(in id int)
BEGIN
DELETE FROM user WHERE user_id=id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function friends_number_function
-- -----------------------------------------------------

DELIMITER $$
USE `social_network_db`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `friends_number_function`(id int) RETURNS int(11)
BEGIN
DECLARE friends_number INT;
SELECT friendships_list FROM social_network_db.friendships where user_id = id INTO friends_number;
RETURN (friends_number);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insert_user_procedure
-- -----------------------------------------------------

DELIMITER $$
USE `social_network_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_user_procedure`(in new_first_name varchar(45), 
in new_last_name varchar(65), in new_date_of_birth date, in new_country_of_birth varchar(45), 
in new_email_address varchar(65), in new_user_name varchar(45), in new_short_biography text, in new_personal_picture blob)
BEGIN
INSERT INTO user (first_name, last_name, date_of_birth, country_of_birth, email_address, 
user_name, short_biography, personal_picture) VALUES (new_first_name, new_last_name, new_date_of_birth, 
new_country_of_birth, new_email_address, new_user_name, new_short_biography, new_personal_picture);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure update_user_procedure
-- -----------------------------------------------------

DELIMITER $$
USE `social_network_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_procedure`(in id int, in new_first_name varchar(45), 
in new_last_name varchar(65), in new_date_of_birth date, in new_country_of_birth varchar(45), 
in new_email_address varchar(65), in new_user_name varchar(45), in new_short_biography text, 
in new_personal_picture blob)
BEGIN
UPDATE user SET first_name = new_first_name, last_name = new_last_name, date_of_birth = new_date_of_birth, 
country_of_birth = new_country_of_birth, email_address = new_email_address, user_name = new_user_name, 
short_biography = new_short_biography, personal_picture = new_personal_picture where user_id = id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `social_network_db`.`user_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `social_network_db`.`user_view`;
USE `social_network_db`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `social_network_db`.`user_view` AS select `social_network_db`.`user`.`first_name` AS `first_name`,`social_network_db`.`user`.`last_name` AS `last_name`,`social_network_db`.`user`.`date_of_birth` AS `date_of_birth`,`social_network_db`.`user`.`country_of_birth` AS `country_of_birth` from `social_network_db`.`user`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
