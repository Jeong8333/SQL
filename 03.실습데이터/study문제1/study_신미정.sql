/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
*/
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
---------------------------------------------------------------------
SELECT *
FROM (SELECT *
      FROM customer
      WHERE SUBSTR(birth, 1, 4) >= 1988) a
WHERE job = '의사'
OR job = '자영업'
ORDER BY SUBSTR(a.birth, 1, 4) desc
       , job desc; 
SELECT SUBSTR(birth, 5, 6)
FROM customer;


-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
SELECT *
FROM customer;

SELECT *
FROM address;

SELECT c.customer_name, c.phone_number
FROM customer c, address a
WHERE c.zip_code = a.zip_code
AND a.address_detail = '강남구';


----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
SELECT job
     , count(customer_id) as 회원수
FROM customer
WHERE job IS NOT NULL
GROUP BY job
ORDER BY 회원수 desc;


----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------
SELECT 요일, 건수
FROM (SELECT TO_CHAR(first_reg_date, 'day') as 요일
           , COUNT(TO_CHAR(first_reg_date, 'day')) as 건수
      FROM customer
      GROUP BY TO_CHAR(first_reg_date, 'day')
      ORDER BY 건수 desc) a
WHERE ROWNUM <= 1;


----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
---------------------------------------------------------------------
SELECT DECODE(g, null, '합계', g) as gender
     , COUNT(g) as cnt 
FROM (SELECT DECODE(sex_code, 'F', '여자', 'M', '남자', null, '미등록') as g
      FROM customer
      ORDER BY g)
GROUP BY ROLLUP(g);


----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
---------------------------------------------------------------------
SELECT a.month as 월
     , count(a.month) as 취소건수
FROM (SELECT reserv_no, TO_CHAR(TO_DATE(reserv_date),'MM') as month
      FROM reservation) a, reservation r
WHERE a.reserv_no = r.reserv_no
AND r.cancel = 'Y'
GROUP BY a.month
ORDER BY 취소건수 desc;