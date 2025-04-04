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
drop table code_list;



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



-- ������ũ Ƽ�� ũ�Ѹ�
CREATE TABLE ip_ticket(
     comm_cd     VARCHAR2(4)          --�з��׸�
    ,title       VARCHAR2(1000)       --����
    ,poster      VARCHAR2(1000)       --�̹���(����� �ּ�)
    ,period_date VARCHAR2(50)         --�Ⱓ
    ,loc         VARCHAR2(1000)       --���
    ,CONSTRAINT fk_ip_ticket_comm_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);


drop table members;

-- ȸ�� ����
CREATE TABLE members (
     mem_id         VARCHAR2(1000)    PRIMARY KEY         -- ȸ�� ID
    ,mem_pw         VARCHAR2(1000)    NOT NULL            -- ȸ�� ��й�ȣ
    ,mem_nm         VARCHAR2(1000)    NOT NULL            -- ȸ�� �̸�
    ,mem_nick       VARCHAR2(1000)   NOT NULL            -- ȸ�� �г���
    ,mem_addr       VARCHAR2(1000)  NOT NULL            -- ȸ�� ���� �ּ�
    ,profile_img    VARCHAR2(1000)                      -- ������ �̹��� URL �Ǵ� ���
    ,create_date    DATE            DEFAULT SYSDATE     -- ���� ������
    ,update_date    DATE            DEFAULT SYSDATE     -- ���� ������
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'         -- ��� ����(Y �Ǵ� N)
);


-- ���
CREATE TABLE post(
      mem_id        VARCHAR2(50)            -- ȸ�� id
     ,comm_cd       VARCHAR2(4)             -- �з��ڵ�
     ,comm_nm       VARCHAR2(16)            -- �з� �׸�
     ,title         VARCHAR2(1000)          -- ������
     ,loca          VARCHAR2(1000)          -- ���
     ,viewing_date  DATE                    -- ������
     ,post_date     DATE DEFAULT SYSDATE    -- �ۼ���
     ,friend        VARCHAR2(30)            -- ������
     ,rating        NUMBER                  -- ����
     ,review        CLOB                    -- ������
     ,image_url     VARCHAR2(1000)          -- ÷�� ���� ���
     ,CONSTRAINT fk_post_id FOREIGN KEY (mem_id) REFERENCES members(mem_id)
     ,CONSTRAINT fk_post_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
     ,CONSTRAINT fk_post_cdnm FOREIGN KEY (comm_nm) REFERENCES code_list(comm_nm)
     ,CONSTRAINT fk_post_title FOREIGN KEY (title) REFERENCES            (title)
     ,CONSTRAINT fk_post_loca FOREIGN KEY (loca) REFERENCES            (loca)
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
FROM culture;

-- ������ũ Ƽ�� ũ�Ѹ�
SELECT *
FROM ip_ticket;
SELECT COUNT(title)
FROM ip_ticket;

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
ORDER BY a.end_date;


SELECT b.comm_nm, a.title, a.poster, a.period_date, a.loc
FROM ip_ticket a, code_list b
WHERE a.comm_cd = b.comm_cd
ORDER BY a.comm_cd, a.title;


-- culture���̺�� ip_ticket ���̺��� comm_cd�� ����






