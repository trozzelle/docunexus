-- MySQL dump 10.13  Distrib 8.0.26, for Linux (x86_64)
--
-- Host: localhost    Database: shrd
-- ------------------------------------------------------
-- Server version	8.0.26-0ubuntu0.20.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `shrd`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `shrd` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `shrd`;

--
-- Table structure for table `api_get_position`
--

DROP TABLE IF EXISTS `api_get_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_get_position` (
  `id` int NOT NULL AUTO_INCREMENT,
  `source_name` varchar(255) NOT NULL,
  `target_schema` varchar(255) NOT NULL,
  `target_table` varchar(255) NOT NULL,
  `refresh_type` varchar(255) NOT NULL,
  `ts` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `connection_id` bigint DEFAULT NULL,
  `json_position` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `api_get_position_v`
--

DROP TABLE IF EXISTS `api_get_position_v`;
/*!50001 DROP VIEW IF EXISTS `api_get_position_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `api_get_position_v` AS SELECT 
 1 AS `id`,
 1 AS `source_name`,
 1 AS `target_schema`,
 1 AS `target_table`,
 1 AS `refresh_type`,
 1 AS `ts`,
 1 AS `json_position`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `dim_date`
--

DROP TABLE IF EXISTS `dim_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_date` (
  `date_key` bigint unsigned NOT NULL,
  `day_of_week` int DEFAULT NULL,
  `day_name_of_week` varchar(9) DEFAULT NULL,
  `day_of_month` int DEFAULT NULL,
  `day_of_year` int DEFAULT NULL,
  `is_weekday` int NOT NULL DEFAULT '0',
  `week_of_year` int DEFAULT NULL,
  `month_name` varchar(9) DEFAULT NULL,
  `month_of_year` int DEFAULT NULL,
  `is_last_day_of_month` int NOT NULL DEFAULT '0',
  `calendar_quarter` int DEFAULT NULL,
  `javascript_date` varchar(22) DEFAULT NULL,
  `yesterday_date_key` bigint unsigned DEFAULT NULL,
  `tomorrow_date_key` bigint unsigned DEFAULT NULL,
  `last_week_date_key` bigint unsigned DEFAULT NULL,
  `next_week_date_key` bigint unsigned DEFAULT NULL,
  `last_month_date_key` bigint unsigned DEFAULT NULL,
  `next_month_date_key` bigint unsigned DEFAULT NULL,
  `last_quarter_date_key` bigint unsigned DEFAULT NULL,
  `next_quarter_date_key` bigint unsigned DEFAULT NULL,
  `last_year_date_key` bigint unsigned DEFAULT NULL,
  `next_year_date_key` bigint unsigned DEFAULT NULL,
  `week_key` bigint unsigned DEFAULT NULL,
  `month_start_key` bigint unsigned DEFAULT NULL,
  `week_key2` varchar(7) DEFAULT NULL,
  `month_key` bigint unsigned DEFAULT NULL,
  `quarter_key` bigint unsigned DEFAULT NULL,
  `year_key` int DEFAULT NULL,
  PRIMARY KEY (`date_key`),
  KEY `month_key` (`month_key`),
  KEY `quarter_key` (`quarter_key`),
  KEY `year_key` (`year_key`),
  KEY `last_week_date_key` (`last_week_date_key`),
  KEY `next_week_date_key` (`next_week_date_key`),
  KEY `last_month_date_key` (`last_month_date_key`),
  KEY `next_month_date_key` (`next_month_date_key`),
  KEY `day_of_month` (`day_of_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dim_int`
--

DROP TABLE IF EXISTS `dim_int`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_int` (
  `int_key` double NOT NULL,
  PRIMARY KEY (`int_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'shrd'
--

--
-- Current Database: `dcnxs_app`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dcnxs_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `dcnxs_app`;

--
-- Table structure for table `environments`
--

DROP TABLE IF EXISTS `environments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `environments` (
  `envid` int NOT NULL AUTO_INCREMENT,
  `env_name` varchar(45) NOT NULL,
  `url` varchar(200) DEFAULT NULL,
  `path` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`envid`,`env_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `group_regions`
--

DROP TABLE IF EXISTS `group_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group_regions` (
  `groupid` int NOT NULL,
  `regionid` int NOT NULL,
  PRIMARY KEY (`groupid`,`regionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `groupid` int NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `group_image` longtext,
  PRIMARY KEY (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `regionid` int NOT NULL AUTO_INCREMENT,
  `region_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`regionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rights`
--

DROP TABLE IF EXISTS `rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rights` (
  `rightsid` int NOT NULL AUTO_INCREMENT,
  `rights_name` varchar(100) DEFAULT NULL,
  `can_delete` char(1) DEFAULT 'Y',
  PRIMARY KEY (`rightsid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_groups`
--

DROP TABLE IF EXISTS `user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_groups` (
  `userid` int NOT NULL,
  `groupid` int NOT NULL,
  `group_admin` char(1) DEFAULT 'N',
  PRIMARY KEY (`userid`,`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_regions`
--

DROP TABLE IF EXISTS `user_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_regions` (
  `userid` int NOT NULL,
  `regionid` int NOT NULL,
  `region_admin` char(1) DEFAULT 'N',
  PRIMARY KEY (`userid`,`regionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `email` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `site_admin` char(1) DEFAULT 'N',
  `enabled` char(1) DEFAULT 'Y',
  `username` varchar(20) NOT NULL,
  `userid` int NOT NULL AUTO_INCREMENT,
  `reset_link_token` varchar(36) DEFAULT NULL,
  `reset_expires` varchar(45) DEFAULT NULL,
  `auth_token` varchar(128) DEFAULT NULL,
  `auth_token_expires` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'dcnxs_app'
--

--
-- Current Database: `dcnxs_ny`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dcnxs_ny` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `dcnxs_ny`;

--
-- Table structure for table `assembly_rep`
--

DROP TABLE IF EXISTS `assembly_rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assembly_rep` (
  `assembly_district` varchar(3) NOT NULL,
  `representative` varchar(255) DEFAULT NULL,
  `party` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`assembly_district`),
  KEY `idx_assembly_district` (`assembly_district`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `congressional_rep`
--

DROP TABLE IF EXISTS `congressional_rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `congressional_rep` (
  `congressional_district` varchar(3) NOT NULL,
  `representative` varchar(255) DEFAULT NULL,
  `party` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`congressional_district`),
  KEY `idx_cd` (`congressional_district`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `elections`
--

DROP TABLE IF EXISTS `elections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elections` (
  `election_name` varchar(150) NOT NULL,
  `election_year` int unsigned DEFAULT NULL,
  `election_year_2` int unsigned DEFAULT NULL,
  `is_primary` int NOT NULL DEFAULT '0',
  `is_general` int NOT NULL DEFAULT '0',
  `is_special` int NOT NULL DEFAULT '0',
  `is_democratic` int NOT NULL DEFAULT '0',
  `is_republican` int NOT NULL DEFAULT '0',
  `is_conservative` int NOT NULL DEFAULT '0',
  `is_presidential` int NOT NULL DEFAULT '0',
  `is_federal` int NOT NULL DEFAULT '0',
  `election_year_4_string` varchar(4) DEFAULT NULL,
  `election_year_2_string` varchar(2) DEFAULT NULL,
  `voter_count` int DEFAULT NULL,
  PRIMARY KEY (`election_name`),
  KEY `idx_election_year` (`election_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enrollment`
--

DROP TABLE IF EXISTS `enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollment` (
  `code` varchar(3) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lists`
--

DROP TABLE IF EXISTS `lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lists` (
  `listid` int NOT NULL AUTO_INCREMENT,
  `userid` int NOT NULL,
  `list_name` varchar(255) DEFAULT NULL,
  `list_count` int DEFAULT NULL,
  `source` varchar(45) DEFAULT NULL,
  `query` longtext,
  `date_modified` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`listid`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `match_data`
--

DROP TABLE IF EXISTS `match_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `matchid` int DEFAULT NULL,
  `userid` int DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(10) DEFAULT NULL,
  `residence_num` varchar(10) DEFAULT NULL,
  `residence_halfnum` varchar(10) DEFAULT NULL,
  `residence_aptnum` varchar(50) DEFAULT NULL,
  `residence_pre_street_dir` varchar(20) DEFAULT NULL,
  `residence_street_name` varchar(70) DEFAULT NULL,
  `residence_post_street_dir` varchar(20) DEFAULT NULL,
  `residence_city` varchar(50) DEFAULT NULL,
  `residence_zip` varchar(10) DEFAULT NULL,
  `residence_zip_4` varchar(5) DEFAULT NULL,
  `mailing_address_1` varchar(100) DEFAULT NULL,
  `mailing_address_2` varchar(100) DEFAULT NULL,
  `mailing_address_3` varchar(100) DEFAULT NULL,
  `mailing_address_4` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(8) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `enrollment` varchar(3) DEFAULT NULL,
  `other_party` varchar(30) DEFAULT NULL,
  `county_code` varchar(2) DEFAULT NULL,
  `election_district` varchar(3) DEFAULT NULL,
  `legislative_district` varchar(3) DEFAULT NULL,
  `town_city` varchar(30) DEFAULT NULL,
  `ward` varchar(3) DEFAULT NULL,
  `congressional_district` varchar(3) DEFAULT NULL,
  `senate_district` varchar(3) DEFAULT NULL,
  `assembly_district` varchar(3) DEFAULT NULL,
  `last_voted_date` varchar(8) DEFAULT NULL,
  `last_voted_year` varchar(4) DEFAULT NULL,
  `last_voted_county` varchar(2) DEFAULT NULL,
  `previous_address` varchar(100) DEFAULT NULL,
  `last_registered_name` varchar(150) DEFAULT NULL,
  `county_voter_reg_num` varchar(50) DEFAULT NULL,
  `application_date` varchar(8) DEFAULT NULL,
  `application_source` varchar(10) DEFAULT NULL,
  `id_required` varchar(1) DEFAULT NULL,
  `id_required_met` varchar(1) DEFAULT NULL,
  `voter_status` varchar(10) DEFAULT NULL,
  `voter_status_reason` varchar(15) DEFAULT NULL,
  `inactive_date` varchar(8) DEFAULT NULL,
  `purge_date` varchar(8) DEFAULT NULL,
  `nys_voter_id` varchar(50) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `matched_voter_id` varchar(50) DEFAULT NULL,
  `queueid` int DEFAULT NULL,
  `birth_year` varchar(4) DEFAULT NULL,
  `clean_full_name` varchar(200) DEFAULT NULL,
  `clean_residence_address` varchar(300) DEFAULT NULL,
  `clean_mailing_address` varchar(450) DEFAULT NULL,
  `clean_first_name` varchar(60) DEFAULT NULL,
  `clean_last_name` varchar(60) DEFAULT NULL,
  `clean_previous_address` varchar(100) DEFAULT NULL,
  `clean_email` varchar(60) DEFAULT NULL,
  `clean_phone` varchar(60) DEFAULT NULL,
  `clean_zip5` varchar(5) DEFAULT NULL,
  `clean_residence_city` varchar(50) DEFAULT NULL,
  `clean_residence_street_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `match_potentials`
--

DROP TABLE IF EXISTS `match_potentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_potentials` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userid` int DEFAULT NULL,
  `matchid` int DEFAULT NULL,
  `queueid` int DEFAULT NULL,
  `score` int DEFAULT NULL,
  `matchkey` varchar(50) DEFAULT NULL,
  `nys_voter_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nys_voter_id` (`nys_voter_id`),
  KEY `queueid` (`queueid`),
  KEY `userid` (`userid`),
  KEY `matchid` (`matchid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `match_test`
--

DROP TABLE IF EXISTS `match_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_test` (
  `id` int NOT NULL AUTO_INCREMENT,
  `queueid` int NOT NULL,
  `PreferredEmail` varchar(255) DEFAULT NULL,
  `Preferred Phone` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `Zip5` varchar(255) DEFAULT NULL,
  `full_name` text,
  `mailing_address` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matches` (
  `matchid` int NOT NULL AUTO_INCREMENT,
  `userid` int NOT NULL DEFAULT '0',
  `status` varchar(20) DEFAULT NULL,
  `matchfile_name` varchar(200) DEFAULT NULL,
  `date_submitted` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `matchmap` longtext,
  `matchtable` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`matchid`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_counties`
--

DROP TABLE IF EXISTS `nys_counties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_counties` (
  `county_code` varchar(2) NOT NULL,
  `county_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`county_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_dem`
--

DROP TABLE IF EXISTS `nys_dem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_dem` (
  `id` int NOT NULL AUTO_INCREMENT,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(10) DEFAULT NULL,
  `residence_num` varchar(10) DEFAULT NULL,
  `residence_halfnum` varchar(10) DEFAULT NULL,
  `residence_aptnum` varchar(15) DEFAULT NULL,
  `residence_pre_street_dir` varchar(20) DEFAULT NULL,
  `residence_street_name` varchar(70) DEFAULT NULL,
  `residence_post_street_dir` varchar(20) DEFAULT NULL,
  `residence_city` varchar(50) DEFAULT NULL,
  `residence_zip` varchar(10) DEFAULT NULL,
  `residence_zip_4` varchar(5) DEFAULT NULL,
  `mailing_address_1` varchar(100) DEFAULT NULL,
  `mailing_address_2` varchar(100) DEFAULT NULL,
  `mailing_address_3` varchar(100) DEFAULT NULL,
  `mailing_address_4` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(8) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `enrollment` varchar(3) DEFAULT NULL,
  `other_party` varchar(30) DEFAULT NULL,
  `county_code` varchar(2) DEFAULT NULL,
  `election_district` varchar(3) DEFAULT NULL,
  `legislative_district` varchar(3) DEFAULT NULL,
  `town_city` varchar(30) DEFAULT NULL,
  `ward` varchar(3) DEFAULT NULL,
  `congressional_district` varchar(3) DEFAULT NULL,
  `senate_district` varchar(3) DEFAULT NULL,
  `assembly_district` varchar(3) DEFAULT NULL,
  `last_voted_date` varchar(8) DEFAULT NULL,
  `last_voted_year` varchar(4) DEFAULT NULL,
  `last_voted_county` varchar(2) DEFAULT NULL,
  `previous_address` varchar(100) DEFAULT NULL,
  `last_registered_name` varchar(150) DEFAULT NULL,
  `county_voter_reg_num` varchar(50) DEFAULT NULL,
  `application_date` varchar(8) DEFAULT NULL,
  `application_source` varchar(10) DEFAULT NULL,
  `id_required` varchar(1) DEFAULT NULL,
  `id_required_met` varchar(1) DEFAULT NULL,
  `voter_status` varchar(10) DEFAULT NULL,
  `voter_status_reason` varchar(15) DEFAULT NULL,
  `inactive_date` varchar(8) DEFAULT NULL,
  `purge_date` varchar(8) DEFAULT NULL,
  `nys_voter_id` varchar(50) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `voter_history` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `process_list`
--

DROP TABLE IF EXISTS `process_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `process_list` (
  `process_name` varchar(100) NOT NULL,
  `nys_voter_id` varchar(50) NOT NULL,
  `process_complete` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`process_name`,`nys_voter_id`),
  KEY `idx_process_complete` (`process_complete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
/*!50500 PARTITION BY LIST  COLUMNS(process_name)
(PARTITION part_refresh_history VALUES IN ('refresh_history') ENGINE = InnoDB,
 PARTITION part_refresh_email VALUES IN ('refresh_email') ENGINE = InnoDB,
 PARTITION part_refresh_first_name VALUES IN ('refresh_first_name') ENGINE = InnoDB,
 PARTITION part_refresh_last_name VALUES IN ('refresh_last_name') ENGINE = InnoDB,
 PARTITION part_refresh_phone VALUES IN ('refresh_phone') ENGINE = InnoDB,
 PARTITION part_refresh_zip5 VALUES IN ('refresh_zip5') ENGINE = InnoDB,
 PARTITION part_refresh_mailing_address VALUES IN ('refresh_mailing_address') ENGINE = InnoDB,
 PARTITION part_refresh_previous_address VALUES IN ('refresh_previous_address') ENGINE = InnoDB,
 PARTITION part_refresh_residence_address VALUES IN ('refresh_residence_address') ENGINE = InnoDB,
 PARTITION part_refresh_city VALUES IN ('refresh_city') ENGINE = InnoDB,
 PARTITION part_refresh_last_first_name VALUES IN ('refresh_last_first_name') ENGINE = InnoDB,
 PARTITION part_refresh_street_name VALUES IN ('refresh_street_name') ENGINE = InnoDB,
 PARTITION part_refresh_history2 VALUES IN ('refresh_history2') ENGINE = InnoDB) */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `process_queue`
--

DROP TABLE IF EXISTS `process_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `process_queue` (
  `connection_id` int NOT NULL,
  `process_name` varchar(100) NOT NULL,
  `nys_voter_id` varchar(50) NOT NULL,
  PRIMARY KEY (`connection_id`,`process_name`,`nys_voter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `senate_rep`
--

DROP TABLE IF EXISTS `senate_rep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `senate_rep` (
  `senate_district` varchar(3) NOT NULL,
  `representative` varchar(255) DEFAULT NULL,
  `party` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`senate_district`),
  KEY `idx_sd` (`senate_district`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `source`
--

DROP TABLE IF EXISTS `source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `source` (
  `table_name` varchar(100) DEFAULT NULL,
  `table_description` varchar(200) DEFAULT NULL,
  `table_script` longtext,
  `created_by` int DEFAULT NULL,
  `public_ind` char(1) DEFAULT 'N',
  `source_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_match_data`
--

DROP TABLE IF EXISTS `test_match_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_match_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `matchid` int DEFAULT NULL,
  `userid` int DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(10) DEFAULT NULL,
  `residence_num` varchar(10) DEFAULT NULL,
  `residence_halfnum` varchar(10) DEFAULT NULL,
  `residence_aptnum` varchar(50) DEFAULT NULL,
  `residence_pre_street_dir` varchar(20) DEFAULT NULL,
  `residence_street_name` varchar(70) DEFAULT NULL,
  `residence_post_street_dir` varchar(20) DEFAULT NULL,
  `residence_city` varchar(50) DEFAULT NULL,
  `residence_zip` varchar(10) DEFAULT NULL,
  `residence_zip_4` varchar(5) DEFAULT NULL,
  `mailing_address_1` varchar(100) DEFAULT NULL,
  `mailing_address_2` varchar(100) DEFAULT NULL,
  `mailing_address_3` varchar(100) DEFAULT NULL,
  `mailing_address_4` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(8) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `enrollment` varchar(3) DEFAULT NULL,
  `other_party` varchar(30) DEFAULT NULL,
  `county_code` varchar(2) DEFAULT NULL,
  `election_district` varchar(3) DEFAULT NULL,
  `legislative_district` varchar(3) DEFAULT NULL,
  `town_city` varchar(30) DEFAULT NULL,
  `ward` varchar(3) DEFAULT NULL,
  `congressional_district` varchar(3) DEFAULT NULL,
  `senate_district` varchar(3) DEFAULT NULL,
  `assembly_district` varchar(3) DEFAULT NULL,
  `last_voted_date` varchar(8) DEFAULT NULL,
  `last_voted_year` varchar(4) DEFAULT NULL,
  `last_voted_county` varchar(2) DEFAULT NULL,
  `previous_address` varchar(100) DEFAULT NULL,
  `last_registered_name` varchar(150) DEFAULT NULL,
  `county_voter_reg_num` varchar(50) DEFAULT NULL,
  `application_date` varchar(8) DEFAULT NULL,
  `application_source` varchar(10) DEFAULT NULL,
  `id_required` varchar(1) DEFAULT NULL,
  `id_required_met` varchar(1) DEFAULT NULL,
  `voter_status` varchar(10) DEFAULT NULL,
  `voter_status_reason` varchar(15) DEFAULT NULL,
  `inactive_date` varchar(8) DEFAULT NULL,
  `purge_date` varchar(8) DEFAULT NULL,
  `nys_voter_id` varchar(50) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `matched_voter_id` varchar(50) DEFAULT NULL,
  `queueid` int DEFAULT NULL,
  `birth_year` varchar(4) DEFAULT NULL,
  `clean_full_name` varchar(200) DEFAULT NULL,
  `clean_residence_address` varchar(300) DEFAULT NULL,
  `clean_mailing_address` varchar(450) DEFAULT NULL,
  `clean_first_name` varchar(60) DEFAULT NULL,
  `clean_last_name` varchar(60) DEFAULT NULL,
  `clean_previous_address` varchar(100) DEFAULT NULL,
  `clean_email` varchar(60) DEFAULT NULL,
  `clean_phone` varchar(60) DEFAULT NULL,
  `clean_zip5` varchar(5) DEFAULT NULL,
  `clean_residence_city` varchar(50) DEFAULT NULL,
  `clean_residence_street_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `union_match_data`
--

DROP TABLE IF EXISTS `union_match_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `union_match_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `union_name` varchar(3) NOT NULL DEFAULT '',
  `member_id` int NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `zip5` varchar(255) DEFAULT NULL,
  `full_name` text,
  `mailing_address` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `unmatched`
--

DROP TABLE IF EXISTS `unmatched`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unmatched` (
  `id` int NOT NULL AUTO_INCREMENT,
  `matchid` int DEFAULT NULL,
  `userid` int DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(10) DEFAULT NULL,
  `residence_num` varchar(10) DEFAULT NULL,
  `residence_halfnum` varchar(10) DEFAULT NULL,
  `residence_aptnum` varchar(50) DEFAULT NULL,
  `residence_pre_street_dir` varchar(20) DEFAULT NULL,
  `residence_street_name` varchar(70) DEFAULT NULL,
  `residence_post_street_dir` varchar(20) DEFAULT NULL,
  `residence_city` varchar(50) DEFAULT NULL,
  `residence_zip` varchar(10) DEFAULT NULL,
  `residence_zip_4` varchar(5) DEFAULT NULL,
  `mailing_address_1` varchar(100) DEFAULT NULL,
  `mailing_address_2` varchar(100) DEFAULT NULL,
  `mailing_address_3` varchar(100) DEFAULT NULL,
  `mailing_address_4` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(8) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `enrollment` varchar(3) DEFAULT NULL,
  `other_party` varchar(30) DEFAULT NULL,
  `county_code` varchar(2) DEFAULT NULL,
  `election_district` varchar(3) DEFAULT NULL,
  `legislative_district` varchar(3) DEFAULT NULL,
  `town_city` varchar(30) DEFAULT NULL,
  `ward` varchar(3) DEFAULT NULL,
  `congressional_district` varchar(3) DEFAULT NULL,
  `senate_district` varchar(3) DEFAULT NULL,
  `assembly_district` varchar(3) DEFAULT NULL,
  `last_voted_date` varchar(8) DEFAULT NULL,
  `last_voted_year` varchar(4) DEFAULT NULL,
  `last_voted_county` varchar(2) DEFAULT NULL,
  `previous_address` varchar(100) DEFAULT NULL,
  `last_registered_name` varchar(150) DEFAULT NULL,
  `county_voter_reg_num` varchar(50) DEFAULT NULL,
  `application_date` varchar(8) DEFAULT NULL,
  `application_source` varchar(10) DEFAULT NULL,
  `id_required` varchar(1) DEFAULT NULL,
  `id_required_met` varchar(1) DEFAULT NULL,
  `voter_status` varchar(10) DEFAULT NULL,
  `voter_status_reason` varchar(15) DEFAULT NULL,
  `inactive_date` varchar(8) DEFAULT NULL,
  `purge_date` varchar(8) DEFAULT NULL,
  `nys_voter_id` varchar(50) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `matched_voter_id` varchar(50) DEFAULT NULL,
  `queueid` int DEFAULT NULL,
  `birth_year` varchar(4) DEFAULT NULL,
  `clean_full_name` varchar(200) DEFAULT NULL,
  `clean_residence_address` varchar(300) DEFAULT NULL,
  `clean_mailing_address` varchar(450) DEFAULT NULL,
  `clean_first_name` varchar(60) DEFAULT NULL,
  `clean_last_name` varchar(60) DEFAULT NULL,
  `clean_previous_address` varchar(100) DEFAULT NULL,
  `clean_email` varchar(60) DEFAULT NULL,
  `clean_phone` varchar(60) DEFAULT NULL,
  `clean_zip5` varchar(5) DEFAULT NULL,
  `clean_residence_city` varchar(50) DEFAULT NULL,
  `clean_residence_street_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `unmatched_v`
--

DROP TABLE IF EXISTS `unmatched_v`;
/*!50001 DROP VIEW IF EXISTS `unmatched_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `unmatched_v` AS SELECT 
 1 AS `matchid`,
 1 AS `userid`,
 1 AS `last_name`,
 1 AS `first_name`,
 1 AS `middle_name`,
 1 AS `name_suffix`,
 1 AS `residence_num`,
 1 AS `residence_halfnum`,
 1 AS `residence_aptnum`,
 1 AS `residence_pre_street_dir`,
 1 AS `residence_street_name`,
 1 AS `residence_post_street_dir`,
 1 AS `residence_city`,
 1 AS `residence_zip`,
 1 AS `residence_zip_4`,
 1 AS `mailing_address_1`,
 1 AS `mailing_address_2`,
 1 AS `mailing_address_3`,
 1 AS `mailing_address_4`,
 1 AS `date_of_birth`,
 1 AS `gender`,
 1 AS `enrollment`,
 1 AS `other_party`,
 1 AS `county_code`,
 1 AS `election_district`,
 1 AS `legislative_district`,
 1 AS `town_city`,
 1 AS `ward`,
 1 AS `congressional_district`,
 1 AS `senate_district`,
 1 AS `assembly_district`,
 1 AS `last_voted_date`,
 1 AS `last_voted_year`,
 1 AS `last_voted_county`,
 1 AS `previous_address`,
 1 AS `last_registered_name`,
 1 AS `county_voter_reg_num`,
 1 AS `application_date`,
 1 AS `application_source`,
 1 AS `id_required`,
 1 AS `id_required_met`,
 1 AS `voter_status`,
 1 AS `voter_status_reason`,
 1 AS `inactive_date`,
 1 AS `purge_date`,
 1 AS `nys_voter_id`,
 1 AS `telephone`,
 1 AS `email`,
 1 AS `matched_voter_id`,
 1 AS `queueid`,
 1 AS `birth_year`,
 1 AS `clean_full_name`,
 1 AS `clean_residence_address`,
 1 AS `clean_mailing_address`,
 1 AS `clean_first_name`,
 1 AS `clean_last_name`,
 1 AS `clean_previous_address`,
 1 AS `clean_email`,
 1 AS `clean_phone`,
 1 AS `clean_zip5`,
 1 AS `clean_residence_city`,
 1 AS `clean_residence_street_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_city`
--

DROP TABLE IF EXISTS `voter_city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_city` (
  `nys_voter_id` varchar(50) NOT NULL,
  `residence_city` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `idx_city` (`residence_city`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `voter_city_v`
--

DROP TABLE IF EXISTS `voter_city_v`;
/*!50001 DROP VIEW IF EXISTS `voter_city_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `voter_city_v` AS SELECT 
 1 AS `nys_voter_id`,
 1 AS `residence_city`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_data`
--

DROP TABLE IF EXISTS `voter_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_data` (
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(10) DEFAULT NULL,
  `residence_num` varchar(10) DEFAULT NULL,
  `residence_halfnum` varchar(10) DEFAULT NULL,
  `residence_aptnum` varchar(15) DEFAULT NULL,
  `residence_pre_street_dir` varchar(20) DEFAULT NULL,
  `residence_street_name` varchar(70) DEFAULT NULL,
  `residence_post_street_dir` varchar(20) DEFAULT NULL,
  `residence_city` varchar(50) DEFAULT NULL,
  `residence_zip` varchar(10) DEFAULT NULL,
  `residence_zip_4` varchar(5) DEFAULT NULL,
  `mailing_address_1` varchar(100) DEFAULT NULL,
  `mailing_address_2` varchar(100) DEFAULT NULL,
  `mailing_address_3` varchar(100) DEFAULT NULL,
  `mailing_address_4` varchar(100) DEFAULT NULL,
  `date_of_birth` varchar(8) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `enrollment` varchar(3) DEFAULT NULL,
  `other_party` varchar(30) DEFAULT NULL,
  `county_code` varchar(2) DEFAULT NULL,
  `election_district` varchar(3) DEFAULT NULL,
  `legislative_district` varchar(3) DEFAULT NULL,
  `town_city` varchar(30) DEFAULT NULL,
  `ward` varchar(3) DEFAULT NULL,
  `congressional_district` varchar(3) DEFAULT NULL,
  `senate_district` varchar(3) DEFAULT NULL,
  `assembly_district` varchar(3) DEFAULT NULL,
  `last_voted_date` varchar(8) DEFAULT NULL,
  `last_voted_year` varchar(4) DEFAULT NULL,
  `last_voted_county` varchar(2) DEFAULT NULL,
  `previous_address` varchar(100) DEFAULT NULL,
  `last_registered_name` varchar(150) DEFAULT NULL,
  `county_voter_reg_num` varchar(50) DEFAULT NULL,
  `application_date` varchar(8) DEFAULT NULL,
  `application_source` varchar(10) DEFAULT NULL,
  `id_required` varchar(1) DEFAULT NULL,
  `id_required_met` varchar(1) DEFAULT NULL,
  `voter_status` varchar(10) DEFAULT NULL,
  `voter_status_reason` varchar(15) DEFAULT NULL,
  `inactive_date` varchar(8) DEFAULT NULL,
  `purge_date` varchar(8) DEFAULT NULL,
  `nys_voter_id` varchar(50) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `voter_history` varchar(2000) DEFAULT NULL,
  `sourceYYYYMM` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `idx_date_of_birth` (`date_of_birth`),
  KEY `idx_gender` (`gender`),
  KEY `idx_enrollment` (`enrollment`),
  KEY `idx_county_code` (`county_code`),
  KEY `idx_election_district` (`election_district`),
  KEY `idx_legislative_district` (`legislative_district`),
  KEY `idx_town_city` (`town_city`),
  KEY `idx_ward` (`ward`),
  KEY `idx_congressional_district` (`congressional_district`),
  KEY `idx_senate_district` (`senate_district`),
  KEY `idx_assembly_district` (`assembly_district`),
  KEY `idx_last_voted_date` (`last_voted_date`),
  KEY `idx_last_voted_year` (`last_voted_year`),
  KEY `idx_last_registered_name` (`last_registered_name`),
  KEY `idx_voter_status` (`voter_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `voter_email`
--

DROP TABLE IF EXISTS `voter_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_email` (
  `nys_voter_id` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `voter_email_v`
--

DROP TABLE IF EXISTS `voter_email_v`;
/*!50001 DROP VIEW IF EXISTS `voter_email_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `voter_email_v` AS SELECT 
 1 AS `nys_voter_id`,
 1 AS `email`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_first_name`
--

DROP TABLE IF EXISTS `voter_first_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_first_name` (
  `nys_voter_id` varchar(50) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `first_name_UNIQUE` (`first_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `voter_first_name_v`
--

DROP TABLE IF EXISTS `voter_first_name_v`;
/*!50001 DROP VIEW IF EXISTS `voter_first_name_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `voter_first_name_v` AS SELECT 
 1 AS `nys_voter_id`,
 1 AS `first_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_full_name`
--

DROP TABLE IF EXISTS `voter_full_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_full_name` (
  `nys_voter_id` varchar(50) NOT NULL,
  `full_name` varchar(163) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `full_name_UNIQUE` (`full_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `voter_full_name_v`
--

DROP TABLE IF EXISTS `voter_full_name_v`;
/*!50001 DROP VIEW IF EXISTS `voter_full_name_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `voter_full_name_v` AS SELECT 
 1 AS `nys_voter_id`,
 1 AS `full_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_history`
--

DROP TABLE IF EXISTS `voter_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_history` (
  `nys_voter_id` varchar(50) NOT NULL,
  `election_name` varchar(150) NOT NULL,
  PRIMARY KEY (`nys_voter_id`,`election_name`),
  KEY `idx_nys_voter_id` (`nys_voter_id`),
  KEY `idx_election_name` (`election_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `voter_last_first_name_v`
--

DROP TABLE IF EXISTS `voter_last_first_name_v`;
/*!50001 DROP VIEW IF EXISTS `voter_last_first_name_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `voter_last_first_name_v` AS SELECT 
 1 AS `nys_voter_id`,
 1 AS `last_first_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_last_name`
--

DROP TABLE IF EXISTS `voter_last_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_last_name` (
  `nys_voter_id` varchar(50) NOT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `last_name_UNIQUE` (`last_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `voter_last_name_v`
--

DROP TABLE IF EXISTS `voter_last_name_v`;
/*!50001 DROP VIEW IF EXISTS `voter_last_name_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `voter_last_name_v` AS SELECT 
 1 AS `nys_voter_id`,
 1 AS `last_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_mailing_address`
--

DROP TABLE IF EXISTS `voter_mailing_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_mailing_address` (
  `nys_voter_id` varchar(50) NOT NULL,
  `mailing_address` varchar(403) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `idx_mailing_address` (`mailing_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `voter_mailing_address_v`
--

DROP TABLE IF EXISTS `voter_mailing_address_v`;
/*!50001 DROP VIEW IF EXISTS `voter_mailing_address_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `voter_mailing_address_v` AS SELECT 
 1 AS `nys_voter_id`,
 1 AS `mailing_address`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `voter_name_part`
--

DROP TABLE IF EXISTS `voter_name_part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_name_part` (
  `nys_voter_id` varchar(50) NOT NULL,
  `last_first_name` varchar(200) DEFAULT NULL,
  `first_initial` varchar(1) DEFAULT NULL,
  `first_name_part4` varchar(4) DEFAULT NULL,
  `first_name_part3` varchar(3) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `full_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`nys_voter_id`),
  KEY `idx_last_first` (`last_first_name`) /*!80000 INVISIBLE */,
  KEY `idx_last` (`last_name`) /*!80000 INVISIBLE */,
  KEY `idx_first` (`first_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'dcnxs_ny'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_match` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `add_match`(IN in_user_id INT(11), IN in_filename VARCHAR(200), IN in_map LONGTEXT)
    MODIFIES SQL DATA
BEGIN
DECLARE matchid INT;

 INSERT INTO matches (userid, matchfile_name, matchmap, status, date_submitted) VALUES 
 (in_user_id, in_filename, in_map, 'QUEUED', CURRENT_TIMESTAMP);
  SET matchid = LAST_INSERT_ID(); 
 COMMIT;
SELECT matchid FROM DUAL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `clean_match_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `clean_match_data`(IN in_matchid INT)
BEGIN
UPDATE match_data set clean_full_name = clean_full_name(first_name, middle_name, last_name, name_suffix) WHERE matchid = in_matchid;
UPDATE match_data SET clean_mailing_address = clean_mailing_address(mailing_address_1, mailing_address_2, mailing_address_3, mailing_address_4)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_first_name = clean_data_part(first_name)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_last_name = clean_data_part(last_name)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_residence_city = clean_data_part(residence_city)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_residence_street_name = clean_data_part(residence_street_name)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_email = clean_email(email)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_phone = clean_phone(telephone)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_zip5 = clean_zip5(residence_zip)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_residence_address = clean_residence_address(residence_num, residence_halfnum, residence_aptnum, residence_pre_street_dir, residence_street_name, residence_post_street_dir, residence_city, residence_zip)  WHERE matchid = in_matchid;
UPDATE match_data SET clean_previous_address = clean_previous_address(previous_address)  WHERE matchid = in_matchid;
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `delete_list`(IN in_userid INT, in in_listid INT)
BEGIN
DELETE FROM lists WHERE userid = in_userid and listid = in_listid;
SELECT in_listid as listid FROM DUAL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_match` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `delete_match`(IN in_userid INT(11), IN in_matchid INT(11))
    MODIFIES SQL DATA
BEGIN
DECLARE v_matchtable VARCHAR(255);
SET SQL_SAFE_UPDATES = 0;
-- Delete dynamically created table

SET @v = (SELECT CONCAT('DROP TABLE ', GROUP_CONCAT(matchtable)) FROM matches WHERE userid = in_userid AND matchid = in_matchid);
PREPARE s FROM @v;
EXECUTE s;

-- Delete match data
DELETE FROM match_data WHERE userid = in_userid AND matchid = in_matchid;

-- Delete potential matches
DELETE FROM match_potentials WHERE userid = in_userid AND matchid = in_matchid;

-- Delete match
DELETE FROM matches WHERE userid = in_userid AND matchid = in_matchid;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `do_match` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `do_match`(IN in_userid INT(11), IN in_matchid INT(11))
BEGIN
DELETE FROM match_potentials WHERE matchid = in_matchid AND userid = in_userid;

UPDATE matches 
SET 
    status = 'MATCHING',
    date_completed = NULL,
    date_submitted = CURRENT_TIMESTAMP
WHERE
    matchid = in_matchid
        AND userid = in_userid;            
        
-- Full name and address exact
REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '151', 'FULLNAMEADDREXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_full_name fn
ON (fn.full_name = md.clean_full_name)
JOIN voter_residence_address ra
ON (ra.residence_address = md.clean_residence_address AND ra.nys_voter_id = fn.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = fn.nys_voter_id AND vd.nys_voter_id = ra.nys_voter_id)
WHERE md.matchid = in_matchid
AND md.userid = in_userid);

-- Street name, city, last name, first name exact
REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '101', 'FNLNCITYSTREETEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN dcnxs_ny.voter_street_name sn
ON (sn.residence_street_name = md.clean_residence_street_name)
JOIN dcnxs_ny.voter_city vc
ON (vc.residence_city = md.clean_residence_city AND vc.nys_voter_id = sn.nys_voter_id)
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name) AND ln.nys_voter_id = sn.nys_voter_id)
JOIN dcnxs_ny.voter_first_name fn
ON (fn.first_name = md.clean_first_name AND fn.nys_voter_id = sn.nys_voter_id)
JOIN dcnxs_ny.voter_data vd
ON (vc.nys_voter_id = vd.nys_voter_id)
LEFT JOIN match_potentials mp
ON (mp.queueid = md.queueid)
WHERE mp.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- Street name, zip, last name, first name exact
REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '101', 'STREETZIPLNAMEFNAMEEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN dcnxs_ny.voter_street_name sn
ON (sn.residence_street_name = md.clean_residence_street_name)
JOIN dcnxs_ny.voter_zip5 z5
ON (z5.zip5 = md.clean_zip5 AND z5.nys_voter_id = sn.nys_voter_id)
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name) AND ln.nys_voter_id = sn.nys_voter_id)
JOIN dcnxs_ny.voter_data vd
ON (vd.nys_voter_id = sn.nys_voter_id)
LEFT JOIN match_potentials mp
ON (mp.queueid = md.queueid)
WHERE mp.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- Telephone, last name first name exact
REPLACE INTO match_potentials
(SELECT md.userid, md.matchid, md.queueid, '101', 'PHONEEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_phone vp
ON (vp.phone = md.clean_phone)
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name) AND ln.nys_voter_id = vp.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = vp.nys_voter_id AND ln.nys_voter_id = vd.nys_voter_id)
LEFT JOIN match_potentials mp
ON (mp.queueid = md.queueid)
WHERE mp.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first/last mailing = residence
REPLACE INTO match_potentials
(SELECT md.userid, md.matchid, md.queueid, '101', 'FNAMELNAMEMAILINGRESIDENCEEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN voter_mailing_address ma
 ON (ma.mailing_address = md.clean_residence_address and ln.nys_voter_id = ma.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = ln.nys_voter_id)
WHERE md.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- Email exact
REPLACE INTO match_potentials
(SELECT md.userid, md.matchid, md.queueid, '101', 'EMAILEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_email vm
ON (UPPER(vm.email) = UPPER(md.clean_email))
JOIN voter_data vd
ON (vd.nys_voter_id = vm.nys_voter_id)
LEFT JOIN match_potentials mp
ON (mp.queueid = md.queueid)
WHERE mp.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- full name mailing exact
REPLACE INTO match_potentials
(SELECT
md.userid, md.matchid, md.queueid, '101', 'FULLNAMEMAILINGEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_full_name fn
ON (fn.full_name = md.clean_full_name)
JOIN voter_mailing_address ra
ON (ra.mailing_address = md.clean_mailing_address AND md.clean_mailing_address != md.clean_residence_address and fn.nys_voter_id = ra.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = fn.nys_voter_id)
LEFT JOIN match_potentials mp
ON (mp.queueid = md.queueid)
WHERE mp.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first/last residence = mailing
REPLACE INTO match_potentials
(SELECT
md.userid, md.matchid, md.queueid, '101', 'FNAMELNAMERESIDENCEMAILINGEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN voter_residence_address ra
 ON (ra.residence_address = md.clean_mailing_address and ln.nys_voter_id = ra.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = ln.nys_voter_id)
WHERE md.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first/last mailing exact
REPLACE INTO match_potentials
(SELECT
md.userid, md.matchid, md.queueid, '101', 'FNAMELNAMEMAILINGEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN voter_mailing_address ra
ON (ra.mailing_address = md.clean_mailing_address AND md.clean_mailing_address != md.clean_residence_address and ln.nys_voter_id = ra.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = ln.nys_voter_id)
WHERE md.queueid IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- Stromg matches complete
update dcnxs_ny.match_data md
join dcnxs_ny.match_potentials mp on
(md.queueid = mp.queueid
and md.userid = mp.userid
and md.matchid = mp.matchid)
set md.matched_voter_id = mp.nys_voter_id
WHERE mp.score > 100
and mp.userid = in_userid and mp.matchid = in_matchid;

-- Last name, first name, date of birth exact
REPLACE INTO match_potentials
(SELECT md.userid, md.matchid, md.queueid, '80', 'LNAMEFNAMEDOBEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN dcnxs_ny.voter_data vd
ON (ln.nys_voter_id = vd.nys_voter_id AND vd.gender = md.gender AND SUBSTRING(vd.date_of_birth, 1, 4) IN (md.birth_year, md.birth_year - 1))
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first/last mailing = previous
REPLACE INTO match_potentials
(SELECT md.userid, md.matchid, md.queueid, '90', 'FNAMELNAMEMAILINGPREVIOUSEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN voter_mailing_address ra
ON (ra.mailing_address = md.clean_previous_address and ln.nys_voter_id = ra.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = ln.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first/last previous = mailing
REPLACE INTO match_potentials
(SELECT
md.userid, md.matchid, md.queueid, '90', 'FNAMELNAMEPREVIOUSMAILINGEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN voter_previous_address ra
ON (ra.previous_address = md.clean_mailing_address and ln.nys_voter_id = ra.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = ln.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first/last previous = residence
REPLACE INTO match_potentials
(SELECT
md.userid, md.matchid, md.queueid, '90', 'FNAMELNAMEPREVIOUSRESIDENCEEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN voter_previous_address ra
ON (ra.previous_address = md.clean_residence_address and ln.nys_voter_id = ra.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = ln.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first/last residence = previous
REPLACE INTO match_potentials
(SELECT
md.userid, md.matchid, md.queueid, '90', 'FNAMELNAMERESIDENCEPREVIOUSEXACT', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part ln
ON (ln.last_first_name = CONCAT(md.clean_last_name, md.clean_first_name))
JOIN voter_residence_address ra
ON (ra.residence_address = md.clean_previous_address and ln.nys_voter_id = ra.nys_voter_id)
JOIN voter_data vd
ON (vd.nys_voter_id = ln.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid);

-- first name, part last name, residence number, street
REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '50', 'FNPARTLNRNUMSTREET', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part n1
ON (n1.last_name = md.clean_last_name AND n1.first_name_part4 = SUBSTRING(md.clean_first_name, 1, 4))
JOIN voter_data vd
ON (vd.nys_voter_id = n1.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid
AND vd.residence_num = md.residence_num
AND vd.residence_street_name = md.clean_residence_street_name);

-- full name, city
REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '50', 'FULLNAMECITY', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_full_name fn
ON (fn.full_name = md.clean_full_name)
JOIN voter_data vd
ON (vd.nys_voter_id = fn.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid
AND vd.residence_city = md.clean_residence_city);

-- last name, first name part, city, residence num
REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '50', 'FNPARTLNCITYRNUM', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part n1
ON (n1.last_name = md.clean_last_name AND n1.first_name_part4 = SUBSTRING(md.clean_first_name, 1, 4))
JOIN voter_data vd
ON (vd.nys_voter_id = n1.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid
AND vd.residence_num = md.residence_num
AND vd.residence_city = md.clean_residence_city);

-- first initial, last name, mailing similar
REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '50', 'FINITIALLNMAILINGLIKE', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_name_part n1
ON (n1.last_name = md.clean_last_name AND n1.first_initial = SUBSTRING(md.clean_first_name, 1, 1))
JOIN voter_data vd
ON (vd.nys_voter_id = n1.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid
AND TRIM(vd.mailing_address_1) > ''
AND md.clean_mailing_address like CONCAT(vd.mailing_address_1, '%'));

/*REPLACE INTO match_potentials
(SELECT 
md.userid, md.matchid, md.queueid, '20', 'LNPARTRNUMZIPGENDERPARTSTREET', vd.nys_voter_id
FROM dcnxs_ny.match_data md
JOIN voter_last_name n1
ON (n1.last_name = md.clean_last_name)
JOIN voter_data vd
ON (vd.nys_voter_id = n1.nys_voter_id)
WHERE md.matched_voter_id IS NULL
AND md.matchid = in_matchid
AND md.userid = in_userid
AND LEFT(md.residence_street_name ,LOCATE(' ',md.residence_street_name) - 1) = LEFT(vd.residence_street_name ,LOCATE(' ',vd.residence_street_name ) - 1)
and md.gender = vd.gender
and md.clean_zip5 = vd.residence_zip
and SUBSTRING(md.residence_num, 1, 2) =  SUBSTRING(vd.residence_num, 1, 2));*/

UPDATE matches 
SET 
    status = 'PASS1',
    date_completed = CURRENT_TIMESTAMP
WHERE matchid = in_matchid
	AND userid = in_userid;            
COMMIT;
           
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fuzzy_first_last_city` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `fuzzy_first_last_city`()
BEGIN
SELECT 
REGEXP_REPLACE(CONCAT(md.first_name, md.clean_last_name, md.clean_residence_city, md.clean_zip5), '\\s+', '') as n1,
REGEXP_REPLACE(CONCAT(vf.first_name, vl.last_name, vc.residence_city, z5.zip5), '\\s+', '') as n2,
mp.nys_voter_id,
mp.userid,
mp.matchid, 
mp.queueid,
vd.voter_status
from dcnxs_ny.match_data md 
left join dcnxs_ny.match_potentials mp
on (md.queueid = mp.queueid and mp.score <= '100')
join dcnxs_ny.matches m
on (m.matchid = md.matchid and m.userid = md.userid and m.status = 'PASS1')
join dcnxs_ny.voter_first_name vf
on (vf.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_last_name vl
on (vl.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_city vc
on (vc.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_zip5 z5
on (z5.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_full_name vfn
on (vfn.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_residence_address vra
on (vra.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_data vd 
on (vd.nys_voter_id = mp.nys_voter_id and vd.voter_status in ('ACTIVE', 'PREREG'));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fuzzy_name_address` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `fuzzy_name_address`()
BEGIN
SELECT 
REGEXP_REPLACE(CONCAT(md.clean_full_name, md.clean_residence_address), '\\s+', '') as n1,
REGEXP_REPLACE(CONCAT(vfn.full_name, vra.residence_address), '\\s+', '') as n2,
mp.nys_voter_id,
mp.userid,
mp.matchid, 
mp.queueid
from dcnxs_ny.match_data md 
left join dcnxs_ny.match_potentials mp
on (md.queueid = mp.queueid and mp.score <= '100')
join dcnxs_ny.matches m
on (m.matchid = md.matchid and m.userid = md.userid and m.status = 'PASS1')
join dcnxs_ny.voter_full_name vfn
on (vfn.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_residence_address vra
on (vra.nys_voter_id = mp.nys_voter_id)
join dcnxs_ny.voter_data vd 
on (vd.nys_voter_id = mp.nys_voter_id and vd.voter_status in ('ACTIVE', 'PREREG'));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `get_list`(IN in_userid INT, IN in_listid INT)
BEGIN
SELECT listid, userid, list_name, list_count, source, query, DATE_FORMAT(DATE_SUB(date_modified, INTERVAL 4 HOUR), '%M %e, %Y %l:%i %p') as date_modified FROM dcnxs_ny.lists WHERE listid = in_listid AND userid = in_userid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_lists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `get_lists`(IN in_userid INT)
BEGIN
SELECT listid, userid, list_name, list_count, source, query, DATE_FORMAT(DATE_SUB(date_modified, INTERVAL 4 HOUR), '%M %e, %Y %l:%i %p') as date_modified FROM dcnxs_ny.lists WHERE userid = in_userid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_matches` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `get_matches`(IN in_user_id INT(11), IN in_match_id INT(11))
BEGIN

SELECT y.queueid, y.score, y.nys_voter_id, y.matchtype FROM (
  SELECT queueid, max(score) as score, nys_voter_id, 'LIKELY' as matchtype FROM (
    SELECT queueid, sum(score) as score,  nys_voter_id FROM match_potentials
      WHERE userid = in_user_id
      AND matchid = in_match_id
      GROUP BY nys_voter_id, queueid) x
    GROUP BY  queueid
    HAVING max(score) >= 100
  UNION
  SELECT queueid, max(score) as score, nys_voter_id, 'POSSIBLE' as matchtype FROM ( 
    SELECT queueid, sum(score) as score,  nys_voter_id FROM match_potentials
    WHERE userid = in_user_id
    AND matchid = in_match_id
    GROUP BY nys_voter_id, queueid) x
  GROUP BY queueid
  HAVING max(score) BETWEEN 51 and 99
  UNION
  SELECT queueid, max(score) as score, nys_voter_id, 'UNLIKELY' as matchtype FROM (
    SELECT queueid, sum(score) as score,  nys_voter_id FROM match_potentials
    WHERE userid = in_user_id
    AND matchid = in_match_id
    GROUP BY nys_voter_id, queueid) x
  GROUP BY queueid
  HAVING max(score) BETWEEN 0 and 50
  UNION
  SELECT match_data.queueid, 0 as score, NULL, 'NOMATCH' as matchtype
  FROM match_data
  LEFT JOIN match_potentials
  ON (match_potentials.queueid = match_data.queueid)
  WHERE match_potentials.queueid IS NULL  
  AND match_data.userid = in_user_id
  AND match_data.matchid = in_match_id
) y
ORDER BY queueid;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_potentials` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `get_potentials`(IN in_user_id INT(11), IN in_match_id INT(11), IN in_queue_start INT(11), IN in_queue_end INT(11))
BEGIN

select 
x.queueid,
x.score,
x.matched_on,
vd.nys_voter_id,
vd.first_name,
vd.last_name,
vd.name_suffix, 
vd.residence_num, 
vd.residence_halfnum, 
vd.residence_aptnum, 
vd.residence_pre_street_dir, 
vd.residence_street_name, 
vd.residence_post_street_dir, 
vd.residence_city, 
vd.residence_zip, 
vd.residence_zip_4, 
vd.mailing_address_1, 
vd.mailing_address_2, 
vd.mailing_address_3, 
vd.mailing_address_4, 
vd.date_of_birth, 
vd.gender, 
vd.enrollment, 
vd.other_party, 
vd.county_code, 
vd.election_district, 
vd.legislative_district, 
vd.town_city, 
vd.ward, 
vd.congressional_district, 
vd.senate_district, 
vd.assembly_district, 
vd.last_voted_date, 
vd.last_voted_year, 
vd.last_voted_county, 
vd.previous_address, 
vd.last_registered_name, 
vd.county_voter_reg_num, 
vd.application_date, 
vd.application_source, 
vd.id_required, 
vd.id_required_met, 
vd.voter_status, 
vd.voter_status_reason, 
vd.inactive_date, 
vd.purge_date, 
vd.voter_history, 
vd.telephone, 
vd.email
from voter_data vd
JOIN (select queueid, sum(score) as score,  GROUP_CONCAT(matchkey
        ORDER BY score desc
        SEPARATOR '|') as matched_on, nys_voter_id from match_potentials
where userid = in_user_id
and matchid = in_match_id
and queueid between in_queue_start and in_queue_end
group by nys_voter_id, queueid) x
ON (x.nys_voter_id = vd.nys_voter_id)
order by x.queueid, vd.voter_status, x.score desc;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_matches` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `get_user_matches`(IN in_userid INT)
BEGIN
SELECT m.matchid, m.matchfile_name, m.userid, u.display_name as submitted_by, m.status, m.matchtable, md.matchcount, mc.matched, (mp.potentialcount - mc.matched) as potentialcount, (md.matchcount - mp.potentialcount) as unmatched,
DATE_FORMAT(m.date_submitted, '%M %e, %Y %l:%i %p') as date_submitted, DATE_FORMAT(m.date_completed, '%M %e, %Y %l:%i %p') as date_completed
FROM dcnxs_ny.matches m
LEFT JOIN (SELECT matchid, userid, count(queueid) AS matchcount FROM dcnxs_ny.match_data GROUP BY matchid, userid) md
ON (md.matchid = m.matchid)
LEFT JOIN dcnxs_app.users u
ON (u.userid = m.userid)
LEFT JOIN (SELECT matchid, userid, count(DISTINCT(queueid)) AS potentialcount FROM dcnxs_ny.match_potentials GROUP BY matchid, userid) mp
ON (mp.matchid = md.matchid AND mp.userid = md.userid)
LEFT JOIN (select matchid, userid, count(DISTINCT(queueid)) AS matched from dcnxs_ny.match_data where matched_voter_id is not null GROUP BY matchid, userid) mc
ON (md.matchid = mc.matchid and md.userid = mc.userid)
WHERE m.userid = in_userid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `save_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `save_list`(IN in_user_id INT(11), IN in_list_name VARCHAR(255), IN in_list_count INT, IN in_source VARCHAR(45), IN in_query LONGTEXT)
BEGIN
DECLARE c INT DEFAULT 0;
SELECT count(*) INTO c FROM lists WHERE userid = in_user_id AND UPPER(list_name) = UPPER(in_list_name);
IF (c > 0) THEN
SELECT "You already have a list with this name" as err FROM DUAL;
ELSE
INSERT INTO lists (userid, list_name, list_count, source, query) VALUES (in_user_id, in_list_name, in_list_count, in_source, in_query);
SELECT listid, userid, list_name, list_count, source, query, DATE_FORMAT(date_modified, '%M %e, %Y %l:%i %p') as date_modified FROM lists where listid = last_insert_id();
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `set_fuzzy_match` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `set_fuzzy_match`()
BEGIN
UPDATE dcnxs_ny.match_data md
JOIN (
SELECT mp.queueid, mp.matchid, mp.userid, sum(mp.score) as score, mp.nys_voter_id from dcnxs_ny.match_potentials mp
JOIN matches m
ON (m.matchid = mp.matchid and m.userid = mp.userid and m.status = 'PASS1')
group by mp.nys_voter_id, mp.queueid, mp.matchid, mp.userid
HAVING max(score)) x
ON (x.matchid = md.matchid and x.queueid = md.queueid and x.userid = md.userid)
SET md.matched_voter_id = x.nys_voter_id
WHERE x.score > '100';
COMMIT;
UPDATE dcnxs_ny.matches m
SET m.status = 'COMPLETE' WHERE m.status = 'PASS1';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `set_strong_match` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `set_strong_match`(IN in_userid INT, IN in_matchid INT )
BEGIN
update dcnxs_ny.match_data md
join dcnxs_ny.match_potentials mp on
(md.queueid = mp.queueid
and md.userid = mp.userid
and md.matchid = mp.matchid)
set md.matched_voter_id = mp.nys_voter_id
WHERE mp.score > 100
and mp.userid = in_userid and mp.matchid = in_matchid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `update_list`(IN in_userid INT(11), IN in_listid INT, IN in_list_count INT, IN in_query LONGTEXT)
BEGIN
UPDATE lists SET list_count = in_list_count, query = in_query 
WHERE userid = in_userid AND listid = in_listid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `nxsidx_app`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `nxsidx_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `nxsidx_app`;

--
-- Table structure for table `saved_lists`
--

DROP TABLE IF EXISTS `saved_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_lists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userid` int DEFAULT NULL,
  `saveid` int DEFAULT NULL,
  `save_name` mediumtext,
  `search_type` varchar(50) DEFAULT NULL,
  `search_parameters` longtext,
  `record_count` int DEFAULT NULL,
  `route_name` text,
  `time_ran` datetime DEFAULT NULL,
  `time_saved` datetime DEFAULT NULL,
  `time_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `saved_lists_pk` (`userid`,`saveid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `saved_pages`
--

DROP TABLE IF EXISTS `saved_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_pages` (
  `userid` int DEFAULT NULL,
  `saveid` int NOT NULL AUTO_INCREMENT,
  `page_title` mediumtext,
  `page_type` mediumtext,
  `route_name` text,
  `route_params` text,
  `location` longtext,
  `time_saved` datetime DEFAULT NULL,
  `time_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`saveid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `saved_searches`
--

DROP TABLE IF EXISTS `saved_searches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_searches` (
  `userid` int DEFAULT NULL,
  `saveid` int NOT NULL AUTO_INCREMENT,
  `save_name` text,
  `search_type` varchar(50) DEFAULT NULL,
  `search_parameters` longtext,
  `record_count` int DEFAULT NULL,
  `route_name` text,
  `time_ran` datetime DEFAULT NULL,
  `time_saved` datetime DEFAULT CURRENT_TIMESTAMP,
  `time_modified` datetime DEFAULT NULL,
  PRIMARY KEY (`saveid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'nxsidx_app'
--
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_delete_saved_page` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_delete_saved_page`(IN in_userid int, IN in_saveid int)
    MODIFIES SQL DATA
BEGIN
SET SQL_SAFE_UPDATES = 0;

DELETE FROM saved_pages WHERE userid = in_userid AND saveid = in_saveid;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_delete_saved_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_delete_saved_search`(IN in_userid int, IN in_saveid int)
    MODIFIES SQL DATA
BEGIN
SET SQL_SAFE_UPDATES = 0;

DELETE FROM saved_searches WHERE userid = in_userid AND saveid = in_saveid;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_edit_saved_page` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_edit_saved_page`(IN in_userid int, IN in_saveid int, IN in_pagetitle varchar(255))
    MODIFIES SQL DATA
BEGIN
    SET SQL_SAFE_UPDATES = 0;

UPDATE nxsidx_app.saved_pages sp SET sp.page_title = in_pagetitle WHERE userid = in_userid AND saveid = in_saveid;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_edit_saved_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_edit_saved_search`(IN in_userid int, IN in_saveid int, IN in_savename varchar(255))
    MODIFIES SQL DATA
BEGIN
    SET SQL_SAFE_UPDATES = 0;

UPDATE nxsidx_app.saved_searches sl SET sl.save_name = in_savename WHERE userid = in_userid AND saveid = in_saveid;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_get_bookmark_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_get_bookmark_status`(IN in_userid int, IN in_page_location text)
BEGIN
SELECT userid, saveid FROM nxsidx_app.saved_pages WHERE userid = in_userid AND location = in_page_location;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_get_saved_lists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_get_saved_lists`(IN in_userid int)
BEGIN
SELECT userid, saveid, save_name, search_type, search_parameters, record_count, route_name, time_ran, time_saved, time_modified
FROM nxsidx_app.saved_lists sl
WHERE userid = in_userid
ORDER BY sl.time_modified DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_get_saved_pages` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_get_saved_pages`(IN in_userid int)
BEGIN
SELECT userid, saveid, page_title, page_type, route_name, route_params, location, time_saved, time_modified FROM nxsidx_app.saved_pages WHERE userid = in_userid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_get_single_saved_search` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_get_single_saved_search`(IN in_userid int, IN in_saveid int)
BEGIN
SELECT userid, saveid, save_name, search_type, search_parameters, record_count, route_name, time_ran, time_saved, time_modified FROM nxsidx_app.saved_searches WHERE userid = in_userid AND saveid = in_saveid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_get_transactions_by_filing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_get_transactions_by_filing`(IN in_filer_id int, IN in_election_year int,
                                                                         IN in_filing_abbrev varchar(1),
                                                                         IN in_transaction_type varchar(20))
BEGIN
    DECLARE filing_array VARCHAR(50);
    IF (in_transaction_type like 'CONTRIBUTIONS') THEN
        SET filing_array = "'A','B','C','D','E','G','I','K','L'";
    ELSEIF (in_transaction_type like 'EXPENDITURES') THEN
        SET filing_array = "'A','B','C','D','E','G','I','K','L'";
END IF;
SELECT td.unique_id, td.filer_id, td.election_year, td.filing_abbreviation, td.filing_schedule_abbreviation, td.loan_liability_id, td.transaction_number, td.transaction_date, td.contributor_type, td.contribution_type, td.transfer_type, td.receipt_type, td.receipt_code, td.purpose_code, td.is_subcontractor, td.donor_organization_name, td.donor_first_name, td.donor_middle_name, td.donor_last_name, td.donor_address, td.donor_city, td.donor_state, td.donor_zip, td.donor_country, td.payment_type, td.payment_number, td.owed_amount, td.original_amount, td.loan_type, td.transaction_explanation, td.is_itemized, td.is_liability
FROM
    nxsidx_ny.nys_transaction_data_child td
WHERE td.filer_id = in_filer_id
  AND td.election_year = in_election_year
  AND td.filing_abbreviation = in_filing_abbrev
  AND td.filing_schedule_abbreviation IN (filing_array);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `nxsidx_ny`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `nxsidx_ny` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `nxsidx_ny`;

--
-- Table structure for table `nys_committee_types`
--

DROP TABLE IF EXISTS `nys_committee_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_committee_types` (
  `committee_id` int NOT NULL,
  `committee_type` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`committee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_counties`
--

DROP TABLE IF EXISTS `nys_counties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_counties` (
  `id` int NOT NULL AUTO_INCREMENT,
  `county_code` varchar(2) DEFAULT NULL,
  `county_name` varchar(100) DEFAULT NULL,
  `state_code` varchar(10) DEFAULT NULL,
  `county_fips` int DEFAULT NULL,
  `latitude` decimal(11,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `geojson` json DEFAULT NULL,
  `registered_voters` int DEFAULT NULL,
  `population` int DEFAULT NULL,
  `updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_nxsidx_nycounties_ct` (`county_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_county_committees`
--

DROP TABLE IF EXISTS `nys_county_committees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_county_committees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `county` varchar(255) DEFAULT NULL,
  `district_abbreviation` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `ward` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `suffix_name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `address_city` varchar(255) DEFAULT NULL,
  `address_state` varchar(255) DEFAULT NULL,
  `address_zip` varchar(30) DEFAULT NULL,
  `address_zip4` varchar(255) DEFAULT NULL,
  `affiliation` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `office_desc` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `legislative_district` varchar(255) DEFAULT NULL,
  `assembly_district` varchar(255) DEFAULT NULL,
  `imported_timestamp` timestamp NULL DEFAULT NULL,
  `updated_timestamp` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_nxsidx_committees_county` (`county`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_filer_data_geo`
--

DROP TABLE IF EXISTS `nys_filer_data_geo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_filer_data_geo` (
  `filer_id` int NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `accuracy` double DEFAULT NULL,
  `accuracy_type` varchar(25) DEFAULT NULL,
  `street_number` varchar(25) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `unit_type` varchar(10) DEFAULT NULL,
  `unit_number` varchar(10) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `county` varchar(25) DEFAULT NULL,
  `zip` varchar(5) DEFAULT NULL,
  `country` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`filer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_filer_data_previous_id`
--

DROP TABLE IF EXISTS `nys_filer_data_previous_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_filer_data_previous_id` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filer_id` int NOT NULL,
  `filer_previous_id` varchar(6) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_filer_map`
--

DROP TABLE IF EXISTS `nys_filer_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_filer_map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `committee_id` int NOT NULL,
  `candidate_id` int DEFAULT NULL,
  `boe_map_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_filer_offices`
--

DROP TABLE IF EXISTS `nys_filer_offices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_filer_offices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `office_id` int NOT NULL,
  `office_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_transaction_data_filers_cash_on_hand`
--

DROP TABLE IF EXISTS `nys_transaction_data_filers_cash_on_hand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_transaction_data_filers_cash_on_hand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filer_id` int DEFAULT NULL,
  `election_year` int DEFAULT NULL,
  `filing_abbreviation` varchar(1) DEFAULT NULL,
  `cash_on_hand` double DEFAULT NULL,
  `average_transaction_date` decimal(12,4) DEFAULT NULL,
  `earliest_transaction_date` date DEFAULT NULL,
  `latest_transaction_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_transaction_data_source`
--

DROP TABLE IF EXISTS `nys_transaction_data_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_transaction_data_source` (
  `id` int NOT NULL AUTO_INCREMENT,
  `FILER_ID` int DEFAULT NULL,
  `FILER_PREVIOUS_ID` varchar(10) DEFAULT NULL,
  `CAND_COMM_NAME` varchar(100) DEFAULT NULL,
  `ELECTION_YEAR` int DEFAULT NULL,
  `ELECTION_TYPE` varchar(15) DEFAULT NULL,
  `COUNTY_DESC` varchar(15) DEFAULT NULL,
  `FILING_ABBREV` varchar(1) DEFAULT NULL,
  `FILING_DESC` varchar(50) DEFAULT NULL,
  `R_AMEND` varchar(1) DEFAULT NULL,
  `FILING_CAT_DESC` varchar(10) DEFAULT NULL,
  `FILING_SCHED_ABBREV` varchar(5) DEFAULT NULL,
  `FILING_SCHED_DESC` varchar(50) DEFAULT NULL,
  `LOAN_LIB_NUMBER` varchar(50) DEFAULT NULL,
  `TRANS_NUMBER` varchar(50) DEFAULT NULL,
  `TRANS_MAPPING` varchar(50) DEFAULT NULL,
  `SCHED_DATE` varchar(10) DEFAULT NULL,
  `ORG_DATE` varchar(10) DEFAULT NULL,
  `CNTRBR_TYPE_DESC` varchar(50) DEFAULT NULL,
  `CNTRBN_TYPE_DESC` varchar(50) DEFAULT NULL,
  `TRANSFER_TYPE_DESC` varchar(100) DEFAULT NULL,
  `RECEIPT_TYPE_DESC` varchar(20) DEFAULT NULL,
  `RECEIPT_CODE_DESC` varchar(30) DEFAULT NULL,
  `PURPOSE_CODE_DESC` varchar(50) DEFAULT NULL,
  `R_SUBCONTRACTOR` varchar(1) DEFAULT NULL,
  `FLNG_ENT_NAME` varchar(255) DEFAULT NULL,
  `FLNG_ENT_FIRST_NAME` varchar(100) DEFAULT NULL,
  `FLNG_ENT_MIDDLE_NAME` varchar(100) DEFAULT NULL,
  `FLNG_ENT_LAST_NAME` varchar(100) DEFAULT NULL,
  `FLNG_ENT_ADD1` varchar(100) DEFAULT NULL,
  `FLNG_ENT_CITY` varchar(100) DEFAULT NULL,
  `FLNG_ENT_STATE` varchar(30) DEFAULT NULL,
  `FLNG_ENT_ZIP` varchar(20) DEFAULT NULL,
  `FLNG_ENT_COUNTRY` varchar(20) DEFAULT NULL,
  `PAYMENT_TYPE_DESC` varchar(30) DEFAULT NULL,
  `PAY_NUMBER` varchar(30) DEFAULT NULL,
  `OWED_AMT` varchar(50) DEFAULT NULL,
  `ORG_AMT` varchar(50) DEFAULT NULL,
  `LOAN_OTHER_DESC` varchar(50) DEFAULT NULL,
  `TRANS_EXPLNTN` varchar(255) DEFAULT NULL,
  `R_ITEMIZED` varchar(1) DEFAULT NULL,
  `R_LIABILITY` varchar(1) DEFAULT NULL,
  `ELECTION_YEAR_R` varchar(4) DEFAULT NULL,
  `OFFICE_DESC` varchar(25) DEFAULT NULL,
  `DISTRICT` varchar(5) DEFAULT NULL,
  `DIST_OFF_CAND_BAL_PROP` varchar(10) DEFAULT NULL,
  `TRIMM_CONTROL` varchar(5) DEFAULT NULL,
  `ROW_HASH` varchar(255) NOT NULL,
  `IMPORTED_TIMESTAMP` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_nxsidx_transaction_data_source_hash` (`ROW_HASH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nys_zip_codes`
--

DROP TABLE IF EXISTS `nys_zip_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nys_zip_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zip` int DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `county_name` varchar(255) DEFAULT NULL,
  `state_name` varchar(255) DEFAULT NULL,
  `population` int DEFAULT NULL,
  `density` float DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `county_names_all` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usa_zip_codes`
--

DROP TABLE IF EXISTS `usa_zip_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usa_zip_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zip` varchar(30) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `primary_city` varchar(255) DEFAULT NULL,
  `acceptable_cities` mediumtext,
  `unacceptable_cities` mediumtext,
  `state` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  `area_codes` varchar(255) DEFAULT NULL,
  `world_region` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `voter_history_map`
--

DROP TABLE IF EXISTS `voter_history_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_history_map` (
  `election_name` varchar(100) NOT NULL,
  `election_map` varchar(50) DEFAULT NULL,
  `level` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`election_name`),
  UNIQUE KEY `voter_history_map_election_name_uindex` (`election_name`),
  KEY `vhm_election_name` (`election_name`),
  KEY `idx_voter_history_map_election_name` (`election_name`,`election_map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'nxsidx_ny'
--
/*!50003 DROP FUNCTION IF EXISTS `nxsidx_obscure_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `nxsidx_obscure_email`(in_email varchar(255)) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
DECLARE cleaned_email VARCHAR(255) DEFAULT NULL;
SELECT
    CONCAT(
            SUBSTR(in_email,1,1),
            REPEAT('*',LOCATE('@',in_email)-3),
            SUBSTR(in_email,LOCATE('@',in_email)-1,3),
            REPEAT('*',LENGTH(in_email)-LOCATE('.',REVERSE(in_email))-LOCATE('@',in_email)-1),
            SUBSTR(in_email,LENGTH(in_email)-LOCATE('.',REVERSE(in_email)))
        ) into cleaned_email
FROM DUAL;
IF (LENGTH(cleaned_email) > 2) THEN
RETURN cleaned_email;
ELSE
return NULL;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `nxsidx_obscure_phone_number` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `nxsidx_obscure_phone_number`(phone_number varchar(255)) RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
DECLARE cleaned_phone_number VARCHAR(255) DEFAULT NULL;
SELECT
    CONCAT(
            SUBSTR(phone_number,1,(LENGTH(phone_number)/2)),
            REPEAT('*',(LENGTH(phone_number)/2))
        ) into cleaned_phone_number
FROM DUAL;
IF (LENGTH(cleaned_phone_number) > 2) THEN
RETURN cleaned_phone_number;
ELSE
return NULL;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_generate_filer_cash_on_hand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_generate_filer_cash_on_hand`()
BEGIN
DROP TABLE IF EXISTS nxsidx_ny.nys_transaction_data_filers_cash_on_hand;
CREATE TABLE nxsidx_ny.nys_transaction_data_filers_cash_on_hand
AS
WITH summary_by_filing AS (
    SELECT *
    FROM nxsidx_ny.nys_transaction_data_summary_by_filing
)
SELECT filer_id, election_year, filing_abbreviation, round(sum(net_cash) OVER (PARTITION BY filer_id ORDER BY average_transaction_date),2) AS cash_on_hand, average_transaction_date, earliest_transaction_date, latest_transaction_date
FROM summary_by_filing
ORDER BY average_transaction_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_generate_filer_summary_by_schedule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_generate_filer_summary_by_schedule`()
BEGIN
#     This is a kludge as the query fills up the tmp data on my machine
    SET SESSION internal_tmp_mem_storage_engine=Memory;
DROP TABLE IF EXISTS nxsidx_ny.nys_transaction_data_summary_by_filing;
CREATE TABLE nxsidx_ny.nys_transaction_data_summary_by_filing
    AS
SELECT filer_id, election_year, filing_abbreviation, filing_description, contributions_ind_part, contributions_corp, contributions_other,
       contributions_inkind, other_receipts, expenditures, transfers_in, transfers_out, loans_received, loans_repayed, liabilities_forgiven, expenditures_refunded, contributions_refunded,
       liabilities_outstanding, subcontractor_payments, housekeeping_receipts, housekeeping_expenses, expense_allocation_among_candidates,
       ROUND(SUM(contributions_ind_part + contributions_corp + contributions_other + contributions_inkind + other_receipts + transfers_in + loans_received + expenditures_refunded),2) as contributions,
       ROUND(SUM(expenditures + transfers_out + loans_repayed + contributions_refunded),2) as disbursements,
       ROUND(SUM(((contributions_ind_part + contributions_corp + contributions_other + contributions_inkind + other_receipts + transfers_in + loans_received + expenditures_refunded)
            - (expenditures + transfers_out + loans_repayed + contributions_refunded))),2) as net_raise,
       ROUND(SUM(((contributions_ind_part + contributions_corp + contributions_other + other_receipts + transfers_in + loans_received + expenditures_refunded)
            - (expenditures + transfers_out + loans_repayed + contributions_refunded))),2) as net_cash,
       average_transaction_date, earliest_transaction_date, latest_transaction_date
FROM
(SELECT filer_id, election_year, filing_abbreviation, filing_description,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "A" then sq.sum end),0) contributions_ind_part,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "B" then sq.sum end),0) contributions_corp,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "C" then sq.sum end),0) contributions_other,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "D" then sq.sum end),0) contributions_inkind,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "E" then sq.sum end),0) other_receipts,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "F" then sq.sum end),0) expenditures,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "G" then sq.sum end),0) transfers_in,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "H" then sq.sum end),0) transfers_out,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "I" then sq.sum end),0) loans_received,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "J" then sq.sum end),0) loans_repayed,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "K" then sq.sum end),0) liabilities_forgiven,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "L" then sq.sum end),0) expenditures_refunded,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "M" then sq.sum end),0) contributions_refunded,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "N" then sq.sum end),0) liabilities_outstanding,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "O" then sq.sum end),0) subcontractor_payments,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "P" then sq.sum end),0) housekeeping_receipts,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "Q" then sq.sum end),0) housekeeping_expenses,
COALESCE(MAX(case when sq.filing_schedule_abbreviation like "R" then sq.sum end),0) expense_allocation_among_candidates,
MAX(average_transaction_date) as average_transaction_date,
MIN(earliest_transaction) as earliest_transaction_date,
MAX(latest_transaction) as latest_transaction_date
from (SELECT filer_id, election_year, filing_abbreviation, filing_description, filing_schedule_abbreviation, ROUND(SUM(td.original_amount),2) as 'sum', avg(transaction_date) as 'average_transaction_date', min(transaction_date) as 'earliest_transaction', max(transaction_date) as 'latest_transaction'
    from nxsidx_ny.nys_transaction_data_child td
    group by filer_id, election_year, filing_abbreviation, filing_schedule_abbreviation) sq
group by filer_id, election_year, filing_abbreviation) pivot
group by filer_id, election_year, filing_abbreviation
order by filer_id, election_year, average_transaction_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_get_filer_cash_on_hand` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_get_filer_cash_on_hand`(IN in_filer_id INT)
BEGIN
    SELECT * FROM nxsidx_ny.nys_transaction_data_summary_by_filing WHERE filer_id = in_filer_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nxsidx_get_filer_summary_by_schedule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `nxsidx_get_filer_summary_by_schedule`(IN in_filer_id int)
BEGIN
SELECT sbf.filer_id, sbf.election_year, sbf.filing_abbreviation, sbf.filing_description, sbf.contributions_ind_part, sbf.contributions_corp, sbf.contributions_other, sbf.contributions_inkind, sbf.other_receipts, sbf.expenditures, sbf.transfers_in, sbf.transfers_out, sbf.loans_received, sbf.loans_repayed, sbf.liabilities_forgiven, sbf.expenditures_refunded, sbf.contributions_refunded, sbf.liabilities_outstanding, sbf.subcontractor_payments, sbf.housekeeping_receipts, sbf.housekeeping_expenses, sbf.expense_allocation_among_candidates, sbf.contributions, sbf.disbursements, sbf.net_raise, sbf.net_cash, sbf.average_transaction_date, sbf.earliest_transaction_date, sbf.latest_transaction_date, coh.cash_on_hand
FROM nys_transaction_data_summary_by_filing sbf
         JOIN nys_transaction_data_filers_cash_on_hand coh
              ON sbf.filer_id = coh.filer_id
                  AND sbf.election_year = coh.election_year
                  AND sbf.filing_abbreviation = coh.filing_abbreviation
WHERE sbf.filer_id = in_filer_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `nxsidx_user_lists`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `nxsidx_user_lists` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `nxsidx_user_lists`;

--
-- Table structure for table `1_saved_lists`
--

DROP TABLE IF EXISTS `1_saved_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `1_saved_lists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userid` int NOT NULL,
  `saveid` int NOT NULL,
  `unique_id` int NOT NULL,
  `row_hash` varchar(255) NOT NULL,
  `filer_id` bigint NOT NULL,
  `filer_previous_id` varchar(6) NOT NULL,
  `candidate_committee_name` varchar(255) NOT NULL,
  `election_year` int NOT NULL,
  `election_type` varchar(100) NOT NULL,
  `county_description` varchar(255) NOT NULL,
  `filing_abbreviation` varchar(5) NOT NULL,
  `filing_description` longtext NOT NULL,
  `is_amended` varchar(5) NOT NULL,
  `filing_category_description` longtext NOT NULL,
  `filing_schedule_abbreviation` varchar(5) NOT NULL,
  `filing_schedule_description` varchar(80) NOT NULL,
  `loan_liability_id` varchar(100) NOT NULL,
  `transaction_number` varchar(100) NOT NULL,
  `transaction_mapping` varchar(100) NOT NULL,
  `transaction_date` date NOT NULL,
  `transaction_parent_date` text NOT NULL,
  `contributor_type` varchar(80) NOT NULL,
  `contribution_type` varchar(80) NOT NULL,
  `transfer_type` varchar(255) NOT NULL,
  `receipt_type` varchar(80) NOT NULL,
  `receipt_code` varchar(80) NOT NULL,
  `purpose_code` varchar(80) NOT NULL,
  `is_subcontractor` varchar(5) NOT NULL,
  `donor_organization_name` varchar(100) NOT NULL,
  `donor_first_name` varchar(100) NOT NULL,
  `donor_middle_name` varchar(100) NOT NULL,
  `donor_last_name` varchar(100) NOT NULL,
  `donor_address` varchar(100) NOT NULL,
  `donor_city` varchar(100) NOT NULL,
  `donor_state` varchar(30) NOT NULL,
  `donor_zip` varchar(30) NOT NULL,
  `donor_country` varchar(30) NOT NULL,
  `payment_type` varchar(80) NOT NULL,
  `payment_number` varchar(30) NOT NULL,
  `owed_amount` longtext NOT NULL,
  `original_amount` varchar(255) NOT NULL,
  `loan_type` longtext NOT NULL,
  `transaction_explanation` longtext NOT NULL,
  `is_itemized` longtext NOT NULL,
  `is_liability` varchar(10) NOT NULL,
  `candidate_election_year` varchar(4) NOT NULL,
  `candidate_office` varchar(50) NOT NULL,
  `candidate_district` varchar(50) NOT NULL,
  `district_office_candidate_ballot_proposition` varchar(50) NOT NULL,
  `imported_timestamp` timestamp NOT NULL,
  `updated_timestamp` timestamp NOT NULL,
  `saved_timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`,`userid`,`saveid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `38_saved_lists`
--

DROP TABLE IF EXISTS `38_saved_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `38_saved_lists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userid` int NOT NULL,
  `saveid` int NOT NULL,
  `unique_id` int NOT NULL,
  `row_hash` varchar(255) NOT NULL,
  `filer_id` bigint NOT NULL,
  `filer_previous_id` varchar(6) NOT NULL,
  `candidate_committee_name` varchar(255) NOT NULL,
  `election_year` int NOT NULL,
  `election_type` varchar(100) NOT NULL,
  `county_description` varchar(255) NOT NULL,
  `filing_abbreviation` varchar(5) NOT NULL,
  `filing_description` longtext NOT NULL,
  `is_amended` varchar(5) NOT NULL,
  `filing_category_description` longtext NOT NULL,
  `filing_schedule_abbreviation` varchar(5) NOT NULL,
  `filing_schedule_description` varchar(80) NOT NULL,
  `loan_liability_id` varchar(100) NOT NULL,
  `transaction_number` varchar(100) NOT NULL,
  `transaction_mapping` varchar(100) NOT NULL,
  `transaction_date` date NOT NULL,
  `transaction_parent_date` text NOT NULL,
  `contributor_type` varchar(80) NOT NULL,
  `contribution_type` varchar(80) NOT NULL,
  `transfer_type` varchar(255) NOT NULL,
  `receipt_type` varchar(80) NOT NULL,
  `receipt_code` varchar(80) NOT NULL,
  `purpose_code` varchar(80) NOT NULL,
  `is_subcontractor` varchar(5) NOT NULL,
  `donor_organization_name` varchar(100) NOT NULL,
  `donor_first_name` varchar(100) NOT NULL,
  `donor_middle_name` varchar(100) NOT NULL,
  `donor_last_name` varchar(100) NOT NULL,
  `donor_address` varchar(100) NOT NULL,
  `donor_city` varchar(100) NOT NULL,
  `donor_state` varchar(30) NOT NULL,
  `donor_zip` varchar(30) NOT NULL,
  `donor_country` varchar(30) NOT NULL,
  `payment_type` varchar(80) NOT NULL,
  `payment_number` varchar(30) NOT NULL,
  `owed_amount` longtext NOT NULL,
  `original_amount` varchar(255) NOT NULL,
  `loan_type` longtext NOT NULL,
  `transaction_explanation` longtext NOT NULL,
  `is_itemized` longtext NOT NULL,
  `is_liability` varchar(10) NOT NULL,
  `candidate_election_year` varchar(4) NOT NULL,
  `candidate_office` varchar(50) NOT NULL,
  `candidate_district` varchar(50) NOT NULL,
  `district_office_candidate_ballot_proposition` varchar(50) NOT NULL,
  `imported_timestamp` timestamp NOT NULL,
  `updated_timestamp` timestamp NOT NULL,
  `saved_timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`,`userid`,`saveid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `template`
--

DROP TABLE IF EXISTS `template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userid` int NOT NULL,
  `saveid` int NOT NULL,
  `unique_id` int NOT NULL,
  `row_hash` varchar(255) NOT NULL,
  `filer_id` bigint NOT NULL,
  `filer_previous_id` varchar(6) NOT NULL,
  `candidate_committee_name` varchar(255) NOT NULL,
  `election_year` int NOT NULL,
  `election_type` varchar(100) NOT NULL,
  `county_description` varchar(255) NOT NULL,
  `filing_abbreviation` varchar(5) NOT NULL,
  `filing_description` longtext NOT NULL,
  `is_amended` varchar(5) NOT NULL,
  `filing_category_description` longtext NOT NULL,
  `filing_schedule_abbreviation` varchar(5) NOT NULL,
  `filing_schedule_description` varchar(80) NOT NULL,
  `loan_liability_id` varchar(100) NOT NULL,
  `transaction_number` varchar(100) NOT NULL,
  `transaction_mapping` varchar(100) NOT NULL,
  `transaction_date` date NOT NULL,
  `transaction_parent_date` text NOT NULL,
  `contributor_type` varchar(80) NOT NULL,
  `contribution_type` varchar(80) NOT NULL,
  `transfer_type` varchar(255) NOT NULL,
  `receipt_type` varchar(80) NOT NULL,
  `receipt_code` varchar(80) NOT NULL,
  `purpose_code` varchar(80) NOT NULL,
  `is_subcontractor` varchar(5) NOT NULL,
  `donor_organization_name` varchar(100) NOT NULL,
  `donor_first_name` varchar(100) NOT NULL,
  `donor_middle_name` varchar(100) NOT NULL,
  `donor_last_name` varchar(100) NOT NULL,
  `donor_address` varchar(100) NOT NULL,
  `donor_city` varchar(100) NOT NULL,
  `donor_state` varchar(30) NOT NULL,
  `donor_zip` varchar(30) NOT NULL,
  `donor_country` varchar(30) NOT NULL,
  `payment_type` varchar(80) NOT NULL,
  `payment_number` varchar(30) NOT NULL,
  `owed_amount` longtext NOT NULL,
  `original_amount` varchar(255) NOT NULL,
  `loan_type` longtext NOT NULL,
  `transaction_explanation` longtext NOT NULL,
  `is_itemized` longtext NOT NULL,
  `is_liability` varchar(10) NOT NULL,
  `candidate_election_year` varchar(4) NOT NULL,
  `candidate_office` varchar(50) NOT NULL,
  `candidate_district` varchar(50) NOT NULL,
  `district_office_candidate_ballot_proposition` varchar(50) NOT NULL,
  `imported_timestamp` timestamp NOT NULL,
  `updated_timestamp` timestamp NOT NULL,
  `saved_timestamp` datetime NOT NULL,
  PRIMARY KEY (`id`,`userid`,`saveid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'nxsidx_user_lists'
--

--
-- Current Database: `shrd`
--

USE `shrd`;

--
-- Final view structure for view `api_get_position_v`
--

/*!50001 DROP VIEW IF EXISTS `api_get_position_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `api_get_position_v` AS select `a`.`id` AS `id`,`a`.`source_name` AS `source_name`,`a`.`target_schema` AS `target_schema`,`a`.`target_table` AS `target_table`,`a`.`refresh_type` AS `refresh_type`,`a`.`ts` AS `ts`,`a`.`json_position` AS `json_position` from `api_get_position` `a` where (`a`.`id` = (select max(`b`.`id`) from `api_get_position` `b` where ((`b`.`source_name` = `a`.`source_name`) and (`b`.`target_schema` = `a`.`target_schema`) and (`b`.`target_table` = `a`.`target_table`) and (`b`.`refresh_type` = `a`.`refresh_type`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `dcnxs_app`
--

USE `dcnxs_app`;

--
-- Current Database: `dcnxs_ny`
--

USE `dcnxs_ny`;

--
-- Final view structure for view `unmatched_v`
--

/*!50001 DROP VIEW IF EXISTS `unmatched_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `unmatched_v` AS select 1 AS `matchid`,1 AS `userid`,1 AS `last_name`,1 AS `first_name`,1 AS `middle_name`,1 AS `name_suffix`,1 AS `residence_num`,1 AS `residence_halfnum`,1 AS `residence_aptnum`,1 AS `residence_pre_street_dir`,1 AS `residence_street_name`,1 AS `residence_post_street_dir`,1 AS `residence_city`,1 AS `residence_zip`,1 AS `residence_zip_4`,1 AS `mailing_address_1`,1 AS `mailing_address_2`,1 AS `mailing_address_3`,1 AS `mailing_address_4`,1 AS `date_of_birth`,1 AS `gender`,1 AS `enrollment`,1 AS `other_party`,1 AS `county_code`,1 AS `election_district`,1 AS `legislative_district`,1 AS `town_city`,1 AS `ward`,1 AS `congressional_district`,1 AS `senate_district`,1 AS `assembly_district`,1 AS `last_voted_date`,1 AS `last_voted_year`,1 AS `last_voted_county`,1 AS `previous_address`,1 AS `last_registered_name`,1 AS `county_voter_reg_num`,1 AS `application_date`,1 AS `application_source`,1 AS `id_required`,1 AS `id_required_met`,1 AS `voter_status`,1 AS `voter_status_reason`,1 AS `inactive_date`,1 AS `purge_date`,1 AS `nys_voter_id`,1 AS `telephone`,1 AS `email`,1 AS `matched_voter_id`,1 AS `queueid`,1 AS `birth_year`,1 AS `clean_full_name`,1 AS `clean_residence_address`,1 AS `clean_mailing_address`,1 AS `clean_first_name`,1 AS `clean_last_name`,1 AS `clean_previous_address`,1 AS `clean_email`,1 AS `clean_phone`,1 AS `clean_zip5`,1 AS `clean_residence_city`,1 AS `clean_residence_street_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `voter_city_v`
--

/*!50001 DROP VIEW IF EXISTS `voter_city_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `voter_city_v` AS select 1 AS `nys_voter_id`,1 AS `residence_city` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `voter_email_v`
--

/*!50001 DROP VIEW IF EXISTS `voter_email_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `voter_email_v` AS select 1 AS `nys_voter_id`,1 AS `email` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `voter_first_name_v`
--

/*!50001 DROP VIEW IF EXISTS `voter_first_name_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `voter_first_name_v` AS select 1 AS `nys_voter_id`,1 AS `first_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `voter_full_name_v`
--

/*!50001 DROP VIEW IF EXISTS `voter_full_name_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `voter_full_name_v` AS select 1 AS `nys_voter_id`,1 AS `full_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `voter_last_first_name_v`
--

/*!50001 DROP VIEW IF EXISTS `voter_last_first_name_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `voter_last_first_name_v` AS select 1 AS `nys_voter_id`,1 AS `last_first_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `voter_last_name_v`
--

/*!50001 DROP VIEW IF EXISTS `voter_last_name_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `voter_last_name_v` AS select 1 AS `nys_voter_id`,1 AS `last_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `voter_mailing_address_v`
--

/*!50001 DROP VIEW IF EXISTS `voter_mailing_address_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 */
/*!50001 VIEW `voter_mailing_address_v` AS select 1 AS `nys_voter_id`,1 AS `mailing_address` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `nxsidx_app`
--

USE `nxsidx_app`;

--
-- Current Database: `nxsidx_ny`
--

USE `nxsidx_ny`;

--
-- Current Database: `nxsidx_user_lists`
--

USE `nxsidx_user_lists`;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-08-07  0:44:32
