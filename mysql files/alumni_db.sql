-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: alumni_db
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add admin notification',7,'add_adminnotification'),(26,'Can change admin notification',7,'change_adminnotification'),(27,'Can delete admin notification',7,'delete_adminnotification'),(28,'Can view admin notification',7,'view_adminnotification'),(29,'Can add contact message',8,'add_contactmessage'),(30,'Can change contact message',8,'change_contactmessage'),(31,'Can delete contact message',8,'delete_contactmessage'),(32,'Can view contact message',8,'view_contactmessage'),(33,'Can add event',9,'add_event'),(34,'Can change event',9,'change_event'),(35,'Can delete event',9,'delete_event'),(36,'Can view event',9,'view_event'),(37,'Can add alumni profile',10,'add_alumniprofile'),(38,'Can change alumni profile',10,'change_alumniprofile'),(39,'Can delete alumni profile',10,'delete_alumniprofile'),(40,'Can view alumni profile',10,'view_alumniprofile'),(41,'Can add event registration',11,'add_eventregistration'),(42,'Can change event registration',11,'change_eventregistration'),(43,'Can delete event registration',11,'delete_eventregistration'),(44,'Can view event registration',11,'view_eventregistration'),(45,'Can add exemplary achievement',12,'add_exemplaryachievement'),(46,'Can change exemplary achievement',12,'change_exemplaryachievement'),(47,'Can delete exemplary achievement',12,'delete_exemplaryachievement'),(48,'Can view exemplary achievement',12,'view_exemplaryachievement'),(49,'Can add job posting',13,'add_jobposting'),(50,'Can change job posting',13,'change_jobposting'),(51,'Can delete job posting',13,'delete_jobposting'),(52,'Can view job posting',13,'view_jobposting'),(53,'Can add message',14,'add_message'),(54,'Can change message',14,'change_message'),(55,'Can delete message',14,'delete_message'),(56,'Can view message',14,'view_message'),(57,'Can add student profile',15,'add_studentprofile'),(58,'Can change student profile',15,'change_studentprofile'),(59,'Can delete student profile',15,'delete_studentprofile'),(60,'Can view student profile',15,'view_studentprofile'),(61,'Can add mentorship',16,'add_mentorship'),(62,'Can change mentorship',16,'change_mentorship'),(63,'Can delete mentorship',16,'delete_mentorship'),(64,'Can view mentorship',16,'view_mentorship'),(65,'Can add testimonial',17,'add_testimonial'),(66,'Can change testimonial',17,'change_testimonial'),(67,'Can delete testimonial',17,'delete_testimonial'),(68,'Can view testimonial',17,'view_testimonial'),(69,'Can add user profile',18,'add_userprofile'),(70,'Can change user profile',18,'change_userprofile'),(71,'Can delete user profile',18,'delete_userprofile'),(72,'Can view user profile',18,'view_userprofile');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1000000$NvMYK0InVqkw9BtHCK9age$QuUSwj5l2y0ndfanTxyvnETR46RgfoldtrHiugPryIo=','2025-07-07 18:20:07.981562',1,'saida','','','saida27112002@gmail.com',1,1,'2025-06-11 09:04:31.566475'),(2,'pbkdf2_sha256$1000000$VtIFzYTQ8RqbGgmBoXKAaZ$h9D5DhLN/0x0rHl2nCGDdBce07A1rYAQM+Zipp/Pp5E=','2025-07-09 14:13:04.433475',0,'test','','','test@gmail.com',0,1,'2025-06-11 13:55:53.776884'),(3,'pbkdf2_sha256$1000000$3c7k9WSZ5CE0jMZBPV3Jo1$F8g/FXYnHW9suViZpVbI5OSfHEawlt2ru2oz58vp0rI=','2025-07-09 17:11:11.473245',0,'jdoe','','','abc@gmail.com',0,1,'2025-06-11 18:36:14.555889'),(4,'pbkdf2_sha256$1000000$q7VvaBoH3mFxkGPC9L0HLy$mfbU4JYFq+1JZIgPKK4o8dSU53RpjqMmzSp58B0ZS34=','2025-07-08 11:09:20.861458',0,'jbond','','','jm@gmail.com',0,1,'2025-06-13 08:12:05.576167'),(5,'pbkdf2_sha256$1000000$xNlMGEW1P9fszMIISlgcnF$FgNt+rE9YMcLlCCVil8AhabJGKLfWx2FTNT2ECei6Jg=',NULL,0,'a','','','avc@gmail.com',0,1,'2025-06-20 14:57:15.386844'),(7,'pbkdf2_sha256$1000000$LLPAzPR0bADzbiizAAhXJE$OadGyFvokBNN0z8E7OSX8DVjtEeLnrhZ9XIudAt/Cao=',NULL,0,'avc','','','avc@gmail.com',0,1,'2025-06-20 14:59:27.844539'),(9,'pbkdf2_sha256$1000000$Rr2unFazWWFy4TipBLyWkZ$iKrsi/jl+F9AEwuGFRuxIUCAI1IjVGzrPW7rL51BMK0=','2025-06-20 15:01:24.929273',0,'avccccccccc','','','avc@gmail.com',0,1,'2025-06-20 15:01:22.686036'),(10,'pbkdf2_sha256$1000000$QuZ4yp5Ps8HGwoKH91oFu4$ny/Ia9eD2LITOlKz1H6NQ9tTHQJtbNtbZ0hJMyjuVEQ=','2025-07-09 18:42:52.615733',0,'asd','','','a@123',0,1,'2025-06-20 15:08:50.899305'),(11,'pbkdf2_sha256$1000000$8gafYKIwndhKKeO1w3Z7Ex$4jAWBGsBmWj++YqEdQJqgUIMVsGCi6rfhtEuvNKvt8g=','2025-07-05 12:50:13.733689',0,'anika_._','','','anikatasneem@gmail.com',0,1,'2025-06-20 15:11:35.441832'),(12,'pbkdf2_sha256$1000000$YPg8nUd3ghOcwr74GSFxT3$/uQKuukmqmOM8b7OURanJe58rVgFEj+il5ELj1pOHw8=','2025-07-05 18:02:29.922580',0,'sakib_._','','','sakibahmed@gmail.com',0,1,'2025-06-20 15:22:22.488584'),(13,'pbkdf2_sha256$1000000$0W546TtC0wGKXLSvuaQYxV$rzoUrrblW8EOhUnYi0rh4QTQgINU3M+kE2vLS782ruw=','2025-07-09 15:22:07.975661',0,'syn_._','','','s.islam@gmail.com',0,1,'2025-06-20 16:12:18.301687'),(14,'pbkdf2_sha256$1000000$LCB4hdI7E3FIDY7Dp6r2pc$gyoYAY3CUYwIXDTRiWqyA9hC+l/1txLZCuDqM4pj3nQ=','2025-07-05 18:10:24.204213',0,'khaa_._','','','khaled@gmail.com',0,1,'2025-06-20 16:28:21.103194'),(15,'pbkdf2_sha256$1000000$SWHxtY4uiJZD1xrfSKmK6U$/wUu+rKjUVfITrAu88MBRMFGS+ty7+qoP3QeCnatRAw=','2025-07-05 17:59:42.919260',0,'samiha','','','samiha@gmail.com',0,1,'2025-06-20 16:40:49.335387'),(16,'pbkdf2_sha256$1000000$TQRQjkKWIPCJKEKbobwAnJ$8GxHxBHFXm4yTj7w1cp/Ud+TBTObGuTjtOhSAduOLPs=','2025-07-05 17:57:54.357677',0,'tabassum','','','anika@gmail.com',0,1,'2025-06-20 17:11:05.939520'),(17,'pbkdf2_sha256$1000000$KBqgqkIpqMB5qaJCeZvoCk$9tyrGtEZopCxca7WGmbAdW2WTVFYAhv2J9gGFopOOzE=','2025-07-05 18:13:42.992698',0,'Rehnuma','','','rehnuma@gmail.com',0,1,'2025-06-20 17:16:33.781948'),(18,'pbkdf2_sha256$1000000$1xuE6lCKOUnLd93t9gR9x8$WenBqF6k7FY1vjNVQ27xIzPW95R6K+RD40yf53Itrik=','2025-07-05 17:52:03.360675',0,'soad','','','soad@gmail.com',0,1,'2025-06-20 17:18:41.172644'),(19,'pbkdf2_sha256$1000000$Hpdx9hQHKcfRXkDpiwgTud$CN5a+N48lcZDvYj6SOXY+BbozfRPzR+Jf0OI7kyFhg4=','2025-07-05 17:50:01.914241',0,'zahed','','','zahed@gmail.com',0,1,'2025-06-20 17:20:34.711610'),(20,'pbkdf2_sha256$1000000$6uHL2EbEEbNUdYd2qahsXP$hD+JHTv/FDFVyGQVP/d1RenpBzsvxuI1gNwGYOgTrgs=','2025-07-05 18:06:09.805490',0,'salman','','','salman@gmail.com',0,1,'2025-06-20 17:23:42.688986'),(21,'pbkdf2_sha256$1000000$h7J983Qa20VPpxaChiWOuT$M20D8UaoSN2mNfLptNVg0KcYdSRwY2sjvGm59uF2DyA=','2025-07-05 18:11:49.319078',0,'ava_._','','','abantika@gmail.com',0,1,'2025-06-20 17:28:39.746323'),(22,'pbkdf2_sha256$1000000$eajsRXMsBvdJZ02wA8Er0R$2OU+XN9q9MuDEXBiQAus/W9lRM4vkVfRUR/yEMBqf2A=','2025-07-05 17:53:35.812074',0,'mehrin','','','mehrin@gmail.com',0,1,'2025-06-20 17:33:10.403694'),(23,'pbkdf2_sha256$1000000$uqYpkfwdiiCEpSDjLSdghF$j+5Zn21m7oxFn1BWTyGFRkLcRIawTYlCnlbuGuh4+7M=','2025-07-05 18:12:20.451483',0,'sadia','','','sadia@gmail.com',0,1,'2025-06-20 17:35:52.159117'),(24,'pbkdf2_sha256$1000000$4O9tjqxvrwJCwO01o1HnGX$Z55cdsSiImzF63pNzUL3kwjBGYS5I4WI+GBDn4wOtm4=','2025-07-05 18:12:44.819238',0,'afrina','','','afrina@gmail.com',0,1,'2025-06-20 17:56:40.904974'),(25,'pbkdf2_sha256$1000000$sqwvwPQMpq6FI5apZtpYt1$zQg2ndkm9Iwyo3XOnrrZ8R+TKWbyGRu2VglbSOVnSzU=','2025-07-05 18:13:09.132088',0,'fayeaz','','','fayeaz@gmail.com',0,1,'2025-06-20 18:28:34.154055'),(26,'pbkdf2_sha256$1000000$DZxFe3NvKs8xMim4TcpxVr$O08anWfcxXONgJxhytd/OufumU85L/5ZpVDvAvegiWA=','2025-07-07 19:49:43.652049',0,'subaha','','','sub@gmail.com',1,1,'2025-06-27 17:34:06.818520'),(27,'pbkdf2_sha256$1000000$oCtwvZhrtbFP8oYJfaxuoE$SQgoett25zQz4X8c0wErk1FFhhBz7R8L7sCJoYbcLsU=',NULL,0,'shafika','','','shafika@gmail.com',0,1,'2025-07-05 20:56:42.972397'),(28,'pbkdf2_sha256$1000000$FvFCrL3OoDKrmK949rzkb7$oWS83VlEZMafeCyyQTbAuCZh/vbeSl6mkFLiSpSCj1U=','2025-07-06 19:55:24.172537',0,'fahmida','','','fah@gmail.com',0,1,'2025-07-06 19:55:22.184541'),(29,'pbkdf2_sha256$1000000$EdAsrNUYgELBbsveHUhpYt$X6R7MPCKrr6F1RD/yu/Dl7igbSaO6gNMQtqKzv5mQUE=','2025-07-07 19:28:40.311572',0,'sara','','','sara@gmail.com',0,1,'2025-07-07 19:28:39.516037'),(30,'pbkdf2_sha256$1000000$RuKBDTjdUdgSyZ4RBNtbo3$TGgqKAvDP5X8CiU65+YV6T85Bxo1E9cyvIi5lEoIo4o=',NULL,0,'sadman','','','shs@gmail.com',0,1,'2025-07-07 20:13:57.428670');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(7,'alumni','adminnotification'),(10,'alumni','alumniprofile'),(8,'alumni','contactmessage'),(9,'alumni','event'),(11,'alumni','eventregistration'),(12,'alumni','exemplaryachievement'),(13,'alumni','jobposting'),(16,'alumni','mentorship'),(14,'alumni','message'),(15,'alumni','studentprofile'),(17,'alumni','testimonial'),(18,'alumni','userprofile'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2025-06-11 08:58:20.754001'),(2,'auth','0001_initial','2025-06-11 08:58:21.753437'),(3,'admin','0001_initial','2025-06-11 08:58:22.031515'),(4,'admin','0002_logentry_remove_auto_add','2025-06-11 08:58:22.041872'),(5,'admin','0003_logentry_add_action_flag_choices','2025-06-11 08:58:22.053727'),(6,'alumni','0001_initial','2025-06-11 08:58:23.399010'),(7,'contenttypes','0002_remove_content_type_name','2025-06-11 08:58:23.556746'),(8,'auth','0002_alter_permission_name_max_length','2025-06-11 08:58:23.673968'),(9,'auth','0003_alter_user_email_max_length','2025-06-11 08:58:23.721342'),(10,'auth','0004_alter_user_username_opts','2025-06-11 08:58:23.736034'),(11,'auth','0005_alter_user_last_login_null','2025-06-11 08:58:23.840006'),(12,'auth','0006_require_contenttypes_0002','2025-06-11 08:58:23.844500'),(13,'auth','0007_alter_validators_add_error_messages','2025-06-11 08:58:23.856545'),(14,'auth','0008_alter_user_username_max_length','2025-06-11 08:58:23.968728'),(15,'auth','0009_alter_user_last_name_max_length','2025-06-11 08:58:24.081131'),(16,'auth','0010_alter_group_name_max_length','2025-06-11 08:58:24.108552'),(17,'auth','0011_update_proxy_permissions','2025-06-11 08:58:24.126227'),(18,'auth','0012_alter_user_first_name_max_length','2025-06-11 08:58:24.239848'),(19,'sessions','0001_initial','2025-06-11 08:58:24.292811'),(20,'alumni','0002_userprofile','2025-06-11 09:01:59.886918'),(21,'alumni','0003_alumniprofile_picture_studentprofile_picture','2025-06-11 18:09:10.933291');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0jtxfee5pit6giftwnami4olin9v22ra','.eJxVjDsOwjAQBe_iGln-ZRNT0nMGa727wQHkSHFSIe4OkVJA-2bmvVTCbS1pa7KkidVZWXX63TLSQ-oO-I71Nmua67pMWe-KPmjT15nleTncv4OCrXzrHkU8BIoOTe9EbAAcmGnwZMC70faYgWGErotBBgqOIzgfTXDgCbx6fwDlBzdM:1uYTmc:EjF-xOHtTognQ6129d_AVOkliWGapxGFrI_IvIy3o5I','2025-07-20 18:08:10.586188'),('40f1wzx28237n8s4tq8rkto5ngunhuyp','.eJxVjDEOwjAMRe-SGUV1IpyWkZ0zRI7tkgJKpKadEHenlTrA-t97_20irUuOa9M5TmIuBjpz-h0T8VPLTuRB5V4t17LMU7K7Yg_a7K2Kvq6H-3eQqeWtTqgAwbMn58-OaGSHCOy8eEIacADpgYJDdps29owJREkBO05BxXy-_gY4RQ:1uY6a3:R5nunUpp29cmzcbmEUn4dDIBJuaLva_GzF6LOHmDPeg','2025-07-19 17:21:39.788999'),('4d14mwcf5ziunt7jevtnd1875r7ihfzu','.eJxVjMsOgjAUBf-la9OUcmmpS_d-Q3NfWNRAQmFl_HclYaHbMzPnZTJua8lb1SWPYs6mNaffjZAfOu1A7jjdZsvztC4j2V2xB632Oos-L4f7d1Cwlm9NySd2seeGRHjooyK3wQeQwNzLwI0bEAGUVaAlBYddpNgl5yGSqHl_ABREOSA:1uPoPx:YyV5N3obEFYY144wam0uGZ_6YW3CWs-o4wzwdtPHQrg','2025-06-26 20:20:57.736143'),('71pbxocs04au01m5yrbjeb791nl58aer','e30:1uUoxm:jZxau5oN7rzIx34uY7trQegghNknT9bkXNVS7tsb1vg','2025-07-10 15:56:34.440589'),('73wkm679uk2wcidwwrykpbu8jkv2yh32','.eJxVjMsOgjAUBf-la9OUcmmpS_d-Q3NfWNRAQmFl_HclYaHbMzPnZTJua8lb1SWPYs6mNaffjZAfOu1A7jjdZsvztC4j2V2xB632Oos-L4f7d1Cwlm9NySd2seeGRHjooyK3wQeQwNzLwI0bEAGUVaAlBYddpNgl5yGSqHl_ABREOSA:1uY7FV:U2V9_kmKMUXacwLTYl2RZriagnQuFPIWNlIxULWsV4A','2025-07-19 18:04:29.411577'),('iyne7n61ttcd237jiwql2lfspdgwpd58','.eJxVjMsOgjAUBf-la9OUcmmpS_d-Q3NfWNRAQmFl_HclYaHbMzPnZTJua8lb1SWPYs6mNaffjZAfOu1A7jjdZsvztC4j2V2xB632Oos-L4f7d1Cwlm9NySd2seeGRHjooyK3wQeQwNzLwI0bEAGUVaAlBYddpNgl5yGSqHl_ABREOSA:1uQoku:2oTwX2KT5dPP5UYayL6ayr6-uquI5K5ydG-9o5mqUmo','2025-06-29 14:54:44.209709'),('mfevn2rw0k53xu4474oc1vtxrnwe3wh0','e30:1uUp4v:pLTG5eBI68t3uECvpjEMJ-resuE2fxHTvuzUNrhys3M','2025-07-10 16:03:57.012989'),('mhl61t7r82y9fe5xdbolu9jluqxawx8m','.eJxVjEEOwiAQRe_C2hAKDAMu3XuGZoCpVA0kpV0Z765NutDtf-_9lxhpW8u4dV7GOYuz0OL0u0VKD647yHeqtyZTq-syR7kr8qBdXlvm5-Vw_w4K9fKtzeRhohBw0GBRO0haMwAazw4YEQKBGiyhx5SMijyQVya6DBRMVFa8P7MoNsA:1uZVXk:Pda9NCHEkUhuOpGyqVw18h-L2Ba7K8-m56gGVlhN7E0','2025-07-23 14:13:04.442672'),('ngpifez7baku9aiw1ykoms4yud38dhh6','.eJxVjDsOwjAQRO_iGlmL4y8lPWew1usNDiBbipMKcXcSKQUU08x7M28RcV1KXDvPccriIs5anH7LhPTkupP8wHpvklpd5inJXZEH7fLWMr-uh_t3ULCXbR00GxXIKo8ECJkcaERO7IMJBEx28NnoLWSUSlbDyMo5GAYcvQ0oPl8OVTgM:1uY7L6:J3GUhu__xl8SkCmVwKfWB5zQQ5FMkNzd4okE1xzWvh4','2025-07-19 18:10:16.299844'),('oq591p64isgeyep552hnxrt02p3lfecr','.eJxVjEEOwiAQRe_C2hAKDAMu3XuGZoCpVA0kpV0Z765NutDtf-_9lxhpW8u4dV7GOYuz0OL0u0VKD647yHeqtyZTq-syR7kr8qBdXlvm5-Vw_w4K9fKtzeRhohBw0GBRO0haMwAazw4YEQKBGiyhx5SMijyQVya6DBRMVFa8P7MoNsA:1uYAZS:k08imh786CyngC6IgZQVDNbVB9Zh0LZnhoRNPXm14O0','2025-07-19 21:37:18.361238'),('tsa39b5pl16n7leqalfvhu96ipsx7qx1','.eJxVjEEOwiAQRe_C2hCgDAGX7j0DmYFBqoYmpV013t026UK3773_NxFxXWpcO89xzOIq9CAuv5AwvbgdJj-xPSaZprbMI8kjkaft8j5lft_O9u-gYq_7mooCQKsImF1i1tZkJKV9oAQY2AAXq0Ie3I5DKN4AUCFvEzvmAuLzBS8KOVw:1uYSas:ewyoRvKw-zZNv2ZD5jdl6spGlQOWMAsoTWEcv1zRJuo','2025-07-20 16:51:58.533236'),('u95loztj7gcsbl6aflhyp72jef2d9uzz','.eJxVjEEOwiAQRe_C2pAylMK4dO8ZyACDVA0kpV0Z765NutDtf-_9l_C0rcVvnRc_J3EWMInT7xgoPrjuJN2p3pqMra7LHOSuyIN2eW2Jn5fD_Tso1Mu3diojkLUqEyHmmDTlwA5DghQnYBfNGA3goMMIjM6BGjg7bY1WmiiI9wcnmThz:1uY57J:1P6zjYd8r8XN3q03ao9COwa_jlI1Gh9MxMnf869lJhk','2025-07-19 15:47:53.568813'),('umqjhcj12dkrce2acqzp150yep2r2v9t','.eJxVjDEOwjAMRe-SGUV1IpyWkZ0zRI7tkgJKpKadEHenlTrA-t97_20irUuOa9M5TmIuBjpz-h0T8VPLTuRB5V4t17LMU7K7Yg_a7K2Kvq6H-3eQqeWtTqgAwbMn58-OaGSHCOy8eEIacADpgYJDdps29owJREkBO05BxXy-_gY4RQ:1uZZkq:gm84oEQM7Z2zddNrGIddk-XwVazGgoei3mLXOQAHc8o','2025-07-23 18:42:52.622955'),('w81nvwzdsdjykeoj5l20bl3y3fosurd7','.eJxVjDsOwjAQRO_iGlmL4y8lPWew1usNDiBbipMKcXcSKQUU08x7M28RcV1KXDvPccriIs5anH7LhPTkupP8wHpvklpd5inJXZEH7fLWMr-uh_t3ULCXbR00GxXIKo8ECJkcaERO7IMJBEx28NnoLWSUSlbDyMo5GAYcvQ0oPl8OVTgM:1uY7LC:4eGES45tIfE9mmrjE4W-FWx2ImfDM-UbO4DqPzy8ChI','2025-07-19 18:10:22.668257'),('wc1gu3jebklg7jxyr7mdd1w0ox5wzlso','.eJxVjEEOwiAQRe_C2pAylMK4dO8ZyACDVA0kpV0Z765NutDtf-_9l_C0rcVvnRc_J3EWMInT7xgoPrjuJN2p3pqMra7LHOSuyIN2eW2Jn5fD_Tso1Mu3diojkLUqEyHmmDTlwA5DghQnYBfNGA3goMMIjM6BGjg7bY1WmiiI9wcnmThz:1uYrqR:lFti7mF8Pt1vtclFqLsOHzb5KthbStmQPgXp3Ftd9Ls','2025-07-21 19:49:43.660689'),('xibjkfeiy79ltuypqnqcny1xy5af8tfo','.eJxVjMsOgjAUBf-la9OUcmmpS_d-Q3NfWNRAQmFl_HclYaHbMzPnZTJua8lb1SWPYs6mNaffjZAfOu1A7jjdZsvztC4j2V2xB632Oos-L4f7d1Cwlm9NySd2seeGRHjooyK3wQeQwNzLwI0bEAGUVaAlBYddpNgl5yGSqHl_ABREOSA:1uZYK7:XDD-y3Q8N1rP1p--PjZzjVDkVVmbo1wDq5m0MqST8bQ','2025-07-23 17:11:11.483034'),('yje4oyjsucbbtzjejkt8aodf6i95f0i2','e30:1uUovc:rJpCwhvymO2Hno1l4_vcLa9UuomTl6WVlIIHLB-OptA','2025-07-10 15:54:20.976562');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-10  0:51:37
