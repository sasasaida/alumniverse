-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: alumni
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
-- Table structure for table `admin_notifications`
--

DROP TABLE IF EXISTS `admin_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_notifications` (
  `notification_id` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_notifications`
--

LOCK TABLES `admin_notifications` WRITE;
/*!40000 ALTER TABLE `admin_notifications` DISABLE KEYS */;
INSERT INTO `admin_notifications` VALUES ('20520b37-138d-4206-8','Donation requests','Donation requests for scholarships, campus development','2025-07-05 14:25:07'),('52e35509-d7fc-4d9e-8','Volunteer Opportunities','Events or programs that need alumni help or involvement','2025-07-05 14:25:29'),('9b058241-2991-476f-b','Alumni Recommendations','Alumni recommending jobs or workshops to you','2025-07-05 14:27:11'),('b90df075-ae23-46a9-9','Profile Completion','Encouragement to update profile','2025-06-26 08:44:35'),('d06c5a63-8963-49db-9','Requests for Mentorship','Students requesting guidance','2025-07-05 14:24:29'),('d1ecf5df-9981-4af0-8','Maintenance Alert','Scheduled maintenance notice.','2025-06-26 08:41:36'),('e2611fab-1c65-4257-a','Reunion/Event Invitations','Batch-specific or regional meetups','2025-07-05 14:26:43'),('N001','Welcome','Welcome to AlumniVerse!','2025-06-13 20:43:00'),('N002','Event Reminder','Join our reunion!','2025-06-14 20:43:00');
/*!40000 ALTER TABLE `admin_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alumni_profile`
--

DROP TABLE IF EXISTS `alumni_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumni_profile` (
  `alumni_id` varchar(20) NOT NULL,
  `user_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `batch` varchar(10) NOT NULL,
  `department` varchar(50) NOT NULL,
  `job_title` varchar(100) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `linkedin` varchar(100) DEFAULT NULL,
  `bio` text,
  `picture` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`alumni_id`),
  KEY `alumni_profile_ibfk_1` (`user_id`),
  CONSTRAINT `alumni_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `alumni_profile_chk_1` CHECK ((`linkedin` like _utf8mb4'https://www.linkedin.com/%'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumni_profile`
--

LOCK TABLES `alumni_profile` WRITE;
/*!40000 ALTER TABLE `alumni_profile` DISABLE KEYS */;
INSERT INTO `alumni_profile` VALUES ('A003',3,'Mukit Ahmed','2020','ICT','Software Engineer','TechCorp','https://www.linkedin.com/in/johndoe','Passionate about AI and cloud computing','profiles/alumni/jdoe_chandlerb.jpg'),('A011',11,'Anika Tasneem','2019','Marketing','Digital Marketing Specialist','Unilever Bangladesh Ltd.','https://www.linkedin.com/in/anika-tasneem-marketing','A results-driven marketing professional with over 3 years of experience in digital campaigns, brand management, and market research. Specialized in driving consumer engagement through data-driven strategies, social media optimization, and content storytelling. Currently thriving at Unilever Bangladesh, where I contribute to brand growth and consumer loyalty across multiple FMCG products. Passionate about blending creativity with analytics to build compelling brand experiences.','profiles/alumni/anika_.__kyYHjE4aNUAP7ppMyeXZtT-1200-80.jpg'),('A013',13,'Synthia Islam','2018','CSE','Software Engineer – Backend Development','BJIT Ltd., Dhaka, Bangladesh','https://www.linkedin.com/in/synthia-islam-cse','A passionate and detail-oriented Software Engineer with strong experience in backend development using Java, Spring Boot, and RESTful APIs. Graduated in CSE with a solid foundation in data structures, algorithms, and database systems. At BJIT Ltd., I contribute to the development of scalable enterprise solutions for international clients. I\'m committed to writing clean, maintainable code and continuously improving performance through optimized backend logic. I thrive in collaborative environments and am always eager to take on new challenges in full-stack and cloud-based development.','profiles/alumni/syn_.__robin.jpg'),('A014',14,'Sheikh Khaled','2019','CSE','Data Analyst – Business Intelligence','Pathao Ltd., Dhaka, Bangladesh','https://www.linkedin.com/in/sheikh-khaled-cse','A data-driven professional with a CSE background and a strong interest in analytics and business intelligence. Currently working at Pathao Ltd. as a Data Analyst, where I transform raw data into actionable insights that support product decisions and operational improvements. Skilled in SQL, Python (Pandas, NumPy), and data visualization tools like Power BI and Tableau. I enjoy uncovering trends and patterns that help drive growth in high-speed tech environments. My goal is to bridge the gap between data and decision-making through effective storytelling and analytics.','profiles/alumni/khaa_.__RossGeller.jpg'),('A021',21,'Avantika Chowdhury','2020','Finance','Financial Analyst – Corporate Finance','BRAC Bank Limited, Dhaka, Bangladesh','https://www.linkedin.com/in/avantika-chowdhury-finance','A detail-oriented and analytical finance professional with strong expertise in financial modeling, budgeting, and investment analysis. As a Financial Analyst at BRAC Bank, I support the corporate finance team by conducting financial forecasts, evaluating risk factors, and preparing strategic reports for high-level decision-making. With a background in Finance and Accounting, I am proficient in Excel, Power BI, and financial tools like Bloomberg Terminal. I am passionate about helping organizations grow sustainably through accurate data interpretation and strategic financial planning.','profiles/alumni/ava_.__rachel.jpg'),('A023',23,'Sadia Afrin','2018','Marketing','Brand Executive – FMCG Marketing','PRAN-RFL Group, Dhaka, Bangladesh','https://www.linkedin.com/in/sadia-Afrin-marketing','A creative and strategy-driven marketing professional passionate about building impactful brands in the fast-moving consumer goods (FMCG) sector. As a Brand Executive at PRAN-RFL Group, I assist in planning and executing 360° marketing campaigns, managing product launches, and monitoring brand performance across both urban and rural markets. With a strong academic background in marketing and hands-on experience in consumer research, packaging, and BTL activation, I focus on creating meaningful connections between products and consumers. Skilled in campaign planning, social media strategy, and cross-functional coordination.','profiles/alumni/sadia_monica.jpg'),('A024',24,'Afrina Rahman','2017','CSE','UI/UX Designer – Product Design','Selise Digital Platforms, Dhaka, Bangladesh','https://www.linkedin.com/in/afrina-rahman-ux','A tech-savvy and user-focused UI/UX Designer with a background in Computer Science and a passion for intuitive digital experiences. At Selise Digital Platforms, I work closely with product managers and developers to design user-friendly interfaces for web and mobile applications. My role includes creating wireframes, prototypes, and final UI designs using tools like Figma and Adobe XD. With a strong foundation in front-end technologies (HTML, CSS, JavaScript), I bridge the gap between design and development to ensure seamless product delivery. I enjoy solving usability challenges through user research, feedback analysis, and design thinking.','profiles/alumni/afrina_OIP (1).jpg'),('A025',25,'Fayeaz Ahmed','2017','ICT','IT Support Engineer – Infrastructure & Networking','Banglalink Digital Communications Ltd., Dhaka, Bangladesh','https://www.linkedin.com/in/fayeaz-ahmed-ict','An adaptable and service-oriented ICT graduate working as an IT Support Engineer at Banglalink, specializing in enterprise network support and infrastructure troubleshooting. I provide technical assistance across departments, manage user accounts, and maintain system performance to ensure business continuity. Skilled in hardware diagnostics, network configuration, and resolving system issues both on-site and remotely. I take pride in keeping teams connected and systems running efficiently, with a strong focus on security, uptime, and responsive support.','profiles/alumni/fayeaz_CRXZrwPnBDrKRbtTuM25uY-1024-80.jpg'),('A029',29,'Mehjabin Sara','2016','Marketing','Digital Marketing Analyst','Grameenphone','https://www.linkedin.com/in/sara-digital','Data-driven analyst specializing in campaign optimization and ROI tracking.',NULL);
/*!40000 ALTER TABLE `alumni_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `contact_id` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `submitted_at` datetime NOT NULL,
  PRIMARY KEY (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES ('CT0c4a04','Sifat Rahman','sifatrahman123@yahoo.com','Can I publish an article in the alumni blog as a current student?','2025-07-05 16:03:10'),('CT1a77b6','Azad Rahman','azad_r92@gmail.com','The site is great, but mobile view needs improvement.','2025-07-05 16:11:36'),('CT279e15','Jubayer Siddique','jubayer.siddique@outlook.com','Can I get a certificate for attending the last webinar?','2025-07-05 16:02:06'),('CT28e07a','Tania Rahman','taniar91@yahoo.com','I can’t upload my LinkedIn link—it keeps showing an error.','2025-07-05 16:07:33'),('CT333311','Rezwan Haque','rezwan.haque.bd@gmail.com','My mentorship status still shows as “pending” – please look into it.','2025-07-05 16:02:48'),('CT4060f1','Biplob Das','biplob.das@pressbd.com','I’m a journalist. I’d like to feature your platform in an article. Who can I speak to?','2025-07-05 16:10:02'),('CT496819','Saifuddin Alam','saif.alam.bd@gmail.com','Great platform! Can you add a feature to send birthday wishes to alumni?','2025-07-05 16:10:30'),('CT61681b','Amina Khatoon','amina_kh@edu-mail.org','I’m from another university and would like to collaborate on an alumni research project.','2025-07-05 16:09:38'),('CT73558e','Maria Karim','maria.karim@students.du.ac.bd','How can I register for the upcoming alumni reunion event?','2025-07-05 15:57:43'),('CT746069','Imran Mahbub','imran.mahbub@icloud.com','Is there any volunteering opportunity in the upcoming tech fest?','2025-07-05 15:59:38'),('CT765794','Tanima Akter','tanima.a@students.univ.edu','I accidentally registered for the wrong event. How can I cancel it?','2025-07-05 16:02:25'),('CT7e12b6','Kamrul Islam','kamrul.i@outlook.com','I’m interested in hosting a tech talk. How do I get involved?','2025-07-05 16:04:36'),('CT7ec30f','Zahin Al Mahmud','zahin_alm@gmail.com','I’m facing issues logging into my student profile.','2025-07-05 15:58:18'),('CT83a76c','Farzana Huda','farzana.huda@bdmail.net','Do you allow sponsorship for alumni events? If so, what are the packages?','2025-07-05 16:09:13'),('CT86df56','Nishat Chowdhury','nishat_c@alumniverse.com','Is it possible to post job openings for my startup?','2025-07-05 16:08:06'),('CT912f83','Sarah Hossain','sarahhossain@gmail.com','I’m interested in becoming a mentor. How do I apply?','2025-07-05 15:50:57'),('CT9b67af','Priya Sinha','priya.sinha2020@gmail.com','I found a broken link on the homepage. Can you fix it?','2025-07-05 16:08:54'),('CTa3a330','Md. Rakib Hasan','rakib_hasan@yahoo.com','Can I update my job info in my alumni profile?','2025-07-05 15:55:00'),('CTa42044','Sabrina Tahsin','sabrinatahsin@gmail.com','My graduation year is displayed incorrectly. Please update it.','2025-07-05 16:04:15'),('CTab43ea','Nafisa Jahan','nafisa.jahan21@std.univ.edu','I would like to connect with an alumna working in data science. Can you help me?','2025-07-05 16:01:45'),('CTafebca','Rehana Siddiqua','rehana.siddiqa@outlook.com','I want to feature my startup in the Alumni Achievements section.','2025-07-05 15:59:18'),('CTbdfd2e','Mr. A.K. Hossain','ak.hossain@researchmail.org','I’m an academic researcher. Can I access alumni data for a survey?','2025-07-05 16:08:32'),('CTcee05a','Nilufa Yasmin','nilufa.yasmin@alumniverse.com','Please consider including a “batch-wise gallery” to showcase memories.','2025-07-05 16:10:51'),('CTd139e5','Sonia Ferdous','sonia.f.bd@students.univ.edu','Can you send reminders for events one day before via email or SMS?','2025-07-05 16:12:14'),('CTd3c7b4','Tanvir Rahman','tanvir.r@outlook.com','Please check my testimonial submission. I haven’t received approval.','2025-07-05 15:57:20'),('CTda90d4','Arif Mahmud','arif.mahmud@techzone.com','I want to offer internship opportunities at my company. Whom should I contact?','2025-07-05 16:03:38'),('CTe1c65a','Mahin Talukder','mahin.talukder@fintechmail.com','Suggest adding a filter for job postings based on location.','2025-07-05 16:11:55'),('fUFs25Qutwdi','Arif Rahman','arif.rahman@gmail.com','Is there any upcoming alumni networking event this month?','2025-06-27 06:20:46'),('ortM9RBBvxHO','nafisa','naf@gmail.com','Hello, I would like to know more about your alumni mentorship program.','2025-06-27 06:03:30'),('QIzHDxjtX3F8','Asifa Akter','asifa@gmail.com','hello','2025-06-27 12:21:20');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_registration`
--

DROP TABLE IF EXISTS `event_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_registration` (
  `registration_id` varchar(20) NOT NULL,
  `user_id` int NOT NULL,
  `event_id` varchar(20) NOT NULL,
  `registration_date` date NOT NULL,
  PRIMARY KEY (`registration_id`),
  KEY `event_id` (`event_id`),
  KEY `event_registration_ibfk_1` (`user_id`),
  CONSTRAINT `event_registration_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `event_registration_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_registration`
--

LOCK TABLES `event_registration` WRITE;
/*!40000 ALTER TABLE `event_registration` DISABLE KEYS */;
INSERT INTO `event_registration` VALUES ('R057F1E',19,'E002','2025-07-05'),('R0A925D',23,'E_fe3af097','2025-07-05'),('R1089D5',11,'E001','2025-06-20'),('R181343',2,'E002','2025-06-15'),('R1B0DBF',21,'8c1347e3-010d-4e0c-a','2024-07-05'),('R1F6B97',3,'E002','2025-06-15'),('R278025',14,'E_61a14a0b','2025-07-05'),('R2E733A',13,'E_89ced873','2025-07-05'),('R301537',18,'E_3e40ec6f','2025-07-05'),('R36EC9F',13,'E_3e40ec6f','2025-07-05'),('R37A8E7',19,'E_df86b84a','2025-07-05'),('R384A6A',3,'E_61a14a0b','2025-07-05'),('R3B1671',10,'E_df86b84a','2025-07-05'),('R41A1C7',18,'E_df86b84a','2025-07-05'),('R46CAD4',13,'E002','2025-07-05'),('R4F5DF2',25,'E_89ced873','2025-07-05'),('R5B633F',2,'E001','2025-06-13'),('R6054AD',10,'E002','2025-07-05'),('R6056F6',14,'E_72617b54','2025-07-05'),('R625401',3,'E_3e40ec6f','2025-07-05'),('R6BDA36',25,'E_61a14a0b','2025-07-05'),('R73BDB2',20,'E_61a14a0b','2025-07-05'),('R7614CD',14,'E_3e40ec6f','2025-07-05'),('R76A239',25,'E_df86b84a','2025-07-05'),('R79D6F0',3,'E_fe3af097','2025-07-05'),('R7E963A',25,'E_72617b54','2025-07-05'),('R7F8428',20,'E_fe3af097','2025-07-05'),('R88CC99',3,'E_89ced873','2025-07-09'),('R89AC96',23,'E_89ced873','2025-07-05'),('R8A56C0',13,'8c1347e3-010d-4e0c-a','2024-08-05'),('R8BD852',23,'E002','2025-07-05'),('R90E5B7',19,'E_3e40ec6f','2025-07-05'),('R90F539',10,'8c1347e3-010d-4e0c-a','2024-09-05'),('R98591C',19,'E_fe3af097','2025-07-05'),('RA0993C',18,'E_72617b54','2025-07-05'),('RA2AEF5',18,'E_61a14a0b','2025-07-05'),('RC0B434',3,'8c1347e3-010d-4e0c-a','2024-09-05'),('RC6356E',23,'8c1347e3-010d-4e0c-a','2024-08-05'),('RCD393B',13,'E_72617b54','2025-07-05'),('RD188C3',12,'E001','2025-06-20'),('RD76EE6',25,'E001','2025-07-05'),('RE4E87F',21,'E_fe3af097','2025-07-05'),('RE6B581',19,'E_61a14a0b','2025-07-05'),('RE734E7',10,'E_89ced873','2025-07-05'),('RE8A1CD',13,'E_df86b84a','2025-07-05'),('RF3313B',13,'E_fe3af097','2025-07-06'),('RFE0A90',3,'E_72617b54','2025-07-05');
/*!40000 ALTER TABLE `event_registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `event_id` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `date` date NOT NULL,
  `location` varchar(100) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES ('8c1347e3-010d-4e0c-a','Career Fair','A networking event with top companies for internships and full-time roles.','2024-12-26','University Main Auditorium','events/2fcedf213dac44bcb7bf981e6e82f48d_career-fair.jpg'),('E_3e40ec6f','Tree plantation','Alumni sponsor trees/plants on campus','2025-08-30','University Campus','events/1f262fef4e4f4d74827a55ef72f72f24_OIP (6).webp'),('E_61a14a0b','Sports Tournament','Fun cricket, basketball and football matches between different graduating batches.','2025-10-15','University Field','events/c683ad83cf374123ae783bb2ce460883_OIP (4).webp'),('E_72617b54','Blood Donation','Donate blood and spread awareness.','2025-09-25','University Campus','events/7c42107052d44fae83fd3a71ead74569_OIP (5).webp'),('E_89ced873','Virtual Campus Tour','Virtual Campus Tour with Alumni Stories','2025-12-01','Online','events/8a04184b681c405a83a332ed5bc76f87_unnamed_iE4G5qq.2e16d0ba.fill-650x500.png'),('E_df86b84a','Memory Lane – Photo Contest','Alumni submit old photos and stories.','2025-08-12','University Campus','events/142d7c3d753f47708d2d75daade25519_student-photo-contest-23.jpg'),('E_fe3af097','Alumni Volunteering Day','Cleanup, charity, education','2025-11-20','University Campus','events/5ccda3b915e045ed8626acf8ab98c411_fundraising-event-ideas-sip-and-swine-min.jpg'),('E001','Alumni Reunion 2025','Annual gathering of alumni.','2025-08-15','University Campus','events/5b1f42162fc24b54a650b15f7b815c03_about.png'),('E002','Tech Talk','AI advancements discussion.','2025-09-10','Online','events/4351cace4dfd46309b80a307892f6e86_Tech-Talk.jpg');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exemplary_achievements`
--

DROP TABLE IF EXISTS `exemplary_achievements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exemplary_achievements` (
  `achievement_id` varchar(20) NOT NULL,
  `alumni_id` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `date_posted` date NOT NULL,
  PRIMARY KEY (`achievement_id`),
  KEY `alumni_id` (`alumni_id`),
  CONSTRAINT `exemplary_achievements_ibfk_1` FOREIGN KEY (`alumni_id`) REFERENCES `alumni_profile` (`alumni_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exemplary_achievements`
--

LOCK TABLES `exemplary_achievements` WRITE;
/*!40000 ALTER TABLE `exemplary_achievements` DISABLE KEYS */;
INSERT INTO `exemplary_achievements` VALUES ('008EA28C','A013','Optimized Backend API Performance by 40% for Global ERP Client','Led the backend optimization of a critical module in a large-scale ERP system for a Japanese client at BJIT Ltd., resulting in a 40% reduction in API response time and significantly improving overall system efficiency. Achieved this by restructuring SQL queries, implementing caching strategies, and refactoring legacy Java code. The enhancement improved user experience for over 10,000 active users and was praised by the client as a key performance milestone.','2023-04-20'),('280866BA','A025','Reduced System Downtime by 40% Through Proactive Network Monitoring','Implemented a proactive network monitoring system using open-source tools to track server performance and connectivity issues in real time. This initiative enabled faster detection and resolution of infrastructure problems, resulting in a 40% reduction in average system downtime across departments. The solution enhanced overall workflow reliability at Banglalink and minimized disruptions to daily operations, earning positive feedback from both technical and non-technical teams.','2022-04-10'),('923424CD','A003','Launched AI Startup After MIT Fellowship','After completing my undergraduate studies in Computer Science, I was selected for the prestigious MIT Global Entrepreneurship and AI Fellowship. During the six-month intensive program, I collaborated with engineers, researchers, and business leaders from over 20 countries. We worked on cutting-edge machine learning problems, from generative models to real-time edge computing.\r\n\r\nInspired by our research on healthcare diagnostics, I founded my startup, NeuroScan AI, which builds non-invasive tools to detect early signs of cognitive decline using EEG signals and machine learning. In the beginning, we faced countless challenges – from securing funding to building a prototype that could pass medical validation. But with persistence, mentorship, and a strong team, we raised $1.2 million in seed funding and were incubated by Y Combinator in 2024.\r\n\r\nToday, NeuroScan AI is being piloted in hospitals across five countries, and our mission to make brain health accessible and measurable continues to grow. My advice to fellow alumni: dream big, be bold, and never be afraid to solve problems that matter.\r\n\r\nThis journey wasn\'t just about building a company. It was about believing in a purpose larger than myself – improving lives through technology. If you\'re thinking of taking the leap into entrepreneurship, know that you are more ready than you think.\r\n','2025-06-19'),('ACH001','A003','Google Internship','I was selected for Google’s summer internship!','2022-06-01'),('AD8BD4E6','A024','Redesigned Client Dashboard, Increasing User Task Efficiency by 35%','Led the redesign of a client-facing dashboard for a major enterprise software product at Selise Digital Platforms. Through user interviews, heatmap analysis, and usability testing, I identified key UX pain points and implemented a cleaner, more intuitive layout. By optimizing navigation flow and simplifying data presentation, the updated design resulted in a 35% improvement in task completion time and significantly enhanced user satisfaction. The new interface was adopted across multiple client accounts and praised by stakeholders for its clarity and responsiveness.','2023-02-18'),('BB61ACE5','A014','Reduced Delivery Delays by 25% Using Data-Driven Route Optimization','Analyzed over 500,000 delivery route records at Pathao to identify patterns causing frequent delays. By developing a custom Python script and leveraging Power BI dashboards, I pinpointed high-traffic zones and peak-hour bottlenecks. Collaborated with the logistics team to optimize delivery time slots and reroute peak-hour deliveries. The result was a 25% reduction in average delivery delays over a two-month period, improving customer satisfaction and lowering operational costs.','2023-06-15'),('C120F42A','A011','Boosted Brand Engagement by 65% Through Targeted Digital Campaign','Successfully led a multi-platform digital campaign for one of Unilever Bangladesh’s flagship skincare products, resulting in a 65% increase in social media engagement and a 30% growth in online sales within just three months. By analyzing consumer behavior data, optimizing ad placements, and collaborating with influencers, I helped reposition the brand to better connect with Gen Z consumers. This campaign was recognized internally as a benchmark for digital excellence and innovation in the South Asia region.','2024-02-16'),('E1BBE9F4','A023','Successfully Launched New Beverage Product Across 30+ Districts','Played a key role in the successful launch of a new fruit-based beverage under PRAN-RFL Group, overseeing the campaign execution across 30+ districts in Bangladesh. Coordinated with cross-functional teams to develop packaging, design promotional materials, and execute both online and offline marketing strategies. The campaign generated over 2 million impressions on digital platforms and exceeded initial sales targets by 18% within the first quarter of launch. My strategic input in regional targeting and BTL activation was highlighted by the brand management team.','2024-05-13'),('EAD3DCA2','A021','Improved Loan Portfolio Performance by Identifying High-Risk Segments','Conducted a comprehensive analysis of BRAC Bank’s SME loan portfolio and identified high-risk borrower segments using trend analysis and credit scoring models. My findings led to the introduction of stricter risk controls and revised lending criteria, which resulted in a 15% reduction in non-performing loans (NPLs) within six months. This achievement directly contributed to stronger asset quality and was recognized by senior management as a key strategic insight for risk mitigation.\r\n\r\n','2025-01-15');
/*!40000 ALTER TABLE `exemplary_achievements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gallery_images`
--

DROP TABLE IF EXISTS `gallery_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gallery_images` (
  `image_id` varchar(20) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text,
  `image_path` varchar(255) DEFAULT NULL,
  `uploaded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `fk_user` (`user_id`),
  CONSTRAINT `fk_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gallery_images`
--

LOCK TABLES `gallery_images` WRITE;
/*!40000 ALTER TABLE `gallery_images` DISABLE KEYS */;
INSERT INTO `gallery_images` VALUES ('03e5278e-37ba-4df1-9','Sports Meet 2023','Energetic moments from the inter-departmental sports meet.\r\n','gallery/cc61930066ca401c878d989211c9397d_sports-meet.jpg','2025-06-27 18:27:06',22),('0f5ce05a-385b-4b7b-b','Tech Talk with Alumni','A vibrant session with our alumni sharing insights on tech industry trends.','gallery/57c9490fd81149aca2aeee884a12a2ad_R.jpg','2025-07-05 12:51:57',11),('2abbf415-ee7c-412f-8','Cultural Fest Highlights','Dance, drama, and joy—snaps from our annual cultural fest.','gallery/04a4f4ce77224f679eeb6da35a5a5050_image-3280.jpeg','2025-07-05 12:56:04',11),('4b57fb34-c946-4f79-b','Campus Life Flashback','Throwback to the fun-filled student days around our green campus.\r\n','gallery/81b2dc656349417e8a82aeb49e3bd269_orig_photo562074_5536260.jpg','2025-07-05 12:55:13',11),('52a043c9-ac76-4d77-b','Guest Lecture Series','Capturing key moments from inspirational talks by industry leaders.','gallery/de521265688745748725ed2afdccab16_1531340707105.jpg','2025-07-05 13:21:08',14),('8df64dc3-25ec-4e6c-a','Convocation 2022',' A glimpse of the proud moments from our 2022 graduation ceremony.','gallery/36243358e5794ad19222c4be2bdc686b_convocation.jpg','2025-06-27 18:23:14',23),('a0e24016-5051-46ba-a','2024 Alumni Reunion Night.','A heartwarming evening of laughter, memories, and reconnections as Hogwarts alumni gathered for the annual reunion at the Grand Hall.','gallery/1ff55db38e0244b4943859eb4aa4b5f1_reunion-night.avif','2025-06-27 15:37:33',NULL),('d00d7249-e7f1-4387-a',' Alumni Awards Night','Honoring the achievements of our distinguished alumni.\r\n','gallery/eed8deedeb674cd2b2f2991a9c1591e5_OIP (1).webp','2025-07-05 13:17:10',14),('d9da8ec3-3393-4389-8','Farewell Ceremony','A bittersweet goodbye to our graduating students.','gallery/b495693194884afb9b2b7ab4ae18ba0b_528b9b98-a508-4148-96e9-8d91105ed6a1.jpg','2025-07-05 13:22:20',14),('e9aa4efc-4f66-473b-b','Startup Showcase','Featuring startups led by our innovative alumni.\r\n','gallery/170c8ea68e3e49ce83a35d8b33cb4759_OIP (2).webp','2025-07-05 13:18:22',14);
/*!40000 ALTER TABLE `gallery_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_postings`
--

DROP TABLE IF EXISTS `job_postings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_postings` (
  `job_id` varchar(20) NOT NULL,
  `alumni_id` varchar(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `company` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `deadline` date NOT NULL,
  PRIMARY KEY (`job_id`),
  KEY `alumni_id` (`alumni_id`),
  CONSTRAINT `job_postings_ibfk_1` FOREIGN KEY (`alumni_id`) REFERENCES `alumni_profile` (`alumni_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_postings`
--

LOCK TABLES `job_postings` WRITE;
/*!40000 ALTER TABLE `job_postings` DISABLE KEYS */;
INSERT INTO `job_postings` VALUES ('0a02fefd-eeb9-44ff-a','A023','Marketing Coordinator','PRAN-RFL Group, Dhaka, Bangladesh','PRAN-RFL Group is Hiring Marketing Coordinator\r\n\r\nVacancy: 1\r\n\r\nSend your CV to: career@prangroup.com\r\n\r\nRequirements\r\n\r\nEducation:\r\n• Bachelor’s degree in Marketing, Business Administration, or a related field\r\n• MBA preferred but not mandatory\r\nExperience:\r\n• 1–2 years of experience in a marketing coordination, branding, or communications role\r\n• Experience in FMCG or manufacturing industry will be a strong advantage\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Solid understanding of marketing principles, campaign planning, and execution\r\n• Strong project coordination and multitasking abilities\r\n• Excellent written and verbal communication skills in both Bengali and English\r\n• Proficiency in MS Office (Excel, PowerPoint, Word) and basic familiarity with design/collaboration tools (e.g., Canva, Trello, or Google Workspace)\r\n• Strong attention to detail, time management, and reporting capability\r\n• Ability to manage multiple stakeholders and deadlines efficiently________________________________________\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Experience in digital marketing or social media campaign coordination\r\n• Familiarity with brand development and product positioning strategies\r\n• Basic knowledge of Adobe Creative Suite (Photoshop/Illustrator)\r\n• Exposure to retail marketing, trade marketing, or rural activation programs\r\n• Ability to generate creative ideas and contribute to brainstorming sessions\r\n\r\nWhat You’ll Need to Succeed:\r\n• A positive and collaborative attitude\r\n• Ownership mindset with a willingness to go the extra mile\r\n• Strong analytical skills and a drive to improve processes\r\n• Passion for marketing, brand building, and consumer engagement\r\n• Ability to work under pressure and meet tight deadlines\r\n\r\nDuties and Responsibilities:\r\n• Assist in planning and executing marketing campaigns across various channels (print, digital, retail)\r\n• Coordinate between internal teams (creative, sales, production) and external agencies/vendors\r\n• Prepare and maintain marketing calendars, budgets, and performance reports\r\n• Monitor competitor activities, industry trends, and market developments\r\n• Organize promotional events, trade fairs, and product launches\r\n• Ensure marketing materials and brand assets are aligned with guidelines and approved on time\r\n• Track campaign metrics, generate insights, and prepare presentations for management\r\n• Support content creation, product packaging design coordination, and market research activities\r\n\r\nSkills & Expertise:\r\nMarketing Coordination, Communication, Campaign Planning, FMCG Marketing, Brand Support, MS Office, Time Management, Stakeholder Management, Reporting, Consumer Insights\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits:\r\n\r\n• Competitive salary (Negotiable based on experience)\r\n• Mobile bill, festival bonuses, and provident fund\r\n• Lunch facilities: Subsidized\r\n• Yearly salary review and performance-based increment\r\n• Professional development opportunities and cross-functional exposure\r\n• Friendly, structured, and supportive workplace\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring #pranflgroup\r\n','2025-09-15'),('0bbeb27f-f2f9-47c9-b','A014','Data Analyst Intern','Pathao Ltd., Dhaka, Bangladesh','Pathao Ltd. is Hiring Data Analyst Intern\r\n\r\nVacancy: 2\r\n\r\nSend your CV to: internship@pathao.com\r\n\r\nRequirements\r\nEducation:\r\n• Final year student or recent graduate in CSE, Statistics, Mathematics, Data Science, or related field\r\n• OR self-learners with hands-on project experience and strong analytical mindset\r\n\r\nExperience:\r\n• No prior job experience required\r\n• Internship or academic project in data analysis is a plus\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Proficiency in Excel/Google Sheets for data manipulation\r\n• Basic knowledge of SQL (MySQL/PostgreSQL) for data querying\r\n• Familiarity with data visualization tools like Power BI, Tableau, or Looker Studio\r\n• Understanding of data cleaning, transformation, and exploratory data analysis (EDA)\r\n• Strong problem-solving skills and logical thinking\r\n• Effective communication of complex findings in simple terms\r\n\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Experience with Python (Pandas, NumPy, Matplotlib, Seaborn) or R\r\n• Knowledge of statistical methods or A/B testing principles\r\n• Familiarity with big data platforms (Google BigQuery, AWS Athena)\r\n• Hands-on with business intelligence tools or CRM systems\r\n• Exposure to data storytelling and dashboard design best practices\r\n\r\nWhat You’ll Need to Succeed:\r\n• Curiosity and a data-driven mindset\r\n• Strong attention to detail\r\n• Ability to work independently and in a fast-paced team environment\r\n• Willingness to learn and take initiative\r\n• Good communication skills to present data insights effectively\r\n• A portfolio of data projects or GitHub contributions (optional but appreciated)\r\n\r\n\r\nDuties and Responsibilities:\r\n• Collect, clean, and organize large datasets from various internal sources\r\n• Assist in building dashboards and regular reporting using tools like Power BI or Tableau\r\n• Analyze trends, patterns, and anomalies to provide actionable insights\r\n• Collaborate with cross-functional teams (Product, Operations, Marketing) to define KPIs\r\n• Support A/B testing, customer segmentation, and performance tracking\r\n• Present insights through visualizations and concise reports\r\n• Ensure data accuracy and maintain documentation for data processes\r\n\r\nSkills & Expertise\r\nData Analysis, SQL, Excel, Visualization, Business Intelligence, Communication, Problem Solving, Critical Thinking, Python/R (Optional)\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits\r\n• Monthly internship allowance (negotiable)\r\n• 5 working days/week (Sunday to Thursday)\r\n• Friendly work environment with mentorship and learning opportunities\r\n• Real-world experience with impactful data projects\r\n• Opportunity to transition to a full-time role based on performance\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring #pathaoltd.','2025-10-05'),('1375a8b9-e4df-431a-b','A024','UI/UX Design Intern','Selise Digital Platforms, Dhaka, Bangladesh','Selise Digital Platforms is Hiring UI/UX Design Intern\r\n\r\nVacancy: 2\r\n\r\nSend your CV to: careers@selisegroup.com\r\n\r\nRequirements\r\nEducation:\r\n• Final year student or recent graduate in CSE, Graphic Design, HCI, or a relevant field\r\n• OR solid self-taught knowledge with a strong portfolio\r\n\r\nExperience:\r\n• Prior internship or academic project experience in UI/UX design preferred\r\n• Freshers with a strong portfolio are encouraged to apply\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Familiarity with design tools like Figma, Adobe XD, Sketch, or similar\r\n• Basic knowledge of UI principles, responsive design, and usability\r\n• Ability to create user flows, wireframes, mockups, and interactive prototypes\r\n• Good understanding of typography, color theory, and layout design\r\n• Willingness to take feedback and improve iteratively\r\n• Strong visual storytelling and communication skills\r\n\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Familiarity with front-end technologies (HTML/CSS/JS)\r\n• Experience working with design systems or style guides\r\n• Exposure to tools like Miro, Whimsical, or Framer\r\n• Animation/microinteraction design with tools like Lottie or Principle\r\n• Interest in user psychology or behavior-driven design\r\n\r\nWhat You’ll Need to Succeed:\r\n• A creative and analytical mindset\r\n• Passion for improving user experience\r\n• Collaborative attitude and openness to feedback\r\n• Strong attention to detail\r\n• Ability to meet deadlines in a fast-paced environment\r\n• A strong portfolio showcasing design thinking and process\r\n\r\nDuties and Responsibilities:\r\n• Assist in creating wireframes, prototypes, and user flows for web and mobile applications\r\n• Collaborate with cross-functional teams including developers, business analysts, and QA engineers\r\n• Conduct user research and usability testing to guide design decisions\r\n• Support in translating client requirements into impactful visual design concepts\r\n• Ensure consistency and adherence to design systems and brand guidelines\r\n• Stay updated with the latest UI/UX trends, tools, and design principles\r\n\r\nSkills & Expertise\r\nCreativity, Empathy, Visual Design, Critical Thinking, Team Collaboration, Communication, Figma, Adobe XD\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits\r\n• Monthly stipend (negotiable based on skills)\r\n• 5-day work week (Sunday to Thursday)\r\n• Hybrid work environment\r\n• Mentorship from experienced design professionals\r\n• Real project experience with international clients\r\n• Opportunity for full-time employment based on performance\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring #selisedigitalplatforms','2025-10-01'),('3617e155-15e8-4269-9','A011','Digital Marketing Associate','Unilever Bangladesh Ltd.','Unilever Bangladesh Ltd. is Hiring Digital Marketing Associate\r\n\r\nVacancy: 1\r\n\r\nSend your CV to: careers.bd@unilever.com\r\n\r\nRequirements\r\nEducation:\r\n• Bachelor’s degree in Marketing, Business, Media & Communication, or relevant field\r\n• Certifications in Digital Marketing (Google, Meta, HubSpot, etc.) will be an added advantage\r\n\r\nExperience:\r\n• 1–2 years of experience in digital marketing or related roles\r\n• Freshers with strong internship experience and portfolio are also encouraged to apply\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Solid understanding of digital marketing channels: social media, SEO, email marketing, PPC\r\n• Proficient in Google Analytics, Google Ads, Meta Ads Manager, and social media management tools\r\n• Hands-on experience in creating, managing, and optimizing paid campaigns\r\n• Strong copywriting and storytelling skills for digital platforms\r\n• Analytical mindset and ability to interpret digital data into actionable strategies\r\n• Up-to-date with digital trends, tools, and best practices\r\n________________________________________\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Experience with marketing automation platforms (Mailchimp, HubSpot, etc.)\r\n• Knowledge of basic HTML/CSS or CMS platforms (e.g., WordPress)\r\n• Familiarity with influencer marketing and affiliate strategy\r\n• Exposure to brand marketing in the FMCG sector\r\n• Ability to create basic visual content using Canva, Adobe Creative Suite, etc.\r\n\r\nWhat You’ll Need to Succeed:\r\n• A growth mindset and creativity\r\n• Strategic thinking with an eye for performance metrics\r\n• Ability to manage multiple campaigns and tight deadlines\r\n• Excellent collaboration and communication skills\r\n• Passion for branding, digital innovation, and consumer engagement\r\n\r\nDuties and Responsibilities:\r\n• Plan, execute, and optimize digital marketing campaigns across social media, SEO, paid media, email, and web\r\n• Coordinate with creative agencies to develop engaging content aligned with brand tone and objectives\r\n• Monitor digital campaign performance and prepare weekly/monthly performance reports using tools like Google Analytics, Meta Business Suite, etc.\r\n• Manage and grow online brand presence through community engagement and influencer collaboration\r\n• Conduct competitive research, audience analysis, and digital trend tracking\r\n• Assist in e-commerce marketing strategy and coordinate promotional activities with online partners\r\n• Collaborate with internal brand teams, media buyers, and external vendors to ensure digital alignment\r\n• Stay updated with the latest UI/UX trends, tools, and design principles\r\n\r\nSkills & Expertise:\r\nDigital Marketing Strategy, SEO/SEM, Analytics, Social Media Marketing, Campaign Management, Copywriting, Paid Media, Google Ads, Meta Ads, Communication\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits\r\n• Competitive salary (Negotiable based on experience)\r\n• Mobile bill, Provident fund, Performance bonuses\r\n• Lunch facilities: Subsidized\r\n• Annual salary review and performance-based increments\r\n• Health & wellness support, learning and development programs\r\n• Global exposure through Unilever’s regional and international networks\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring # unileverbangladeshltd.\r\n','2025-09-20'),('4c38e054-c563-4a33-9','A013','Junior Backend Developer','BJIT Ltd., Dhaka, Bangladesh','BJIT Ltd. is Hiring Junior Backend Developer\r\n\r\nVacancy: 2\r\n\r\nSend your CV to: career@bjitgroup.com\r\n\r\nRequirements\r\nEducation:\r\n• BSc in Computer Science, Software Engineering, or relevant discipline\r\n• Candidates with strong project/internship experience in backend development are encouraged to apply\r\nExperience:\r\n• 0.5 to 1.5 years of experience preferred\r\n• Freshers with excellent GitHub portfolios or strong academic project experience are welcome\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Proficiency in at least one backend language: Node.js, Python (Django/Flask), Java (Spring Boot), or PHP (Laravel)\r\n• Experience with RESTful API design and development\r\n• Familiarity with Relational Databases (MySQL/PostgreSQL) and NoSQL (MongoDB)\r\n• Understanding of authentication mechanisms (JWT, OAuth, etc.)\r\n• Experience with Git/GitHub for version control\r\n• Basic knowledge of server deployment, CI/CD pipelines, or Docker________________________________________\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Experience with GraphQL, WebSockets, or real-time communication\r\n• Familiarity with Cloud services (AWS, GCP, or Azure)\r\n• Knowledge of message queues (RabbitMQ, Kafka, etc.)\r\n• Exposure to microservices architecture\r\n• Understanding of testing tools (Postman, Jest, Mocha, etc.)\r\n• Participation in open-source projects or hackathons\r\n\r\nWhat You’ll Need to Succeed:\r\n• Strong problem-solving and analytical skills\r\n• Passion for building efficient and scalable backend systems\r\n• Ability to work both independently and in a team-oriented environment\r\n• Curiosity to learn new technologies and take ownership of your work\r\n• Good communication and documentation skills\r\n\r\nDuties and Responsibilities:\r\n• Develop, test, and maintain server-side logic and RESTful APIs\r\n• Collaborate with front-end developers and other team members to integrate user-facing elements with server-side logic\r\n• Write clean, scalable, and well-documented code following best practices\r\n• Maintain and optimize databases for performance and reliability\r\n• Debug, troubleshoot, and fix bugs in production and development environments\r\n• Participate in code reviews, sprint planning, and technical discussions\r\n• Stay updated with backend technologies and development trends\r\n\r\nSkills & Expertise:\r\nNode.js / Django / Spring Boot, REST API, SQL, NoSQL, Git, Backend Architecture, Server Management, Team Collaboration, Debugging, Docker (optional)\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits\r\n• Competitive salary (Negotiable based on skill and experience)\r\n• 5 working days/week (Sunday to Thursday)\r\n• Provident fund, yearly salary review, and performance bonuses\r\n• Medical allowance and annual health checkup\r\n• Lunch facilities: Subsidized\r\n• Access to international training and global project exposure\r\n• Friendly work environment with career growth opportunities\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring # bjitltd.\r\n','2025-10-03'),('5140380a-610e-4085-9','A003','Junior Web Developer','TechSoft Ltd.','TechSoft Ltd. is Hiring Junior Web Developer\r\n\r\nVacancy: 2\r\n\r\nSend your CV to: hr@techsoft.com.bd\r\n\r\nRequirements\r\n\r\nEducation:\r\n• BSc in Computer Science, Software Engineering, or a related field\r\n• Candidates with strong project experience or relevant certifications are also encouraged to apply\r\nExperience:\r\n• 0.5 to 1.5 years of experience in web development\r\n• Freshers with strong portfolios and academic projects are welcome\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Strong knowledge of HTML5, CSS3, JavaScript (ES6+)\r\n• Experience in front-end frameworks/libraries like React.js, Vue.js, or basic jQuery\r\n• Understanding of back-end technologies such as PHP, Node.js, or Python (basic level)\r\n• Familiarity with relational databases (MySQL/PostgreSQL)\r\n• Basic knowledge of RESTful API integration\r\n• Version control using Git and GitHub\r\n• Understanding of responsive design and cross-browser compatibility________________________________________\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Experience with CMS platforms like WordPress or Shopify\r\n• Familiarity with Tailwind CSS, Bootstrap, or Material UI\r\n• Exposure to deployment tools or platforms (cPanel, Netlify, Vercel)\r\n• Basic SEO and website performance optimization knowledge\r\n• Knowledge of Docker, CI/CD tools, or Firebase\r\n\r\nWhat You’ll Need to Succeed:\r\n• A problem-solving mindset and willingness to learn\r\n• Good communication and teamwork skills\r\n• Strong attention to detail and commitment to quality\r\n• Ability to manage time effectively and meet deadlines\r\n• Curiosity to explore new technologies and coding trends\r\n\r\nDuties and Responsibilities:\r\n• Develop responsive websites and web applications using HTML, CSS, JavaScript, and related technologies\r\n• Assist in building and integrating front-end interfaces with backend APIs\r\n• Write clean, maintainable, and scalable code following web standards and best practices\r\n• Work with designers to convert UI/UX mockups into functional web pages\r\n• Troubleshoot, test, and maintain web applications to ensure optimal performance and user experience\r\n• Collaborate with senior developers and project managers to meet delivery timelines\r\n• Maintain documentation for code, technical processes, and user guides\r\n• Stay updated with emerging web technologies and frameworks\r\n\r\nSkills & Expertise:\r\nWeb Development, HTML, CSS, JavaScript, React.js, PHP/Node.js, Git, Responsive Design, REST API, UI Integration\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits:\r\n\r\n• Competitive salary (Negotiable based on skills and experience)\r\n• 5 working days/week (Sunday to Thursday)\r\n• Yearly salary review and performance-based increments\r\n• Festival bonuses: 2\r\n• Friendly and collaborative work environment\r\n• Continuous learning opportunities and mentorship\r\n• Career growth with exposure to international projects\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring #techsoftltd.\r\n','2025-06-25'),('8f7a9bc8-7c26-4ddf-8','A021','Finance Associate','BRAC Bank Limited, Dhaka, Bangladesh','BRAC Bank Limited is Hiring Finance Associate\r\n\r\nVacancy: 1\r\n\r\nSend your CV to: careers@bracbank.com\r\n\r\nRequirements\r\n\r\nEducation:\r\n• Bachelor’s degree in Finance, Accounting, Business Administration, or related field\r\n• Professional certifications (CA-CC, CMA, ACCA part qualified) are preferred but not mandatory\r\nExperience:\r\n• 1–2 years of relevant work experience in a bank, financial institution, or audit firm\r\n• Fresh graduates with strong academic backgrounds may also apply\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Sound knowledge of accounting principles, financial reporting, and regulatory compliance\r\n• Proficiency in MS Excel, MS Word, and financial reporting tools (e.g., Tally, Oracle, SAP)\r\n• Excellent attention to detail and analytical skills\r\n• Strong organizational skills and ability to handle multiple tasks efficiently\r\n• Knowledge of Bangladesh Bank reporting formats and tax/VAT rules\r\n• Effective communication skills for interdepartmental coordination________________________________________\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Experience in core banking systems or ERP platforms\r\n• Familiarity with IFRS/BAS reporting standards\r\n• Ability to automate reports using Excel Macros, Power Query, or Power BI\r\n• Participation in financial projects, audits, or risk assessments\r\n• Good understanding of treasury or investment accounting principles\r\n\r\nWhat You’ll Need to Succeed:\r\n• Integrity and a high level of responsibility in handling financial data\r\n• Ability to work under pressure and meet strict deadlines\r\n• Strong initiative and ownership mindset\r\n• Team player with a collaborative attitude\r\n• Eagerness to learn and grow within the banking sector\r\n\r\nDuties and Responsibilities:\r\n• Assist in preparing monthly, quarterly, and annual financial reports in compliance with regulatory and internal standards\r\n• Support budgeting and forecasting processes for various departments\r\n• Monitor daily financial transactions, reconcile bank statements, and ensure accurate recordkeeping\r\n• Collaborate with auditors during internal and external audits by providing necessary documentation\r\n• Ensure compliance with central bank regulations, tax requirements, and internal policies\r\n• Maintain financial databases, reports, and spreadsheets with high accuracy\r\n• Assist in financial analysis, variance reporting, and cost control initiatives\r\n• Coordinate with departments to ensure timely submission of financial data\r\n\r\nSkills & Expertise:\r\nFinancial Reporting, MS Excel, Budgeting, Compliance, Audit Support, Reconciliation, Accounting Software, Financial Analysis, Tax & VAT Knowledge, Team Collaboration\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits:\r\n\r\n• Competitive salary (Negotiable based on experience)\r\n• Mobile bill, Provident Fund, Gratuity, and Insurance coverage\r\n• Lunch facilities: Subsidized\r\n• Yearly salary review and performance bonus\r\n• Festival bonuses: 2\r\n• Career progression in a leading financial institution\r\n• Access to professional training and banking certifications\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring #bracbankltd.\r\n','2025-12-01'),('f166b52f-72f0-40c4-8','A025','IT Support Intern','Infrastructure & Networking','Infrastructure & Networking Department is hiring IT Support Intern\r\n\r\nVacancy: 2\r\n\r\nSend your CV to: it.recruit@company.com\r\n\r\nRequirements\r\n\r\nEducation:\r\n• Diploma/BSc in CSE, EEE, IT, or a related discipline\r\n• Final year students or recent graduates preferred\r\nExperience:\r\n• No prior job experience required\r\n• Academic projects or hands-on lab work in networking/support will be a plus\r\n\r\nAdditional Requirements\r\n• Age at least 24 years\r\n\r\nMust-Have Skills:\r\n• Basic knowledge of computer hardware, operating systems (Windows/Linux)\r\n• Familiarity with IP addressing, DHCP, DNS, and common networking concepts\r\n• Experience with MS Office and troubleshooting common software issues\r\n• Understanding of how to configure routers, switches, and access points (basic level)\r\n• Ability to diagnose and resolve IT issues promptly\r\n• Good documentation and reporting skills________________________________________\r\nBonus Skills (Not Mandatory but a Plus):\r\n• Exposure to network monitoring tools (e.g., Wireshark, PRTG)\r\n• Knowledge of Active Directory, file servers, or domain controllers\r\n• Familiarity with ticketing systems like Jira or Freshdesk\r\n• Hands-on experience with virtualization tools (VMware, VirtualBox, etc.)\r\n• Certification (or coursework) in CCNA, CompTIA A+/N+, or Microsoft Fundamentals\r\n\r\nWhat You’ll Need to Succeed:\r\n• A problem-solving attitude with a proactive mindset\r\n• Willingness to learn new tools, protocols, and procedures\r\n• Good time management and organizational skills\r\n• Ability to follow instructions and document processes clearly\r\n• Strong teamwork and communication abilities\r\n\r\nDuties and Responsibilities:\r\n• Provide first-level technical support for hardware, software, and network issues\r\n• Assist in setting up desktops, laptops, printers, and other IT equipment\r\n• Support installation, configuration, and updates of operating systems and applications\r\n• Troubleshoot LAN/WAN, Wi-Fi, and internet connectivity problems\r\n• Maintain inventory and documentation of IT assets\r\n• Monitor system logs, backup processes, and server status\r\n• Assist in setting up and maintaining structured cabling, switches, routers, and firewalls\r\n• Escalate unresolved issues to senior IT staff when necessary\r\n\r\nSkills & Expertise:\r\nTechnical Troubleshooting, Networking Basics, Hardware Support, LAN/WAN, MS Windows/Linux, Communication, System Setup, IT Asset Management\r\n\r\nSalary: Negotiable\r\n\r\nCompensation & Other Benefits:\r\n\r\n• Monthly internship allowance (based on skills and performance)\r\n• 5 working days/week (Sunday to Thursday)\r\n• Access to internal training, mentoring, and certifications\r\n• Certificate upon successful completion of the internship\r\n• Opportunity to be considered for full-time employment\r\n\r\nWorkplace\r\nWork at office\r\n\r\nEmployment Status\r\nFull Time\r\n\r\nJob Location\r\nDhaka\r\n\r\n#job #hiring # infrastructureandnetworkingdepartment\r\n','2025-12-01');
/*!40000 ALTER TABLE `job_postings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mentorship`
--

DROP TABLE IF EXISTS `mentorship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mentorship` (
  `mentorship_id` varchar(20) NOT NULL,
  `mentor_id` varchar(20) NOT NULL,
  `mentee_id` varchar(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  PRIMARY KEY (`mentorship_id`),
  KEY `mentor_id` (`mentor_id`),
  KEY `mentee_id` (`mentee_id`),
  CONSTRAINT `mentorship_ibfk_1` FOREIGN KEY (`mentor_id`) REFERENCES `alumni_profile` (`alumni_id`) ON DELETE CASCADE,
  CONSTRAINT `mentorship_ibfk_2` FOREIGN KEY (`mentee_id`) REFERENCES `student_profile` (`student_id`) ON DELETE CASCADE,
  CONSTRAINT `mentorship_chk_1` CHECK ((`status` in (_utf8mb4'pending',_utf8mb4'active',_utf8mb4'completed',_utf8mb4'rejected')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mentorship`
--

LOCK TABLES `mentorship` WRITE;
/*!40000 ALTER TABLE `mentorship` DISABLE KEYS */;
INSERT INTO `mentorship` VALUES ('18D75D9E','A003','S012','pending','2025-06-20'),('77D81FF3','A003','S002','Active','2025-06-22'),('CFCA3BB8','A003','S004','Completed','2025-06-20'),('D0AB5C08','A003','S002','Rejected','2025-06-20'),('M_007A1160','A023','S020','Active','2025-07-05'),('M_03864BE3','A013','S010','Active','2025-07-06'),('M_04D860D0','A003','S002','Rejected','2025-07-05'),('M_089B872A','A011','S022','Pending','2025-07-05'),('M_0961C38C','A025','S019','Pending','2025-07-05'),('M_0F11A56F','A011','S015','Pending','2025-07-05'),('M_1ADE6E01','A003','S010','Rejected','2025-07-06'),('M_1BDBA0C9','A014','S010','Active','2025-07-06'),('M_2249D9ED','A023','S022','Active','2025-07-05'),('M_2E96E99D','A013','S016','Active','2025-07-05'),('M_3BCAB420','A024','S017','Active','2025-07-05'),('M_3C1150CB','A024','S015','Active','2025-07-06'),('M_3D81DBAF','A014','S016','Active','2025-07-05'),('M_3FB29100','A014','S017','Active','2025-07-05'),('M_4E076289','A003','S010','Active','2025-07-06'),('M_5282DDFB','A025','S017','Active','2025-07-05'),('M_594DB8C1','A024','S010','Active','2025-07-06'),('M_5F744B8D','A025','S016','Active','2025-07-05'),('M_60DB6BF5','A014','S015','Pending','2025-07-06'),('M_64B5BE15','A023','S018','Active','2025-07-05'),('M_6DDFC77C','A024','S022','Pending','2025-07-05'),('M_782DA374','A003','S017','Active','2025-07-05'),('M_79032943','A011','S020','Pending','2025-07-05'),('M_7AD872B2','A003','S020','Active','2025-07-06'),('M_7C9FEF36','A025','S012','Pending','2025-07-06'),('M_83937D10','A023','S017','Pending','2025-07-05'),('M_89B931B1','A003','S015','Rejected','2025-07-06'),('M_8C23ACB7','A013','S015','Active','2025-07-05'),('M_9C6F2ADE','A021','S020','Active','2025-07-05'),('M_A8859B7C','A013','S002','Active','2025-07-05'),('M_AA628B7C','A011','S018','Pending','2025-07-05'),('M_AAAEC591','A003','S015','Active','2025-07-05'),('M_B0FFABBC','A024','S010','Active','2025-07-06'),('M_B104482E','A013','S019','Pending','2025-07-05'),('M_B4794868','A023','S022','Active','2025-07-05'),('M_B97659FA','A025','S010','Active','2025-07-06'),('M_BB9647D2','A021','S022','Active','2025-07-05'),('M_C9F984F8','A021','S018','Active','2025-07-05'),('M_D2FD41E7','A003','S020','Rejected','2025-07-05'),('M_DEAE650B','A011','S020','Pending','2025-07-05'),('M_E0DD8358','A013','S017','Active','2025-07-05'),('M_F7026FB7','A003','S016','Active','2025-07-05'),('M_FAB65104','A025','S015','Active','2025-07-06'),('M_FE9F67A7','A021','S020','Rejected','2025-07-05');
/*!40000 ALTER TABLE `mentorship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `message_id` varchar(20) NOT NULL,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `content` text NOT NULL,
  `timestamp` datetime NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `is_reported` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`message_id`),
  KEY `messages_ibfk_1` (`sender_id`),
  KEY `messages_ibfk_2` (`receiver_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES ('26293a6b-d423-4a3e-a',3,4,'kjhkjhgjh','2025-07-09 17:12:33',0,0),('386d71fe-8695-41f5-b',12,11,'hey, can we talk?','2025-06-20 15:24:35',1,0),('51d1fd27-f875-415e-a',4,2,'how do u do','2025-06-20 13:06:17',1,0),('58e82653-50b3-4c39-a',2,4,'hello.','2025-06-20 13:05:38',1,0),('85b2619d-91c1-45ae-9',4,2,'same','2025-06-20 14:07:48',1,0),('89af9300-b150-4642-b',1,4,'Your message was reported. Please follow community guidelines.','2025-07-04 08:17:01',0,0),('8f188ec0-a12b-4992-a',2,4,'fine','2025-06-20 13:32:20',1,0),('a0facd75-f1ea-4c96-8',2,4,'good to know\r\n','2025-07-06 15:24:45',0,0),('b60be762-d2a4-49c1-8',3,4,'Hello, there.','2025-06-20 12:16:49',1,0),('b8639709-b938-4588-9',4,3,'hi','2025-06-20 12:51:51',1,0),('b9d948dc-4924-450a-9',3,4,'sup\r\n','2025-07-09 17:12:12',0,0),('bcd17226-cca5-4350-9',4,3,'...','2025-06-20 13:00:57',1,1),('c0b1a700-0980-4d0a-9',11,12,'no\r\n','2025-06-20 15:25:37',0,0),('c46787e1-b325-4cec-9',4,3,'hi','2025-06-20 12:49:40',1,0),('d8c9930b-2403-40bc-8',4,3,'thanks for reaching out to me','2025-06-20 12:55:59',1,0);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `our_community`
--

DROP TABLE IF EXISTS `our_community`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `our_community` (
  `role_id` varchar(20) NOT NULL,
  `alumni_id` varchar(20) DEFAULT NULL,
  `role_title` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`role_id`),
  KEY `alumni_id` (`alumni_id`),
  CONSTRAINT `our_community_ibfk_1` FOREIGN KEY (`alumni_id`) REFERENCES `alumni_profile` (`alumni_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `our_community`
--

LOCK TABLES `our_community` WRITE;
/*!40000 ALTER TABLE `our_community` DISABLE KEYS */;
INSERT INTO `our_community` VALUES ('R23c32414','A011','President','2024-01-05','2025-07-31','Leads the alumni association, oversees all operations, represents the community officially, and makes key decisions for long-term goals.'),('R3b336ca6','A021','General Secretary','2025-01-15','2026-03-04','Maintains records, handles internal communication, schedules meetings, and ensures smooth coordination among members.\r\n'),('R4e95897d','A003','Editor','2025-03-05','2026-02-06','Creates and manages newsletters, alumni stories, and official content; ensures clear, engaging communication across platforms.\r\n'),('R4f763940','A024','General Secretary','2024-01-05','2025-07-31','Maintains records, handles internal communication, schedules meetings, and ensures smooth coordination among members.\r\n'),('R7bfde0ba','A014','Vice President','2024-01-05','2025-07-31','Supports the president, manages responsibilities in their absence, and helps coordinate strategic initiatives and events.'),('Rbc0d86cd','A025','Editor','2025-01-04','2026-01-05','Creates and manages newsletters, alumni stories, and official content; ensures clear, engaging communication across platforms.\r\n');
/*!40000 ALTER TABLE `our_community` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_drafts`
--

DROP TABLE IF EXISTS `student_drafts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_drafts` (
  `draft_id` varchar(20) NOT NULL,
  `student_id` varchar(20) DEFAULT NULL,
  `project_title` varchar(100) DEFAULT NULL,
  `project_desc` text,
  `research_paper` text,
  `thesis_summary` text,
  `club_details` text,
  PRIMARY KEY (`draft_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `student_drafts_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_profile` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_drafts`
--

LOCK TABLES `student_drafts` WRITE;
/*!40000 ALTER TABLE `student_drafts` DISABLE KEYS */;
INSERT INTO `student_drafts` VALUES ('D05d5effa','S012','Impact of Urbanization on Local Biodiversity','This project investigates how urban development affects plant and animal diversity in a specific area. It includes species surveys, habitat mapping, and proposing conservation strategies.','','',''),('D0d7524a7','S016',' Real-Time Sign Language Translator using Computer Vision','Use a webcam to capture hand gestures and translate sign language to text/speech using TensorFlow or MediaPipe, helping bridge communication for the hearing-impaired.','Human Emotion Detection using EEG Signals and Deep Learning - Use EEG datasets to detect human emotions using deep neural networks or CNNs. This can be used in mental health monitoring, BCI (Brain-Computer Interface), and gaming.','','VisionX - Specialized in computer vision and AR/VR, focusing on AI-powered image processing and augmented reality projects.'),('D35022552','S010','ChatBot for University Helpdesk','A chatbot using Dialogflow or Rasa that answers student queries about admissions, class schedules, exam dates, and notices through a simple web or Telegram interface.','Lightweight Cryptographic Algorithms for IoT Devices - Investigate cryptographic algorithms suitable for constrained environments like IoT sensors. Compare existing methods (like Tiny Encryption Algorithm) and propose optimizations in speed and energy efficiency.\r\n\r\n','','ByteBuddies - A beginner-friendly club where students learn programming fundamentals, solve DSA problems, and build small projects together.'),('D5b6bc495','S015','IoT-Based Smart Waste Monitoring System','Use Arduino/Raspberry Pi and sensors to detect waste levels in bins and send alerts to municipal services through a dashboard, optimizing collection routes.\r\n\r\n','','',''),('D5bc5e224','S017','Personal Finance Tracker with ML Spending Analysis','A mobile/web app that allows users to record expenses, categorize them, and predict future expenses using machine learning based on past behavior.','','',''),('D7cd8a3d1','S018','Financial Statement Analysis of a Public Company','Evaluate the profitability, liquidity, and solvency of a listed company using ratio analysis, trend analysis, and comparative statements over a 5-year period.','','',''),('Dc46a852a','S002','Smart Health Monitoring Wristband','A wearable device prototype to measure vitals and alert doctors in emergencies','','',''),('Ddbcef6f3','S002','AI-Powered Attendance System','An automated attendance tracking system using facial recognition.','This paper explores the use of OpenCV and deep learning for real-time face detection in classrooms.','The project focuses on the application of CNNs for facial recognition in institutional settings.','Tech Club: Worked as the lead in the facial recognition sub-team.'),('Defecbfbb','S022','Comparative Analysis of Mutual Funds and Stock Market Returns','Compare returns and risks of mutual funds vs. direct stock investments using performance metrics like NAV, Alpha, and Beta over a 3-5 year period.','','',''),('DRAFT002','S004','Smart Health Monitoring Wristband','A wearable device prototype to measure vitals and alert doctors in emergencies.','Research includes microcontroller interfacing, pulse oximetry, and IoT alert systems.','Thesis summarizes the effectiveness of continuous health monitoring through wearables.','Innovation Club: Participated in health-tech startup pitching.');
/*!40000 ALTER TABLE `student_drafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_profile`
--

DROP TABLE IF EXISTS `student_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_profile` (
  `student_id` varchar(20) NOT NULL,
  `user_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `department` varchar(50) NOT NULL,
  `year` int NOT NULL,
  `interests` text,
  `picture` varchar(100) DEFAULT NULL,
  `is_graduate` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`student_id`),
  KEY `student_profile_ibfk_1` (`user_id`),
  CONSTRAINT `student_profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `student_profile_chk_1` CHECK ((`year` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_profile`
--

LOCK TABLES `student_profile` WRITE;
/*!40000 ALTER TABLE `student_profile` DISABLE KEYS */;
INSERT INTO `student_profile` VALUES ('S002',2,'Abdullah Towhid','CSE',1,'Backend web development, HTML, CSS','profiles/student/test_81QKThNShyL.jpg',0),('S004',4,'Akib Mahmud','ICT',2,'Machine Learning, UI/UX',NULL,0),('S010',10,'Bushra Chowdhury','CSE',1,NULL,'profiles/student/asd_OIP (3).jpg',0),('S012',12,'Sakib Ahmed','ES',2,'Geography and social science','profiles/student/sakib_.__OIP (5).webp',0),('S015',15,'Samiha Binte','ICT',2,NULL,'profiles/student/samiha_iiii.webp',0),('S016',16,'Anika Tabassum','CSE',1,'Web Management, Artificial Intelligence','profiles/student/tabassum_OIP (6).jpg',0),('S017',17,'Rehnuma Nowrin','ICT',3,'Graphics Designing','profiles/student/Rehnuma_uuuu.jpg',0),('S018',18,'Soad Rahman','Finance',3,'Business','profiles/student/soad_ooo.jpg',0),('S019',19,'Zahed Mahmud','IR',4,'Global Affairs','profiles/student/zahed_OIP (4).jpg',1),('S020',20,'Salman Shah','Marketing',4,'Business Affairs','profiles/student/salman_hh.jpg',0),('S022',22,'Mehrin Akhter','Marketing',2,'teaching','profiles/student/mehrin_OIP (7).jpg',0),('S028',28,'Fahmida Akter','Marketing',3,'singing',NULL,0);
/*!40000 ALTER TABLE `student_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `testimonials`
--

DROP TABLE IF EXISTS `testimonials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `testimonials` (
  `testimonial_id` varchar(20) NOT NULL,
  `user_id` int NOT NULL,
  `content` text NOT NULL,
  `date_posted` date NOT NULL,
  `approved` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`testimonial_id`),
  KEY `testimonials_ibfk_1` (`user_id`),
  CONSTRAINT `testimonials_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `testimonials`
--

LOCK TABLES `testimonials` WRITE;
/*!40000 ALTER TABLE `testimonials` DISABLE KEYS */;
INSERT INTO `testimonials` VALUES ('03b1ee38',24,'As a UI/UX Design Intern, the foundation I received at my university helped me bridge creativity with strategy. I’m proud to say it opened the door to my first full-time role.','2025-07-05',1),('1f0beaf2',2,'My experience at the university has been truly transformative. The teachers are supportive and the campus life is vibrant.','2025-06-26',1),('3af52aba',13,'The professors at my university didn’t just teach subjects — they mentored us. Their guidance helped me find clarity in my career path and purpose.','2025-07-05',1),('41f9c2dd',14,'Joining student clubs and organizing campus events helped me develop soft skills I now use in my corporate job every day.','2025-07-05',1),('4ddb46e0',25,'Beyond books and lectures, my university gave me leadership experience, lifelong friendships, and the confidence to take on the world.','2025-07-05',1),('99a33ca8',3,'\"My time at my university shaped who I am today. The faculty didn’t just teach us theory — they inspired curiosity, creativity, and confidence. I left with more than a degree — I left with a vision.\"','2025-07-05',1),('abba8fd7',23,'Courses on innovation, real-world case studies, and hackathons helped me think outside the box. That mindset is what drives my startup today.','2025-07-05',1),('b7682fc0',21,'Joining student clubs and organizing campus events helped me develop soft skills I now use in my corporate job every day.','2025-07-05',1),('c2d341bb',11,'The practical learning, industry projects, and internship support at [University] made me job-ready even before graduation. I still use the principles I learned here every day.','2025-07-05',1);
/*!40000 ALTER TABLE `testimonials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  CONSTRAINT `users_chk_1` CHECK ((`role` in (_utf8mb4'student',_utf8mb4'alumni',_utf8mb4'admin')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'saida','saida123@gmail.com','123','admin',1),(2,'towhid','abdullatowhid@gmail.com','123','student',1),(3,'mukit','mkit@gmail.com','123','alumni',1),(4,'akib','akibbb@gmail.com','123','student',1),(10,'bushra','bush@gmail.com','123','student',1),(11,'anika_._','anikatasneem@gmail.com','123','alumni',1),(12,'sakib_._','sakibahmed@gmail.com','123','student',1),(13,'syn_._','s.islam@gmail.com','123','alumni',1),(14,'khaa_._','khaled@gmail.com','123','alumni',1),(15,'samiha','samiha@gmail.com','123','student',1),(16,'tabassum','anika@gmail.com','123','student',1),(17,'Rehnuma','rehnuma@gmail.com','123','student',1),(18,'soad','soad@gmail.com','123','student',1),(19,'zahed','zahed@gmail.com','123','student',1),(20,'salman','salman@gmail.com','123','student',1),(21,'ava_._','abantika@gmail.com','123','alumni',1),(22,'mehrin','mehrin@gmail.com','123','student',1),(23,'sadia','sadia@gmail.com','123','alumni',1),(24,'afrina','afrina@gmail.com','123','alumni',1),(25,'fayeaz','fayeaz@gmail.com','123','alumni',1),(26,'subaha','sub@gmail.com','123','admin',1),(27,'shafika','shafika@gmail.com','123','admin',1),(28,'fahmida','fah@gmail.com','123','student',1),(29,'sara','sara@gmail.com','123','alumni',1),(30,'sadman','shs@gmail.com','123','admin',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `valid_university_ids`
--

DROP TABLE IF EXISTS `valid_university_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valid_university_ids` (
  `uni_id` varchar(20) NOT NULL,
  `role` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`uni_id`),
  CONSTRAINT `valid_university_ids_chk_1` CHECK ((`role` in (_utf8mb4'student',_utf8mb4'alumni',_utf8mb4'admin')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `valid_university_ids`
--

LOCK TABLES `valid_university_ids` WRITE;
/*!40000 ALTER TABLE `valid_university_ids` DISABLE KEYS */;
INSERT INTO `valid_university_ids` VALUES ('20140321','alumni'),('20150123','alumni'),('20160089','alumni'),('20170056','alumni'),('20180022','alumni'),('20210077','student'),('20220045','student'),('20230011','student'),('20230012','student'),('20230013','student'),('admin001','admin'),('admin002','admin');
/*!40000 ALTER TABLE `valid_university_ids` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-10  0:51:49
