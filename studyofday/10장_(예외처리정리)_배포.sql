-- �ý��� ����
DECLARE
 v_num NUMBER := 0;
BEGIN
 v_num := 10/0;
 DBMS_OUTPUT.PUT_LINE('����ó��');
EXCEPTION WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('�����߻�!');
 DBMS_OUTPUT.PUT_LINE(SQLCODE);
 DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

DECLARE
 v_num NUMBER := 0;
BEGIN
 v_num := 10/0;
 DBMS_OUTPUT.PUT_LINE('����ó��');
EXCEPTION WHEN NO_DATA_FOUND THEN
             DBMS_OUTPUT.PUT_LINE('�����͸� ã�� �� ����');
          WHEN ZERO_DIVIDE THEN
             DBMS_OUTPUT.PUT_LINE('���� zero divide');   
          WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE('�����߻�!');
             DBMS_OUTPUT.PUT_LINE(SQLCODE);
             DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;



/*
-------------------------------------------------------------------------------------------------------------------------------------
 1.����� ���� ����
-------------------------------------------------------------------------------------------------------------------------------------
   �ý��� ���� �̿ܿ� ����ڰ� ���� ���ܸ� ���� 
   �����ڰ� ���� ���ܸ� �����ϴ� ���.
-------------------------------------------------------------------------------------------------------------------------------------
[1] ����� ���� ���ǹ�� 
 (1) ���� ���� : �����_����_���ܸ� EXCEPTION;
 (2) ���ܹ߻���Ű�� : RAISE �����_����_���ܸ�;
                    �ý��� ���ܴ� �ش� ���ܰ� �ڵ����� ���� ������, ����� ���� ���ܴ� ���� ���ܸ� �߻����Ѿ� �Ѵ�.
                  RAISE ���ܸ� ���·� ����Ѵ�.
 (3) �߻��� ���� ó�� : EXCEPTION WHEN �����_����_���ܸ� THEN ..
*/
    CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                      p_emp_name       employees.emp_name%TYPE,
                      p_department_id  departments.department_id%TYPE )
    IS
       vn_employee_id  employees.employee_id%TYPE;
       vd_curr_date    DATE := SYSDATE;
       vn_cnt          NUMBER := 0;
       ex_invalid_depid EXCEPTION; -- (1) �߸��� �μ���ȣ�� ��� ���� ����
    BEGIN
	     -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	     SELECT COUNT(*)
	       INTO vn_cnt
	       FROM departments
	      WHERE department_id = p_department_id;
	     IF vn_cnt = 0 THEN
	        RAISE ex_invalid_depid; -- (2) ����� ���� ���� �߻�
	     END IF;
	     -- employee_id�� max ���� +1
	     SELECT MAX(employee_id) + 1
	       INTO vn_employee_id
	       FROM employees; 
	     -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
                  VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
       COMMIT;        
          
    EXCEPTION WHEN ex_invalid_depid THEN --(3) ����� ���� ���� ó������ 
                   DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
              WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);              
    END;                	

EXEC ch10_ins_emp_proc ('ȫ�浿', 999);     -- ���� �μ� ����� ���� ����ó����.
EXEC ch10_ins_emp_proc ('ȫ�浿', 20);      -- �ִ� �μ� ����ó���Ǿ� ������ �����.



/*
--[2]�ý��� ���ܿ� �̸� �ο��ϱ�----------------------------------------------------------------------------------------------
 �ý��� ���ܿ��� ZERO_DIVIDE, INVALID_NUMBER .... �Ͱ��� ���ǵ� ���ܰ� �ִ� ������ �̵�ó�� ���ܸ��� �ο��� ���� 
 �ý��� ���� �� �ؼҼ��̰� �������� �����ڵ常 �����Ѵ�. �̸��� ���� �ڵ忡 �̸� �ο��ϱ�.

	1.����� ���� ���� ���� 
	2.����� ���� ���ܸ�� �ý��� ���� �ڵ� ���� (PRAGMA EXCEPTION_INIT(����� ���� ���ܸ�, �ý���_����_�ڵ�)

		/*
		   PRAGMA �����Ϸ��� ����Ǳ� ���� ó���ϴ� ��ó���� ���� 
		   PRAGMA EXCEPTION_INIT(���ܸ�, ���ܹ�ȣ)
		   ����� ���� ���� ó���� �� �� ���Ǵ°����� 
		   Ư�� ���ܹ�ȣ�� ����ؼ� �����Ϸ��� �� ���ܸ� ����Ѵٴ� ���� �˸��� ���� 
		   (�ش� ���ܹ�ȣ�� �ش�Ǵ� �ý��� ������ �߻�) 
		*/
	3.�߻��� ���� ó��:EXCEPTION WHEN ����� ���� ���ܸ� THEN ....
*/

CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
   ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- ���ܸ�� �����ڵ� ����
BEGIN
	 -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	 WHERE department_id = p_department_id;
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- ����� ���� ���� �߻�
	 END IF;
	 -- �Ի�� üũ (1~12�� ������ ������� üũ)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- ����� ���� ���� �߻�
	 END IF;
	 -- employee_id�� max ���� +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
   COMMIT;              
EXCEPTION WHEN ex_invalid_depid THEN -- ����� ���� ���� ó��
               DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
          WHEN ex_invalid_month THEN -- �Ի�� ����� ���� ����
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12�� ������ ��� ���Դϴ�');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    
EXEC ch10_ins_emp_proc ('ȫ�浿', 110, '201314');
/*
 [3].����� ���ܸ� �ý��� ���ܿ� ���ǵ� ���ܸ��� ���----------------------------------------------------------------------------------------------
      RAISE ����� ���� ���� �߻��� 
      ����Ŭ���� ���� �Ǿ� �ִ� ���ܸ� �߻� ��ų�� �ִ�. 
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('����� �Է¹��� �� �ֽ��ϴ�');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);

/*
[4].���ܸ� �߻���ų �� �ִ� ���� ���ν��� ----------------------------------------------------------------------------------------------
  RAISE_APPLICATOIN_ERROR(�����ڵ�, ���� �޼���);
  ���� �ڵ�� �޼����� ����ڰ� ���� ����  -20000 ~ -20999 ������ �� ��밡�� 
   �ֳĸ� ����Ŭ���� �̹� ����ϰ� �ִ� ���ܵ��� �� ��ȣ ������ ������� �ʰ� �ֱ� ������)
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE_APPLICATION_ERROR (-20000, '����� �Է¹��� �� �ִ� ���Դϴ�!');
	END IF;  
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);
