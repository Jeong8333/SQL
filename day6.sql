-- 17002 ���� �߻� ��
-- lsnrctl status ���� Ȯ��
-- lsnrctl start ����

/*
    �����Լ��� �׷����
    �����Լ� ��� �����Ϳ� ���� ����, ���, �ִ�, �ּڰ� ���� ���ϴ� �Լ�
*/
SELECT COUNT(*)                       -- null ����. ��ü�� ����
     , COUNT(department_id)           -- default all
     , COUNT(ALL department_id)       -- �ߺ�o, null x
     , COUNT(DISTINCT department_id)  -- �ߺ� x, null x
     , COUNT(employee_id)
FROM employees;

SELECT SUM(salary) as �հ�
     , MAX(salary) as �ִ�
     , MIN(salary) as �ּ�
     , ROUND(AVG(salary),2) as ���
FROM employees;  

-- �μ��� ����
SELECT department_id
     , SUM(salary) as �հ�
     , MAX(salary) as �ִ�
     , MIN(salary) as �ּ�
     , ROUND(AVG(salary),2) as ���
     , COUNT(employee_id)   as ������
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN (30,60,90)
GROUP BY department_id
ORDER BY 1;

-- �μ���, ������ ����
SELECT department_id
     , job_id
     , SUM(salary) as �հ�
     , MAX(salary) as �ִ�
     , MIN(salary) as �ּ�
     , ROUND(AVG(salary),2) as ���
     , COUNT(employee_id)   as ������
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN (30,60,90)
GROUP BY department_id, job_id
ORDER BY ������;

-- select�� ���� ����
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY

-- member�� ȸ������ ���ϸ����� �հ�, ����� ����Ͻÿ�
SELECT *
FROM member;

SELECT COUNT(mem_id) as ȸ����
     , COUNT(*)      as ȸ����2
     , SUM(mem_mileage) as ���ϸ����հ�
     , ROUND(AVG(mem_mileage),2) as ���ϸ������
FROM member;

-- ������, ȸ����, ���ϸ��� �հ�, ���(���ϸ������ ��������)
SELECT mem_job
     , COUNT(mem_id) as ȸ����
     , SUM(mem_mileage) as ���ϸ����հ�
     , ROUND(AVG(mem_mileage),2) as ���ϸ������
FROM member
GROUP BY mem_job
ORDER BY ���ϸ������ ASC;

-- ������ ���ϸ��� ����� 3000�̻��� ȸ���� ������ ȸ������ ���
SELECT mem_job
     , COUNT(mem_id) as ȸ����
     , SUM(mem_mileage) as ���ϸ����հ�
     , ROUND(AVG(mem_mileage),2) as ���ϸ������
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000   -- �������� ���ؼ� �˻����� �߰��Ҷ� ���
ORDER BY ���ϸ������ DESC;

-- kor_loan_status(java������ ����) ���̺���
-- 2013�⵵ �Ⱓ��, ������ �� ���� �ܾ��� ����Ͻÿ�
SELECT *
FROM kor_loan_status;

SELECT SUBSTR(period,1,4) as �⵵
     , region as ����
     , SUM(loan_jan_amt) as ������
FROM kor_loan_status
WHERE  SUBSTR(period,1,4) = '2013'
GROUP BY SUBSTR(period,1,4), region;

-- ������ ������ ��ü�հ谡 300000 �̻��� ������ ����Ͻÿ�!
-- �����ܾ� ��������
SELECT region as ����
     , SUM(loan_jan_amt) as ������
FROM kor_loan_status
GROUP BY region
HAVING SUM(loan_jan_amt) >= 300000
ORDER BY 2 DESC;

-- ����, ����, �λ��� �⵵�� ���� �հ迡��
-- ������ ���� 60000 �Ѵ� ����� ����Ͻÿ�
-- ���� ���� ��������, ������ ��������
SELECT SUBSTR(period,1,4) as �⵵
     , region as ����
     , SUM(loan_jan_amt) as �����հ�
FROM kor_loan_status
--WHERE region = '����' OR region = '����' OR region = '�λ�'
WHERE region IN ('����','����','�λ�')
GROUP BY region, SUBSTR(period,1,4)
HAVING SUM(loan_jan_amt) >= 60000
ORDER BY region ASC, �����հ� DESC;


-- GROUP BY ROLLUP
-- ������ ������ �հ�
SELECT NVL(region,'�Ѱ�')
     , SUM(loan_jan_amt) as �հ�
FROM kor_loan_status
GROUP BY ROLLUP(region);

SELECT SUBSTR(period,1,4) as �⵵
     , SUM(loan_jan_amt) as �հ�
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period,1,4));

-- employees �������� �Ի�⵵�� �������� ����Ͻÿ�(���� �Ի�⵵ ��������)
desc employees;
SELECT TO_CHAR(hire_date,'YYYY') as �⵵
     , COUNT(employee_id) as ������
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY')
ORDER BY �⵵;

-- employees �������� �Ի��� ���� ������ �������� ����Ͻÿ�(���� ��,�� ~> ��)
SELECT TO_CHAR(hire_date, 'day') as ����
     , COUNT(*) as ������
FROM employees
GROUP BY TO_CHAR(hire_date, 'day'), TO_CHAR(hire_date, 'd')
ORDER BY TO_CHAR(hire_date, 'd');

SELECT COUNT(DECODE(cust_gender,'F', '��')) as  ����
     , SUM(DECODE(cust_gender,'F', 1, 0)) as  ����2
     , COUNT(DECODE(cust_gender,'M', '��')) as  ����
     , COUNT(cust_gender) as ��ü
FROM customers;























