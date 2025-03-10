-- �ּ� ctrl + /
/*
    ���� �ּ�
    ������ �� �ּ�ó����.
    �ּ� ������ ��ɾ ������ ���� ����.
*/
-- sqldeveloper���� ��ɾ�� �Ķ������� ǥ�õ�.
-- ��ɾ�� ��ҹ��ڸ� �������� ���� (�ĺ��� ���ؼ� ��ҹ��ڷ� �ۼ�)
-- ��ɾ�� ; �����ݷ����� ����

-- 11g ���� ������ ##�� �ٿ��� �ϴµ�
-- ���� ������� ������ ����� ���ؼ��� �Ʒ� ��ɾ� ���� �� ������ ��.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- ���� ���� ������:java, ���:oracle
CREATE USER java IDENTIFIED BY oracle;
-- ���� �ο�(����&���ҽ� ���� �� ����)
GRANT CONNECT, RESOURCE TO java;
-- ���̺� �����̽� ���� ����(�������� ���� ����)
GRANT UNLIMITED TABLESPACE TO java;
-- ��ɾ� ������ �����ݷ� �������� Ŀ�� ��ġ �� ctrl + enter or �����ư



-- java �������� ����
CREATE TABLE members(
     mem_id        VARCHAR2(10)
    ,mem_password  VARCHAR2(10)
    ,mem_name      VARCHAR2(10)
    ,mem_phone     CHAR(11)
    ,mem_email     VARCHAR2(100)
);
-- ������ ����
INSERT INTO members VALUES('a001', '1234', '�ؼ�', '01012345678', 'pangsu@gamil.com');
INSERT INTO members VALUES('a002', '1234', '����', '01112345678', 'dongsu@gamil.com');
-- ������ ��ȸ
SELECT *
FROM members;


delete members;

SELECT employee_id
    , emp_name
    , department_id
FROM employees;

SELECT *
FROM departments;
-- PK, FK �� Ȱ���Ͽ� �� ���̺��� ���踦 �ξ� �����͸� ������.
SELECT employees.employee_id        -- ���� ���̺��� PK
    , employees.department_id       -- ���� ���̺��� FK(�μ� ���̺� �μ���ȣ����)
    , employees.emp_name            
    , departments.department_id     -- �μ����̺��� PK
    , departments.department_name
FROM employees
    ,departments
WHERE employees.department_id = departments.department_id;

/* ��������
   ���̺��� �����ϱ� ���� ��Ģ
   NOT NULL ���� ������� �ʰڴ�
   UNIQUE �ߺ��� ������� �ʰڴ�
   CHECK Ư�� �����͸� �ްڴ�
   PRIMARY KEY �⺻Ű(�ϳ��� ���̺� 1���� ��������(n���� �÷��� �����ؼ� ��밡��)
                      �ϳ��� ���� �����ϴ� �ĺ��� or Ű�� or PK or �⺻Ű��� ��.
                      PK�� UNIQUE �ϸ� NOT NULL��)
   FOREIGN KEY �ܷ�Ű(����Ű, FK�� ��, �ٸ� ���̺��� PK�� �����ϴ� Ű)
*/
CREATE TABLE ex1_4(
    mem_id VARCHAR2(50)         PRIMARY KEY     -- �⺻Ű
  , mem_nm VARCHAR2(50)         NOT NULL        -- �� ������
  , mem_nickname VARCHAR2(100)  UNIQUE          -- �ߺ� ������
  , age NUMBER                                  -- 1~150
  , gender VARCHAR2(1)                          -- F or M
  , create_dt DATE DEFAULT SYSDATE              -- ����Ʈ�� ����
  , CONSTRAINT ck_ex_age CHECK(age BETWEEN 1 AND 150)
  , CONSTRAINT ck_ex_gender CHECK(gender IN('F','M'))
);
INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a001', '�ؼ�', '����', 10, 'M');

INSERT INTO ex1_4 (mem_id, mem_nm, mem_nickname, age, gender)
VALUES('a002', '����', '����', 10, 'M');    -- gender üũ �������� ����

SELECT *
FROM ex1_4;

SELECT *
FROM user_constraints
WHERE table_name = 'EX1_4';

delete TB_INFO;

CREATE TABLE TB_INFO(
    INFO_NO NUMBER(2) PRIMARY KEY
  , PC_NO VARCHAR2(10) UNIQUE NOT NULL
  , NM VARCHAR2(20) NOT NULL
  , EN_NM VARCHAR2(50) NOT NULL
  , EMAIL VARCHAR2(50) NOT NULL
  , HOBBY VARCHAR2(500) 
  , CREATE_DT DATE DEFAULT SYSDATE
  , UPDATE_DT DATE DEFAULT SYSDATE
);

    
SELECT *
FROM ex1_4;

-- ex1_4 ��ü���� ������Ʈ��
UPDATE ex1_4
SET age = 11;

-- a001 age ����
SELECT *
FROM ex1_4
WHERE mem_id = 'a001';

-- ������ üũ �� �����ϴ� ����!
UPDATE ex1_4
SET age = 11
WHERE mem_id = 'a001';
COMMIT;


-- hobby ����
SELECT *
FROM tb_info
WHERE info_no = '10';

UPDATE tb_info
SET hobby ='�������'
WHERE info_no = '10';
commit;
