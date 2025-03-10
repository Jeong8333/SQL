/*
    PL/SQL ���� & ������ ����� Ư¡�� ��� ������ ����
    DB���ο� ���巷�� �Ϲ� ���α׷��� ���� ����
    �Լ�, ���ν���, Ʈ����... �� ���� �� ����.
*/
SET SERVEROUTPUT ON;       
-- ��ũ��Ʈ�� ����Ϸ���

DECLARE             -- �͸���
    v_num NUMBER;   -- �����
BEGIN
    v_num := 100;   -- �����
    DBMS_OUTPUT.PUT_LINE(v_num);
END;


DECLARE
 emp_nm VARCHAR2(80);
 dep_nm departments.department_name%TYPE;   --���̺��� �÷� Ÿ��
BEGIN
 SELECT a.emp_name, b.department_name
  INTO emp_nm, dep_nm
 FROM employees a, departments b
 WHERE a.department_id = b.department_id
 AND a.employee_id = 100;
 DBMS_OUTPUT.PUT_LINE(emp_nm || ':' || dep_nm);
END;

-- �ܼ� ����
DECLARE
 dan NUMBER := 2;
 su  NUMBER := 1;
BEGIN
 LOOP
  DBMS_OUTPUT.PUT_LINE(dan || 'x' || su || '=' || dan*su);
  su := su+1;
  EXIT WHEN su > 9;  -- �ܼ� ������ ������ �ʿ�!(Ż������)
 END LOOP;
END;

DECLARE
 dan NUMBER := 2;
 su  NUMBER := 1;
BEGIN
 LOOP
  su := 1;
  DBMS_OUTPUT.PUT_LINE('========= ' || dan || '�� =========');
      LOOP
        DBMS_OUTPUT.PUT_LINE(dan || 'x' || su || '=' || dan*su);
        su := su+1;
        EXIT WHEN su > 9;  
      END LOOP;
  dan := dan+1;
  EXIT WHEN dan > 9;
 END LOOP;
END;


-- FOR ��
DECLARE
    dan NUMBER := 2;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i=5;   -- i=5�϶� �ǳʶ�
        DBMS_OUTPUT.PUT_LINE(dan || '*' || i || '=' || (dan*  i));
    END LOOP;
END;


-- mem_id�� �Է¹޾� ����� �����ϴ� �Լ�.
-- VIP :5000�̻�
-- GOLD :5000�̸� 3000�̻�
-- SILVER :������
-- INPUT VARCHAR2, OUTPUT VARCHAR2
CREATE OR REPLACE FUNCTION fn_grade(p_id VARCHAR2)
 RETURN VARCHAR2
IS
 m_mileage NUMBER;
 m_grade VARCHAR2(30);
BEGIN
 SELECT mem_mileage
  INTO m_mileage
 FROM member
 WHERE mem_id = p_id;
 IF m_mileage >= 5000 THEN m_grade := 'VIP';
 ELSIF m_mileage < 5000 AND m_mileage >= 3000 THEN m_grade := 'GOLD';
 ELSE m_grade := 'SILVER';
 END IF;
 RETURN m_grade;
END;

SELECT fn_grade(mem_id)
FROM member;


CREATE OR REPLACE PROCEDURE test_proc(p_v1 VARCHAR2, p_v2 OUT VARCHAR2, p_v3 IN OUT VARCHAR2)  -- IN OUT�� �������� �� �� �ִ�.

IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_v1:'|| p_v1);
    DBMS_OUTPUT.PUT_LINE('p_v2:'|| p_v2);
    DBMS_OUTPUT.PUT_LINE('p_v3:'|| p_v3);
    p_v2 := '����2';
    p_v3 := '����3';
END;

DECLARE
    p1 VARCHAR2(10) := '�Է�1';
    p2 VARCHAR2(10) := '�Է�2';
    p3 VARCHAR2(10) := '�Է�3';
BEGIN
    TEST_PROC(p1, p2, p3); -- ���ν��� ȣ��
    DBMS_OUTPUT.PUT_LINE(p2 || ',' ||p3);
END;

/*
    �й����� �Լ��� ������ּ���
    ���Ի��� ���Խ��ϴ�.
    �л����̺��� �й� �� ���� ū �й��� ���ڸ�(4�ڸ�)�� ���� �⵵��� +1
    �ƴ϶�� ���س⵵ +000001�� ��ȣ�� �������ּ���!
    ex) 2002110112 ->> ���� �ƴ� 2025000001
        2025000001 ->> ���� +1 : 2025000002
*/
CREATE OR REPLACE FUNCTION fn_make_haknum
 RETURN NUMBER
IS
 make_num NUMBER;
 this_year VARCHAR2(4) := TO_CHAR(SYSDATE,'YYYY');
BEGIN
 --1.���� ū �й� ��ȸ
 SELECT MAX(�й�)
  INTO make_num 
 FROM �л�;
 --2.���ؿ� ��
 --  ���ǿ� ���� ��ȣ ����
  IF SUBSTR(make_num,1,4) = this_year THEN make_num := make_num+1;
  ELSE make_num := this_year || '000001';
  END IF;
 RETURN make_num;
END;

SELECT fn_make_haknum
FROM dual;

INSERT INTO �л�(�̸�,�й�) VALUES('�ؼ�',fn_make_haknum);
INSERT INTO �л�(�̸�,�й�) VALUES('�ؼ�',fn_make_haknum);
SELECT *
FROM �л�;