/*
 STUDY ������ create_table ��ũ��Ʈ�� �����Ͽ� 
 ���̺� ������ 1~ 5 �����͸� ����Ʈ�� �� 
 �Ʒ� ������ ����Ͻÿ� 
 (������ ���� ��¹��� �̹��� ����)
*/
-----------1�� ���� ---------------------------------------------------
--1988�� ���� ������� ������ �ǻ�,�ڿ��� ���� ����Ͻÿ� (� ������ ���)
---------------------------------------------------------------------
SELECT *
FROM (SELECT *
      FROM customer
      WHERE SUBSTR(birth, 1, 4) >= 1988) a
WHERE job = '�ǻ�'
OR job = '�ڿ���'
ORDER BY SUBSTR(a.birth, 1, 4) desc
       , job desc; 
SELECT SUBSTR(birth, 5, 6)
FROM customer;


-----------2�� ���� ---------------------------------------------------
--�������� ��� ���� �̸�, ��ȭ��ȣ�� ����Ͻÿ� 
---------------------------------------------------------------------
SELECT *
FROM customer;

SELECT *
FROM address;

SELECT c.customer_name, c.phone_number
FROM customer c, address a
WHERE c.zip_code = a.zip_code
AND a.address_detail = '������';


----------3�� ���� ---------------------------------------------------
--CUSTOMER�� �ִ� ȸ���� ������ ȸ���� ���� ����Ͻÿ� (���� NULL�� ����)
---------------------------------------------------------------------
SELECT job
     , count(customer_id) as ȸ����
FROM customer
WHERE job IS NOT NULL
GROUP BY job
ORDER BY ȸ���� desc;


----------4-1�� ���� ---------------------------------------------------
-- ���� ���� ����(ó�����)�� ���ϰ� �Ǽ��� ����Ͻÿ� 
---------------------------------------------------------------------
SELECT ����, �Ǽ�
FROM (SELECT TO_CHAR(first_reg_date, 'day') as ����
           , COUNT(TO_CHAR(first_reg_date, 'day')) as �Ǽ�
      FROM customer
      GROUP BY TO_CHAR(first_reg_date, 'day')
      ORDER BY �Ǽ� desc) a
WHERE ROWNUM <= 1;


----------4-2�� ���� ---------------------------------------------------
-- ���� �ο����� ����Ͻÿ� 
---------------------------------------------------------------------
SELECT DECODE(g, null, '�հ�', g) as gender
     , COUNT(g) as cnt 
FROM (SELECT DECODE(sex_code, 'F', '����', 'M', '����', null, '�̵��') as g
      FROM customer
      ORDER BY g)
GROUP BY ROLLUP(g);


----------5�� ���� ---------------------------------------------------
--���� ���� ��� �Ǽ��� ����Ͻÿ� (���� �� ���� ���)
---------------------------------------------------------------------
SELECT a.month as ��
     , count(a.month) as ��ҰǼ�
FROM (SELECT reserv_no, TO_CHAR(TO_DATE(reserv_date),'MM') as month
      FROM reservation) a, reservation r
WHERE a.reserv_no = r.reserv_no
AND r.cancel = 'Y'
GROUP BY a.month
ORDER BY ��ҰǼ� desc;