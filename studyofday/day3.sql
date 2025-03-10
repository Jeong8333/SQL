
-- delete 데이터 삭제 (where 필수!!)
DELETE ex1_4;  -- 전체 삭제

DELETE ex1_4
WHERE mem_id = 'a001';  -- 해당 조건이 true인 행을 삭제
SELECT *
FROM ex1_4;

-- 테이블 수정 ALTER (update는 테이블에 데이터를 수정)

-- 컬럼 이름 변경
ALTER TABLE ex1_4 RENAME COLUMN mem_nickname TO mem_nick;

-- 테이블 이름 변경
ALTER TABLE ex1_4 RENAME TO mem;

-- 컬럼 데이터 타입 변경 (변경시 제약조건 주의)
ALTER TABLE mem MODIFY (mem_nick VARCHAR2(500));

-- 제약조건 삭제
SELECT *
FROM user_constraints
WHERE table_name = 'MEM'; -- 해당 테이블 제약조건 이름 검색
ALTER TABLe mem DROP CONSTRAINT CK_EX_AGE;

-- 제약조건 추가
ALTER TABLE mem ADD CONSTRAINT ck_ex_new_age CHECK(age BETWEEN 1 AND 150);
-- 컬럼 추가
ALTER TABLE mem ADD (new_en_nm VARCHAR2(100));
-- 컬럼 삭제
ALTER TABLE mem DROP COLUMN new_en_nm;

DESC mem;

-- TB_INFO에 MBTI 컬럼 추가
ALTER TABLE TB_INFO ADD (MBTI VARCHAR2(20));

DESC TB_INFO;


-- FK 외래키
CREATE TABLE dep(
      deptno NUMBER(3) PRIMARY KEY
    , dept_nm VARCHAR2(20)
    , dep_floor NUMBER(4)
);
CREATE TABLE emp(
      empno NUMBER(5) PRIMARY KEY
    , emp_nm VARCHAR2(20)
    , title  VARCHAR2(20)
    -- 참조 하고자하는 컬럼의 타입 일치해야함(명은 달라도 됨)
    -- refernces 참조할 테이블(컬럼명)
    -- 참조 테이블, 컬럼이 존재해야함(PK이면서)
    -- 참조된 열을 삭제하기 위해선 참조중인 열을 먼저 지운 다음 참조열을 지워야 함.
    , dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno)
);
INSERT INTO dep VALUES(1, '영업', 8);
INSERT INTO dep VALUES(2, '기획', 9);
INSERT INTO dep VALUES(3, '개발', 10);
INSERT INTO emp VALUES(100, '팽수', '대리', 2);
INSERT INTO emp VALUES(200, '동수', '과장', 3);
INSERT INTO emp VALUES(300, '길동', '부장', 4); -- 오류남(참조테이블 부서에 '4'가 존재하지 않음)

SELECT *
FROM dep;

SELECT emp.empno
     , emp.emp_nm
     , emp.title
     , dep.dept_nm || '부서(' || dep.dep_floor ||'층)'as 부서   -- || : 문자열 더하기
FROM emp, dep
WHERE emp.dno = dep.deptno
AND emp.emp_nm ='동수';


-- 참조하고 있는 테이블에서 사용중인 데이터는 삭제 안 됨.
DELETE dep
WHERE deptno = 3;
-- 방법1.참조중인 데이터 삭제 후 삭제
DELETE emp
WHERE empno = 200;

-- 방법2.제약조건 무시하고 삭제
DELETE dep;
DROP TABLE emp CASCADE CONSTRAINTS;  -- 제약조건 무시하고 테이블 삭제


SELECT employee_id
     , emp_name
     , job_id
     , manager_id
     , department_id
FROM employees;


-- 테이블 코멘트
COMMENT ON TABLE tb_info IS 'tech9';
-- 컬럼 코멘트
COMMENT ON COLUMN tb_info.info_no IS '출석번호';
COMMENT ON COLUMN tb_info.pc_no IS '좌석번호';
COMMENT ON COLUMN tb_info.nm IS '이름';
COMMENT ON COLUMN tb_info.en_nm IS '영문명';
COMMENT ON COLUMN tb_info.email IS '이메일';
COMMENT ON COLUMN tb_info.hobby IS '취미';
COMMENT ON COLUMN tb_info.create_dt IS '생성일';
COMMENT ON COLUMN tb_info.update_dt IS '수정일';
COMMENT ON COLUMN tb_info.mbti IS '성격유형검사';
-- 정보조회
SELECT *
FROM all_tab_comments
WHERE comments = 'tech9';

SELECT *
FROM user_col_comments
WHERE comments = '성격유형검사';



-- (1) member 계정 만들기
    -- user id : member, pw : member
    -- 권한부여 : 접속 & 테이블생성
    
    -- system 계정으로 권한부여
    ALTER SESSION SET "_ORACLE_SCRIPT"=true;
    CREATE USER member IDENTIFIED BY member;
    GRANT CONNECT, RESOURCE TO member;
    GRANT UNLIMITED TABLESPACE TO member;
-- (2) 해당 계정으로 접속
    -- !!! java 계정에서 (3)을 실행하지 마세요!!!
-- (3) member_table(utf-8).sql문을 실행하여 테이블 생성 및 데이터 저장)
    SELECT *
    FROM member
    WHERE mem_id = 'a001';