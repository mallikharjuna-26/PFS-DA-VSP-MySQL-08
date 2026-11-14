DROP DATABASE IF EXISTS studentdb;
CREATE DATABASE studentdb;
USE studentdb;
 
-- ---------- Strong Entity: STUDENTS ----------
CREATE TABLE Students (
	student_id  	INT PRIMARY KEY,
	first_name  	VARCHAR(50),
	last_name   	VARCHAR(50),
	enrollment_year INT
);
 
-- ---------- Strong Entity: SUBJECTS ----------
CREATE TABLE Subjects (
	subject_id   INT PRIMARY KEY,
	subject_name VARCHAR(50)
);
 
-- ---------- Strong Entity: EXAMS ----------
CREATE TABLE Exams (
	exam_id   INT PRIMARY KEY,
	exam_name VARCHAR(50),
	exam_date DATE
);
 
-- ---------- Associative Entity: MARKS ----------
-- Resolves the natural many-to-many-to-many relationship between
-- STUDENTS, SUBJECTS and EXAMS. It has its own surrogate key (mark_id),
-- so it is a strong/associative entity, not a weak entity -- but every
-- row is meaningless without its three foreign keys.
CREATE TABLE Marks (
	mark_id    INT PRIMARY KEY,
	student_id INT,
	subject_id INT,
	exam_id    INT,
	score      INT,
	FOREIGN KEY (student_id) REFERENCES Students(student_id),
	FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id),
	FOREIGN KEY (exam_id)	REFERENCES Exams(exam_id)
);


-- Students
INSERT INTO Students VALUES
(1, 'Aarav',  'Sharma', 2023),
(2, 'Diya',   'Patel',  2023),
(3, 'Vihaan', 'Rao',	2024),
(4, 'Ananya', 'Singh',  2024);
 
-- Subjects
INSERT INTO Subjects VALUES
(101, 'Mathematics'),
(102, 'Science'),
(103, 'Hindi Literature');
 
-- Exams
INSERT INTO Exams VALUES
(1, 'Half-Yearly 2024',  '2024-09-15'),
(2, 'Final Annual 2024', '2024-03-20');
 
-- Marks
INSERT INTO Marks VALUES
(1, 1, 101, 1, 85),  -- Aarav,  Math,    Half-Yearly
(2, 1, 102, 1, 90),  -- Aarav,  Science, Half-Yearly
(3, 2, 101, 1, 75),  -- Diya,   Math,    Half-Yearly
(4, 2, 102, 1, 60),  -- Diya,   Science, Half-Yearly
(5, 3, 101, 1, 95),  -- Vihaan, Math,	Half-Yearly
(6, 1, 101, 2, 88),  -- Aarav,  Math,    Final
(7, 2, 101, 2, 79),  -- Diya,   Math,    Final
(8, 3, 101, 2, 92);  -- Vihaan, Math,	Final
 
-- Note: Ananya Singh (student_id 4) has no marks recorded, and
-- Hindi Literature (subject_id 103) is never used -- both are useful
-- edge cases for the LEFT JOIN / "never took an exam" queries below.


-- Foreign-key and frequently-filtered columns get explicit indexes to
-- speed up the JOINs, WHERE and GROUP BY clauses used throughout.
 
CREATE INDEX idx_marks_student   	ON Marks(student_id);
CREATE INDEX idx_marks_subject   	ON Marks(subject_id);
CREATE INDEX idx_marks_exam      	ON Marks(exam_id);
CREATE INDEX idx_marks_score     	ON Marks(score);
CREATE INDEX idx_students_enrollment ON Students(enrollment_year);
CREATE INDEX idx_exams_date      	ON Exams(exam_date);
 
-- Verify indexes:
-- SHOW INDEX FROM Marks;
-- SHOW INDEX FROM Students;




-- 4.1 Flattened mark + student + subject + exam info (for reporting/UI)
CREATE OR REPLACE VIEW view_student_marks AS
SELECT
	M.mark_id,
	CONCAT(St.first_name, ' ', St.last_name) AS student_name,
	Sb.subject_name,
	E.exam_name,
	E.exam_date,
	M.score
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
JOIN Subjects Sb ON M.subject_id = Sb.subject_id
JOIN Exams E 	ON M.exam_id	= E.exam_id;
 
-- 4.2 Average score per subject
CREATE OR REPLACE VIEW view_subject_averages AS
SELECT
	Sb.subject_id,
	Sb.subject_name,
	ROUND(AVG(M.score), 2) AS average_score,
	COUNT(M.mark_id)   	AS marks_recorded
FROM Subjects Sb
LEFT JOIN Marks M ON Sb.subject_id = M.subject_id
GROUP BY Sb.subject_id, Sb.subject_name;
 
-- 4.3 Per-student totals (includes students with zero marks)
CREATE OR REPLACE VIEW view_student_totals AS
SELECT
	St.student_id,
	CONCAT(St.first_name, ' ', St.last_name) AS student_name,
	St.enrollment_year,
	COUNT(M.mark_id)              	AS marks_count,
	COALESCE(SUM(M.score), 0)     	AS total_score,
	ROUND(AVG(M.score), 2)        	AS average_score
FROM Students St
LEFT JOIN Marks M ON St.student_id = M.student_id
GROUP BY St.student_id, St.first_name, St.last_name, St.enrollment_year;
 
-- 4.4 Pass / Fail report (score >= 70 is a Pass)
CREATE OR REPLACE VIEW view_pass_fail AS
SELECT
	CONCAT(St.first_name, ' ', St.last_name) AS student_name,
	Sb.subject_name,
	E.exam_name,
	M.score,
	CASE WHEN M.score >= 70 THEN 'Pass' ELSE 'Fail' END AS status
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
JOIN Subjects Sb ON M.subject_id = Sb.subject_id
JOIN Exams E 	ON M.exam_id	= E.exam_id;
 
-- 4.5 Exam-wise summary (total score, pass count, fail count)
CREATE OR REPLACE VIEW view_exam_summary AS
SELECT
	E.exam_id,
	E.exam_name,
	SUM(M.score)                                  	AS total_score,
	SUM(CASE WHEN M.score >= 70 THEN 1 ELSE 0 END) 	AS pass_count,
	SUM(CASE WHEN M.score < 70  THEN 1 ELSE 0 END) 	AS fail_count
FROM Exams E
JOIN Marks M ON E.exam_id = M.exam_id
GROUP BY E.exam_id, E.exam_name;



-- STORED PROCEDURES
 
-- 5.1 All marks for one student (by student_id)
DROP PROCEDURE IF EXISTS sp_get_student_marks;
DELIMITER $$
CREATE PROCEDURE sp_get_student_marks(IN p_student_id INT)
BEGIN
	SELECT Sb.subject_name, E.exam_name, M.score
	FROM Marks M
	JOIN Subjects Sb ON M.subject_id = Sb.subject_id
	JOIN Exams E 	ON M.exam_id	= E.exam_id
	WHERE M.student_id = p_student_id
	ORDER BY E.exam_date, Sb.subject_name;
END $$
DELIMITER ;
 
-- 5.2 Add a new mark (validates score range 0-100, auto-generates mark_id)
DROP PROCEDURE IF EXISTS sp_add_mark;
DELIMITER $$
CREATE PROCEDURE sp_add_mark(
	IN p_student_id INT,
	IN p_subject_id INT,
	IN p_exam_id	INT,
	IN p_score  	INT
)
BEGIN
	DECLARE v_new_id INT;
 
	IF p_score < 0 OR p_score > 100 THEN
    	SIGNAL SQLSTATE '45000'
        	SET MESSAGE_TEXT = 'Score must be between 0 and 100';
	ELSE
    	SELECT COALESCE(MAX(mark_id), 0) + 1 INTO v_new_id FROM Marks;
    	INSERT INTO Marks (mark_id, student_id, subject_id, exam_id, score)
    	VALUES (v_new_id, p_student_id, p_subject_id, p_exam_id, p_score);
	END IF;
END $$
DELIMITER ;
 
-- 5.3 Average score for one subject (by subject_id)
DROP PROCEDURE IF EXISTS sp_subject_average;
DELIMITER $$
CREATE PROCEDURE sp_subject_average(IN p_subject_id INT)
BEGIN
	SELECT Sb.subject_name, ROUND(AVG(M.score), 2) AS average_score
	FROM Subjects Sb
	LEFT JOIN Marks M ON Sb.subject_id = M.subject_id
	WHERE Sb.subject_id = p_subject_id
	GROUP BY Sb.subject_name;
END $$
DELIMITER ;
 
-- 5.4 Full exam report: every mark + pass/fail + exam-level pass count
DROP PROCEDURE IF EXISTS sp_exam_report;
DELIMITER $$
CREATE PROCEDURE sp_exam_report(IN p_exam_id INT)
BEGIN
	SELECT CONCAT(St.first_name, ' ', St.last_name) AS student_name,
       	Sb.subject_name,
       	M.score,
       	CASE WHEN M.score >= 70 THEN 'Pass' ELSE 'Fail' END AS status
	FROM Marks M
	JOIN Students St ON M.student_id = St.student_id
	JOIN Subjects Sb ON M.subject_id = Sb.subject_id
	WHERE M.exam_id = p_exam_id
	ORDER BY M.score DESC;
END $$
DELIMITER ;
 
-- 5.5 Student report card (all marks + overall average)
DROP PROCEDURE IF EXISTS sp_student_report_card;
DELIMITER $$
CREATE PROCEDURE sp_student_report_card(IN p_student_id INT)
BEGIN
	SELECT Sb.subject_name, E.exam_name, M.score,
       	CASE WHEN M.score >= 70 THEN 'Pass' ELSE 'Fail' END AS status
	FROM Marks M
	JOIN Subjects Sb ON M.subject_id = Sb.subject_id
	JOIN Exams E 	ON M.exam_id	= E.exam_id
	WHERE M.student_id = p_student_id;
 
	SELECT ROUND(AVG(score), 2) AS overall_average
	FROM Marks
	WHERE student_id = p_student_id;
END $$
DELIMITER ;


-- TRIGGERS
 
-- 6.0 Supporting audit table for mark changes
CREATE TABLE marks_log (
	log_id      INT AUTO_INCREMENT PRIMARY KEY,
	mark_id     INT,
	student_id  INT,
	action_type VARCHAR(10),
	old_score   INT,
	new_score   INT,
	change_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
 
-- 6.1 Reject an out-of-range score before it is ever inserted
DROP TRIGGER IF EXISTS trg_validate_score_insert;
DELIMITER $$
CREATE TRIGGER trg_validate_score_insert
BEFORE INSERT ON Marks
FOR EACH ROW
BEGIN
	IF NEW.score < 0 OR NEW.score > 100 THEN
    	SIGNAL SQLSTATE '45000'
        	SET MESSAGE_TEXT = 'Score must be between 0 and 100';
	END IF;
END $$
DELIMITER ;
 
-- 6.2 Reject an out-of-range score on UPDATE too
DROP TRIGGER IF EXISTS trg_validate_score_update;
DELIMITER $$
CREATE TRIGGER trg_validate_score_update
BEFORE UPDATE ON Marks
FOR EACH ROW
BEGIN
	IF NEW.score < 0 OR NEW.score > 100 THEN
    	SIGNAL SQLSTATE '45000'
        	SET MESSAGE_TEXT = 'Score must be between 0 and 100';
	END IF;
END $$
DELIMITER ;
 
-- 6.3 Block duplicate marks (same student + subject + exam already exists)
DROP TRIGGER IF EXISTS trg_prevent_duplicate_mark;
DELIMITER $$
CREATE TRIGGER trg_prevent_duplicate_mark
BEFORE INSERT ON Marks
FOR EACH ROW
BEGIN
	DECLARE v_count INT;
	SELECT COUNT(*) INTO v_count
	FROM Marks
	WHERE student_id = NEW.student_id
  	AND subject_id = NEW.subject_id
  	AND exam_id	= NEW.exam_id;
 
	IF v_count > 0 THEN
    	SIGNAL SQLSTATE '45000'
        	SET MESSAGE_TEXT = 'This student already has a mark for this subject in this exam';
	END IF;
END $$
DELIMITER ;
 
-- 6.4 Log every new mark inserted
DROP TRIGGER IF EXISTS trg_log_mark_insert;
DELIMITER $$
CREATE TRIGGER trg_log_mark_insert
AFTER INSERT ON Marks
FOR EACH ROW
BEGIN
	INSERT INTO marks_log (mark_id, student_id, action_type, old_score, new_score)
	VALUES (NEW.mark_id, NEW.student_id, 'INSERT', NULL, NEW.score);
END $$
DELIMITER ;
 
-- 6.5 Log every score change (old vs new)
DROP TRIGGER IF EXISTS trg_log_mark_update;
DELIMITER $$
CREATE TRIGGER trg_log_mark_update
AFTER UPDATE ON Marks
FOR EACH ROW
BEGIN
	IF OLD.score <> NEW.score THEN
    	INSERT INTO marks_log (mark_id, student_id, action_type, old_score, new_score)
    	VALUES (NEW.mark_id, NEW.student_id, 'UPDATE', OLD.score, NEW.score);
	END IF;
END $$
DELIMITER ;
 
-- 6.6 Log every deleted mark
DROP TRIGGER IF EXISTS trg_log_mark_delete;
DELIMITER $$
CREATE TRIGGER trg_log_mark_delete
AFTER DELETE ON Marks
FOR EACH ROW
BEGIN
	INSERT INTO marks_log (mark_id, student_id, action_type, old_score, new_score)
	VALUES (OLD.mark_id, OLD.student_id, 'DELETE', OLD.score, NULL);
END $$
DELIMITER ;


-- DEMO CALLS - Views / Stored Procedures / Triggers
-- Run these one at a time to see the objects from PART 4-6 in action.
 
-- Views:
-- SELECT * FROM view_student_marks;
-- SELECT * FROM view_subject_averages;
-- SELECT * FROM view_student_totals ORDER BY total_score DESC;
-- SELECT * FROM view_pass_fail WHERE status = 'Fail';
-- SELECT * FROM view_exam_summary;
 
-- Stored Procedures:
-- CALL sp_get_student_marks(1);                 -- Aarav Sharma's marks
-- CALL sp_add_mark(4, 103, 1, 72);               -- Ananya gets a Hindi Literature mark
-- CALL sp_subject_average(101);                  -- Mathematics average
-- CALL sp_exam_report(2);                        -- Final Annual 2024 report
-- CALL sp_student_report_card(2);                -- Diya Patel's report card
 
-- Triggers (fire automatically, nothing to CALL):
--   * Inserting a Mark with score < 0 or > 100 is blocked  	-> trg_validate_score_insert
--   * Updating a Mark to an out-of-range score is blocked  	-> trg_validate_score_update
--   * Inserting a duplicate (same student+subject+exam) is
-- 	blocked                                                  -> trg_prevent_duplicate_mark
--   * Every INSERT / UPDATE / DELETE on Marks is written to
-- 	marks_log automatically                              	-> trg_log_mark_insert /
--                                                                   trg_log_mark_update /
--                                                                   trg_log_mark_delete
 
-- Check the audit trail after running the demo calls above:
-- SELECT * FROM marks_log ORDER BY log_id;



-- Q1. Retrieve all students (first and last name).
SELECT first_name, last_name FROM Students;
-- ANSWER:
--   Aarav Sharma, Diya Patel, Vihaan Rao, Ananya Singh
 
-- Q2. Filter by Score: marks greater than 80.
SELECT * FROM Marks WHERE score > 80;
-- ANSWER:
--   mark_id 1 - Aarav  - Math    - Half-Yearly - 85
--   mark_id 2 - Aarav  - Science - Half-Yearly - 90
--   mark_id 5 - Vihaan - Math	- Half-Yearly - 95
--   mark_id 6 - Aarav  - Math    - Final   	- 88
--   mark_id 8 - Vihaan - Math	- Final   	- 92
 
-- Q3. Sort Data: all exams, most recent first.
SELECT * FROM Exams ORDER BY exam_date DESC;
-- ANSWER:
--   Half-Yearly 2024  - 2024-09-15
--   Final Annual 2024 - 2024-03-20


-- Q4. Student Marks: First Name, Subject Name, Score for every mark.
SELECT St.first_name, Sb.subject_name, M.score
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
JOIN Subjects Sb ON M.subject_id = Sb.subject_id;
-- ANSWER: 8 rows -- Aarav/Math/85, Aarav/Science/90, Diya/Math/75,
--   Diya/Science/60, Vihaan/Math/95, Aarav/Math/88, Diya/Math/79, Vihaan/Math/92
 
-- Q5. Subject Averages: average score per subject.
SELECT Sb.subject_name, AVG(M.score) AS average_score
FROM Marks M
JOIN Subjects Sb ON M.subject_id = Sb.subject_id
GROUP BY Sb.subject_name;
-- ANSWER:
--   Mathematics - 85.67  (85+75+95+88+79+92 = 514 / 6)
--   Science     - 75.00  (90+60 = 150 / 2)
--   (Hindi Literature does not appear -- an INNER JOIN excludes subjects
--	with zero marks recorded; see view_subject_averages in PART 4 for
--	a version that includes it via LEFT JOIN.)
 
-- Q6. Count Exams: how many marks recorded for "Aarav Sharma"?
SELECT COUNT(*) AS total_exams_taken
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
WHERE St.first_name = 'Aarav' AND St.last_name = 'Sharma';
-- ANSWER: 3  (Math/Half-Yearly, Science/Half-Yearly, Math/Final)


-- Q7. Top Performer: student with the highest single score in any exam.
SELECT first_name, last_name
FROM Students
WHERE student_id = (
	SELECT student_id FROM Marks ORDER BY score DESC LIMIT 1
);
-- Note: use 'TOP 1' instead of 'LIMIT 1' if you are on MS SQL Server.
-- ANSWER: Vihaan Rao (score 95, Mathematics, Half-Yearly 2024)
 
-- Q8. Scores by Exam: exam name + total score, only where total > 250.
SELECT E.exam_name, SUM(M.score) AS total_score
FROM Marks M
JOIN Exams E ON M.exam_id = E.exam_id
GROUP BY E.exam_name
HAVING SUM(M.score) > 250;
-- ANSWER:
--   Half-Yearly 2024  - 405  (85+90+75+60+95)
--   Final Annual 2024 - 259  (88+79+92)
--   (Both exams clear the 250 threshold.)
 
-- Q9. Pass/Fail Label: Student Name, Subject, Score, Pass/Fail status.
SELECT
	St.first_name, Sb.subject_name, M.score,
	CASE WHEN M.score >= 70 THEN 'Pass' ELSE 'Fail' END AS status
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
JOIN Subjects Sb ON M.subject_id = Sb.subject_id;
-- ANSWER: 8 rows, all "Pass" except Diya / Science / 60 -> "Fail"


-- Q10. Students enrolled in 2023.
SELECT first_name, last_name FROM Students WHERE enrollment_year = 2023;
-- ANSWER: Aarav Sharma, Diya Patel
 
-- Q11. Highest score recorded in each subject.
SELECT Sb.subject_name, MAX(M.score) AS highest_score
FROM Marks M
JOIN Subjects Sb ON M.subject_id = Sb.subject_id
GROUP BY Sb.subject_name;
-- ANSWER:
--   Mathematics - 95  (Vihaan Rao, Half-Yearly)
--   Science     - 90  (Aarav Sharma, Half-Yearly)
 
-- Q12. Students who took the 'Final Annual 2024' exam.
SELECT DISTINCT St.first_name, St.last_name
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
JOIN Exams E ON M.exam_id = E.exam_id
WHERE E.exam_name = 'Final Annual 2024';
-- ANSWER: Aarav Sharma, Diya Patel, Vihaan Rao  (Ananya Singh did not)
 
-- Q13. Students whose average score (across all their marks) is above 80.
SELECT St.first_name, St.last_name, ROUND(AVG(M.score), 2) AS avg_score
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
GROUP BY St.student_id, St.first_name, St.last_name
HAVING AVG(M.score) > 80;
-- ANSWER:
--   Vihaan Rao   - 93.50  ( (95+92)/2 )
--   Aarav Sharma - 87.67  ( (85+90+88)/3 )
 
-- Q14. Number of students per enrollment year.
SELECT enrollment_year, COUNT(*) AS student_count
FROM Students
GROUP BY enrollment_year;
-- ANSWER:
--   2023 - 2 students  (Aarav, Diya)
--   2024 - 2 students  (Vihaan, Ananya)
 
-- Q15. Which subject has the highest average score?
SELECT Sb.subject_name, ROUND(AVG(M.score), 2) AS avg_score
FROM Marks M
JOIN Subjects Sb ON M.subject_id = Sb.subject_id
GROUP BY Sb.subject_name
ORDER BY avg_score DESC
LIMIT 1;
-- ANSWER: Mathematics - 85.67
 
-- Q16. Students who scored above their subject's own average (correlated subquery).
SELECT St.first_name, Sb.subject_name, M.score
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
JOIN Subjects Sb ON M.subject_id = Sb.subject_id
WHERE M.score > (
	SELECT AVG(M2.score) FROM Marks M2 WHERE M2.subject_id = M.subject_id
);
-- ANSWER:
--   Aarav  - Science - 90  (subject avg 75.00)
--   Vihaan - Math	- 95  (subject avg 85.67)
--   Aarav  - Math	- 88  (subject avg 85.67)
--   Vihaan - Math	- 92  (subject avg 85.67)
 
-- Q17. Pass count per exam (score >= 70).
SELECT E.exam_name,
   	SUM(CASE WHEN M.score >= 70 THEN 1 ELSE 0 END) AS pass_count,
   	SUM(CASE WHEN M.score < 70  THEN 1 ELSE 0 END) AS fail_count
FROM Marks M
JOIN Exams E ON M.exam_id = E.exam_id
GROUP BY E.exam_name;
-- ANSWER:
--   Half-Yearly 2024  - 4 pass, 1 fail  (fail: Diya/Science/60)
--   Final Annual 2024 - 3 pass, 0 fail
 
-- Q18. Full detail list: student, subject, exam, score (3-way join).
SELECT CONCAT(St.first_name, ' ', St.last_name) AS student_name,
   	Sb.subject_name, E.exam_name, M.score
FROM Marks M
JOIN Students St ON M.student_id = St.student_id
JOIN Subjects Sb ON M.subject_id = Sb.subject_id
JOIN Exams E 	ON M.exam_id	= E.exam_id
ORDER BY E.exam_date, St.first_name;
-- ANSWER: all 8 marks fully detailed (same data as view_student_marks)
 
-- Q19. Students who have never taken any exam (no marks recorded).
SELECT St.first_name, St.last_name
FROM Students St
LEFT JOIN Marks M ON St.student_id = M.student_id
WHERE M.mark_id IS NULL;
-- ANSWER: Ananya Singh (the only student with zero marks)
 
-- Q20. Rank all students by total score, highest first.
SELECT CONCAT(St.first_name, ' ', St.last_name) AS student_name,
   	COALESCE(SUM(M.score), 0) AS total_score
FROM Students St
LEFT JOIN Marks M ON St.student_id = M.student_id
GROUP BY St.student_id, St.first_name, St.last_name
ORDER BY total_score DESC;
-- ANSWER:
--   1. Aarav Sharma - 263  (85+90+88)
--   2. Diya Patel   - 214  (75+60+79)
--   3. Vihaan Rao   - 187  (95+92)
--   4. Ananya Singh - 0	(no marks recorded)
 
-- Q21. Second-highest individual score recorded.
SELECT DISTINCT score
FROM Marks
ORDER BY score DESC
LIMIT 1 OFFSET 1;
-- ANSWER: 92  (highest is 95; second-highest is 92, Vihaan Rao, Final Math)

