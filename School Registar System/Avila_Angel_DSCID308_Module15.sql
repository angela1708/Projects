/*
Angel Avila
August 5, 2026
DSCI-D308: Database Design Final Project: Phase 4

LLM DISCLOSURE: I used Gemini Thinking 3.5 for aid in applying the 2nd view and trigger function for this project. I also let it oversee my project creating, insertion, 
updating, and deletion to make sure syntax, camalCase, logic, and grammar were in place and looked perfect. I did not rely on it giving me code, but rather
use it as a tool in the thought making process.
*/

-- formerStaff AND formerStudents AUDIT TABLE CODE IS AT THE BOTTOM, CATEGORIZED AS BONUSES/EXTRAS (after the big hashtag comment block)

--######################################################################################################################################################

/*
-- VIEWS

1. An administrator would like to see the courses each of the student's have enrolled into. This view takes the students information, and see's which course they enrolled into,
as well as the instructor that is teaching the course. This most effective to see how enrollment has gone through courses (bonus at end).  The reason I created this view is because
when it comes to enrollment, staff would like to see if students have started enrolling into courses and which ones could be missing.

2. A teacher is ecstatic to start the new semester and would like to see how many students have enrolled in each of the courses they'll be teaching. In here, they'll see their name,
the course name and it's subject, as well as the total # of students enrolled. This view's purpose is for instructors to take note and vision out their future plans for the coming
semester, and see how they can deal with tests, exams, etc.
*/

-- 1
CREATE VIEW `2026_2027_student_enrollment` AS 
    SELECT 
        CONCAT(s.studentFirstName, ' ', s.studentLastName) AS `Student Full Name`,
        s.schoolGrade,
        c.courseSubject,
        c.courseName,
        CONCAT(st.staffFirstName, ' ', st.staffLastName) AS `Instructor Full Name`
    FROM student s
    JOIN enrollment e ON s.studentID = e.studentID
    JOIN course c ON e.courseID = c.courseID
    LEFT JOIN staff st ON c.staffID = st.staffID
    WHERE e.enrollmentDate BETWEEN '2026-08-24' AND '2027-01-11'
    ORDER BY s.studentFirstName;

-- 2
CREATE VIEW `2026_2027_teachers_course_count` AS 
    SELECT 
        s.staffFirstName,
        s.staffLastName,
        s.jobTitle,
        c.courseID,
        c.courseName,
        c.courseSubject,
        COUNT(e.studentID) AS `Total # of Enrolled Students`
    FROM staff s
    JOIN course c ON s.staffID = c.staffID
    LEFT JOIN enrollment e 
        ON c.courseID = e.courseID 
        AND e.enrollmentDate BETWEEN '2026-08-24' AND '2027-01-11'
    GROUP BY 
        s.staffID, 
        c.courseID, 
        s.staffFirstName, 
        s.staffLastName,
        s.jobTitle,
        c.courseName, 
        c.courseSubject
    ORDER BY s.staffFirstName;

--######################################################################################################################################################

/*
-- TRIGGER

1. This trigger takes the enrolmentDate value insertion and converts it into the date form YYYY-MM-DD. Realistically speaking, when someone is enrolling students to their proper semester
season, all they would need to do is type 'Fall 2026' and it'll convert it to '2026-08-24'. If one were to do it manually, this would take a lot of time whereas just typing the season type,
it would speed things up. I also made sure to include exception handling like lower or uppercase lettering, and if one were to shorten the key value.
*/

-- 1
DELIMITER $$
CREATE TRIGGER correct_semester_date_2026_2027
BEFORE INSERT ON enrollment FOR EACH ROW
BEGIN

	IF LOWER(NEW.enrollmentDate) IN ('fall 2026', 'fall 26', 'fall2026', 'fall26')
		THEN SET NEW.enrollmentDate = '2026-08-24';
	ELSEIF LOWER(NEW.enrollmentDate) IN ('spring 2027', 'spring 27', 'spring2027', 'spring27')
		THEN SET NEW.enrollmentDate = '2027-01-11';
	ELSEIF LOWER(NEW.enrollmentDate) IN ('summer 2027', 'summer 27', 'summer2027', 'summer27')
		THEN SET NEW.enrollmentDate = '2027-05-17';
	END IF ;
    
END $$
DELIMITER ;

--######################################################################################################################################################

/*
-- QUIERIES

1. Make two (2) queries that join two or more tables.

    1.1. An administrator would like to view the students grades for all the courses theyr're enrolled in. This way, one can see how a student is doing for one or many of their courses.
    1.2. An instructor does not remember the course(s) they'll be teaching. They would like to view which type course(s) they're instructed to do. Instructors are well aware of the courses
    they'll be teaching. But, if it were to be their boss or assistants, or etc., they would like to view the course(s) they're teaching.

2. Make two (2) queries, each using a different aggregation function from this list: MAX, MIN, AVG, COUNT, and SUM.
    2.1. Most of the school registar system is filled with instructors. The administrator would like a count of how many instructors there are. 
    2.2. Who was the most recent staff member to be let go? When it comes to past contacts, knowing which employees were the last to be let go is important for data analysts to know what 
    information of theirs possibly still linger in the database.

3. Make one (1) query using one of the following in a predicate: OR, AND
    3.1. What students are have a C or F in one or many of their courses? I've also added feedback column to know which ones are in vile improvement or have the lowest passing grade. This is
    important for advisors and instructors to know which students that meet either requirement.

4. Make one (1) query using one of the following in a predicate: BETWEEN, IN, LIKE
    4.1. What students have an A or greater in their courses? Opposite to 3.1, an advisor or instructor would like to see which students are on track to pass their course.

5. Make one (1) query using one of the following: DISTINCT, LIMIT
    5.1. What were the last 3 staff members to leave? Same reason as 2.2.

6. Make two (2) useful queries of your own -- and explain briefly why you created them.
    6.1. A new school year is starting, and teachers would like to see how many students have enrolled in their courses. Knowing how many students are enrolled in your course helps plan out
    the school year and know how tests, exams, or group projects would work.
    6.2. What are the names of the students that have not enrolled in any courses yet? This would alert advisors to start advocating those students to start enrolling into some courses. And, to
    be notified if those students have some sort of reason to not be enrolled in any courses yet.
*/

-- 1.1
SELECT 
    CONCAT(s.studentFirstName, ' ', s.studentLastName) AS `Student Full Name`,
    c.courseName,
    c.courseSubject,
    g.academicsGrade
FROM gradebook g
JOIN student s ON g.studentID = s.studentID
JOIN course c ON g.courseID = c.courseID
ORDER BY s.studentFirstName;

-- 1.2
SELECT 
    CONCAT(s.staffFirstName, ' ', s.staffLastName) AS `Instructor Full Name`,
    s.jobTitle,
    c.courseSubject,
    c.courseName
FROM staff s
JOIN course c ON s.staffID = c.staffID
ORDER BY s.staffFirstName;

-- 2.1
SELECT 
    jobTitle,
    COUNT(staffID) AS `Total Instructors`
FROM staff
WHERE jobTitle = 'Instructor';

-- 2.2
SELECT 
    CONCAT(studentFirstName, ' ', studentLastName) AS `Student Full Name`,
    studentStatus AS `Reason of leave`,
    MAX(dateOccurred) AS `Date Occurred`
FROM formerStudents
GROUP BY studentID, studentFirstName, studentLastName, studentStatus
ORDER BY `Date Occurred` DESC;

-- 3.1
SELECT 
    studentID,
    courseID,
    academicsGrade,
    CASE 
        WHEN academicsGrade = 'C' THEN 'Lowest Passing Grade'
        WHEN academicsGrade = 'F' THEN 'Needs Improvement'
    END AS `feedback`
FROM gradebook
WHERE academicsGrade = 'C' OR academicsGrade = 'F';

-- 4.1
SELECT 
    studentID,
    courseID,
    academicsGrade
FROM gradebook
WHERE academicsGrade IN ('A+', 'A', 'A-');

-- 5.1
SELECT 
    CONCAT(staffFirstName, ' ', staffLastName) AS `Former Staff Name`,
    jobTitle,
    dateOccurred AS `Departure Date`
FROM formerStaff
ORDER BY dateOccurred DESC
LIMIT 3;

-- 6.1
SELECT 
    CONCAT(s.staffFirstName, ' ', s.staffLastName) AS `Instructor Name`,
    c.courseSubject,
    c.courseName,
    COUNT(e.studentID) AS `Total Enrolled Students`
FROM staff s
JOIN course c ON s.staffID = c.staffID
JOIN enrollment e ON c.courseID = e.courseID
GROUP BY s.staffID, s.staffFirstName, s.staffLastName, c.courseID, c.courseSubject, c.courseName;

-- 6.2
SELECT 
    s.studentID,
    s.studentFirstName,
    s.studentLastName,
    s.schoolGrade,
    s.studentStatus
FROM student s
LEFT JOIN enrollment e ON s.studentID = e.studentID
WHERE e.studentID IS NULL
ORDER BY s.studentFirstName;

--######################################################################################################################################################
--######################################################################################################################################################
--######################################################################################################################################################
--######################################################################################################################################################
--######################################################################################################################################################
--######################################################################################################################################################
--######################################################################################################################################################
--######################################################################################################################################################
--######################################################################################################################################################
-----BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS-----
-----BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS-----
-----BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS----------BONUS-----

/*
Throughout the quiery making, I realized that most made sense to be procedures, views, or triggers. This isn't part of the original views or triggers,
but rather are fun little extras I decided to create to make it easier when it comes to the real thing. Here are the codes and the reason why.
*/

/*
-- TRIGGERS

2. Same reason as the first trigger.
3. When an administrator adds the students course enrollment, MySQL takes the data and automatically adds it to the gradebook table. This would save time for 
the admin as they don't also have to insert the same data into the gradebok table. All students grades will be null until it's updated.
4. This is for the aduit table formerStaff. When a staff member's staffStatus is updated to either fired, suspended, moved, or quit, the row will automatically be
added to the formerStaff table. This is important for data analysts to know which staff members have left and when.
5. Same reason as 3, but for the formerStudents audit table.
*/

-- 2
DELIMITER $$
CREATE TRIGGER correct_semester_date_2025_2026
BEFORE INSERT ON enrollment FOR EACH ROW
BEGIN

	IF LOWER(NEW.enrollmentDate) IN ('fall 2025', 'fall 25', 'fall2025', 'fall25')
		THEN SET NEW.enrollmentDate = '2025-08-25';
	ELSEIF LOWER(NEW.enrollmentDate) IN ('spring 2026', 'spring 26', 'spring2026', 'spring26')
		THEN SET NEW.enrollmentDate = '2026-01-12';
	ELSEIF LOWER(NEW.enrollmentDate) IN ('summer 2026', 'summer 26', 'summer2026', 'summer26')
		THEN SET NEW.enrollmentDate = '2026-05-18';
	END IF ;
    
END $$
DELIMITER ;

-- 3
DELIMITER $$
CREATE TRIGGER enrollment_to_gradebook_entry
AFTER INSERT ON enrollment FOR EACH ROW
BEGIN

    INSERT INTO gradebook (studentID, courseID)
    VALUES (NEW.studentID, NEW.courseID);

END $$
DELIMITER ;

-- 4
DELIMITER $$

CREATE TRIGGER update_staff_status
AFTER UPDATE ON staff FOR EACH ROW
BEGIN
    
    IF OLD.staffStatus <> NEW.staffStatus 
        AND LOWER(NEW.staffStatus) IN ('fired', 'suspended', 'moved', 'quit') 
        
        THEN INSERT INTO formerStaff
        SET 
            staffID = NEW.staffID,
            staffFirstName = NEW.staffFirstName,
            staffLastName = NEW.staffLastName,
            jobTitle = NEW.jobTitle,
            staffStatus = NEW.staffStatus,
            dateOccurred = NOW();
    END IF;

END $$
DELIMITER ;

-- 5
DELIMITER $$

CREATE TRIGGER update_student_status
AFTER UPDATE ON student FOR EACH ROW
BEGIN
    
    IF OLD.studentStatus <> NEW.studentStatus 
       AND LOWER(NEW.studentStatus) IN ('graduated', 'suspended', 'moved', 'expelled') THEN
       
        INSERT INTO formerStudents
        SET 
            studentID = NEW.studentID,
            studentFirstName = NEW.studentFirstName,
            studentLastName = NEW.studentLastName,
            studentStatus = NEW.studentStatus,
            dateOccurred = NOW();
    END IF;

END $$
DELIMITER ;

--######################################################################################################################################################

/* 
-- VIEWS

3. This was created after I realized query 6.2 in the main project could be a view as well. It would make sense to see the student enrolment roster and a roster
to see which students haven't enrolled yet. This would be important for advisors to know which students haven't enrolled yet and to advocate them to do so.
*/

-- 3
CREATE VIEW `students_not_enrolled` AS
    SELECT 
        s.studentID,
        s.studentFirstName,
        s.studentLastName,
        s.schoolGrade,
        s.studentStatus
    FROM student s
    LEFT JOIN enrollment e ON s.studentID = e.studentID
    WHERE e.studentID IS NULL
    ORDER BY s.studentFirstName;

--######################################################################################################################################################

/*
-- PROCEDURES

1. The triggers that deal with the staff audit table does not delete the row, only moves it. This procedure was created to be called and delete those rows 
where staffStatus say either of the acceptable values. It'll clear up the main staff table and keep things organized from the active and inactive staff members.
2. Same reason as 1, but for the main student table.
(there probably wouldve been an easier way to do this, but I decided to do it the way I know how to)
*/

-- 1
DELIMITER //
CREATE PROCEDURE delete_inactive_students()
BEGIN

    DELETE FROM student
    WHERE LOWER(studentStatus) IN ('graduated', 'suspended', 'moved', 'expelled');
    
END //
DELIMITER ;

-- 2
DELIMITER //
CREATE PROCEDURE delete_inactive_staff()
BEGIN

    DELETE FROM staff
    WHERE LOWER(staffStatus) IN ('fired', 'suspended', 'moved', 'quit');
    
END //
DELIMITER ;

-- i loved this class :)