-- MySQL Script generated by MySQL Workbench
-- Tue Oct 26 20:57:54 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`address` (
  `address` VARCHAR(100) NOT NULL,
  `district` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`address`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`kindergarden`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`kindergarden` (
  `id` INT NOT NULL,
  `address` VARCHAR(100) NOT NULL,
  `flats_count` INT NOT NULL,
  `workers_count` INT NULL,
  `group_count` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_kinder_garden_address_idx` (`address` ASC) VISIBLE,
  CONSTRAINT `fk_kinder_garden_address`
    FOREIGN KEY (`address`)
    REFERENCES `mydb`.`address` (`address`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`position` (
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`name`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`worker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`worker` (
  `passport` VARCHAR(9) NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `surname` VARCHAR(20) NOT NULL,
  `hire_date` DATE NOT NULL,
  `fire_date` DATE NULL,
  `kindergarden_id` INT NULL,
  `position_name` VARCHAR(30) NULL,
  PRIMARY KEY (`passport`),
  INDEX `fk_worker_kindergarden1_idx` (`kindergarden_id` ASC) VISIBLE,
  INDEX `fk_worker_position1_idx` (`position_name` ASC) VISIBLE,
  CONSTRAINT `fk_worker_kindergarden1`
    FOREIGN KEY (`kindergarden_id`)
    REFERENCES `mydb`.`kindergarden` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_worker_position1`
    FOREIGN KEY (`position_name`)
    REFERENCES `mydb`.`position` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`child_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`child_group` (
  `id` INT NOT NULL,
  `name` VARCHAR(30) NULL,
  `bedroom_number` INT NOT NULL,
  `worker_passport` VARCHAR(9) NOT NULL,
  `kindergarden_id` INT NOT NULL,
  PRIMARY KEY (`id`, `kindergarden_id`),
  INDEX `fk_child_group_worker1_idx` (`worker_passport` ASC) VISIBLE,
  INDEX `fk_child_group_kindergarden1_idx` (`kindergarden_id` ASC) VISIBLE,
  CONSTRAINT `fk_child_group_worker1`
    FOREIGN KEY (`worker_passport`)
    REFERENCES `mydb`.`worker` (`passport`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_child_group_kindergarden1`
    FOREIGN KEY (`kindergarden_id`)
    REFERENCES `mydb`.`kindergarden` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`child`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`child` (
  `birth_certificate` VARCHAR(15) NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `surname` VARCHAR(20) NOT NULL,
  `birth_date` DATE NOT NULL,
  `child_group_id` INT NOT NULL,
  `child_group_kindergarden_id` INT NOT NULL,
  PRIMARY KEY (`birth_certificate`),
  INDEX `fk_child_child_group1_idx` (`child_group_id` ASC, `child_group_kindergarden_id` ASC) VISIBLE,
  CONSTRAINT `fk_child_child_group1`
    FOREIGN KEY (`child_group_id` , `child_group_kindergarden_id`)
    REFERENCES `mydb`.`child_group` (`id` , `kindergarden_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`lesson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`lesson` (
  `name` VARCHAR(20) NOT NULL,
  `classroom` VARCHAR(20) NULL,
  `worker_passport` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`name`, `worker_passport`),
  INDEX `fk_lesson_worker1_idx` (`worker_passport` ASC) VISIBLE,
  CONSTRAINT `fk_lesson_worker1`
    FOREIGN KEY (`worker_passport`)
    REFERENCES `mydb`.`worker` (`passport`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`schedule` (
  `id` INT NOT NULL,
  `child_group_id` INT NOT NULL,
  `child_group_kindergarden_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_schedule_child_group1_idx` (`child_group_id` ASC, `child_group_kindergarden_id` ASC) VISIBLE,
  CONSTRAINT `fk_schedule_child_group1`
    FOREIGN KEY (`child_group_id` , `child_group_kindergarden_id`)
    REFERENCES `mydb`.`child_group` (`id` , `kindergarden_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`schedule_has_lesson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`schedule_has_lesson` (
  `schedule_id` INT NOT NULL,
  `lesson_name` VARCHAR(20) NOT NULL,
  `lesson_worker_passport` VARCHAR(9) NOT NULL,
  `lesson_time` TIME NOT NULL,
  `lesson_day` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`schedule_id`, `lesson_name`, `lesson_worker_passport`),
  INDEX `fk_schedule_has_lesson_lesson1_idx` (`lesson_name` ASC, `lesson_worker_passport` ASC) VISIBLE,
  INDEX `fk_schedule_has_lesson_schedule1_idx` (`schedule_id` ASC) VISIBLE,
  CONSTRAINT `fk_schedule_has_lesson_schedule1`
    FOREIGN KEY (`schedule_id`)
    REFERENCES `mydb`.`schedule` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_schedule_has_lesson_lesson1`
    FOREIGN KEY (`lesson_name` , `lesson_worker_passport`)
    REFERENCES `mydb`.`lesson` (`name` , `worker_passport`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`kindergarden_has_position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`kindergarden_has_position` (
  `kindergarden_id` INT NOT NULL,
  `position_name` VARCHAR(30) NOT NULL,
  `salary` INT NULL,
  `bonus` INT NULL,
  PRIMARY KEY (`kindergarden_id`, `position_name`),
  INDEX `fk_kindergarden_has_position_position1_idx` (`position_name` ASC) VISIBLE,
  INDEX `fk_kindergarden_has_position_kindergarden1_idx` (`kindergarden_id` ASC) VISIBLE,
  CONSTRAINT `fk_kindergarden_has_position_kindergarden1`
    FOREIGN KEY (`kindergarden_id`)
    REFERENCES `mydb`.`kindergarden` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_kindergarden_has_position_position1`
    FOREIGN KEY (`position_name`)
    REFERENCES `mydb`.`position` (`name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
