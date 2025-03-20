ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- ���� ���� ������:jdbc, ���:jdbc
CREATE USER jdbc IDENTIFIED BY jdbc;
-- ���� �ο�(����&���ҽ� ���� �� ����)
GRANT CONNECT, RESOURCE TO jdbc;
-- ���̺� �����̽� ���� ����(�������� ���� ����)
GRANT UNLIMITED TABLESPACE TO jdbc;

-- members ���̺� ����
CREATE TABLE members (
     mem_id         VARCHAR2(50)    PRIMARY KEY         -- ȸ�� ID(�⺻ Ű)
    ,mem_pw         VARCHAR2(1000)  NOT NULL            -- ȸ�� ��й�ȣ
    ,mem_nm         VARCHAR2(100)                       -- ȸ�� �̸�
    ,mem_addr       VARCHAR2(1000)                      -- ȸ�� �ּ�
    ,profile_img    VARCHAR2(1000)                      -- ������ �̹��� URL �Ǵ� ���
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'         -- ��� ����(Y �Ǵ� N)
    ,update_dt      DATE            DEFAULT SYSDATE     -- ���� ������
    ,create_dt      DATE            DEFAULT SYSDATE     -- ���� ������
);

select *
from members;

INSERT INTO members (mem_id, mem_pw, mem_nm)
VALUES ('a001','1234','��');
commit;

delete members;
commit;

SELECT mem_id
     , mem_pw
     , mem_nm
     , mem_addr
     , profile_img
FROM members
WHERE use_yn = 'Y'
AND mem_id = 'aa'
AND mem_pw = 'aa';

-- boards ���̺� ����
CREATE TABLE boards (
     board_no       NUMBER          GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 NOCACHE)  PRIMARY KEY
    ,board_title    VARCHAR2(1000)            
    ,mem_id         VARCHAR2(100)  CONSTRAINT boards_fk REFERENCES members(mem_id) NOT NULL                  
    ,board_content  VARCHAR2(2000)                     
    ,create_dt      DATE            DEFAULT SYSDATE     
    ,update_dt      DATE            DEFAULT SYSDATE     
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'        
);

-- boards ���̺� ����
CREATE TABLE replys (
     reply_no       NUMBER                  
    ,board_no       NUMBER(10)      CONSTRAINT replys_fk REFERENCES boards(board_no)   ON DELETE CASCADE  
    ,mem_id         VARCHAR2(100)   CONSTRAINT replys_fk_mem_id REFERENCES members(mem_id)    ON DELETE CASCADE           
    ,reply_content  VARCHAR2(1000)                     
    ,reply_date     DATE            DEFAULT SYSDATE     
    ,del_yn         VARCHAR2(1)     DEFAULT 'N'
    ,CONSTRAINT replys_PK PRIMARY KEY(reply_no, board_no)
);


commit;
delete boards;
drop table boards;
drop table replys;


INSERT INTO boards(board_title,mem_id,board_content) VALUES ('test2','aa','�����Դϴ�.');
INSERT INTO boards(board_title,mem_id,board_content) VALUES ('test','aa','�����Դϴ�.');

SELECT a.board_no
     , a.board_title
     , b.mem_id
     , b.mem_nm
     ,TO_CHAR(a.update_dt,'YYYY/MM/DD HH24:MI:SS') as update_dt
FROM boards a, members b
WHERE a.mem_id = b.mem_id
AND a.use_yn='Y'
ORDER BY a.update_dt DESC;

-- �� ��ȸ
SELECT a.board_no
     , a.board_title
     , a.board_content
     , b.mem_nm
     ,TO_CHAR(a.update_dt,'YYYY/MM/DD HH24:MI:SS') as update_dt
FROM boards a, members b
WHERE a.mem_id = b.mem_id
AND a.use_yn='Y'
AND a.board_no = 4;

UPDATE boards
SET board_title = 'bbbbbbb'
   ,board_content='bbbbbb'
WHERE board_no = '5';