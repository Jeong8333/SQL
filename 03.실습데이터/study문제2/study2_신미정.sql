----------6�� ���� ---------------------------------------------------
 -- ��ü ��ǰ�� '��ǰ�̸�', '��ǰ����' �� ������������ ���Ͻÿ� 
-----------------------------------------------------------------------------
SELECT i.product_name as ��ǰ�̸�
     , SUM(o.sales) as ��ǰ����
FROM item i, order_info o
WHERE i.item_id = o.item_id
GROUP BY i.product_name
ORDER BY 2 DESC;

---------- 7�� ���� ---------------------------------------------------
-- ����ǰ�� ���� ������� ���Ͻÿ� 
-- �����, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------
SELECT o.�����
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
     
FROM (SELECT item_id, sales, TO_CHAR(TO_DATE(reserv_no,'YYYYMMDDSS'),'YYYYMM') as �����
      FROM ORDER_INFO 
      ) o, item i
WHERE i.item_id = o.item_id
GROUP BY o.�����
ORDER BY 1;

---------- 8�� ���� ---------------------------------------------------
-- ���� �¶���_���� ��ǰ ������� �Ͽ��Ϻ��� �����ϱ��� ������ ����Ͻÿ� 
-- ��¥, ��ǰ��, �Ͽ���, ������, ȭ����, ������, �����, �ݿ���, ������� ������ ���Ͻÿ� 
----------------------------------------------------------------------------
SELECT o.��¥
     , i.product_name as ��ǰ��
     , SUM(CASE WHEN o.���� = '�Ͽ���' THEN o.sales ELSE 0 END) as �Ͽ���,
       SUM(CASE WHEN o.���� = '������' THEN o.sales ELSE 0 END) as ������,
       SUM(CASE WHEN o.���� = 'ȭ����' THEN o.sales ELSE 0 END) as ȭ����,
       SUM(CASE WHEN o.���� = '������' THEN o.sales ELSE 0 END) as ������,
       SUM(CASE WHEN o.���� = '�����' THEN o.sales ELSE 0 END) as �����,
       SUM(CASE WHEN o.���� = '�ݿ���' THEN o.sales ELSE 0 END) as �ݿ���,
       SUM(CASE WHEN o.���� = '�����' THEN o.sales ELSE 0 END) as �����
       
FROM (SELECT *
      FROM item
      WHERE product_desc = '�¶���_�����ǰ'
      ) i, 
      (SELECT a.*, TO_CHAR(a.������, 'YYYYMM') as ��¥, TO_CHAR(a.������, 'day') as ����
       FROM(SELECT item_id, sales, TO_DATE(reserv_no,'YYMMDDSS') as ������
            FROM ORDER_INFO
            ) a
      ) o
WHERE i.item_id = o.item_id
GROUP BY o.��¥, i.product_name
ORDER BY 1;


---------- 9�� ���� ----------------------------------------------------
--'�����̷�'�� �ִ� ���� �ּ�, �����ȣ, �ش����� ������ ����Ͻÿ�
----------------------------------------------------------------------------
SELECT a.address_detail as �ּ�
     , a.zip_code as �����ȣ
     , COUNT(DISTINCT(c.customer_id)) as ����
FROM customer c, address a, reservation r
WHERE c.zip_code = a.zip_code
AND c.customer_id = r.customer_id
AND r.cancel = 'N'
GROUP BY a.address_detail, a.zip_code
ORDER BY 3 DESC, 2;


