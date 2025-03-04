SELECT department_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
     , LEVEL  -- 가상-열로서 트리 내에서 어떤 단계에 있는지 나타내는 정수값
FROM departments
START WITH parent_id IS NULL                -- 해당 조건 로우부터 시작
CONNECT BY PRIOR department_id = parent_id; -- 계층 구조가 어떤 식으로 연결되는지
--        이전 부서들의 parent_id를 찾도록

-- 관리자와 직원
SELECT a.employee_id
     , LPAD(' ', 3 * (LEVEL-1)) || a.emp_name as emp_nm
     , LEVEL
     , b.department_name
FROM employees a
   , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id
AND a.department_id =30;
/*
    1.조인이 있으면 조인 먼저 처리
    2.START WITH 절을 참조해 최상위 계층 로우를 선택
    3.CONNECT BY 절에 명시된 구문에 따라 계층형 관계 LEVEL 생성
    4.자식 로우 찾기가 끝나면 조인 조건을 제외한 검색 조건에 대한하는 로우를 걸러냄.
*/
-- 계층형 쿼리는 정렬조건을 넣으면 계층형 트리가 깨짐
-- SIBLINGS 넣어줘야함.
SELECT department_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
     , LEVEL  
FROM departments
START WITH parent_id IS NULL               
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- 계층형 쿼리에서 사용할 수 있는 함수
SELECT department_id
     , parent_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
      -- 루트 노드에서 시작해 current row 까지 정보 반환
     , SYS_CONNECT_BY_PATH(department_name,'|')  as 부서들
      -- 마지막 노드 1, 자식이 있으면 0
     , CONNECT_BY_ISLEAF 
     , CONNECT_BY_ROOT department_name as root_nm   -- 최상위
FROM departments
START WITH parent_id IS NULL      
CONNECT BY PRIOR department_id = parent_id;

-- 신규 부서가 생겼습니다.
-- 'IT' 밑에 'SNS팀'
-- IT 헬프 데스크 부서 밑에 '댓글부대'
-- 알맞게 데이터를 삽입해주세요
SELECT *
FROM departments;
INSERT INTO departments(
      department_id
    , department_name
    , parent_id)
VALUES(280,'SNS팀',60);
INSERT INTO departments(
      department_id
    , department_name
    , parent_id)
VALUES(290,'댓글부대',230);

--다음과 같이 출력되도록 데이터를 삽입 후 계층형 쿼리를 작성하시오
CREATE TABLE 팀(
       아이디 NUMBER
     , 이름   VARCHAR2(100)
     , 직책   VARCHAR2(100)
     , 상위아이디 NUMBER
);

SELECT *
FROM 팀;

INSERT INTO 팀 VALUES(10,'이사장', '사장',null);
INSERT INTO 팀 VALUES(20,'김부장', '부장',10);
INSERT INTO 팀 VALUES(30,'서차장', '차장',20);
INSERT INTO 팀 VALUES(40,'장과장', '과장',30);
INSERT INTO 팀 VALUES(50,'이대리', '대리',40);
INSERT INTO 팀 VALUES(60,'최사원', '사원',50);
INSERT INTO 팀 VALUES(70,'강사원', '사원',50);
INSERT INTO 팀 VALUES(80,'박과장', '과장',30);
INSERT INTO 팀 VALUES(90,'김대리', '대리',80);
INSERT INTO 팀 VALUES(100,'주사원', '사원',90);

SELECT 이름
     , LPAD(' ', 3*(LEVEL-1)) || 직책 as 직책
     , LEVEL
FROM 팀
START WITH 상위아이디 IS NULL
CONNECT BY PRIOR 아이디 = 상위아이디;


-- (top-down) 부모에서 자식으로 트리구성
SELECT department_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
     , LEVEL
FROM departments
START WITH parent_id IS NULL                
CONNECT BY PRIOR department_id = parent_id;

-- (bottom-up) 자식에서 부모로
SELECT department_id
     , parent_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
     , LEVEL
FROM departments
START WITH department_id = 290
CONNECT BY PRIOR parent_id = department_id;

-- 계층형쿼리 응용 CONNECT BY절과 LEVEL 사용 (샘플 데이터가 필요할때)
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 12;

-- 1 ~ 12월 출력
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL, 2, '0') as yy
FROM dual
CONNECT BY LEVEL <= 12;

SELECT 2013 || LPAD(LEVEL, 2, '0') as yy
FROM dual
CONNECT BY LEVEL <= 12;

SELECT period as yy
     , SUM(loan_jan_amt) 합계
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
ORDER BY 1;

SELECT a.yy
     , b.합계          
FROM(SELECT 2013 || LPAD(LEVEL, 2, '0') as yy
     FROM dual
     CONNECT BY LEVEL <= 12) a
    ,(SELECT period as yy
           , SUM(loan_jan_amt) 합계
      FROM kor_loan_status
      WHERE period LIKE '2013%'
      GROUP BY period
      ORDER BY 1
      ) b
WHERE a.yy = b.yy(+)
ORDER BY 1;

-- 마지막날 일자를 구하여 해당 행 만큼 생성
SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM')|| LPAD(LEVEL, 2, '0'))as DATES
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'dd');



-- study 계정
-- reservation 테이블의 reserv_date, cancel 컬럼을 활용하여
-- '금천'점의 모든 요일별 예약 건수를 출력하시오(취소건 제외)
SELECT TO_CHAR(TO_DATE(reserv_date),'day') as 요일
     , COUNT(TO_CHAR(TO_DATE(reserv_date),'day')) as 예약수
FROM reservation
WHERE BRANCH = '금천'
AND CANCEL = 'N'
GROUP BY TO_CHAR(TO_DATE(reserv_date),'day');

SELECT 요일, COUNT(요일) as 예약수
FROM(SELECT TO_CHAR(TO_DATE(reserv_date),'day') as 요일
     FROM reservation
     WHERE BRANCH = '금천'
     AND CANCEL = 'N') a, reservation b
GROUP BY 요일
WHERE a.요일 = b.reserv_date;