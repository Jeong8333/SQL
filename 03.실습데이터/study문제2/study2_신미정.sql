----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------
SELECT i.product_name as 상품이름
     , SUM(o.sales) as 상품매출
FROM item i, order_info o
WHERE i.item_id = o.item_id
GROUP BY i.product_name
ORDER BY 2 DESC;

---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------
SELECT o.매출월
     , SUM(CASE WHEN i.product_name = 'SPECIAL_SET' THEN o.sales ELSE 0 END) AS SPECIAL_SET,
       SUM(CASE WHEN i.product_name = 'PASTA' THEN o.sales ELSE 0 END) AS PASTA,
       SUM(CASE WHEN i.product_name = 'PIZZA' THEN o.sales ELSE 0 END) AS PIZZA,
       SUM(CASE WHEN i.product_name = 'SEA_FOOD' THEN o.sales ELSE 0 END) AS SEA_FOOD,
       SUM(CASE WHEN i.product_name = 'STEAK' THEN o.sales ELSE 0 END) AS STEAK,
       SUM(CASE WHEN i.product_name = 'SALAD_BAR' THEN o.sales ELSE 0 END) AS SALAD_BAR,
       SUM(CASE WHEN i.product_name = 'SALAD' THEN o.sales ELSE 0 END) AS SALAD,
       SUM(CASE WHEN i.product_name = 'SANDWICH' THEN o.sales ELSE 0 END) AS SANDWICH,
       SUM(CASE WHEN i.product_name = 'WINE' THEN o.sales ELSE 0 END) AS WINE,
       SUM(CASE WHEN i.product_name = 'JUICE' THEN o.sales ELSE 0 END) AS JUICE
     
FROM (SELECT item_id, sales, TO_CHAR(TO_DATE(reserv_no,'YYYYMMDDSS'),'YYYYMM') as 매출월
      FROM ORDER_INFO 
      ) o, item i
WHERE i.item_id = o.item_id
GROUP BY o.매출월
ORDER BY 1;




---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------
WITH o as (SELECT item_id, sales, TO_DATE(reserv_no,'YYMMDDSS') as 예약일
           FROM ORDER_INFO 
          )
SELECT o.날짜
     , i.product_name as 상품명
     , sum(o.sales)
     , o.요일
FROM (SELECT *
      FROM item
      WHERE product_desc = '온라인_전용상품'
      ) i, 
      (SELECT d.*, TO_CHAR(d.예약일, 'YYYYMM') as 날짜, TO_CHAR(d.예약일, 'day') as 요일
        FROM(SELECT item_id, sales, TO_DATE(reserv_no,'YYMMDDSS') as 예약일
     FROM ORDER_INFO) d
      ) o
WHERE i.item_id = o.item_id
GROUP BY o.날짜, i.product_name, o.요일
ORDER BY 1;


---------- 9번 문제 ----------------------------------------------------
--'매출이력'이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------
SELECT *
FROM customer;
SELECT *
FROM address;
SELECT *
FROM reservation;

SELECT a.address_detail, COUNT(a.zip_code)
FROM customer c, address a, reservation r
WHERE c.zip_code = a.zip_code
AND c.customer_id = r.customer_id
AND r.cancel = 'N'
GROUP BY a.address_detail
ORDER BY 2 DESC;