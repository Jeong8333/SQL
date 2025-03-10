
-- delete ������ ���� (where �ʼ�!!)
DELETE ex1_4;  -- ��ü ����

DELETE ex1_4
WHERE mem_id = 'a001';  -- �ش� ������ true�� ���� ����
SELECT *
FROM ex1_4;

-- ���̺� ���� ALTER (update�� ���̺� �����͸� ����)

-- �÷� �̸� ����
ALTER TABLE ex1_4 RENAME COLUMN mem_nickname TO mem_nick;

-- ���̺� �̸� ����
ALTER TABLE ex1_4 RENAME TO mem;

-- �÷� ������ Ÿ�� ���� (����� �������� ����)
ALTER TABLE mem MODIFY (mem_nick VARCHAR2(500));

-- �������� ����
SELECT *
FROM user_constraints
WHERE table_name = 'MEM'; -- �ش� ���̺� �������� �̸� �˻�
ALTER TABLe mem DROP CONSTRAINT CK_EX_AGE;

-- �������� �߰�
ALTER TABLE mem ADD CONSTRAINT ck_ex_new_age CHECK(age BETWEEN 1 AND 150);
-- �÷� �߰�
ALTER TABLE mem ADD (new_en_nm VARCHAR2(100));
-- �÷� ����
ALTER TABLE mem DROP COLUMN new_en_nm;

DESC mem;

-- TB_INFO�� MBTI �÷� �߰�
ALTER TABLE TB_INFO ADD (MBTI VARCHAR2(20));

DESC TB_INFO;


-- FK �ܷ�Ű
CREATE TABLE dep(
      deptno NUMBER(3) PRIMARY KEY
    , dept_nm VARCHAR2(20)
    , dep_floor NUMBER(4)
);
CREATE TABLE emp(
      empno NUMBER(5) PRIMARY KEY
    , emp_nm VARCHAR2(20)
    , title  VARCHAR2(20)
    -- ���� �ϰ����ϴ� �÷��� Ÿ�� ��ġ�ؾ���(���� �޶� ��)
    -- refernces ������ ���̺�(�÷���)
    -- ���� ���̺�, �÷��� �����ؾ���(PK�̸鼭)
    -- ������ ���� �����ϱ� ���ؼ� �������� ���� ���� ���� ���� �������� ������ ��.
    , dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno)
);
INSERT INTO dep VALUES(1, '����', 8);
INSERT INTO dep VALUES(2, '��ȹ', 9);
INSERT INTO dep VALUES(3, '����', 10);
INSERT INTO emp VALUES(100, '�ؼ�', '�븮', 2);
INSERT INTO emp VALUES(200, '����', '����', 3);
INSERT INTO emp VALUES(300, '�浿', '����', 4); -- ������(�������̺� �μ��� '4'�� �������� ����)

SELECT *
FROM dep;

SELECT emp.empno
     , emp.emp_nm
     , emp.title
     , dep.dept_nm || '�μ�(' || dep.dep_floor ||'��)'as �μ�   -- || : ���ڿ� ���ϱ�
FROM emp, dep
WHERE emp.dno = dep.deptno
AND emp.emp_nm ='����';


-- �����ϰ� �ִ� ���̺��� ������� �����ʹ� ���� �� ��.
DELETE dep
WHERE deptno = 3;
-- ���1.�������� ������ ���� �� ����
DELETE emp
WHERE empno = 200;

-- ���2.�������� �����ϰ� ����
DELETE dep;
DROP TABLE emp CASCADE CONSTRAINTS;  -- �������� �����ϰ� ���̺� ����


SELECT employee_id
     , emp_name
     , job_id
     , manager_id
     , department_id
FROM employees;


-- ���̺� �ڸ�Ʈ
COMMENT ON TABLE tb_info IS 'tech9';
-- �÷� �ڸ�Ʈ
COMMENT ON COLUMN tb_info.info_no IS '�⼮��ȣ';
COMMENT ON COLUMN tb_info.pc_no IS '�¼���ȣ';
COMMENT ON COLUMN tb_info.nm IS '�̸�';
COMMENT ON COLUMN tb_info.en_nm IS '������';
COMMENT ON COLUMN tb_info.email IS '�̸���';
COMMENT ON COLUMN tb_info.hobby IS '���';
COMMENT ON COLUMN tb_info.create_dt IS '������';
COMMENT ON COLUMN tb_info.update_dt IS '������';
COMMENT ON COLUMN tb_info.mbti IS '���������˻�';
-- ������ȸ
SELECT *
FROM all_tab_comments
WHERE comments = 'tech9';

SELECT *
FROM user_col_comments
WHERE comments = '���������˻�';



-- (1) member ���� �����
    -- user id : member, pw : member
    -- ���Ѻο� : ���� & ���̺����
    
    -- system �������� ���Ѻο�
    ALTER SESSION SET "_ORACLE_SCRIPT"=true;
    CREATE USER member IDENTIFIED BY member;
    GRANT CONNECT, RESOURCE TO member;
    GRANT UNLIMITED TABLESPACE TO member;
-- (2) �ش� �������� ����
    -- !!! java �������� (3)�� �������� ������!!!
-- (3) member_table(utf-8).sql���� �����Ͽ� ���̺� ���� �� ������ ����)
    SELECT *
    FROM member
    WHERE mem_id = 'a001';