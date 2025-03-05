/*
    WITHÀý (oracle 9ÀÌ»ó Áö¿ø)
    º°ÄªÀ¸·Î »ç¿ëÇÑ SELECT ¹®À» ´Ù¸¥ SELECT¹®¿¡¼­ ÂüÁ¶°¡ °¡´É
    ¹Ýº¹µÇ´Â Äõ¸®°¡ ÀÖ´Ù¸é È¿°úÀûÀÓ
    Åë°èÄõ¸®³ª Æ©´×ÇÒ ¶§ ¸¹ÀÌ »ç¿ë.
    1.temp¶ó´Â ÀÓ½Ã Å×ÀÌºíÀ» »ç¿ëÇØ¼­ Àå½Ã°£ °É¸®´Â Äõ¸®ÀÇ °á°ú¸¦ ÀúÀåÇØ ³õ°í
      ÀúÀåÇØ ³õÀº µ¥ÀÌÅÍ¸¦ ¿¢¼¼½ºÇÏ±â ¶§¹®¿¡ ¼º´ÉÀÌ ÁÁÀ» ¼ö ÀÖÀ½.
*/
-- °í°´º° ¸ÅÃâ
-- »óÇ°º° ¸ÅÃâ
-- ¿äÀÏº° ¸ÅÃâ µîµî Å½»öÇÒ ¶§ ÁÁÀ½

-- ºÎ¼­º° ºñÁß
-- ÀüÃ¼ ºñÁß Á¶È¸
WITH A as ( SELECT employee_id
                 , emp_name
                 , department_id
                 , job_id
                 , salary
            FROM employees
) , B as ( SELECT department_id
                , SUM(salary) as dep_sum
                , COUNT(department_id) as dep_cnt
            FROM a
            GROUP BY department_id
) , C as ( SELECT job_id
                , SUM(salary) as job_sum
                , COUNT(job_id) as job_cnt
           FROM a
           GROUP BY job_id
)
SELECT a.employee_id, a.emp_name, a.salary, b.dep_sum
     , ROUND(a.salary/b.dep_sum * 100, 2) as dep_ratio
     , dep_cnt, c.job_sum, c.job_cnt
FROM a, b, c
WHERE a.department_id = b.department_id
AND a.job_id = c.job_id;

-- kor_loan_status Å×ÀÌºíÀ» È°¿ëÇÏ¿© '¿¬µµº°' 'ÃÖÁ¾¿ù(¸¶Áö¸·¿ù)' ±âÁØ
-- °¡Àå ´ëÃâÀÌ ¸¹Àº µµ½Ã¿Í ÀÜ¾× Ãâ·Â
-- 1.¿¬µµº° ÃÖÁ¾ : 2011³âÀÇ ÃÖÁ¾¿ùÀº 12¿ùÀÌÁö¸¸ 2013³âÀº 11¿ùÀÓ. (¿¬µµº°°¡Àå Å« ¿ùÀ» ±¸ÇÔ)
-- 2.¿¬µµº° ÃÖÁ¾¿ùÀ» ´ë»óÀ¸·Î ´ëÃâÀÜ¾×ÀÌ °¡Àå Å« ±Ý¾×À» ±¸ÇÔ.    (1¹ø°ú Á¶ÀÎÇØ¼­ ¿¬µµº°·Î °¡Àå Å« ÀÜ¾×À» ±¸ÇÔ)
-- 3.¿ùº°, Áö¿ªº° ´ëÃâÀÜ¾×°ú 2ÀÇ °á°ú¸¦ ºñ±³ÇØ ±Ý¾×ÀÌ °°Àº °ÇÀ» Ãâ·Â

-- ÃÖÁ¾¿ù
SELECT MAX(period)
FROM kor_loan_status
GROUP BY substr(period, 1, 4);

-- ¿ùº°Áö¿ªº° ÀÜ¾×
SELECT period, region, SUM(loan_jan_amt) jan_amt
FROM kor_loan_status
GROUP BY period, region;

SELECT b.period
     , MAX(b.jan_amt) max_jan_amt
FROM (SELECT MAX(period) max_month
      FROM kor_loan_status
      GROUP BY substr(period, 1, 4)) a
    ,(SELECT period, region, SUM(loan_jan_amt) jan_amt
      FROM kor_loan_status
      GROUP BY period, region) b
WHERE a.max_month = b.period
GROUP BY b.period;

SELECT b2.*
FROM (SELECT period, region, SUM(loan_jan_amt) jan_amt
      FROM kor_loan_status
      GROUP BY period, region) b2
    ,(SELECT b.period
           , MAX(b.jan_amt) max_jan_amt
      FROM (SELECT MAX(period) max_month
            FROM kor_loan_status
            GROUP BY substr(period, 1, 4)) a
          ,(SELECT period, region, SUM(loan_jan_amt) jan_amt
            FROM kor_loan_status
            GROUP BY period, region) b
      WHERE a.max_month = b.period
      GROUP BY b.period) c
WHERE b2.period = c.period
AND b2.jan_amt = c.max_jan_amt;

-- WITHÀý
WITH b as (SELECT period, region, SUM(loan_jan_amt) as jan_amt
            FROM kor_loan_status
            GROUP BY period, region
), c as (SELECT b.period, MAX(b.jan_amt) as max_jan_amt
         FROM b,
              (SELECT MAX(period) as max_month
               FROM kor_loan_status
               GROUP BY substr(period, 1, 4)) a
         WHERE b.period = a.max_month
         GROUP BY b.period
)
SELECT b.*
FROM b, c
WHERE b.period = c.period
AND   b.jan_amt = c.max_jan_amt;


WITH a as (SELECT 'ÇÑ±Û' as texts FROM dual
           UNION
           SELECT 'ÇÑ±ÛABC' as texts FROM dual
           UNION
           SELECT 'ABC' as texts FROM dual)
SELECT *
FROM a
WHERE REGEXP_LIKE(texts, '^[°¡-ÆR]+$');


/*
    ºÐ¼®ÇÔ¼ö
    Å×ÀÌºí¿¡ ÀÖ´Â ·Î¿ì¿¡ ´ëÇØ Æ¯Á¤ ±×·ìº°·Î Áý°è °ªÀ» »êÃâÇÒ ¶§ »ç¿ë.
    Áý°è ÇÔ¼ö¿Í ´Ù¸¥Á¡Àº ·Î¿ì ¼Õ½Ç ¾øÀÌ Áý°è°ªÀ» »êÃâ ÇÒ ¼ö ÀÖÀ½.
    ºÐ¼®ÇÔ¼ö´Â ÀÚ¿øÀ» ¸¹ÀÌ ¼ÒºñÇÏ±â ¶§¹®¿¡ ¿©·¯ ºÐ¼®ÇÔ¼ö¸¦ µ¿½Ã¿¡ »ç¿ëÇÒ °æ¿ì(partition, order µ¿ÀÏÇÏ°Ô ÇÏ¸é ºü¸§)
    ÃÖ´ëÇÑ ¸ÞÀÎÄõ¸®¿¡¼­ »ç¿ë. ¼­ºêÄõ¸®¿¡¼­´Â »ç¿ëX
    
    ºÐ¼®ÇÔ¼ö(¸Å°³º¯¼ö) OVER(partition by expr1...
                            ORDER BY expr2...
                            WINDOW Àý...)
    Á¾·ù : AVG, SUM, MAX, COUNT, DENSE_RANK, RANK, ROW_NUMBER, OERXENT_RANK, LAG, LEAD..
    PARTITION BY : °è»ê ´ë»ó ±×·ì
    ORDER BY     : ´ë»ó ±×·ì¿¡ ´ëÇÑ Á¤·Ä
    WINDOW       : ÆÄÆ¼¼ÇÀ¸·Î ºÐÇÒµÈ ±×·ì¿¡ ´ëÇØ ´õ »ó¼¼ÇÑ ±×·ìÀ¸·Î ºÐÇÒ(³í¸®, Çà)
*/
-- Á÷¿øµéÀÇ ºÎ¼­º° salary ±âÁØ ³ôÀº ¼øÀ§ Ãâ·Â
SELECT emp_name, department_id, salary
     , RANK() OVER(PARTITION BY department_id
                   ORDER BY salary DESC) as rnk              -- µ¿ÀÏÇÑ °ªÀÌ ÀÖÀ» °æ¿ì 1,2,2,4
     , DENSE_RANK() OVER(PARTITION BY department_id
                         ORDER BY salary DESC) as dense_rnk  -- µ¿ÀÏÇÑ °ªÀÌ ÀÖÀ» °æ¿ì 1,2,2,3
     , ROW_NUMBER() OVER(PARTITION BY department_id
                         ORDER BY salary DESC) as runm       -- rownum »ý¼º
FROM employees;


SELECT department_id
     , emp_name
     , salary
     , SUM(salary) OVER(PARTITION BY department_id) as ºÎ¼­ÇÕ°è
     , ROUND(AVG(salary) OVER(PARTITION BY department_id),2) as ºÎ¼­Æò±Õ
     , MIN(salary) OVER(PARTITION BY department_id) as ºÎ¼­ÃÖ¼Ò
     , MAX(salary) OVER(PARTITION BY department_id) as ºÎ¼­ÃÖ´ë
     , COUNT(employee_id) OVER() as Á÷¿ø¼ö   -- OVER() : ÀüÃ¼ Áý°è
FROM employees
-- ORDER BY Àý ÇÊ¿äX
;

-- ºÎ¼­º° salary ³»¸²Â÷¼øÀ» ±âÁØÀ¸·Î ·©Å· 1À§¸¸ Ãâ·ÂÇÏ½Ã¿À

SELECT *
FROM (SELECT department_id
           , emp_name
           , salary
           , DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as dense_rank
     FROM employees)
WHERE dense_rank = 1;

-- È¸¿øº° Á÷¾÷º° ¸¶ÀÏ¸®Áö ¼øÀ§¸¦ Ãâ·ÂÇÏ½Ã¿À(member)
SELECT mem_name, mem_job, mem_mileage
     , RANK() OVER(PARTITION BY mem_job ORDER BY mem_mileage desc) as rank_num
FROM member;

-- LAG ¼±Çà·Î¿ìÀÇ °ªÀ» °¡Á®¿Í¼­ ¹ÝÈ¯ LAG(mem_name, 2, '°¡Àå³ôÀ½')  2 : 2´Ü°è ³ôÀº
-- LEAD ÈÄÇà·Î¿ìÀÇ °ªÀ» °¡Á®¿Í¼­ ¹ÝÈ¯
SELECT mem_name, mem_job, mem_mileage
     , LAG(mem_name, 1, '°¡Àå³ôÀ½') OVER (PARTITION BY mem_job
                                          ORDER BY mem_mileage DESC) lags
     , LEAD(mem_name, 1, '°¡Àå³·À½') OVER (PARTITION BY mem_job
                                          ORDER BY mem_mileage DESC) leads
FROM member;

-- ÇÐ»ýµéÀÇ Àü°øº° °¢ ÇÐ»ýÀÇ ÆòÁ¡ÀÌ ÇÑ´Ü°è ³ôÀº ÇÐ»ý°úÀÇ ÆòÁ¡ Â÷ÀÌ¸¦ Ãâ·ÂÇÏ½Ã¿À
SELECT ÀÌ¸§, Àü°ø, ÆòÁ¡
     , LAG(ÆòÁ¡, 1, ÆòÁ¡) OVER (PARTITION BY Àü°ø ORDER BY ÆòÁ¡ DESC) - ÆòÁ¡ as Â÷ÀÌ
     , LAG(ÀÌ¸§, 1, '1µî') OVER (PARTITION BY Àü°ø ORDER BY ÆòÁ¡ DESC) as ´ë»óÀÌ¸§
FROM ÇÐ»ý;


-- CART, PROD¸¦ È°¿ëÇÏ¿© ¹°Ç°º° ÆÇ¸Å PROD_PRICE ÇÕ°è ¼øÀ§¸¦ Ãâ·ÂÇÏ½Ã¿À(µ¿ÀÏ ¼øÀ§ °Ç³Ê¶Ü)
WITH a as (SELECT cart_prod, SUM(cart_qty) as sum_qty
           FROM cart
           GROUP BY cart_prod)
SELECT c.*
     , RANK() OVER( ORDER BY c.sum_sale desc) as rank_sale
FROM(SELECT b.prod_id as prod_id
          , b.prod_name
          , b.prod_price * a.sum_qty as sum_sale
      FROM a, PROD b
      WHERE a.cart_prod = b.prod_id) c;