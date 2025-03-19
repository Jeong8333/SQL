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


CREATE TABLE ex_u(
       mem_name  VARCHAR2(50)
     , mem_id    VARCHAR2(10) UNIQUE
     , mem_pw    VARCHAR2(20) NOT NULL
);
;
INSERT INTO ex_u VALUES('홍길동', 'a001', 'a123456789');
INSERT INTO ex_u VALUES('홍길동', 'a001', 'a1234');  -- mem_id 중복
INSERT INTO ex_u VALUES('유재석', 'b001', 'a5678');
INSERT INTO ex_u(mem_name, mem_pw) VALUES('아이유', 'a0000');

CREATE TABLE ex_p(
       mem_name  VARCHAR2(50) NOT NULL
     , mem_id    VARCHAR2(10) PRIMARY KEY
     , mem_pw    VARCHAR2(20) 
);

INSERT INTO ex_p VALUES('홍길동', 'a001', 'a123456789');
INSERT INTO ex_p VALUES('홍길동', 'a001', 'a1234');  -- mem_id 중복
INSERT INTO ex_p VALUES('유재석', 'b001', 'a5678');

CREATE TABLE ex_f(
       mem_num   NUMBER(10) NOT NULL
     , m_id VARCHAR2(10) CONSTRAINT ex_f_fk REFERENCES ex_p(mem_id)
);
INSERT INTO ex_f VALUES('100', 'a001');

SELECT *
FROM ex_p, ex_f
WHERE ex_p.mem_id = ex_f.m_id;


-- 2025.03.19 단일함수 - 숫자
SELECT ROUND(1234.5678)      as ROUND_DEFAULT
     , ROUND(1234.5678, 0)   as ROUND_0
     , ROUND(1234.5678, 1)   as ROUND_1
     , ROUND(1234.5678, 2)   as ROUND_2
     , ROUND(1234.5678, -1)  as ROUND_MINUS1
     , ROUND(1234.5678, -2)  as ROUND_MINUS2
FROM DUAL;

SELECT TRUNC(1234.5678)      as TRUNC_DEFAULT
     , TRUNC(1234.5678, 0)   as TRUNC_0
     , TRUNC(1234.5678, 1)   as TRUNC_1
     , TRUNC(1234.5678, 2)   as TRUNC_2
     , TRUNC(1234.5678, -1)  as TRUNC_MINUS1
     , TRUNC(1234.5678, -2)  as TRUNC_MINUS2 
FROM DUAL;

SELECT CEIL(1234.1)    as CEIL
     , CEIL(-1234.1)   as CEIL_MINUS
FROM DUAL;

SELECT FLOOR(1234.1)    as FLOOR
     , FLOOR(-1234.1)   as FLOOR_MINUS
FROM DUAL;

SELECT MOD(10, 5)    
     , MOD(10, 3)
     , MOD(28, 5)
FROM DUAL;


SELECT ABS(10)    
     , ABS(-10)
FROM DUAL;