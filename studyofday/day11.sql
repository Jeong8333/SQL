SELECT department_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
     , LEVEL  -- ����-���μ� Ʈ�� ������ � �ܰ迡 �ִ��� ��Ÿ���� ������
FROM departments
START WITH parent_id IS NULL                -- �ش� ���� �ο���� ����
CONNECT BY PRIOR department_id = parent_id; -- ���� ������ � ������ ����Ǵ���
--        ���� �μ����� parent_id�� ã����

-- �����ڿ� ����
SELECT a.employee_id
     , LPAD(' ', 3 * (LEVEL-1)) || a.emp_name as emp_nm
     , LEVEL
     , b.department_name
FROM employees a
   , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id = a.manager_id
AND a.department_id =30;
/*
    1.������ ������ ���� ���� ó��
    2.START WITH ���� ������ �ֻ��� ���� �ο츦 ����
    3.CONNECT BY ���� ��õ� ������ ���� ������ ���� LEVEL ����
    4.�ڽ� �ο� ã�Ⱑ ������ ���� ������ ������ �˻� ���ǿ� �����ϴ� �ο츦 �ɷ���.
*/
-- ������ ������ ���������� ������ ������ Ʈ���� ����
-- SIBLINGS �־������.
SELECT department_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
     , LEVEL  
FROM departments
START WITH parent_id IS NULL               
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;

-- ������ �������� ����� �� �ִ� �Լ�
SELECT department_id
     , parent_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
      -- ��Ʈ ��忡�� ������ current row ���� ���� ��ȯ
     , SYS_CONNECT_BY_PATH(department_name,'|')  as �μ���
      -- ������ ��� 1, �ڽ��� ������ 0
     , CONNECT_BY_ISLEAF 
     , CONNECT_BY_ROOT department_name as root_nm   -- �ֻ���
FROM departments
START WITH parent_id IS NULL      
CONNECT BY PRIOR department_id = parent_id;

-- �ű� �μ��� ������ϴ�.
-- 'IT' �ؿ� 'SNS��'
-- IT ���� ����ũ �μ� �ؿ� '��ۺδ�'
-- �˸°� �����͸� �������ּ���
SELECT *
FROM departments;
INSERT INTO departments(
      department_id
    , department_name
    , parent_id)
VALUES(280,'SNS��',60);
INSERT INTO departments(
      department_id
    , department_name
    , parent_id)
VALUES(290,'��ۺδ�',230);

--������ ���� ��µǵ��� �����͸� ���� �� ������ ������ �ۼ��Ͻÿ�
CREATE TABLE ��(
       ���̵� NUMBER
     , �̸�   VARCHAR2(100)
     , ��å   VARCHAR2(100)
     , �������̵� NUMBER
);

SELECT *
FROM ��;

INSERT INTO �� VALUES(10,'�̻���', '����',null);
INSERT INTO �� VALUES(20,'�����', '����',10);
INSERT INTO �� VALUES(30,'������', '����',20);
INSERT INTO �� VALUES(40,'�����', '����',30);
INSERT INTO �� VALUES(50,'�̴븮', '�븮',40);
INSERT INTO �� VALUES(60,'�ֻ��', '���',50);
INSERT INTO �� VALUES(70,'�����', '���',50);
INSERT INTO �� VALUES(80,'�ڰ���', '����',30);
INSERT INTO �� VALUES(90,'��븮', '�븮',80);
INSERT INTO �� VALUES(100,'�ֻ��', '���',90);

SELECT �̸�
     , LPAD(' ', 3*(LEVEL-1)) || ��å as ��å
     , LEVEL
FROM ��
START WITH �������̵� IS NULL
CONNECT BY PRIOR ���̵� = �������̵�;


-- (top-down) �θ𿡼� �ڽ����� Ʈ������
SELECT department_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
     , LEVEL
FROM departments
START WITH parent_id IS NULL                
CONNECT BY PRIOR department_id = parent_id;

-- (bottom-up) �ڽĿ��� �θ��
SELECT department_id
     , parent_id
     , LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
     , LEVEL
FROM departments
START WITH department_id = 290
CONNECT BY PRIOR parent_id = department_id;

-- ���������� ���� CONNECT BY���� LEVEL ��� (���� �����Ͱ� �ʿ��Ҷ�)
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 12;

-- 1 ~ 12�� ���
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL, 2, '0') as yy
FROM dual
CONNECT BY LEVEL <= 12;

SELECT 2013 || LPAD(LEVEL, 2, '0') as yy
FROM dual
CONNECT BY LEVEL <= 12;

SELECT period as yy
     , SUM(loan_jan_amt) �հ�
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period
ORDER BY 1;

SELECT a.yy
     , b.�հ�          
FROM(SELECT 2013 || LPAD(LEVEL, 2, '0') as yy
     FROM dual
     CONNECT BY LEVEL <= 12) a
    ,(SELECT period as yy
           , SUM(loan_jan_amt) �հ�
      FROM kor_loan_status
      WHERE period LIKE '2013%'
      GROUP BY period
      ORDER BY 1
      ) b
WHERE a.yy = b.yy(+)
ORDER BY 1;

-- �������� ���ڸ� ���Ͽ� �ش� �� ��ŭ ����
SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM')|| LPAD(LEVEL, 2, '0'))as DATES
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'dd');



-- study ����
-- reservation ���̺��� reserv_date, cancel �÷��� Ȱ���Ͽ�
-- '��õ'���� ��� ���Ϻ� ���� �Ǽ��� ����Ͻÿ�(��Ұ� ����)
SELECT TO_CHAR(TO_DATE(reserv_date),'day') as ����
     , COUNT(TO_CHAR(TO_DATE(reserv_date),'day')) as �����
FROM reservation
WHERE BRANCH = '��õ'
AND CANCEL = 'N'
GROUP BY TO_CHAR(TO_DATE(reserv_date),'day');

SELECT ����, COUNT(����) as �����
FROM(SELECT TO_CHAR(TO_DATE(reserv_date),'day') as ����
     FROM reservation
     WHERE BRANCH = '��õ'
     AND CANCEL = 'N') a, reservation b
GROUP BY ����
WHERE a.���� = b.reserv_date;