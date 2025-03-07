CREATE TABLE students(
    student_name VARCHAR2(20) NOT NULL
  , student_number number(10) NOT NULL UNIQUE
  , student_phoneNumber VARCHAR2(500) 
);
INSERT INTO students VALUES('홍길동', '1', '01012345678');
INSERT INTO students VALUES('이지은', '2', '01012341234');
INSERT INTO students VALUES('유재석', '3', '01087654321');

desc students;
SELECT *
FROM students;

INSERT INTO students (
        student_name
      , student_number
)VALUES(
      '고양이'
    , '4'
);

UPDATE students
SET student_number = '100'
  , student_phoneNumber = '01011112222'
WHERE student_name = '고양이';

DELETE students
WHERE student_name = '고양이';

CREATE TABLE ex2(
    mem_id VARCHAR2(50)         PRIMARY KEY     -- 기본키
  , mem_nm VARCHAR2(50)         NOT NULL        -- 널 허용안함
  , mem_nickname VARCHAR2(100)  UNIQUE          -- 중복 허용안함
  , age NUMBER                                  -- 1~150
  , gender VARCHAR2(1)                          -- F or M
  , create_dt DATE DEFAULT SYSDATE              -- 디폴트값 설정
  , CONSTRAINT ck_ex_age CHECK(age BETWEEN 1 AND 150)
  , CONSTRAINT ck_ex_gender CHECK(gender IN('F','M'))
);

CREATE TABLE ex0(
       name      VARCHAR2(50)
     , phone_num CHAR(13) DEFAULT '010-0000-0000'
);
INSERT INTO ex0 (name) VALUES('홍길동');
INSERT INTO ex1 VALUES(
      'a001'
    , '홍길동'
    , '길동'
);