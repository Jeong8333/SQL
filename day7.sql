/*
    ����� ���� UNION, UNION ALL, MINUS, INTERSECT
    �÷��� ���� Ÿ�� ��ġ�ؾ���. ������ ����������.
*/

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�ѱ�';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�Ϻ�';

-- UNION �ߺ� ���� �� ����
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
UNION
SELECT 'Ű����'
FROM dual;

-- UNION ALL �ߺ� ������� ����
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
ORDER BY 1;  -- ���� ������ ���������� ��밡��

-- MINUS ������
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
MINUS  
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

-- INTERSECT ������
SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT gubun
     , SUM(loan_jan_amt) as ��
FROM kor_loan_status
GROUP BY ROLLUP(gubun);


SELECT gubun
     , SUM(loan_jan_amt) as ��
FROM kor_loan_status
GROUP BY gubun
UNION
SELECT '�հ�', SUM(loan_jan_amt)
FROM kor_loan_status;

/*
    1. �������� INNER JOIN or ���� ���� EQUI-JOIN�̶���.
       WHERE ������ = ��ȣ ������ ����Ͽ� ������.
       A�� B ���̺� ����� ���� ���� �÷��� ������ ���� ������ True�� ���
       ���� ���� ���� ����
*/
SELECT *
FROM �л�, ��������
WHERE �л�.�й� = ��������.�й�
AND �л�.�̸� = '�ּ���';

SELECT a.�й�
     , a.�̸�
     , a.����
     , b.����������ȣ
     , b.�����ȣ
     , b.�������
FROM �л� a, �������� b  --���̺� ��Ī
WHERE a.�й� = b.�й�
AND a.�̸� = '�ּ���';

-- '�ּ���'���� �������� �Ǽ��� ����Ͻÿ�
SELECT a.�̸�
     , COUNT(b.����������ȣ) as ���������Ǽ�
FROM �л� a, �������� b  --���̺� ��Ī
WHERE a.�й� = b.�й�
AND a.�̸� = '�ּ���'
GROUP BY a.�й�, a.�̸�;

SELECT a.�̸�
     , a.�й�
     , b.���ǽ�
     , c.�����̸�
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�
AND b. �����ȣ = c.�����ȣ
AND a.�̸� = '�ּ���';

-- �ּ��澾�� �� ���������� ����ϼ���
SELECT a.�̸�
     , a.�й�
     , COUNT(b.����������ȣ) as �����Ǽ�
     , SUM(c.����) as �������� 
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�
AND b. �����ȣ = c.�����ȣ
AND a.�̸� = '�ּ���'
GROUP BY a.�й�, a.�̸�;

-- ������ ���� �̷°Ǽ��� ����Ͻÿ�(���� : ���ǰǼ� ��������)
SELECT a.�����̸�
     , COUNT(b.���ǳ�����ȣ) as ���ǰǼ�
FROM ���� a, ���ǳ��� b 
WHERE a.������ȣ = b.������ȣ
GROUP BY a.������ȣ, a.�����̸�
ORDER BY 2 DESC;


/*
    2.�ܺ����� OUTER JOIN
      null ���� �����͵� �����ؾ� �� ��
      null ���� ���Ե� ���̺� ���ι��� (+)��ȣ ���
      �ܺ������� �ߴٸ� ��� ���̺��� ���ǿ� �ɾ������.
*/
SELECT a.�̸�
     , a.�й�
     , COUNT(b.����������ȣ) as �����Ǽ�
FROM �л� a, �������� b
WHERE a.�й� = b.�й�(+)
GROUP BY a.�̸�, a.�й�;

SELECT a.�̸�
     , a.�й�
     , b.����������ȣ
     , c.�����̸�
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�(+)
AND b.�����ȣ = c.�����ȣ(+);

SELECT a.�̸�
     , a.�й�
     , COUNT(b.����������ȣ) as �����Ǽ�
     , COUNT(*)
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�(+)
GROUP BY a.�̸�, a.�й�;

-- ��� ������ ���ǰǼ��� ����Ͻÿ�!
SELECT a.�����̸�
     , COUNT(b.���ǳ�����ȣ) as ���ǰǼ�
FROM ���� a, ���ǳ��� b 
WHERE a.������ȣ = b.������ȣ(+)
GROUP BY a.������ȣ, a.�����̸�
ORDER BY 2 DESC;

SELECT *
FROM member;

SELECT *
FROM cart;

SELECT a.mem_id
     , a.mem_name
     , COUNT(b.cart_no) as īƮ�̷�
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
GROUP BY a.mem_id, a.mem_name;
-- �����뾾�� ��ǰ �����̷�
SELECT a.mem_id
     , a.mem_name
     , b.cart_no as īƮ�̷�
     , b.cart_prod
     , b.cart_qty
--     , c.* -- �ش� ���̺� ��ü �÷�
     , c.prod_name
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
AND a.mem_name = '������';

/*
    ���� �����̷��� ����Ͻÿ�
    ����� ���̵�, �̸�, īƮ���Ƚ��, ��ǰǰ��, ��ü��ǰ���ż�, �ѱ��űݾ�
    member, cart, prod ���̺���(���� �ݾ���  prod_price)�� ���
    ����(īƮ���Ƚ��)
*/
SELECT a.mem_id
     , a.mem_name
     , COUNT(DISTINCT(b.cart_no)) as īƮ���Ƚ��
     , COUNT(DISTINCT(c.prod_id)) as ��ǰǰ���
     , NVL(SUM(b.cart_qty), 0) as ��ü��ǰ���ż�
     , NVL(SUM(c.prod_price * b.cart_qty), 0) as �ѱ��űݾ�
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


