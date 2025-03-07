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
     , SUM(CASE WHEN i.product_name = 'SPECIAL_SET' THEN o.sales ELSE 0 END) as SPECIAL_SET,
       SUM(CASE WHEN i.product_name = 'PASTA' THEN o.sales ELSE 0 END) as PASTA,
       SUM(CASE WHEN i.product_name = 'PIZZA' THEN o.sales ELSE 0 END) as PIZZA,
       SUM(CASE WHEN i.product_name = 'SEA_FOOD' THEN o.sales ELSE 0 END) as SEA_FOOD,
       SUM(CASE WHEN i.product_name = 'STEAK' THEN o.sales ELSE 0 END) as STEAK,
       SUM(CASE WHEN i.product_name = 'SALAD_BAR' THEN o.sales ELSE 0 END) as SALAD_BAR,
       SUM(CASE WHEN i.product_name = 'SALAD' THEN o.sales ELSE 0 END) as SALAD,
       SUM(CASE WHEN i.product_name = 'SANDWICH' THEN o.sales ELSE 0 END) as SANDWICH,
       SUM(CASE WHEN i.product_name = 'WINE' THEN o.sales ELSE 0 END) as WINE,
       SUM(CASE WHEN i.product_name = 'JUICE' THEN o.sales ELSE 0 END) as JUICE
     
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
SELECT o.날짜
     , i.product_name as 상품명
     , SUM(CASE WHEN o.요일 = '일요일' THEN o.sales ELSE 0 END) as 일요일,
       SUM(CASE WHEN o.요일 = '월요일' THEN o.sales ELSE 0 END) as 월요일,
       SUM(CASE WHEN o.요일 = '화요일' THEN o.sales ELSE 0 END) as 화요일,
       SUM(CASE WHEN o.요일 = '수요일' THEN o.sales ELSE 0 END) as 수요일,
       SUM(CASE WHEN o.요일 = '목요일' THEN o.sales ELSE 0 END) as 목요일,
       SUM(CASE WHEN o.요일 = '금요일' THEN o.sales ELSE 0 END) as 금요일,
       SUM(CASE WHEN o.요일 = '토요일' THEN o.sales ELSE 0 END) as 토요일
       
FROM (SELECT *
      FROM item
      WHERE product_desc = '온라인_전용상품'
      ) i, 
      (SELECT a.*, TO_CHAR(a.예약일, 'YYYYMM') as 날짜, TO_CHAR(a.예약일, 'day') as 요일
       FROM(SELECT item_id, sales, TO_DATE(reserv_no,'YYMMDDSS') as 예약일
            FROM ORDER_INFO
            ) a
      ) o
WHERE i.item_id = o.item_id
GROUP BY o.날짜, i.product_name
ORDER BY 1;


---------- 9번 문제 ----------------------------------------------------
--'매출이력'이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------
SELECT a.address_detail as 주소
     , a.zip_code as 우편번호
     , COUNT(DISTINCT(c.customer_id)) as 고객수
FROM customer c, address a, reservation r
WHERE c.zip_code = a.zip_code
AND c.customer_id = r.customer_id
AND r.cancel = 'N'
GROUP BY a.address_detail, a.zip_code
ORDER BY 3 DESC, 2;


