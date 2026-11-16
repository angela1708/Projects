-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 05, 2026 at 09:24 PM
-- Server version: 10.11.14-MariaDB-0ubuntu0.24.04.1
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `avilaan_3_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`avilaan`@`localhost` PROCEDURE `delete_inactive_staff` ()   BEGIN

    DELETE FROM staff
    WHERE LOWER(staffStatus) IN ('fired', 'suspended', 'moved', 'quit')$$

CREATE DEFINER=`avilaan`@`localhost` PROCEDURE `delete_inactive_students` ()   BEGIN

    DELETE FROM student
    WHERE LOWER(studentStatus) IN ('graduated', 'suspended', 'moved', 'expelled')$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `2026_2027_student_enrollment`
-- (See below for the actual view)
--
CREATE TABLE `2026_2027_student_enrollment` (
`Student Name` varchar(61)
,`schoolGrade` varchar(12)
,`courseSubject` varchar(50)
,`courseName` varchar(100)
,`Instructor Name` varchar(61)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `2026_2027_teachers_course_count`
-- (See below for the actual view)
--
CREATE TABLE `2026_2027_teachers_course_count` (
`staffFirstName` varchar(30)
,`staffLastName` varchar(30)
,`jobTitle` varchar(15)
,`courseID` char(15)
,`courseName` varchar(100)
,`courseSubject` varchar(50)
,`Total # of Enrolled Students` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `courseID` char(15) NOT NULL,
  `courseName` varchar(100) NOT NULL,
  `courseSubject` varchar(50) NOT NULL,
  `staffID` char(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`courseID`, `courseName`, `courseSubject`, `staffID`) VALUES
('DSC-I308', 'Database Design', 'Data Science', 'STA-001'),
('INFO-I100', 'First Year Experience', 'Informatics', 'STA-003'),
('INFO-I275', 'Introduction to Human-Computer Interaction Theory', 'Informatics', 'STA-003'),
('INFO-I305', 'Introduction to Research in Informatics', 'Informatics', 'STA-005'),
('MATH-I153', 'College Algebra', 'Mathematics', 'STA-002');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment`
--

CREATE TABLE `enrollment` (
  `enrollmentID` int(11) NOT NULL,
  `studentID` char(15) NOT NULL,
  `courseID` char(15) NOT NULL,
  `enrollmentDate` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollment`
--

INSERT INTO `enrollment` (`enrollmentID`, `studentID`, `courseID`, `enrollmentDate`) VALUES
(1, 'STU-001', 'DSC-I308', '2026-05-18'),
(2, 'STU-002', 'MATH-I153', '2026-05-18'),
(3, 'STU-002', 'MATH-I153', '2026-08-24'),
(4, 'STU-003', 'MATH-I153', '2026-08-24'),
(6, 'STU-005', 'INFO-I100', '2027-01-11'),
(7, 'STU-009', 'INFO-I100', '2026-08-24'),
(8, 'STU-007', 'INFO-I275', '2027-01-11'),
(10, 'STU-006', 'INFO-I275', '2027-01-11'),
(11, 'STU-006', 'MATH-I153', '2026-05-18'),
(12, 'STU-012', 'INFO-I100', '2026-08-24'),
(13, 'STU-012', 'MATH-I153', '2026-08-24'),
(14, 'STU-012', 'DSC-I308', '2027-01-11'),
(15, 'STU-007', 'DSC-I308', '2026-05-18'),
(16, 'STU-007', 'INFO-I275', '2026-08-24'),
(18, 'STU-014', 'INFO-I275', '2026-05-18'),
(19, 'STU-014', 'DSC-I308', '2026-08-24'),
(22, 'STU-017', 'DSC-I308', '2026-05-18'),
(23, 'STU-017', 'MATH-I153', '2026-08-24'),
(24, 'STU-018', 'INFO-I100', '2026-08-24'),
(25, 'STU-019', 'INFO-I100', '2027-01-11');

--
-- Triggers `enrollment`
--
DELIMITER $$
CREATE TRIGGER `correct_semester_date_2025_2026` BEFORE INSERT ON `enrollment` FOR EACH ROW BEGIN

	IF LOWER(NEW.enrollmentDate) IN ('fall 2025', 'fall 25', 'fall2025', 'fall25')
		THEN SET NEW.enrollmentDate = '2025-08-25'$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `correct_semester_date_2026_2027` BEFORE INSERT ON `enrollment` FOR EACH ROW BEGIN

	IF LOWER(NEW.enrollmentDate) IN ('fall 2026', 'fall 26', 'fall2026', 'fall26')
		THEN SET NEW.enrollmentDate = '2026-08-24'$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `enrollment_to_gradebook_entry` AFTER INSERT ON `enrollment` FOR EACH ROW BEGIN

INSERT INTO gradebook (studentID, courseID)
VALUES (NEW.studentID, NEW.courseID)$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `formerStaff`
--

CREATE TABLE `formerStaff` (
  `staffID` char(15) NOT NULL,
  `staffFirstName` varchar(30) NOT NULL,
  `staffLastName` varchar(30) NOT NULL,
  `jobTitle` varchar(15) NOT NULL,
  `staffStatus` varchar(15) NOT NULL,
  `dateOccurred` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `formerStaff`
--

INSERT INTO `formerStaff` (`staffID`, `staffFirstName`, `staffLastName`, `jobTitle`, `staffStatus`, `dateOccurred`) VALUES
('STA-009', 'Evelyn', 'Damian', 'Researcher', 'Quit', '2026-08-04 17:40:57'),
('STA-010', 'Muhammad', 'Kapoor', 'Advisor', 'Suspended', '2026-08-04 17:40:57'),
('STA-011', 'Jordan', 'Belfort', 'Instructor', 'Fired', '2026-08-04 17:23:20'),
('STA-015', 'Priya', 'Sharma', 'Instructor', 'Moved', '2026-08-04 17:40:57'),
('STA-020', 'Arthur', 'Pendelton', 'Advisor', 'Moved', '2026-08-04 17:40:57');

-- --------------------------------------------------------

--
-- Table structure for table `formerStudents`
--

CREATE TABLE `formerStudents` (
  `studentID` char(15) NOT NULL,
  `studentFirstName` varchar(30) NOT NULL,
  `studentLastName` varchar(30) NOT NULL,
  `studentStatus` varchar(15) NOT NULL,
  `dateOccurred` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `formerStudents`
--

INSERT INTO `formerStudents` (`studentID`, `studentFirstName`, `studentLastName`, `studentStatus`, `dateOccurred`) VALUES
('STU-004', 'Luisa', 'Manolo', 'Expelled', '2026-08-04 17:34:20'),
('STU-010', 'Liam', 'Niel', 'Moved', '2026-08-04 17:34:20'),
('STU-011', 'Alex', 'Russo', 'Graduated', '2026-08-04 17:21:47'),
('STU-013', 'Emma', 'Rodriguez', 'Suspended', '2026-08-04 17:34:20'),
('STU-016', 'Benjamin', 'Foster', 'Expelled', '2026-08-04 17:34:20');

-- --------------------------------------------------------

--
-- Table structure for table `gradebook`
--

CREATE TABLE `gradebook` (
  `gradebookID` int(11) NOT NULL,
  `studentID` char(15) NOT NULL,
  `courseID` char(15) NOT NULL,
  `academicsGrade` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gradebook`
--

INSERT INTO `gradebook` (`gradebookID`, `studentID`, `courseID`, `academicsGrade`) VALUES
(1, 'STU-001', 'DSC-I308', 'A'),
(2, 'STU-002', 'MATH-I153', 'C-'),
(3, 'STU-002', 'MATH-I153', NULL),
(4, 'STU-003', 'MATH-I153', 'B'),
(6, 'STU-005', 'INFO-I100', 'B'),
(7, 'STU-009', 'INFO-I100', NULL),
(8, 'STU-007', 'INFO-I275', NULL),
(10, 'STU-006', 'INFO-I275', NULL),
(11, 'STU-006', 'MATH-I153', 'B+'),
(12, 'STU-012', 'INFO-I100', NULL),
(13, 'STU-012', 'MATH-I153', NULL),
(14, 'STU-012', 'DSC-I308', NULL),
(15, 'STU-007', 'DSC-I308', 'F'),
(16, 'STU-007', 'INFO-I275', NULL),
(18, 'STU-014', 'INFO-I275', 'A'),
(19, 'STU-014', 'DSC-I308', NULL),
(22, 'STU-017', 'DSC-I308', 'C-'),
(23, 'STU-017', 'MATH-I153', NULL),
(24, 'STU-018', 'INFO-I100', NULL),
(25, 'STU-019', 'INFO-I100', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staffID` char(15) NOT NULL,
  `staffFirstName` varchar(30) NOT NULL,
  `staffLastName` varchar(30) NOT NULL,
  `jobTitle` varchar(15) NOT NULL,
  `staffStatus` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staffID`, `staffFirstName`, `staffLastName`, `jobTitle`, `staffStatus`) VALUES
('STA-001', 'Steven', 'Thompson', 'Instructor', 'Full-Time'),
('STA-002', 'Eric', 'Adams', 'Instructor', 'Full-Time'),
('STA-003', 'Julie', 'Stella', 'Instructor', 'Full-Time'),
('STA-004', 'Marco', 'Bolia', 'Dean', 'Full-Time'),
('STA-005', 'Sonny', 'Kirkley', 'Instructor', 'Part-Time'),
('STA-006', 'Travis', 'Johnson', 'Instructor', 'Part-Time'),
('STA-007', 'Amina', 'Vance', 'Advisor', 'Part-Time'),
('STA-008', 'Dimitri', 'Rostova', 'Lab Assistant', 'Intern'),
('STA-012', 'Carlos', 'Mendoza', 'Instructor', 'Full-Time'),
('STA-013', 'Hannah', 'Schmidt', 'Advisor', 'Full-Time'),
('STA-014', 'David', 'Kowalski', 'Lab Assistant', 'Part-Time'),
('STA-016', 'Marcus', 'Vance', 'Researcher', 'Full-Time'),
('STA-017', 'Sarah', 'Jenkins', 'Janitor', 'Full-Time'),
('STA-018', 'Tariq', 'Al-Mansoor', 'Instructor', 'Part-Time'),
('STA-019', 'Elena', 'Rossi', 'Lab Assistant', 'Intern');

--
-- Triggers `staff`
--
DELIMITER $$
CREATE TRIGGER `update_staff_status` AFTER UPDATE ON `staff` FOR EACH ROW BEGIN
    
    IF OLD.staffStatus <> NEW.staffStatus 
        AND LOWER(NEW.staffStatus) IN ('fired', 'suspended', 'moved', 'quit') 
        
        THEN INSERT INTO formerStaff
        SET 
            staffID = NEW.staffID,
            staffFirstName = NEW.staffFirstName,
            staffLastName = NEW.staffLastName,
            jobTitle = NEW.jobTitle,
            staffStatus = NEW.staffStatus,
            dateOccurred = NOW()$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `studentID` char(15) NOT NULL,
  `studentFirstName` varchar(30) NOT NULL,
  `studentLastName` varchar(30) NOT NULL,
  `schoolGrade` varchar(12) NOT NULL,
  `studentStatus` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`studentID`, `studentFirstName`, `studentLastName`, `schoolGrade`, `studentStatus`) VALUES
('STU-001', 'Angel', 'Avila', 'Junior', 'Full-time'),
('STU-002', 'Jackson', 'Garcia', 'Senior', 'Part-time'),
('STU-003', 'Madison', 'Smith', 'Sophomore', 'Full-time'),
('STU-005', 'Maya', 'Patel', 'Junior', 'Full-time'),
('STU-006', 'Ethan', 'Chen', 'Freshman', 'Full-time'),
('STU-007', 'Olivia', 'Washington', 'Senior', 'Part-time'),
('STU-008', 'Lucas', 'Ramirez', 'Sophomore', 'Part-Time'),
('STU-009', 'Sophia', 'Dubois', 'Junior', 'Full-time'),
('STU-012', 'Noah', 'Kim', 'Sophomore', 'Full-Time'),
('STU-014', 'James', 'Wilson', 'Senior', 'Full-Time'),
('STU-015', 'Aaliyah', 'Khan', 'Freshman', 'Part-Time'),
('STU-017', 'Isabella', 'Nguyen', 'Junior', 'Full-Time'),
('STU-018', 'Mason', 'Snyder', 'Senior', 'Part-Time'),
('STU-019', 'Zoe', 'Alvarez', 'Freshman', 'Full-Time'),
('STU-020', 'Elijah', 'Brooks', 'Junior', 'Part-Time');

--
-- Triggers `student`
--
DELIMITER $$
CREATE TRIGGER `update_student_status` AFTER UPDATE ON `student` FOR EACH ROW BEGIN
    
    IF OLD.studentStatus <> NEW.studentStatus 
       AND LOWER(NEW.studentStatus) IN ('graduated', 'suspended', 'moved', 'expelled') THEN
       
        INSERT INTO formerStudents
        SET 
            studentID = NEW.studentID,
            studentFirstName = NEW.studentFirstName,
            studentLastName = NEW.studentLastName,
            studentStatus = NEW.studentStatus,
            dateOccurred = NOW()$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `students_not_enrolled`
-- (See below for the actual view)
--
CREATE TABLE `students_not_enrolled` (
`studentID` char(15)
,`studentFirstName` varchar(30)
,`studentLastName` varchar(30)
,`schoolGrade` varchar(12)
,`studentStatus` varchar(20)
);

-- --------------------------------------------------------

--
-- Structure for view `2026_2027_student_enrollment`
--
DROP TABLE IF EXISTS `2026_2027_student_enrollment`;

CREATE ALGORITHM=UNDEFINED DEFINER=`avilaan`@`localhost` SQL SECURITY DEFINER VIEW `2026_2027_student_enrollment`  AS SELECT concat(`s`.`studentFirstName`,' ',`s`.`studentLastName`) AS `Student Name`, `s`.`schoolGrade` AS `schoolGrade`, `c`.`courseSubject` AS `courseSubject`, `c`.`courseName` AS `courseName`, concat(`st`.`staffFirstName`,' ',`st`.`staffLastName`) AS `Instructor Name` FROM (((`student` `s` join `enrollment` `e` on(`s`.`studentID` = `e`.`studentID`)) join `course` `c` on(`e`.`courseID` = `c`.`courseID`)) left join `staff` `st` on(`c`.`staffID` = `st`.`staffID`)) WHERE `e`.`enrollmentDate` between '2026-08-24' and '2027-01-11' ORDER BY `s`.`studentFirstName` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `2026_2027_teachers_course_count`
--
DROP TABLE IF EXISTS `2026_2027_teachers_course_count`;

CREATE ALGORITHM=UNDEFINED DEFINER=`avilaan`@`localhost` SQL SECURITY DEFINER VIEW `2026_2027_teachers_course_count`  AS SELECT `s`.`staffFirstName` AS `staffFirstName`, `s`.`staffLastName` AS `staffLastName`, `s`.`jobTitle` AS `jobTitle`, `c`.`courseID` AS `courseID`, `c`.`courseName` AS `courseName`, `c`.`courseSubject` AS `courseSubject`, count(`e`.`studentID`) AS `Total # of Enrolled Students` FROM ((`staff` `s` join `course` `c` on(`s`.`staffID` = `c`.`staffID`)) left join `enrollment` `e` on(`c`.`courseID` = `e`.`courseID` and `e`.`enrollmentDate` between '2026-08-24' and '2027-01-11')) GROUP BY `s`.`staffID`, `c`.`courseID`, `s`.`staffFirstName`, `s`.`staffLastName`, `s`.`jobTitle`, `c`.`courseName`, `c`.`courseSubject` ORDER BY `s`.`staffFirstName` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `students_not_enrolled`
--
DROP TABLE IF EXISTS `students_not_enrolled`;

CREATE ALGORITHM=UNDEFINED DEFINER=`avilaan`@`localhost` SQL SECURITY DEFINER VIEW `students_not_enrolled`  AS SELECT `s`.`studentID` AS `studentID`, `s`.`studentFirstName` AS `studentFirstName`, `s`.`studentLastName` AS `studentLastName`, `s`.`schoolGrade` AS `schoolGrade`, `s`.`studentStatus` AS `studentStatus` FROM (`student` `s` left join `enrollment` `e` on(`s`.`studentID` = `e`.`studentID`)) WHERE `e`.`studentID` is null ORDER BY `s`.`studentFirstName` ASC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`courseID`),
  ADD KEY `staffID` (`staffID`);

--
-- Indexes for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD PRIMARY KEY (`enrollmentID`),
  ADD KEY `studentID` (`studentID`),
  ADD KEY `courseID` (`courseID`);

--
-- Indexes for table `formerStaff`
--
ALTER TABLE `formerStaff`
  ADD PRIMARY KEY (`staffID`);

--
-- Indexes for table `formerStudents`
--
ALTER TABLE `formerStudents`
  ADD PRIMARY KEY (`studentID`);

--
-- Indexes for table `gradebook`
--
ALTER TABLE `gradebook`
  ADD PRIMARY KEY (`gradebookID`),
  ADD KEY `studentID` (`studentID`),
  ADD KEY `courseID` (`courseID`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staffID`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`studentID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `enrollment`
--
ALTER TABLE `enrollment`
  MODIFY `enrollmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `gradebook`
--
ALTER TABLE `gradebook`
  MODIFY `gradebookID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`) ON UPDATE CASCADE;

--
-- Constraints for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`studentID`) REFERENCES `student` (`studentID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `enrollment_ibfk_2` FOREIGN KEY (`courseID`) REFERENCES `course` (`courseID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `gradebook`
--
ALTER TABLE `gradebook`
  ADD CONSTRAINT `gradebook_ibfk_1` FOREIGN KEY (`studentID`) REFERENCES `student` (`studentID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `gradebook_ibfk_2` FOREIGN KEY (`courseID`) REFERENCES `course` (`courseID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
