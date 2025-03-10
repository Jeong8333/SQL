
/*
  Ʈ����� Transaction '�ŷ�'
  ���࿡�� �Աݰ� ����� �ϴ� �� �ŷ��� ���ϴ� �ܾ�� 
  ���α׷��� �� ����Ŭ���� ���ϴ� Ʈ����ǵ� �� ���信�� �����Ѱ� 

  A ���� (��� �Ͽ� �۱�) -> B ���� 
  �۱� �߿� ������ �߻� 
  A ���� ���¿��� ���� ���������� 
  B ���� ���¿� �Աݵ��� ����.

  ������ �ľ��Ͽ� A���� ��� ��� or ��ݵ� ��ŭ B �������� �ٽ� �۱�
  but � �������� �ľ��Ͽ� ó���ϱ⿡�� ���� �������� �ִ�. 

  �׷��� ���� �ذ�å -> �ŷ��� ���������� ��� ���� �Ŀ��� �̸� ������ �ŷ��� ����, 
                 �ŷ� ���� ���� ������ �߻����� ���� �� �ŷ��� ó������ ������ �ŷ��� �ǵ�����. 

  �ŷ��� �������� Ȯ���ϴ� ����� �ٷ� Ʈ�����
*/


-- COMMIT �� ROLLBACK

CREATE TABLE ch10_sales (
       sales_month   VARCHAR2(8),
       country_name  VARCHAR2(40),
       prod_category VARCHAR2(50),
       channel_desc  VARCHAR2(20),
       sales_amt     NUMBER );
       
-- (1) commit ���� ------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month ch10_sales.sales_month%TYPE )
IS

BEGIN
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH = p_sales_month
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;

 COMMIT;
-- ROLLBACK;

END;            

EXEC iud_ch10_sales_proc ( '199901');



-- sqlplus �����Ͽ� ��ȸ 
-- �Ǽ��� 0
SELECT COUNT(*)
FROM ch10_sales ;

TRUNCATE TABLE ch10_sales;

-- (2) ���� ������ �� ----------------------------------------------------------------------------------------------


ALTER TABLE ch10_sales ADD CONSTRAINTS pk_ch10_sales PRIMARY KEY (sales_month, country_name, prod_category, channel_desc);
-- �������� ���� �� �׽�Ʈ 

CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month ch10_sales.sales_month%TYPE )
IS

BEGIN
	
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)	   
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH = p_sales_month
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;

 -- �� ó���ǰ� ������ ������ Ŀ�� 
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK;

END;   


---------------------------------------------------------------------------------------------------------------------
-- ����ó�� ���� ����
CREATE TABLE error_log(
     error_seq NUMBER
    ,prog_name VARCHAR2(80)
    ,error_code NUMBER
    ,error_message VARCHAR2(300)
    ,error_line VARCHAR2(100)
    ,error_date DATE DEFAULT SYSDATE
);

-- ������
CREATE SEQUENCE error_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999
NOCYCLE
NOCACHE;

-- ���� ����
CREATE OR REPLACE PROCEDURE error_log_proc(
     p_name     error_log.prog_name%TYPE
    ,p_code     error_log.error_code%TYPE
    ,p_message  error_log.error_message%TYPE
    ,p_line     error_log.error_line%TYPE
)
IS
BEGIN
    INSERT INTO error_log(error_seq, prog_name, error_code, error_message, error_line)
    VALUES(error_seq.NEXTVAL, p_name, p_code, p_message, p_line);
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE ch10_ins_emp2_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month     VARCHAR2 )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   
   ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
   PRAGMA EXCEPTION_INIT ( ex_invalid_depid, -20000); -- ���ܸ�� �����ڵ� ����

   ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
   PRAGMA EXCEPTION_INIT ( ex_invalid_month, -1843); -- ���ܸ�� �����ڵ� ����
   
   v_err_code error_log.error_code%TYPE;
   v_err_msg  error_log.error_message%TYPE;
   v_err_line error_log.error_line%TYPE;
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
               v_err_code := SQLCODE;
               v_err_msg  := '�ش� �μ��� �����ϴ�';
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN ex_invalid_month THEN -- �Ի�� ����� ���� ���� ó��
               v_err_code := SQLCODE;
               v_err_msg  := SQLERRM;
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN OTHERS THEN
               v_err_code := SQLCODE;
               v_err_msg  := SQLERRM;
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;  
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line);        	
END;

-- �߸��� �μ�
EXEC ch10_ins_emp2_proc ('HONG', 1000, '201401'); 
-- �߸��� ��
EXEC ch10_ins_emp2_proc ('HONG', 100 , '201413');


SELECT *
FROM  error_log ;

delete error_log;
commit;

/*
    SAVEPOINT 
    ���� ROLLBACK�� ����ϸ� INSERT, DELETE, UPDATE, MERGE 
    �۾� ��ü�� ��ҵǴµ� ��ü�� �ƴ� Ư�� �κп��� Ʈ������� ��ҽ�ų �� �ִ�. 
    �̷��� �Ϸ��� ����Ϸ��� ������ ����� ��, �� �������� �۾��� ����ϴ� 
    ������ ����ϴµ� �� ������ SAVEPOINT��� �Ѵ�. 
*/
CREATE TABLE ex_save(
     ex_no NUMBER
    ,ex_nm VARCHAR2(100)
);
CREATE OR REPLACE PROCEDURE save_porc(flag VARCHAR2)
IS
    point1 EXCEPTION;
    point2 EXCEPTION;
    v_num  NUMBER;
BEGIN
    INSERT INTO ex_save VALUES(1, 'POINT1 BEFORE');
    SAVEPOINT mysavepoint1;
    INSERT INTO ex_save VALUES(2, 'POINT1 AFTER');
    INSERT INTO ex_save VALUES(3, 'POINT1 BEFORE');
    SAVEPOINT mysavepoint2;
    INSERT INTO ex_save VALUES(4, 'POINT2 AFTER');
    IF flag = '1' THEN
        RAISE point1;
    ELSIF flag = '2' THEN
        RAISE point2;
    ELSIF flag = '3' THEN
        v_num := 10/0;
    END IF;
    COMMIT;
 EXCEPTION WHEN point1 THEN
        ROLLBACK TO mysavepoint1;
        COMMIT;
    WHEN point2 THEN
        ROLLBACK TO mysavepoint2;
        COMMIT;
    WHEN OTHERS THEN
        ROLLBACK;
END;

EXEC save_porc('1');  -- ���̺� ����Ʈ 1���� �ѹ� �� Ŀ��
EXEC save_porc('2');  -- ���̺� ����Ʈ 2���� �ѹ� �� Ŀ��
EXEC save_porc('3');  -- �� �ѹ�
EXEC save_porc('4');  -- ���� ó���Ǿ� �� ����� �� Ŀ��

SELECT *
FROM ex_save;
delete ex_save;
    
-----------------------
CREATE TABLE ch10_country_month_sales (
               sales_month   VARCHAR2(8),
               country_name  VARCHAR2(40),
               sales_amt     NUMBER,
               PRIMARY KEY (sales_month, country_name) );
              
CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month  ch10_sales.sales_month%TYPE, 
              p_country_name ch10_sales.country_name%TYPE )
IS

BEGIN
	
	--���� ������ ����
	DELETE ch10_sales
	 WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	      
	-- �űԷ� ��, ������ �Ű������� �޾� INSERT 
	-- DELETE�� �����ϹǷ� PRIMARY KEY �ߺ��� �߻�ġ ����
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)	   
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH  = p_sales_month
   AND C.COUNTRY_NAME = p_country_name
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;
       
 -- SAVEPOINT Ȯ���� ���� UPDATE

  -- ����ð����� �ʸ� ������ ���ڷ� ��ȯ�� �� * 10 (�Ź� �ʴ� �޶����Ƿ� ���������� ���� �� �� ���� �Ź� �޶���)
 UPDATE ch10_sales
    SET sales_amt = 10 * to_number(to_char(sysdate, 'ss'))
  WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	   
 -- SAVEPOINT ����      

 SAVEPOINT mysavepoint;      
 
 
 -- ch10_country_month_sales ���̺� INSERT
 -- �ߺ� �Է� �� PRIMARY KEY �ߺ���
 INSERT INTO ch10_country_month_sales 
       SELECT sales_month, country_name, SUM(sales_amt)
         FROM ch10_sales
        WHERE sales_month  = p_sales_month
	        AND country_name = p_country_name
	      GROUP BY sales_month, country_name;         
       
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK TO mysavepoint; -- SAVEPOINT ������ ROLLBACK
               COMMIT; -- SAVEPOINT ���������� COMMIT

	
END;   

TRUNCATE TABLE ch10_sales;

EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;



EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;