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
SELECT o.�����, sum(o.sales), i.product_name
FROM (SELECT item_id, sales, TO_CHAR(TO_DATE(reserv_no,'YYYYMMDDSS'),'YYYYMM') as �����
      FROM ORDER_INFO 
      ) o, item i
WHERE i.item_id = o.item_id
GROUP BY o.�����, i.product_name;




---------- 8�� ���� ---------------------------------------------------
-- ���� �¶���_���� ��ǰ ������� �Ͽ��Ϻ��� �����ϱ��� ������ ����Ͻÿ� 
-- ��¥, ��ǰ��, �Ͽ���, ������, ȭ����, ������, �����, �ݿ���, ������� ������ ���Ͻÿ� 
----------------------------------------------------------------------------
WITH o as (SELECT item_id, sales, TO_DATE(reserv_no,'YYMMDDSS') as ������
           FROM ORDER_INFO 
          )
SELECT o.��¥
     , i.product_name as ��ǰ��
     , sum(o.sales)
     , o.����
FROM (SELECT *
      FROM item
      WHERE product_desc = '�¶���_�����ǰ'
      ) i, 
      (SELECT d.*, TO_CHAR(d.������, 'YYYYMM') as ��¥, TO_CHAR(d.������, 'day') as ����
        FROM(SELECT item_id, sales, TO_DATE(reserv_no,'YYMMDDSS') as ������
     FROM ORDER_INFO) d
      ) o
WHERE i.item_id = o.item_id
GROUP BY o.��¥, i.product_name, o.����;


---------- 9�� ���� ----------------------------------------------------
--'�����̷�'�� �ִ� ���� �ּ�, �����ȣ, �ش����� ������ ����Ͻÿ�
----------------------------------------------------------------------------
