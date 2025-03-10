/*
    행단위 집단 UNION, UNION ALL, MINUS, INTERSECT
    컬럼의 수와 타입 일치해야함. 정렬은 마지막에만.
*/

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '한국';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '일본';

-- UNION 중복 제거 후 결합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
UNION
SELECT '키보드'
FROM dual;

-- UNION ALL 중복 상관없이 결합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY 1;  -- 정렬 조건은 마지막에만 사용가능

-- MINUS 차집합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS  
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

-- INTERSECT 교집합
SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '일본';

SELECT gubun
     , SUM(loan_jan_amt) as 합
FROM kor_loan_status
GROUP BY ROLLUP(gubun);


SELECT gubun
     , SUM(loan_jan_amt) as 합
FROM kor_loan_status
GROUP BY gubun
UNION
SELECT '합계', SUM(loan_jan_amt)
FROM kor_loan_status;

/*
    1. 내부조인 INNER JOIN or 동등 조인 EQUI-JOIN이라함.
       WHERE 절에서 = 등호 연산자 사용하여 조인함.
       A와 B 테이블에 공통된 값을 가진 컬럼을 연결해 조인 조건이 True일 경우
       값이 같은 행을 추출
*/
SELECT *
FROM 학생, 수강내역
WHERE 학생.학번 = 수강내역.학번
AND 학생.이름 = '최숙경';

SELECT a.학번
     , a.이름
     , a.전공
     , b.수강내역번호
     , b.과목번호
     , b.취득학점
FROM 학생 a, 수강내역 b  --테이블 별칭
WHERE a.학번 = b.학번
AND a.이름 = '최숙경';

-- '최숙경'씨의 수강내역 건수를 출력하시오
SELECT a.이름
     , COUNT(b.수강내역번호) as 수강내역건수
FROM 학생 a, 수강내역 b  --테이블 별칭
WHERE a.학번 = b.학번
AND a.이름 = '최숙경'
GROUP BY a.학번, a.이름;

SELECT a.이름
     , a.학번
     , b.강의실
     , c.과목이름
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번
AND b. 과목번호 = c.과목번호
AND a.이름 = '최숙경';

-- 최숙경씨의 총 수강학점을 출력하세요
SELECT a.이름
     , a.학번
     , COUNT(b.수강내역번호) as 수강건수
     , SUM(c.학점) as 수강학점 
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번
AND b. 과목번호 = c.과목번호
AND a.이름 = '최숙경'
GROUP BY a.학번, a.이름;

-- 교수의 강의 이력건수를 출력하시오(정렬 : 강의건수 내림차순)
SELECT a.교수이름
     , COUNT(b.강의내역번호) as 강의건수
FROM 교수 a, 강의내역 b 
WHERE a.교수번호 = b.교수번호
GROUP BY a.교수번호, a.교수이름
ORDER BY 2 DESC;


/*
    2.외부조인 OUTER JOIN
      null 값의 데이터도 포함해야 할 때
      null 값이 포함될 테이블 조인문에 (+)기호 사용
      외부조인을 했다면 모든 테이블의 조건에 걸어줘야함.
*/
SELECT a.이름
     , a.학번
     , COUNT(b.수강내역번호) as 수강건수
FROM 학생 a, 수강내역 b
WHERE a.학번 = b.학번(+)
GROUP BY a.이름, a.학번;

SELECT a.이름
     , a.학번
     , b.수강내역번호
     , c.과목이름
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번(+)
AND b.과목번호 = c.과목번호(+);

SELECT a.이름
     , a.학번
     , COUNT(b.수강내역번호) as 수강건수
     , COUNT(*)
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번(+)
GROUP BY a.이름, a.학번;

-- 모든 교수의 강의건수를 출력하시오!
SELECT a.교수이름
     , COUNT(b.강의내역번호) as 강의건수
FROM 교수 a, 강의내역 b 
WHERE a.교수번호 = b.교수번호(+)
GROUP BY a.교수번호, a.교수이름
ORDER BY 2 DESC;

SELECT *
FROM member;

SELECT *
FROM cart;

SELECT a.mem_id
     , a.mem_name
     , COUNT(b.cart_no) as 카트이력
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
GROUP BY a.mem_id, a.mem_name;
-- 김은대씨의 상품 구매이력
SELECT a.mem_id
     , a.mem_name
     , b.cart_no as 카트이력
     , b.cart_prod
     , b.cart_qty
--     , c.* -- 해당 테이블 전체 컬럼
     , c.prod_name
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
AND a.mem_name = '김은대';

/*
    고객의 구매이력을 출력하시오
    사용자 아이디, 이름, 카트사용횟수, 상품품목, 전체상품구매수, 총구매금액
    member, cart, prod 테이블사용(구매 금액은  prod_price)로 사용
    정렬(카트사용횟수)
*/
SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT(b.cart_no)) as 카트사용횟수
     , COUNT(DISTINCT(c.prod_id)) as 상품품목수
     , NVL(SUM(b.cart_qty), 0) as 전체상품구매수
     , NVL(SUM(c.prod_price * b.cart_qty), 0) as 총구매금액
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = prod_id(+)
GROUP BY a.mem_id, a.mem_name
ORDER BY 3 desc;


SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT *
FROM member;


