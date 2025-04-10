-- ticket ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER ticket IDENTIFIED BY ticket;
GRANT CONNECT, RESOURCE TO ticket;
GRANT UNLIMITED TABLESPACE TO ticket;


-- �з� �ڵ�
// �з��ڵ�(TH00, MU00, OP00,CN00, KM00, DN00,EX00, ETC)
// �з��׸�(����, ������, �����, ����/�ܼ�Ʈ, ����, ����/�߷�, ����, ��Ÿ)

CREATE TABLE code_list(
     comm_cd      VARCHAR2(4)   PRIMARY KEY  
    ,comm_nm      VARCHAR2(16) 
    ,comm_parent  VARCHAR2(4)  
);




-- ��ȭ���� api
CREATE TABLE culture(
     comm_cd              VARCHAR2(4)                  
    ,title                VARCHAR2(1000)             
    ,poster               VARCHAR2(1000)         
    ,period_date          VARCHAR2(50)           
    ,loc                  VARCHAR2(1000)    
    ,culture_description  CLOB
    ,CONSTRAINT fk_culture_comm_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);

ALTER TABLE reviews
RENAME COLUMN comm_nm TO comm_name;


-- ������ũ Ƽ�� ũ�Ѹ�
CREATE TABLE ip_ticket(
     comm_cd     VARCHAR2(4)          --�з��׸�
    ,title       VARCHAR2(1000)       --����
    ,poster      VARCHAR2(1000)       --�̹���(����� �ּ�)
    ,period_date VARCHAR2(50)         --�Ⱓ
    ,loc         VARCHAR2(1000)       --���
    ,CONSTRAINT fk_ip_ticket_comm_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);



-- ȸ�� ����
CREATE TABLE members (
     mem_id         VARCHAR2(1000)    PRIMARY KEY         -- ȸ�� ID
    ,mem_pw         VARCHAR2(1000)    NOT NULL            -- ȸ�� ��й�ȣ
    ,mem_nm         VARCHAR2(1000)    NOT NULL            -- ȸ�� �̸�
    ,mem_nick       VARCHAR2(1000)    NOT NULL            -- ȸ�� �г���
    ,mem_addr       VARCHAR2(1000)    NOT NULL            -- ȸ�� ���� �ּ�
    ,profile_img    VARCHAR2(1000)                        -- ������ �̹��� URL �Ǵ� ���
    ,create_date    DATE              DEFAULT SYSDATE     -- ���� ������
    ,update_date    DATE              DEFAULT SYSDATE     -- ���� ������
    ,use_yn         VARCHAR2(1)       DEFAULT 'Y'         -- ��� ����(Y �Ǵ� N)
); 

-- ip_ticket, culture ���̺� ������ ���� id(PRIMARY KEY) �ο��� ���� ���ο� ���̺� ����
CREATE TABLE TB_TICKET AS 
SELECT rownum as ticket_no, COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC
FROM (
        SELECT COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC, substr(period_date,1,4) as yy
        FROM ip_ticket
        ORDER BY to_number(yy) ASC
     );


CREATE TABLE TB_CULTURE AS 
SELECT rownum as culture_no, COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC,CULTURE_DESCRIPTION
FROM (
        SELECT COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC,CULTURE_DESCRIPTION, substr(period_date,1,4) as yy
        FROM culture
        ORDER BY to_number(yy) ASC
      );

ALTER TABLE TB_TICKET ADD CONSTRAINT pk_ip_ticket_id PRIMARY KEY (ticket_no);
ALTER TABLE TB_CULTURE ADD CONSTRAINT pk_culture_id PRIMARY KEY (culture_no);




-- �ı� �ۼ� ���� ���� table
CREATE TABLE reviews(
      review_no     NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 NOCACHE)
     ,mem_id        VARCHAR2(1000)          -- ȸ�� id
     ,ticket_no     NUMBER                  -- ������ũ Ƽ�� ���̺� id
     ,culture_no    NUMBER                  -- ��ȭ ���̺� id
     ,comm_cd       VARCHAR2(4)             -- �з��ڵ�
     ,comm_nm       VARCHAR2(16)            -- �з� �׸�
     ,title         VARCHAR2(1000)          -- ������
     ,poster        VARCHAR2(1000)          -- �̹���(����� �ּ�)
     ,loc           VARCHAR2(1000)          -- ���
     ,viewing_date  DATE                    -- ������
     ,review_date   DATE DEFAULT SYSDATE    -- �ۼ���
     ,update_date   DATE DEFAULT SYSDATE    -- ������
     ,friend        VARCHAR2(100)           -- ������
     ,rating        NUMBER                  -- ����
     ,review        CLOB                    -- ������
     ,photo         CLOB                    -- ÷�� ���� ���
     ,del_yn         VARCHAR2(1)  DEFAULT 'N'   -- ���� ����(Y �Ǵ� N)
     ,PRIMARY KEY (review_no)
     ,CONSTRAINT fk_review_mem_id       FOREIGN KEY (mem_id)        REFERENCES members(mem_id)   
     ,CONSTRAINT fk_review_ticket_no    FOREIGN KEY (ticket_no)     REFERENCES tb_ticket(ticket_no)   
     ,CONSTRAINT fk_review_culture_no   FOREIGN KEY (culture_no)    REFERENCES tb_culture(culture_no)   
);



-- ===INSERT==========================================
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('TH00','����', null);         -- ����
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('MU00','������', null);       -- ������
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN00','����', null);         -- ����
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN01','�ܼ�Ʈ', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN02','����', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN03','Ŭ����', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN04','�����', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN05','����', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('DN00','����/�߷�', null);    -- ����/�߷�
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('DN01','����', 'DN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('DN02','�߷�', 'DN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('EX00','����', null);         -- ����ȸ
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('ETC','��Ÿ', null);          -- ��Ÿ

INSERT INTO members (
           mem_id
         , mem_pw
         , mem_nm
         , mem_nick
         , mem_addr)
VALUES ('test1', 1234, '�׽�Ʈ', '�׽�Ʈ����', 'aa');

SELECT mem_id
     , mem_pw
     , mem_nm
     , mem_nick
     , mem_addr
     , profile_img
FROM members
WHERE use_yn = 'Y'
AND mem_id = 'test1';

SELECT comm_cd      
      ,comm_nm     
      ,comm_parent 
FROM code_list;

-- �ߺ� ������ ����
DELETE FROM culture
WHERE title IN (
                SELECT c.title
                FROM culture c
                JOIN ip_ticket i ON c.title = i.title
);



-- =================================================
SELECT c.comm_cd,
       c.comm_nm,
       a.ticket_no,
       a.title,
       a.poster,
       a.period_date,
       a.addr,
       a.culture_description
FROM (SELECT ticket_no, comm_cd, title, poster, period_date, addr,  NULL AS culture_description 
      FROM tb_ticket
      UNION ALL
      SELECT culture_no, comm_cd, title, poster, period_date, addr, culture_description
      FROM tb_culture
  ) a
JOIN code_list c ON c.comm_cd = a.comm_cd
WHERE c.comm_cd = 'TH00';


INSERT INTO reviews( mem_id , ticket_no, culture_no,comm_code, comm_name, title, poster, addr
                    , viewing_date, friend, rating, review, photo)
VALUES('testtest', 1660, null,'MU00','������', '������ ����Ȳ�ġ� 30�ֳ� ��� ���� - ����', 'https://ticketimage.interpark.com/Play/image/large/25/25004164_p.gif', '�������������� ��ƮȦ'
      , '25/04/06', 'ȫ�浿', '4.2', '���� ����', '�̹��� �ּ�');
INSERT INTO reviews( mem_id , ticket_no, culture_no,comm_code, comm_name, title, poster, addr
                    , viewing_date, friend, rating, review, photo)
VALUES('testtest', 18, null,'CN03','Ŭ����', '���з� ��ȭ ���� �����', 'https://ticketimage.interpark.com/Play/image/large/21/21007446_p.gif', '���з�'
      , '25/04/01', '�Ź���', '5', '���� ����', '�̹��� �ּ�');

UPDATE members
SET profile_img = 'test'
  , update_date = SYSDATE
WHERE mem_id = 'testtest';

SELECT *
			FROM(SELECT rownum as rnum
			          , a.*
			     FROM (SELECT r.review_no
			                 ,r.title
			                 ,r.comm_cd
			                 ,c.comm_nm as comm_nm
			                 ,r.ticket_no
			                 ,r.culture_no
			                 ,r.poster
			                 ,r.addr
			                 ,r.viewing_date
			                 ,r.review_date
			                 ,r.update_date
			                 ,r.friend
			                 ,r.rating
			                 ,r.review
			                 ,r.photo
			                 ,r.del_yn
			           FROM reviews r, code_list c
			           WHERE r.comm_cd = c.comm_cd
			           ORDER BY review_no DESC
			          ) a
			    ) b
			WHERE rnum BETWEEN 1 AND 5		;


-- ===��ȸ==============================================================

-- code ��з�
SELECT * 
FROM code_list
WHERE comm_parent IS NULL;
-- code �Һз�
SELECT * 
FROM code_list
WHERE comm_parent = 'DN00';

-- ��ȭ���� api
SELECT *
FROM tb_culture;

-- ������ũ Ƽ�� ũ�Ѹ�
SELECT *
FROM ip_ticket;
SELECT COUNT(title)
FROM tb_ticket;

-- ȸ�� ��ȸ
SELECT mem_id
     , mem_pw
     , mem_nm
     , mem_nick
     , mem_email
     , profile_img
     , create_date
     , update_date
     , use_yn
FROM members
WHERE use_yn = 'Y';



SELECT b.comm_cd
     , b.comm_nm
     , COUNT(b.comm_cd)
FROM culture a, code_list b
WHERE a.comm_cd = b.comm_cd
GROUP BY b.comm_cd, b.comm_nm;


SELECT b.comm_cd
     , b.comm_nm
     , COUNT(b.comm_cd) as count
FROM ip_ticket a, code_list b
WHERE a.comm_cd = b.comm_cd
GROUP BY b.comm_cd, b.comm_nm;



WITH a as(  SELECT comm_cd, title, poster, period_date,loc, culture_description
                  ,TO_DATE(SUBSTR(period_date,1,8)) as start_date    -- ���� ������
                  ,TO_DATE(SUBSTR(period_date,12,8)) as end_date     -- ���� ������
            FROM culture
            WHERE poster IS NOT NULL
)
SELECT b.comm_nm, a.title, a.poster, a.start_date, a.end_date, a.culture_description
FROM a, code_list b
WHERE a.comm_cd = b.comm_cd
AND a.comm_cd = 'TH00'
ORDER BY a.end_date desc;


SELECT b.comm_nm, a.title, a.poster, a.period_date, a.loc
FROM ip_ticket a, code_list b
WHERE a.comm_cd = b.comm_cd
ORDER BY a.comm_cd, a.title;





SELECT a.ticket_no
     , a.title
     , a.comm_code
     , b.comm_nm as comm_name
     , a.poster
     , a.addr
     , TO_CHAR(a.viewing_date,'YYYYMMDD') as viewing_date
     , a.review_date
     , a.update_date
     , a.friend
     , a.rating
     , a.review
     , a.photo
     , a.del_yn
FROM  reviews a, code_list b
WHERE a.comm_code = b.comm_cd
AND   a.review_no = 30
AND   a.del_yn ='N';


UPDATE reviews
SET friend = '����'
   ,review = '�ı�'
   ,rating = 3.5
   ,update_date= SYSDATE
WHERE review_no = 30
AND mem_id = 'testtest';