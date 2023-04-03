-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 28, 2022 at 09:33 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hospital management system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `procedure_patient` ()   BEGIN
DECLARE done INT DEFAULT 0;
DECLARE N VARCHAR(20);
DECLARE I VARCHAR(10);
DECLARE D DATE;
DECLARE cursor_patient CURSOR FOR 
SELECT `Patient ID`, `Name`, `Date of Registration` FROM patient;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
OPEN cursor_patient;
label: LOOP
FETCH cursor_patient INTO I, N, D;
IF done = 1 THEN 
    LEAVE label;
END IF;
IF DATEDIFF(CURRENT_DATE(), D) < 60 THEN
    INSERT INTO backup VALUES(I, N);    
END IF;
END LOOP label;
CLOSE cursor_patient;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `transaction_cost` (IN `T_ID` VARCHAR(10), OUT `cost` FLOAT)   BEGIN

SELECT SUM(transaction_item.Quantity * pharmacy.Price) INTO cost
FROM transaction_item
INNER JOIN pharmacy 
ON transaction_item.`Item ID` = pharmacy.`Item ID`
WHERE transaction_item.`Transaction ID` = T_ID;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_expiry` (`D` DATE) RETURNS VARCHAR(20) CHARSET utf8mb4  BEGIN
DECLARE statement_value VARCHAR(20);
IF D < CURRENT_DATE() THEN
SET statement_value = 'Expired';
ELSEIF DATEDIFF(D, CURRENT_DATE()) < 60 THEN
SET statement_value = 'Expiring Soon';
ELSE
SET statement_value = 'Valid';
END IF;
RETURN statement_value;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `Admin ID` varchar(10) COLLATE utf16_unicode_ci NOT NULL,
  `Name` varchar(20) COLLATE utf16_unicode_ci NOT NULL,
  `Aadhar ID` bigint(20) NOT NULL,
  `Password` varchar(255) COLLATE utf16_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_unicode_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`Admin ID`, `Name`, `Aadhar ID`, `Password`) VALUES
('ADM001', 'ABC', 262788728291, '$2b$12$kZU5zbdIQireD4zq9k3cfeaPsu9DFcTWGEJaL2Lf5Trk1HaIKNdAS'),
('ADM002', 'XYZ', 923924732401, '$2b$12$OWRUCdhcWnpWUErAaxtlxuoDpRnS3Okho.n4BSUlKDXAE88Yo9Xyi');

-- --------------------------------------------------------

--
-- Table structure for table `backup`
--

CREATE TABLE `backup` (
  `ID` varchar(10) NOT NULL,
  `Name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `backup`
--

INSERT INTO `backup` (`ID`, `Name`) VALUES
('PA22135', 'Patil'),
('PA22330', 'Tiwary'),
('PA22395', 'Kenny'),
('PA22413', 'Siddhi'),
('PA22463', 'Kusum'),
('PA22653', 'Sebastian'),
('PA22710', 'Pramod');

-- --------------------------------------------------------

--
-- Table structure for table `bed`
--

CREATE TABLE `bed` (
  `Bed ID` int(10) NOT NULL,
  `Room Number` varchar(3) NOT NULL,
  `Category` varchar(20) NOT NULL,
  `Status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bed`
--

INSERT INTO `bed` (`Bed ID`, `Room Number`, `Category`, `Status`) VALUES
(1, '001', 'General Ward', 'Vacant'),
(2, '001', 'General Ward', 'Vacant'),
(3, '001', 'General Ward', 'Vacant'),
(4, '001', 'General Ward', 'Occupied'),
(5, '001', 'General Ward', 'Occupied'),
(6, '002', 'Emergency Ward', 'Vacant'),
(7, '002', 'Emergency Ward', 'Vacant'),
(8, '002', 'Emergency Ward', 'Vacant'),
(9, '002', 'Emergency Ward', 'Occupied'),
(10, '002', 'Emergency Ward', 'Occupied'),
(11, '003', 'Deluxe', 'Vacant'),
(12, '004', 'Executive Deluxe', 'Vacant'),
(13, '005', 'Twin Sharing', 'Vacant'),
(14, '005', 'Twin Sharing', 'Vacant'),
(15, '006', 'ICU', 'Occupied'),
(16, '007', 'ICU', 'Vacant'),
(17, '101', 'General Ward', 'Vacant'),
(18, '101', 'General Ward', 'Vacant'),
(19, '101', 'General Ward', 'Vacant'),
(20, '101', 'General Ward', 'Vacant'),
(21, '102', 'Deluxe', 'Occupied'),
(22, '103', 'Executive Deluxe', 'Vacant'),
(23, '104', 'NICU', 'Vacant'),
(24, '105', 'NICU', 'Occupied');

-- --------------------------------------------------------

--
-- Stand-in structure for view `cancel_appointments`
-- (See below for the actual view)
--
CREATE TABLE `cancel_appointments` (
`Appointment ID` varchar(10)
,`Patient ID` varchar(10)
,`Doctor ID` varchar(10)
,`Description` varchar(255)
,`Date` date
,`Time` time
,`Status` varchar(10)
,`Diagnosis` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `doctor`
--

CREATE TABLE `doctor` (
  `Doctor ID` varchar(10) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Designation` varchar(30) NOT NULL,
  `Consultation Fees` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `doctor`
--

INSERT INTO `doctor` (`Doctor ID`, `Name`, `Designation`, `Consultation Fees`) VALUES
('DC009', 'Dr. Bimal Dubey', 'General Surgeon', 1000),
('DC031', 'Dr. BL Sharma', 'Neuro Surgeon', 1000),
('DC110', 'Dr. Meena Sharma', 'Opthalmologist', 800),
('DC115', 'Dr. Dana Lepcha', 'Cardiovascular Surgeon', 1500),
('DC125', 'Dr. Tara Sarkar', 'Dermatologist', 500),
('DC132', 'Dr. Kumar Dey', 'Paediatrician Attending', 400),
('DC165', 'Dr. TP Yadav', 'ENT Surgeon', 800),
('DC248', 'Dr. Ajay Yadav', 'Gynaecologist Attending', 600),
('DC340', 'Dr. Rupak Das', 'General Physician', 400),
('DC351', 'Dr. Byomkesh Dutt', 'Resident', 400),
('DC504', 'Dr. Sudha Bharti', 'Paediatric Surgeon', 1100),
('DC548', 'Dr. Gnana Haokip', 'Resident', 400),
('DC556', 'Dr. David Hume', 'Neurologist', 600),
('DC804', 'Dr. Akash Saxena', 'Neurologist', 600),
('DC850', 'Dr. Neha Gupta', 'Oncologist', 1000),
('DC888', 'Dr. Virat Bhatt', 'Nephrologist Attending', 700);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `Employee ID` varchar(10) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Aadhar ID` bigint(20) NOT NULL,
  `Title` varchar(20) NOT NULL,
  `Join Date` date NOT NULL,
  `Base Salary` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`Employee ID`, `Name`, `Aadhar ID`, `Title`, `Join Date`, `Base Salary`) VALUES
('EMP038', 'Gowri', 107203555814, 'Nurse', '2020-09-22', 10000),
('EMP082', 'Gautam', 429208230809, 'Receptionist', '2020-07-01', 30000),
('EMP164', 'Kumar', 527216625867, 'Nurse', '2021-10-26', 25000),
('EMP246', 'Deepthi', 819224692843, 'Nurse', '2022-01-20', 25000),
('EMP265', 'Nitin', 632226495804, 'Lab Technician', '2020-03-11', 15000),
('EMP306', 'Hiray', 145230558804, 'Manager', '2022-04-07', 40000),
('EMP451', 'Bhatt', 144245673851, 'Pharmacist', '2020-08-11', 25000),
('EMP508', 'Shirole', 882250561810, 'Lab Technician', '2022-01-18', 30000),
('EMP557', 'Aruna', 633255159840, 'Nurse', '2022-10-18', 20000),
('EMP691', 'Alia', 884269593840, 'Pharmacist', '2020-07-17', 20000),
('EMP789', 'Shankar', 35278891832, 'Accountant', '2022-06-17', 45000),
('EMP794', 'Shahrukh', 978279201825, 'Receptionist', '2020-05-21', 35000),
('EMP815', 'Pawan', 872281801815, 'Accountant', '2020-02-06', 50000),
('EMP837', 'Anand', 609283275848, 'Lab Technician', '2022-05-31', 20000),
('EMP857', 'Amitha', 54285013873, 'Nurse', '2021-12-20', 20000);

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `Patient ID` varchar(10) NOT NULL,
  `Date of Registration` date NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Gender` char(1) NOT NULL,
  `Date of Birth` date DEFAULT NULL,
  `Phone` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`Patient ID`, `Date of Registration`, `Name`, `Gender`, `Date of Birth`, `Phone`) VALUES
('PA22105', '2022-08-14', 'Abbis', 'M', '1985-08-09', 7766568913),
('PA22135', '2022-11-13', 'Patil', 'M', '1987-06-10', 2761351390),
('PA22150', '2022-04-21', 'Deborah', 'F', '2021-05-10', 6771012903),
('PA22177', '2022-04-28', 'Ritu', 'F', '2000-10-17', 1531777997),
('PA22193', '2022-01-09', 'SushantH', 'M', '1973-04-12', 7841391710),
('PA22237', '2022-03-05', 'Narkhede', 'M', '1979-02-27', 1052377340),
('PA22330', '2022-11-26', 'Tiwary', 'M', '2022-11-09', 8883088645),
('PA22395', '2022-10-13', 'Kenny', 'F', '1993-08-10', 2761513930),
('PA22413', '2022-10-19', 'Siddhi', 'F', '1973-04-12', 7984131710),
('PA22463', '2022-11-05', 'Kusum', 'F', '1992-01-16', 3054637657),
('PA22467', '2022-01-22', 'Ashlesha', 'F', '1989-03-02', 3774678352),
('PA22615', '2022-05-24', 'Yuvraj', 'M', '1955-03-09', 7766156893),
('PA22630', '2022-05-16', 'Mahajan', 'M', '1993-01-09', 8886308845),
('PA22653', '2022-10-15', 'Sebastian', 'M', '2018-04-16', 546337657),
('PA22710', '2022-10-20', 'Pramod', 'M', '1996-05-10', 6727101903),
('PA22714', '2022-02-02', 'Atul', 'M', '1947-09-25', 9857146732);

-- --------------------------------------------------------

--
-- Table structure for table `patient_appointment`
--

CREATE TABLE `patient_appointment` (
  `Appointment ID` varchar(10) NOT NULL,
  `Patient ID` varchar(10) NOT NULL,
  `Doctor ID` varchar(10) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Date` date NOT NULL,
  `Time` time NOT NULL,
  `Status` varchar(10) DEFAULT NULL,
  `Diagnosis` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient_appointment`
--

INSERT INTO `patient_appointment` (`Appointment ID`, `Patient ID`, `Doctor ID`, `Description`, `Date`, `Time`, `Status`, `Diagnosis`) VALUES
('AP001', 'PA22615', 'DC556', 'Poor Grip and Balance', '2022-11-20', '11:00:00', 'Booked', 'Weakness of Nerves'),
('AP002', 'PA22710', 'DC850', 'Sharp Headache and Mass', '2022-11-21', '18:00:00', 'Booked', 'CT Scan'),
('AP003', 'PA22467', 'DC248', 'Stomach Ache and Mood Swings', '2022-11-22', '12:30:00', 'Cancelled', NULL),
('AP004', 'PA22413', 'DC165', 'Ear Pain', '2022-11-23', '11:30:00', 'Cancelled', NULL),
('AP005', 'PA22467', 'DC248', 'Stomach Ache and Mood Swings', '2022-11-24', '18:30:00', 'Booked', 'Ultrasound Scanning'),
('AP006', 'PA22135', 'DC009', 'Mass over the joint', '2022-11-25', '19:00:00', 'Booked', 'MRI Scan'),
('AP007', 'PA22714', 'DC115', 'Chest Pain', '2022-11-26', '18:00:00', 'Booked', 'ECG and ECHO Test'),
('AP008', 'PA22630', 'DC125', 'Rash', '2022-11-26', '13:30:00', 'Cancelled', NULL),
('AP009', 'PA22413', 'DC165', 'Ear Pain and Dizziness', '2022-11-27', '12:00:00', 'Booked', NULL),
('AP010', 'PA22710', 'DC850', 'Post Scan', '2022-11-27', '18:30:00', 'Booked', NULL),
('AP011', 'PA22237', 'DC110', 'Blurred Vision', '2022-11-27', '18:30:00', 'Cancelled', NULL),
('AP012', 'PA22467', 'DC248', 'Post Scan', '2022-11-28', '13:30:00', 'Booked', NULL),
('AP013', 'PA22413', 'DC248', 'PCOD', '2022-11-28', '13:30:00', 'Booked', NULL),
('AP014', 'PA22714', 'DC115', 'Post Scan', '2022-11-29', '11:00:00', 'Booked', NULL),
('AP015', 'PA22135', 'DC009', 'Post Scan', '2022-11-29', '17:30:00', 'Booked', NULL);

--
-- Triggers `patient_appointment`
--
DELIMITER $$
CREATE TRIGGER `max_doctor_appointment` BEFORE INSERT ON `patient_appointment` FOR EACH ROW BEGIN
DECLARE app_count INT;      
IF DATEDIFF(NEW.`Date`, CURRENT_DATE()) > 10 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'APPOINTMENTS ONLY WITHIN 10 DAYS';
ELSEIF DATEDIFF(NEW.`Date`, CURRENT_DATE()) < 0 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO APPOINTMENTS FOR THE PAST';
ELSE   
    SELECT COUNT(*) INTO app_count
    FROM patient_appointment
    WHERE `Doctor ID` = NEW.`Doctor ID` AND `Date` =NEW.`Date` AND `Time`= NEW.`Time`;

    IF app_count >= 2 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO MORE APPOINTMENTS';
    END IF;
END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `patient_bed`
--

CREATE TABLE `patient_bed` (
  `Bed ID` int(10) NOT NULL,
  `Patient ID` varchar(10) NOT NULL,
  `Employee ID` varchar(10) DEFAULT NULL,
  `Date of Admission` date NOT NULL,
  `Diagnosis` varchar(20) NOT NULL,
  `Date of Discharge` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient_bed`
--

INSERT INTO `patient_bed` (`Bed ID`, `Patient ID`, `Employee ID`, `Date of Admission`, `Diagnosis`, `Date of Discharge`) VALUES
(4, 'PA22413', 'EMP557', '2022-11-27', 'Surgery', '2022-11-30'),
(5, 'PA22615', 'EMP857', '2022-11-26', 'Seizures', '2022-12-01'),
(21, 'PA22467', 'EMP557', '2022-11-28', 'Surgery', '2022-11-29'),
(24, 'PA22330', 'EMP164', '2022-11-26', 'Weakness', '2022-11-30'),
(9, 'PA22193', 'EMP038', '2022-11-27', 'Accident', NULL),
(10, 'PA22150', 'EMP164', '2022-11-27', 'Accident', NULL),
(15, 'PA22395', 'EMP038', '2022-11-26', 'Cardiac Arrest', '2022-12-01');

-- --------------------------------------------------------

--
-- Table structure for table `patient_pharmacy`
--

CREATE TABLE `patient_pharmacy` (
  `Transaction ID` varchar(10) NOT NULL,
  `Patient ID` varchar(10) NOT NULL,
  `Doctor ID` varchar(10) NOT NULL,
  `Employee ID` varchar(10) NOT NULL,
  `Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient_pharmacy`
--

INSERT INTO `patient_pharmacy` (`Transaction ID`, `Patient ID`, `Doctor ID`, `Employee ID`, `Date`) VALUES
('TRN001', 'PA22615', 'DC556', 'EMP451', '2022-11-20'),
('TRN002', 'PA22710', 'DC850', 'EMP451', '2022-11-21'),
('TRN003', 'PA22615', 'DC556', 'EMP691', '2022-11-22'),
('TRN004', 'PA22467', 'DC248', 'EMP691', '2022-11-24'),
('TRN005', 'PA22135', 'DC009', 'EMP691', '2022-11-25'),
('TRN006', 'PA22467', 'DC248', 'EMP451', '2022-11-26');

-- --------------------------------------------------------

--
-- Table structure for table `patient_surgery`
--

CREATE TABLE `patient_surgery` (
  `Surgery ID` varchar(10) NOT NULL,
  `Patient ID` varchar(10) NOT NULL,
  `Doctor ID` varchar(10) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Date` date NOT NULL,
  `Time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient_surgery`
--

INSERT INTO `patient_surgery` (`Surgery ID`, `Patient ID`, `Doctor ID`, `Name`, `Date`, `Time`) VALUES
('SUR342', 'PA22714', 'DC115', 'Coronary artery bypass', '2022-11-30', '10:30:00'),
('SUR889', 'PA22467', 'DC009', 'Cholecystectomy', '2022-11-28', '15:00:00'),
('SUR990', 'PA22714', 'DC115', 'Heart valve replacement', '2022-12-03', '17:00:00'),
('SUR889', 'PA22135', 'DC009', 'Joint replacement', '2022-12-01', '19:30:00'),
('SUR463', 'PA22463', 'DC009', 'C-section', '2022-12-01', '10:00:00'),
('SUR868', 'PA22615', 'DC031', 'Carotid endarterectomy', '2022-11-21', '05:30:00'),
('SUR543', 'PA22413', 'DC165', 'Tymphanoplasty', '2022-11-27', '18:30:00'),
('SUR013', 'PA22615', 'DC031', 'Aneurysm surgery', '2022-12-22', '16:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `patient_test`
--

CREATE TABLE `patient_test` (
  `Test ID` varchar(10) NOT NULL,
  `Patient ID` varchar(10) NOT NULL,
  `Doctor ID` varchar(10) NOT NULL,
  `Employee ID` varchar(10) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `patient_test`
--

INSERT INTO `patient_test` (`Test ID`, `Patient ID`, `Doctor ID`, `Employee ID`, `Name`, `Date`) VALUES
('TE001', 'PA22615', 'DC556', 'EMP265', 'EKG', '2022-11-21'),
('TE002', 'PA22710', 'DC850', 'EMP837', 'CT HR', '2022-11-23'),
('TE003', 'PA22467', 'DC248', 'EMP265', 'Ultrasound', '2022-11-25'),
('TE004', 'PA22135', 'DC009', 'EMP837', 'MRI HR', '2022-11-25'),
('TE005', 'PA22714', 'DC115', 'EMP837', 'ECG', '2022-11-26'),
('TE006', 'PA22714', 'DC115', 'EMP265', 'ECHO', '2022-11-26');

-- --------------------------------------------------------

--
-- Table structure for table `pharmacy`
--

CREATE TABLE `pharmacy` (
  `Item ID` varchar(10) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Price` float NOT NULL,
  `Stock` int(11) NOT NULL,
  `Expiry Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pharmacy`
--

INSERT INTO `pharmacy` (`Item ID`, `Name`, `Price`, `Stock`, `Expiry Date`) VALUES
('MED105', 'Tylenol', 180, 10, '2022-12-02'),
('MED108', 'Diclofenac', 50, 100, '2023-10-29'),
('MED119', 'Paracetamol', 12, 100, '2024-01-01'),
('MED146', 'Paracetamol', 10, 130, '2025-08-12'),
('MED171', 'Cyproheptadine', 105.5, 10, '2022-11-02'),
('MED246', 'Diphenhydramine', 100, 108, '2025-02-22'),
('MED323', 'Promethazine', 150.5, 104, '2025-03-30'),
('MED417', 'Pheniramine', 20, 120, '2022-11-15'),
('MED561', 'Chlorpheniramine', 20, 140, '2022-12-28'),
('MED663', 'Pyrilamine', 30, 10, '2024-06-08'),
('MED668', 'Pyrilamine', 35, 25, '2025-10-08'),
('MED741', 'Epinephrine', 10, 130, '2025-07-13'),
('MED842', 'Atropine', 200, 30, '2024-12-19'),
('MED871', 'Atropine', 235.6, 10, '2023-02-09'),
('MED913', 'Isoproterenol', 105.5, 10, '2025-08-10');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `Category` varchar(20) NOT NULL,
  `Cost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`Category`, `Cost`) VALUES
('Deluxe', 1000),
('Emergency Ward', 800),
('Executive Deluxe', 2000),
('General Ward', 500),
('ICU', 2500),
('NICU', 3000),
('Twin Sharing', 800);

-- --------------------------------------------------------

--
-- Table structure for table `schedule`
--

CREATE TABLE `schedule` (
  `Doctor ID` varchar(10) NOT NULL,
  `Date` date NOT NULL,
  `Start Time` time NOT NULL,
  `End Time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `schedule`
--

INSERT INTO `schedule` (`Doctor ID`, `Date`, `Start Time`, `End Time`) VALUES
('DC804', '2022-11-28', '00:00:00', '00:00:00'),
('DC340', '2022-11-29', '11:00:00', '13:30:00'),
('DC850', '2022-11-29', '17:30:00', '18:00:00'),
('DC165', '2022-11-30', '18:00:00', '18:30:00'),
('DC115', '2022-11-30', '10:00:00', '11:00:00'),
('DC115', '2022-11-30', '12:30:00', '13:30:00'),
('DC125', '2022-12-01', '00:00:00', '00:00:00'),
('DC888', '2022-12-02', '10:30:00', '11:30:00'),
('DC888', '2022-12-03', '13:00:00', '13:30:00'),
('DC031', '2022-12-03', '00:00:00', '00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `surgery`
--

CREATE TABLE `surgery` (
  `Name` varchar(30) NOT NULL,
  `Cost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `surgery`
--

INSERT INTO `surgery` (`Name`, `Cost`) VALUES
('Aneurysm surgery', 30000),
('Appendectomy', 50000),
('C-section', 100000),
('Carotid endarterectomy', 20000),
('Cataract surgery', 40000),
('Cholecystectomy', 60000),
('Coronary artery bypass', 400000),
('Full hysterectomty', 50000),
('Heart valve replacement', 400000),
('Joint replacement', 200000),
('Tymphanoplasty', 50000);

-- --------------------------------------------------------

--
-- Table structure for table `test`
--

CREATE TABLE `test` (
  `Name` varchar(20) NOT NULL,
  `Cost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `test`
--

INSERT INTO `test` (`Name`, `Cost`) VALUES
('Blood Panel', 1500),
('CRP', 1200),
('CT HR', 5000),
('Dialysis', 2000),
('ECG', 500),
('ECHO', 2500),
('EKG', 1000),
('HbA1c', 500),
('Lipid Panel', 300),
('MRI HR', 10000),
('Thyroid Panel', 300),
('Ultrasound', 2200);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_item`
--

CREATE TABLE `transaction_item` (
  `Transaction ID` varchar(10) NOT NULL,
  `Item ID` varchar(10) NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaction_item`
--

INSERT INTO `transaction_item` (`Transaction ID`, `Item ID`, `Quantity`) VALUES
('TRN001', 'MED871', 1),
('TRN001', 'MED105', 1),
('TRN002', 'MED119', 10),
('TRN002', 'MED105', 2),
('TRN002', 'MED246', 8),
('TRN003', 'MED663', 2),
('TRN003', 'MED561', 5),
('TRN004', 'MED108', 5),
('TRN005', 'MED741', 5),
('TRN006', 'MED871', 1),
('TRN006', 'MED119', 5),
('TRN004', 'MED171', 5);

-- --------------------------------------------------------

--
-- Structure for view `cancel_appointments`
--
DROP TABLE IF EXISTS `cancel_appointments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cancel_appointments`  AS SELECT `patient_appointment`.`Appointment ID` AS `Appointment ID`, `patient_appointment`.`Patient ID` AS `Patient ID`, `patient_appointment`.`Doctor ID` AS `Doctor ID`, `patient_appointment`.`Description` AS `Description`, `patient_appointment`.`Date` AS `Date`, `patient_appointment`.`Time` AS `Time`, `patient_appointment`.`Status` AS `Status`, `patient_appointment`.`Diagnosis` AS `Diagnosis` FROM `patient_appointment` WHERE `patient_appointment`.`Status` = 'Cancelled' intersect select `patient_appointment`.`Appointment ID` AS `Appointment ID`,`patient_appointment`.`Patient ID` AS `Patient ID`,`patient_appointment`.`Doctor ID` AS `Doctor ID`,`patient_appointment`.`Description` AS `Description`,`patient_appointment`.`Date` AS `Date`,`patient_appointment`.`Time` AS `Time`,`patient_appointment`.`Status` AS `Status`,`patient_appointment`.`Diagnosis` AS `Diagnosis` from `patient_appointment` where `patient_appointment`.`Time` < '13:00'  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`Admin ID`),
  ADD UNIQUE KEY `Aadhar ID` (`Aadhar ID`);

--
-- Indexes for table `bed`
--
ALTER TABLE `bed`
  ADD PRIMARY KEY (`Bed ID`);

--
-- Indexes for table `doctor`
--
ALTER TABLE `doctor`
  ADD PRIMARY KEY (`Doctor ID`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`Employee ID`),
  ADD UNIQUE KEY `Aadhar ID` (`Aadhar ID`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`Patient ID`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- Indexes for table `patient_appointment`
--
ALTER TABLE `patient_appointment`
  ADD PRIMARY KEY (`Appointment ID`),
  ADD KEY `A` (`Patient ID`) USING BTREE,
  ADD KEY `B` (`Doctor ID`) USING BTREE;

--
-- Indexes for table `patient_bed`
--
ALTER TABLE `patient_bed`
  ADD KEY `C` (`Bed ID`),
  ADD KEY `D` (`Patient ID`);

--
-- Indexes for table `patient_pharmacy`
--
ALTER TABLE `patient_pharmacy`
  ADD PRIMARY KEY (`Transaction ID`),
  ADD KEY `E` (`Patient ID`),
  ADD KEY `F` (`Doctor ID`),
  ADD KEY `G` (`Employee ID`);

--
-- Indexes for table `patient_surgery`
--
ALTER TABLE `patient_surgery`
  ADD KEY `H` (`Patient ID`),
  ADD KEY `I` (`Doctor ID`),
  ADD KEY `O` (`Name`);

--
-- Indexes for table `patient_test`
--
ALTER TABLE `patient_test`
  ADD PRIMARY KEY (`Test ID`),
  ADD KEY `J` (`Patient ID`),
  ADD KEY `K` (`Doctor ID`),
  ADD KEY `L` (`Employee ID`),
  ADD KEY `P` (`Name`);

--
-- Indexes for table `pharmacy`
--
ALTER TABLE `pharmacy`
  ADD PRIMARY KEY (`Item ID`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`Category`);

--
-- Indexes for table `schedule`
--
ALTER TABLE `schedule`
  ADD KEY `M` (`Doctor ID`);

--
-- Indexes for table `surgery`
--
ALTER TABLE `surgery`
  ADD PRIMARY KEY (`Name`);

--
-- Indexes for table `test`
--
ALTER TABLE `test`
  ADD PRIMARY KEY (`Name`);

--
-- Indexes for table `transaction_item`
--
ALTER TABLE `transaction_item`
  ADD KEY `N` (`Item ID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `patient_appointment`
--
ALTER TABLE `patient_appointment`
  ADD CONSTRAINT `1` FOREIGN KEY (`Patient ID`) REFERENCES `patient` (`Patient ID`),
  ADD CONSTRAINT `2` FOREIGN KEY (`Doctor ID`) REFERENCES `doctor` (`Doctor ID`);

--
-- Constraints for table `patient_bed`
--
ALTER TABLE `patient_bed`
  ADD CONSTRAINT `C` FOREIGN KEY (`Bed ID`) REFERENCES `bed` (`Bed ID`),
  ADD CONSTRAINT `D` FOREIGN KEY (`Patient ID`) REFERENCES `patient` (`Patient ID`);

--
-- Constraints for table `patient_pharmacy`
--
ALTER TABLE `patient_pharmacy`
  ADD CONSTRAINT `E` FOREIGN KEY (`Patient ID`) REFERENCES `patient` (`Patient ID`),
  ADD CONSTRAINT `F` FOREIGN KEY (`Doctor ID`) REFERENCES `doctor` (`Doctor ID`),
  ADD CONSTRAINT `G` FOREIGN KEY (`Employee ID`) REFERENCES `employee` (`Employee ID`);

--
-- Constraints for table `patient_surgery`
--
ALTER TABLE `patient_surgery`
  ADD CONSTRAINT `H` FOREIGN KEY (`Patient ID`) REFERENCES `patient` (`Patient ID`),
  ADD CONSTRAINT `I` FOREIGN KEY (`Doctor ID`) REFERENCES `doctor` (`Doctor ID`),
  ADD CONSTRAINT `O` FOREIGN KEY (`Name`) REFERENCES `surgery` (`Name`);

--
-- Constraints for table `patient_test`
--
ALTER TABLE `patient_test`
  ADD CONSTRAINT `J` FOREIGN KEY (`Patient ID`) REFERENCES `patient` (`Patient ID`),
  ADD CONSTRAINT `K` FOREIGN KEY (`Doctor ID`) REFERENCES `doctor` (`Doctor ID`),
  ADD CONSTRAINT `L` FOREIGN KEY (`Employee ID`) REFERENCES `employee` (`Employee ID`),
  ADD CONSTRAINT `P` FOREIGN KEY (`Name`) REFERENCES `test` (`Name`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `schedule`
--
ALTER TABLE `schedule`
  ADD CONSTRAINT `M` FOREIGN KEY (`Doctor ID`) REFERENCES `doctor` (`Doctor ID`);

--
-- Constraints for table `transaction_item`
--
ALTER TABLE `transaction_item`
  ADD CONSTRAINT `N` FOREIGN KEY (`Item ID`) REFERENCES `pharmacy` (`Item ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
