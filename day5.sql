-- ���� ���� TRIM, LTRIM, RTRIM
SELECT LTRIM(' ABC ') as l
     , RTRIM(' ABC ') as r
     , TRIM(' ABC ') as al
FROM dual;

-- ���ڿ� �е�(LPAD, RPAD)
SELECT LPAD(123, 5, '0')    as lp1  --LPAD(���, ����, �е�) ���̸�ŭ ä��
     , LPAD(1,   5, '0')    as lp2  
     , LPAD(123456, 5, '0') as lp3  -- ���� ���� ��ŭ(�Ѿ�� ���ŵ�)
     , RPAD(2, 5, '*')      as rp1  -- R�� �����ʺ���
FROM dual;

-- REPLACE(���, ã��, ����) ��Ȯ�ϰ� ��Ī
-- TRANSLATE �ѱ��ھ� ��Ī
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as re
     , TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as tr
FROM dual;

-- INSTR ���ڿ� ��ġ ã�� (p1, p2, p3, p4) p1:����ڿ�, p2:ã�� ���ڿ�, p3:����, p4:��°
SELECT INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�')        as ins1 --����Ʈ 1,1
     , INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�', 5)     as ins2
     , INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�', 1, 2)  as ins3
     , INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', 'hello')     as ins4 -- ������ 0
FROM dual;

-- tb_info �л��� �̸��� �ּҸ�(id,domain���� �и��Ͽ� ����Ͻÿ�)
-- pangsu@gamil.com ->> id:pangsu, domain:gamil.com
SELECT NM
     , email
     , SUBSTR(email, 1, INSTR(email, '@') - 1) as ���̵�
     , SUBSTR(email, INSTR(email, '@') + 1)    as ������
FROM tb_info;

/*  ��ȯ�Լ�(Ÿ��) ���� �����.
    TO_CHAR ����������
    TO_DATE ��¥
    TO_NUMBER ����~
*/
SELECT TO_CHAR(123456, '999,999,999') as ex1
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD') as ex2
     , TO_CHAR(SYSDATE, 'YYYYMMDD')   as ex3
     , TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as ex4
     , TO_CHAR(SYSDATE, 'YYYY/MM/DD HH12:MI:SS') as ex5
     , TO_CHAR(SYSDATE, 'day')                   as ex6   -- ����
     , TO_CHAR(SYSDATE, 'YY')                    as ex7
     , TO_CHAR(SYSDATE, 'dd')                    as ex8
     , TO_CHAR(SYSDATE, 'd')                     as ex9   -- ����(�Ͽ���:1)
FROM dual;

SELECT TO_DATE('231229', 'YYMMDD')                             as ex1
     , TO_DATE('2025 01 21 09:10:00', 'YYYY MM DD HH24:MI:SS') as ex2
     , TO_DATE('45', 'YY')                                     as ex3
     , TO_DATE('50', 'RR')                                     as ex4
     , TO_DATE('49', 'RR')  -- Y2K 2000�� ������ ���� ����å���� ���Ե�. 50 -> 1950, 49 -> 2049
FROM dual;

CREATE TABLE ex5_1 (
      seq1 VARCHAR2(100)
    , seq2 NUMBER
);
INSERT INTO ex5_1 VALUES('1234','1234');
INSERT INTO ex5_1 VALUES('99','99');
INSERT INTO ex5_1 VALUES('195','195');
SELECT *
FROM ex5_1
ORDER BY seq1 ASC;   -- �������� ���� seq2�� NUMBER ���·� ������������ ���ĵ�����,
                     -- seq1�� ���ڿ� ���·� 1�� �������� 9�� Ŀ���� ���������� ��
SELECT *
FROM ex5_1
ORDER BY TO_NUMBER(seq1) ASC;

CREATE TABLE ex5_2(
      title VARCHAR2(100)
    , d_day DATE
);
INSERT INTO ex5_2 VALUES('������', '20250121');
INSERT INTO ex5_2 VALUES('������', '2025.07.09');

SELECT *
FROM ex5_2;
INSERT INTO ex5_2 VALUES('ź�ұ���', '2025 02 24');
INSERT INTO ex5_2 VALUES('���Ư��', '2025 03 31 10:00:00'); -- ������
INSERT INTO ex5_2 VALUES('���Ư��', TO_DATE('2025 03 31 10:00:00','YYYY MM DD HH24:MI:SS'));

-- ȸ���� ��������� �̿��Ͽ� ���̸� ����ϼ���
-- ���� �⵵�̿�( ex 2025-2000) 25��
-- ������ ���� ��������
SELECT MEM_NAME
     , MEM_BIR
     , TO_CHAR(SYSDATE, 'YYYY')-TO_CHAR(mem_bir,'YYYY') || '��' as AGE
FROM member
ORDER BY MEM_BIR DESC;

/*  ��¥ ������ ���� �Լ�
    ADD_MONTHS(��¥, 1) ���� ��
    LAST_DAY(��¥) �ش� ���� ������ ��
    NEXT_DAY(��¥, '����') ����� �̷��� �ش� ������ ��¥
*/
SELECT ADD_MONTHS(SYSDATE, 1)  as ex1    -- ������
     , ADD_MONTHS(SYSDATE, -1) as ex2    -- �� ��
     , LAST_DAY(SYSDATE)       as ex3
     , NEXT_DAY(SYSDATE, '�ݿ���') as ex4
     , NEXT_DAY(SYSDATE, '�����') as ex5
     , SYSDATE - 1                 as ex6  -- ����
     , ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE, -1) as ex7
FROM dual;

SELECT SYSDATE - MEM_BIR
     , SYSDATE sy
     , MEM_BIR
     -- �ܼ� ���ڰ��
     , TO_CHAR(SYSDATE, 'YYYYMMDD') - TO_CHAR(MEM_BIR, 'YYYYMMDD') as ex1
     -- ��¥ ���
     , TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) - TO_DATE(TO_CHAR(MEM_BIR,'YYYYMMDD')) as ex2 
FROM member;

-- �̹� ���� ���� ���������?
SELECT TO_DATE(TO_CHAR(LAST_DAY(SYSDATE), 'YYYYMMDD')) - TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) as �̹���
FROM dual;

SELECT LAST_DAY(SYSDATE) - SYSDATE as �̹���
FROM dual;

-- 20250709���� �󸶳� ���������?
SELECT TO_DATE('20250709') - TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) as �����ϱ���
FROM dual;

-- DECODE ǥ���� Ư�� ���϶� ǥ������ (��Ȯ�� �� ��, ��ġ)
SELECT cust_id
     , cust_name
     , cust_gender
      -- cust_gender�� M�̸�(true) ����, �׹ۿ��� ����
     , DECODE(cust_gender, 'M', '����', '����') as gender
     , DECODE(cust_gender, 'M', '����', 'F', '����', '!?!') as gender
FROM customers;

-- DISTINCT (�ߺ� ����)
-- �ߺ��� �����͸� �����ϰ� ������ ���� ��ȯ
SELECT DISTINCT prod_category
FROM products;
-- �� ������ �ߺ����� �ʴ� �� ��ȯ
SELECT DISTINCT prod_category, prod_subcategory
FROM products
ORDER BY 1;

-- NVL(�÷�, ��ȯ��) �÷� ���� null�� ��� ��ȯ�� ����
SELECT emp_name
     , salary
     , commission_pct
     , salary + salary * commission_pct         as �󿩱�����1
     , salary + salary * NVL(commission_pct, 0) as �󿩱�����2
FROM employees;


/*
    1.employees ���� �� �ټӳ���� 26�� �̻��� ������ ����Ͻÿ�! (�ټӳ�� ��������)
*/
SELECT emp_name
     , hire_date
     , TO_CHAR(SYSDATE, 'YYYY')-TO_CHAR(hire_date,'YYYY') as �ټӳ��
FROM employees
WHERE TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - TO_NUMBER(TO_CHAR(hire_date,'YYYY')) >= 26
ORDER BY �ټӳ�� DESC, hire_date ASC;


/*
    2.customers ���� ���̸� �������� 30��, 40��, 50�븦 �����Ͽ� ���(������ ���ɴ�� '��Ÿ')
        ����(���� ��������), �˻�����(1.����:Achen, 2.����⵵:1960~1990�� �������, 3.��ȥ����:single, 4.����:����)
*/
SELECT cust_name
     , cust_year_of_birth
     , TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth) as ����
     , CASE WHEN TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth) >= 30
        AND TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth) < 40 THEN '30��'
        WHEN TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth) >= 40
        AND TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth) < 50 THEN '40��'
        WHEN TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth) >= 50
        AND TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth) < 60 THEN '50��'
        ELSE '��Ÿ'
        END as ���ɴ�
FROM customers
WHERE cust_city = 'Aachen'
AND cust_year_of_birth >= 1960
AND cust_year_of_birth <= 1990
AND cust_marital_status = 'single'
AND cust_gender = 'M'
ORDER BY ���ɴ�;

SELECT cust_name
     , TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth as ����
     , DECODE(TRUNC((TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth) / 10), 3, '30��'
                                                                         , 4, '40��'
                                                                         , 5, '50��'
                                                                         , '��Ÿ') as ����
FROM customers
WHERE cust_city = 'Aachen'
AND cust_gender = 'M'
AND cust_marital_status = 'single'
AND cust_year_of_birth BETWEEN 1960 AND 1990
ORDER BY cust_year_of_birth DESC;







