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
SELECT o.매출월, o.sales, i.product_name
     , SUM(sales) OVER(PARTITION BY i.product_name,o.매출월 ORDER BY o.매출월
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM (SELECT item_id, sales, TO_CHAR(TO_DATE(reserv_no,'YYYYMMDDSS'),'YYYYMM') as 매출월
      FROM ORDER_INFO
      ) o, item i
WHERE i.item_id = o.item_id;

---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------


---------- 9번 문제 ----------------------------------------------------
--'매출이력'이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------
