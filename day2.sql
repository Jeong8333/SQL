/*
    table ���̺�
    1.���̺�� �÷����� �ִ� ũ��� 30byte (������ 1�� 1byte, �ѱ� 1�� 3byte)
    2.���̺�� �÷������� ������ ����� �� ����(select, varchar2...)
    3.���̺�� �÷������� ����, ����, -, #�� ����� �� ������
      ù ���ڴ� ���ڸ� �� �� ����.
    4.�� ���̺� ��� ������ �÷��� �ִ� 255��
    
    ��ɾ�� ��ҹ��ڸ� �������� ����. (����Ǵ� ���̺� ������ �빮�ڷ� �����.)
    �����ʹ� ��ҹ��ڸ� ������.
    
*/
CREATE TABLE ex1_1(
    col1 CHAR(10)
  , col2 VARCHAR2(10)  -- �÷��� ,�� ���еǸ� �ϳ��� �÷��� �ϳ��� Ÿ�԰� ����� ����
);
-- INSERT ������ ����
INSERT INTO ex1_1 (col1, col2)
VALUES('oracle', 'oracle');
INSERT INTO ex1_1 (col1, col2)
VALUES('����Ŭ', '����Ŭ');
INSERT INTO ex1_1 (col1, col2)
VALUES('����Ŭdb', '����Ŭdb');

SELECT *     -- * ��ü(�÷�)�� �ǹ���.
FROM ex1_1;

SELECT col1  -- ��ȸ�ϰ� ���� �÷� �ۼ�.
FROM ex1_1;

-- length() <- �Լ� ���ڿ� ����, lengthb() <- ���ڿ��� ũ��(byte)
SELECT col1, col2
        ,length(col1), length(col2), lengthb(col1), lengthb(col2)
FROM ex1_1;

SELECT *
FROM employees;  -- from ���� ��ȸ�ϰ��� �ϴ� ���̺� �ۼ�.
-- ���̺� ���� ������ȸ
DESC employees;

SELECT emp_name  as nm    -- AS, as (alias ��Ī)
    , hire_date  hd       -- �޸��� �������� �÷��� ���� ���� �ܾ�� ��Ī���� �ν�
    , salary     sa_la    -- ��Ī���� ����� �ȵ�(����� ���)
    , department_id  "�μ� ���̵�" -- �ѱ� ��Ī�� �Ⱦ����� ������ ""
FROM employees;

-- �˻����� where
SELECT * 
FROM employees
WHERE salary >= 20000;  -- 2�� �̻�
-- �˻� ���� ������ 10000 ~ 11000�̸鼭 �μ� ���̵� 80�� ������ȸ
SELECT *
FROM employees
WHERE salary >= 10000
AND salary < 11000  -- and �׸��� �ش� ������ �Ѵ� true�϶��� �ุ ��ȸ
AND department_id = 80
;
-- �������� ASC:��������(����Ʈ), DESC ��������
SELECT *
FROM employees
WHERE salary >= 10000
AND salary < 11000  -- and �׸��� �ش� ������ �Ѵ� true�϶��� �ุ ��ȸ
AND department_id = 80
ORDER BY emp_name   --����Ʈ ASC
;
-- ��Ģ���� ��밡��
SELECT emp_name             AS ����
    , salary                AS ����
    , salary - salary * 0.1 AS �Ǽ��ɾ�
    , salary * 12           AS ����
    , ROUND(salary/22.5, 2) AS �ϴ�
FROM employees;

/*
    ���� ������ Ÿ�� NUMBER
    number(p, s)  p�� �Ҽ����� �������� ��� ��ȿ���� �ڸ����� �ǹ���.
                  s�� �Ҽ��� �ڸ����� �ǹ���(����Ʈ 0)
                  s�� 2�� �Ҽ��� 2�ڸ�����(�������� �ݿø���)
                  s�� �����̸� �Ҽ��� �������� ���� �ڸ���ŭ �ݿø���.
*/
CREATE TABLE ex1_2(
      col1 NUMBER(3)     --������ 3�ڸ�
    , col2 NUMBER(3, 2)  --����1, �Ҽ��� 2�ڸ�����
    , col3 NUMBER(5, -2) --���� �ڸ����� �ݿø�(�� 7�ڸ�)
    , col4 NUMBER
);
INSERT INTO ex1_2(col) VALUES (0.789); 
INSERT INTO ex1_2(col) VALUES (99.6);
INSERT INTO ex1_2(col) VALUES (1004);  --����

INSERT INTO ex1_2(col2) VALUES (0.7898); 
INSERT INTO ex1_2(col2) VALUES (1.7898);
INSERT INTO ex1_2(col2) VALUES (9.9998);  --����
INSERT INTO ex1_2(col2) VALUES (10);      --����

INSERT INTO ex1_2(col3) VALUES (12345.2345); 
INSERT INTO ex1_2(col3) VALUES (1234569.2345);
INSERT INTO ex1_2(col3) VALUES (12345699.2345);  -- ���� 7�ڸ� ����

SELECT * FROM ex1_2;

/*  ��¥ ������ Ÿ��(date ����Ͻú���, timestamp ����Ͻú���.�и���)
    sysdate ����ð�, systimestamp ����ð�.�и���
*/
CREATE TABLE ex1_3(
      date1 DATE
    , date2 TIMESTAMP
);
INSERT INTO ex1_3 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_3;

--COMMIT;   -- ���������� �ݿ�
--ROLLBACK; -- �ǵ�����!