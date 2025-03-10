-- 주석 ctrl + /
/*
    다중 주석
    영역이 다 주석처리됨.
    주석 영역은 명령어에 영향을 주지 않음.
*/
-- sqldeveloper에서 명령어는 파란색으로 표시됨.
-- 명령어는 대소문자를 구별하지 않음 (식별을 위해서 대소문자로 작성)
-- 명령어는 ; 세미콜론으로 구분

-- 11g 이후 계정명에 ##을 붙여야 하는데
-- 예전 방법으로 계정명 만들기 위해서는 아래 명령어 실행 후 만들어야 함.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정 생성 계정명:java, 비번:oracle
CREATE USER java IDENTIFIED BY oracle;
-- 권한 부여(접속&리소스 생성 및 접근)
GRANT CONNECT, RESOURCE TO java;
-- 테이블 스페이스 접근 권한(물리적인 저장 파일)
GRANT UNLIMITED TABLESPACE TO java;
-- 명령어 실행은 세미콜론 기준으로 커서 위치 후 ctrl + enter or 실행버튼



-- java 계정에서 실행
CREATE TABLE members(
     mem_id        VARCHAR2(10)
    ,mem_password  VARCHAR2(10)
    ,mem_name      VARCHAR2(10)
    ,mem_phone     CHAR(11)
    ,mem_email     VARCHAR2(100)
);
-- 데이터 삽입
INSERT INTO members VALUES('a001', '1234', '팽수', '01012345678', 'pangsu@gamil.com');
INSERT INTO members VALUES('a002', '1234', '동수', '01112345678', 'dongsu@gamil.com');
-- 데이터 조회
SELECT *
FROM members;


delete members;

SELECT employee_id
    , emp_name
    , department_id
FROM employees;

SELECT *
FROM departments;
-- PK, FK 를 활용하여 각 테이블의 관계를 맺어 데이터를 가져옴.
SELECT employees.employee_id        -- 직원 테이블의 PK
    , employees.department_id       -- 직원 테이블의 FK(부서 테이블 부서번호참조)
    , employees.emp_name            
    , departments.department_id     -- 부서테이블의 PK
    , departments.department_name
FROM employees
    ,departments
WHERE employees.department_id = departments.department_id;

/* 제약조건
   테이블을 관리하기 위한 규칙
   NOT NULL 널을 허용하지 않겠다
   UNIQUE 중복을 허용하지 않겠다
   CHECK 특정 데이터만 받겠다
   PRIMARY KEY 기본키(하나의 테이블에 1개만 설정가능(n개의 컬럼을 결합해서 사용가능)
                      하나의 행을 구분하는 식별자 or 키값 or PK or 기본키라고 함.
                      PK는 UNIQUE 하며 NOT NULL임)
   FOREIGN KEY 외래키(참조키, FK라 함, 다른 테이블의 PK를 참조하는 키)
*/
CREATE TABLE ex1_4(
    mem_id VARCHAR2(50)         PRIMARY KEY     -- 기본키
  , mem_nm VARCHAR2(50)         NOT NULL        -- 널 허용안함
  , mem_nickname VARCHAR2(100)  UNIQUE          -- 중복 허용안함
  , age NUMBER                                  -- 1~150
  , gender VARCHAR2(1)                          -- F or M
  , create_dt DATE DEFAULT SYSDATE              -- 디폴트값 설정
  , CONSTRAINT ck_ex_age CHECK(age BETWEEN 1 AND 150)
  , CONSTRAINT ck_ex_gender CHECK(gender IN('F','M'))
);
INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a001', '팽수', '팽하', 10, 'M');

INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a002', '동수', '동하', 10, 'M');    -- gender 체크 제약조건 위배

SELECT *
FROM ex1_4;

SELECT *
FROM user_constraints
WHERE table_name = 'EX1_4';

delete TB_INFO;

CREATE TABLE TB_INFO(
    INFO_NO NUMBER(2) PRIMARY KEY
  , PC_NO VARCHAR2(10) UNIQUE NOT NULL
  , NM VARCHAR2(20) NOT NULL
  , EN_NM VARCHAR2(50) NOT NULL
  , EMAIL VARCHAR2(50) NOT NULL
  , HOBBY VARCHAR2(500) 
  , CREATE_DT DATE DEFAULT SYSDATE
  , UPDATE_DT DATE DEFAULT SYSDATE
);

    
SELECT *
FROM ex1_4;

-- ex1_4 전체행이 업데이트됨
UPDATE ex1_4
SET age = 11;

-- a001 age 수정
SELECT *
FROM ex1_4
WHERE mem_id = 'a001';

-- 데이터 체크 후 수정하는 습관!
UPDATE ex1_4
SET age = 11
WHERE mem_id = 'a001';
COMMIT;


-- hobby 수정
SELECT *
FROM tb_info
WHERE info_no = '10';

UPDATE tb_info
SET hobby ='사진찍기'
WHERE info_no = '10';
commit;
