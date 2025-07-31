CREATE TABLE students(
	id_student INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(120) NOT NULL,
	student_email VARCHAR(70) NOT NULL UNIQUE,
	gender ENUM('female', 'male', 'other'),
	id_number INT UNIQUE NOT NULL,
	career TEXT,
	birth_date DATE NOT NULL,
	admission_date DATE NOT NULL  
);

CREATE TABLE teachers(
	id_teacher INT PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(120) NOT NULL,
	college_email VARCHAR(70) NOT NULL UNIQUE,
	academic_department VARCHAR(100),
	year_exp INT
);

CREATE TABLE courses(
	id_course INT PRIMARY KEY AUTO_INCREMENT,
	course_name VARCHAR(120) NOT NULL,
	course_code INT UNIQUE NOT NULL,
	credits INT NOT NULL,
	semester INT,
	id_teacher INT,
	CONSTRAINT FK_ID_TEACHER
		FOREIGN KEY (id_teacher) REFERENCES teachers(id_teacher)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);

CREATE TABLE enrollments(
	id_enroll INT PRIMARY KEY AUTO_INCREMENT,
	id_student INT,
	id_course INT,
	enroll_date DATE,
	final_grade DECIMAL(2,1),
	CHECK (final_grade BETWEEN 1.0 AND 5.0),
	CONSTRAINT FK_ID_STUDENT
		FOREIGN KEY (id_student) REFERENCES students(id_student)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	CONSTRAINT FK_ID_COURSE
		FOREIGN KEY (id_course) REFERENCES courses(id_course)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);


INSERT INTO students (
    full_name, 
    student_email, 
    gender, 
    id_number, 
    career, 
    birth_date, 
    admission_date
) VALUES
('Ana Gómez', 'ana.gomez@example.com', 'female', 123456, 'Ingeniería en Sistemas', '2000-04-15', '2018-08-20'),
('Luis Martínez', 'luis.martinez@example.com', 'male', 234567, 'Administración de Empresas', '1999-11-30', '2017-09-05'),
('María Fernández', 'maria.fernandez@example.com', 'female', 345678, 'Medicina', '2001-01-22', '2019-01-10'),
('Carlos Pérez', 'carlos.perez@example.com', 'male', 456789, 'Arquitectura', '2000-06-05', '2018-08-15'),
('Sofía Ruiz', 'sofia.ruiz@example.com', 'other', 567890, 'Derecho', '1998-12-12', '2016-07-01');


INSERT INTO teachers (
    full_name,
    college_email,
    academic_department,
    year_exp
) VALUES
('Laura Morales', 'laura.morales@university.edu', 'Matemáticas', 8),
('Javier Soto', 'javier.soto@university.edu', 'Física', 12),
('Elena Ramírez', 'elena.ramirez@university.edu', 'Literatura', 5);


INSERT INTO courses (
    course_name,
    course_code,
    credits,
    semester,
    id_teacher
) VALUES
('Cálculo I', 101, 5, 1, 1),
('Física General', 102, 4, 1, 2),
('Literatura Universal', 103, 3, 2, 3),
('Álgebra Lineal', 104, 4, 2, 1);


INSERT INTO enrollments (
    id_student,
    id_course,
    enroll_date,
    final_grade
) VALUES
(1, 1, '2023-01-10', 4.5),
(1, 2, '2023-01-10', 3.7),
(2, 1, '2023-01-12', 5.0),
(2, 3, '2023-01-12', 4.0),
(3, 4, '2023-01-15', 2.8),
(4, 2, '2023-01-18', 3.9),
(5, 3, '2023-01-20', 4.3),
(5, 4, '2023-01-20', 4.7);


-- ----------------------------Query Exersices ----------------------------------------------

SELECT students.id_student, students.full_name, enrollments.final_grade FROM students
JOIN enrollments ON students.id_student = enrollments.id_student
WHERE final_grade > (
    SELECT AVG(final_grade) FROM enrollments
)
ORDER BY final_grade DESC;


SELECT 
    s.id_student,
    s.full_name,
    s.student_email,
    e.id_enroll,
    e.enroll_date,
    e.final_grade,
    c.course_name,
    c.course_code,
    c.credits,
    c.semester
FROM students s
LEFT JOIN enrollments e ON s.id_student = e.id_student
LEFT JOIN courses c ON e.id_course = c.id_course
ORDER BY s.id_student, e.enroll_date;


SELECT 
    c.course_name,
    c.course_code,
    c.credits,
    c.semester,
    t.full_name AS teacher_name,
    t.year_exp
FROM courses c
JOIN teachers t ON c.id_teacher = t.id_teacher
WHERE t.year_exp > 5;


SELECT 
    c.course_name,
    c.course_code,
    AVG(e.final_grade) AS promedio_calificacion
FROM courses c
JOIN enrollments e ON c.id_course = e.id_course
GROUP BY c.id_course, c.course_name, c.course_code
ORDER BY promedio_calificacion DESC;



SELECT 
    s.id_student,
    s.full_name,
    COUNT(e.id_course) AS cantidad_cursos
FROM students s
JOIN enrollments e ON s.id_student = e.id_student
GROUP BY s.id_student, s.full_name
HAVING COUNT(e.id_course) > 1
ORDER BY cantidad_cursos DESC;



SELECT 
    c.id_course,
    c.course_name,
    COUNT(e.id_student) AS cantidad_estudiantes
FROM courses c
JOIN enrollments e ON c.id_course = e.id_course
GROUP BY c.id_course, c.course_name
HAVING COUNT(e.id_student) >= 2
ORDER BY cantidad_estudiantes DESC;


ALTER TABLE students
ADD COLUMN estado_academico VARCHAR(50);



-- DELETE ON CASCADE --

INSERT INTO teachers (
    full_name,
    college_email,
    academic_department,
    year_exp
) VALUES
('Manuel Ruiz', 'manuel.ruiz@ecci.edu', 'filosofia', 2);

INSERT INTO courses (
    course_name,
    course_code,
    credits,
    semester,
    id_teacher
) VALUES
('Filosofia I', 108, 3, 6, 5);


DELETE FROM teachers
WHERE id_teacher = 5;


SELECT DISTINCT s.career
FROM students s
WHERE EXISTS (
    SELECT 1
    FROM enrollments e
    JOIN courses c ON e.id_course = c.id_course
    WHERE e.id_student = s.id_student
      AND c.semester >= 2
);


CREATE VIEW vista_historial_academico AS
SELECT 
    s.full_name AS nombre_estudiante,
    c.course_name AS nombre_curso,
    t.full_name AS nombre_docente,
    c.semester AS semestre,
    e.final_grade AS calificacion_final
FROM enrollments e
JOIN students s ON e.id_student = s.id_student
JOIN courses c ON e.id_course = c.id_course
JOIN teachers t ON c.id_teacher = t.id_teacher;

SELECT * FROM vista_historial_academico;


-- Access Control

CREATE ROLE IF NOT EXISTS revisor_academico;
GRANT SELECT ON vista_historial_academico TO revisor_academico;


-- Primero le damos accesos para quitarselos
GRANT INSERT, UPDATE, DELETE ON enrollments TO revisor_academico;
REVOKE INSERT, UPDATE, DELETE ON enrollments FROM revisor_academico;



-- Control de acceso y transacciones

BEGIN;

UPDATE enrollments
SET final_grade = 4.8
WHERE id_enroll = 1;

SAVEPOINT checkpoint;

UPDATE enrollments
SET final_grade = 3.9
WHERE id_enroll = 2;

ROLLBACK TO SAVEPOINT checkpoint;

COMMIT;
