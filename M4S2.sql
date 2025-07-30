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
	final_grade DECIMAL(1,1),
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




SELECT students.id_student, students.full_name, enrollments.final_grade FROM students
JOIN enrollments ON students.id_student = enrollments.id_student
WHERE final_grade > (
    SELECT AVG(final_grade) FROM enrollments
)
ORDER BY final_grade DESC;


SELECT students.id_student, students.full_name, enrollment.id_enroll, 




