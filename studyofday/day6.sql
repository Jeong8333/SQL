-- 17002 오류 발생 시
-- lsnrctl status 상태 확인
-- lsnrctl start 실행

/*
    집계함수와 그룹바이
    집계함수 대상 데이터에 대해 총합, 평균, 최댓값, 최솟값 등을 구하는 함수
*/
SELECT COUNT(*)                       -- null 포함. 전체행 개수
     , COUNT(department_id)           -- default all
     , COUNT(ALL department_id)       -- 중복o, null x
     , COUNT(DISTINCT department_id)  -- 중복 x, null x
     , COUNT(employee_id)
FROM employees;

SELECT SUM(salary) as 합계
     , MAX(salary) as 최대
     , MIN(salary) as 최소
     , ROUND(AVG(salary),2) as 평균
FROM employees;  

-- 부서별 집계
SELECT department_id
     , SUM(salary) as 합계
     , MAX(salary) as 최대
     , MIN(salary) as 최소
     , ROUND(AVG(salary),2) as 평균
     , COUNT(employee_id)   as 직원수
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN (30,60,90)
GROUP BY department_id
ORDER BY 1;

-- 부서별, 직종별 집계
SELECT department_id
     , job_id
     , SUM(salary) as 합계
     , MAX(salary) as 최대
     , MIN(salary) as 최소
     , ROUND(AVG(salary),2) as 평균
     , COUNT(employee_id)   as 직원수
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN (30,60,90)
GROUP BY department_id, job_id
ORDER BY 직원수;

-- select문 실행 순서
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY

-- member의 회원수와 마일리지의 합계, 평균을 출력하시오
SELECT *
FROM member;

SELECT COUNT(mem_id) as 회원수
     , COUNT(*)      as 회원수2
     , SUM(mem_mileage) as 마일리지합계
     , ROUND(AVG(mem_mileage),2) as 마일리지평균
FROM member;

-- 직업별, 회원수, 마일리지 합계, 평균(마일리지평균 내림차순)
SELECT mem_job
     , COUNT(mem_id) as 회원수
     , SUM(mem_mileage) as 마일리지합계
     , ROUND(AVG(mem_mileage),2) as 마일리지평균
FROM member
GROUP BY mem_job
ORDER BY 마일리지평균 ASC;

-- 직업별 마일리지 평균이 3000이상인 회원의 직업과 회원수를 출력
SELECT mem_job
     , COUNT(mem_id) as 회원수
     , SUM(mem_mileage) as 마일리지합계
     , ROUND(AVG(mem_mileage),2) as 마일리지평균
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000   -- 집계결과에 대해서 검색조건 추가할때 사용
ORDER BY 마일리지평균 DESC;

-- kor_loan_status(java계정에 있음) 테이블의
-- 2013년도 기간별, 지역별 총 대출 단액을 출력하시오
SELECT *
FROM kor_loan_status;

SELECT SUBSTR(period,1,4) as 년도
     , region as 지역
     , SUM(loan_jan_amt) as 대출합
FROM kor_loan_status
WHERE  SUBSTR(period,1,4) = '2013'
GROUP BY SUBSTR(period,1,4), region;

-- 지역별 대출의 전체합계가 300000 이상인 지역을 출력하시오!
-- 대출잔액 내림차순
SELECT region as 지역
     , SUM(loan_jan_amt) as 대출합
FROM kor_loan_status
GROUP BY region
HAVING SUM(loan_jan_amt) >= 300000
ORDER BY 2 DESC;

-- 대전, 서울, 부산의 년도별 대출 합계에서
-- 대출의 합이 60000 넘는 결과를 출력하시오
-- 정렬 지역 오름차순, 대출합 내림차순
SELECT SUBSTR(period,1,4) as 년도
     , region as 지역
     , SUM(loan_jan_amt) as 대출합계
FROM kor_loan_status
--WHERE region = '대전' OR region = '서울' OR region = '부산'
WHERE region IN ('대전','서울','부산')
GROUP BY region, SUBSTR(period,1,4)
HAVING SUM(loan_jan_amt) >= 60000
ORDER BY region ASC, 대출합계 DESC;


-- GROUP BY ROLLUP
-- 지역별 대출의 합계
SELECT NVL(region,'총계')
     , SUM(loan_jan_amt) as 합계
FROM kor_loan_status
GROUP BY ROLLUP(region);

SELECT SUBSTR(period,1,4) as 년도
     , SUM(loan_jan_amt) as 합계
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period,1,4));

-- employees 직원들의 입사년도별 직원수를 출력하시오(정렬 입사년도 오름차순)
desc employees;
SELECT TO_CHAR(hire_date,'YYYY') as 년도
     , COUNT(employee_id) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY')
ORDER BY 년도;

-- employees 직원들의 입사한 날의 요일의 직원수를 출력하시오(정렬 일,월 ~> 토)
SELECT TO_CHAR(hire_date, 'day') as 요일
     , COUNT(*) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'day'), TO_CHAR(hire_date, 'd')
ORDER BY TO_CHAR(hire_date, 'd');

SELECT COUNT(DECODE(cust_gender,'F', '여')) as  여자
     , SUM(DECODE(cust_gender,'F', 1, 0)) as  여자2
     , COUNT(DECODE(cust_gender,'M', '남')) as  남자
     , COUNT(cust_gender) as 전체
FROM customers;























