CREATE TABLE students(
    student_name VARCHAR2(20) NOT NULL
  , student_number number(10) NOT NULL UNIQUE
  , student_phoneNumber VARCHAR2(500) 
);
INSERT INTO students VALUES('ȫ�浿', '1', '01012345678');
INSERT INTO students VALUES('������', '2', '01012341234');
INSERT INTO students VALUES('���缮', '3', '01087654321');

desc students;
SELECT *
FROM students;

INSERT INTO students (
        student_name
      , student_number
)VALUES(
      '�����'
    , '4'
);

UPDATE students
SET student_number = '100'
  , student_phoneNumber = '01011112222'
WHERE student_name = '�����';

DELETE students
WHERE student_name = '�����';
