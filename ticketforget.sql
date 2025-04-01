-- ticktet ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER ticktet IDENTIFIED BY ticktet;
GRANT CONNECT, RESOURCE TO ticktet;
GRANT UNLIMITED TABLESPACE TO ticktet;


-- �з� �ڵ�
// �з��ڵ�(TH00, MU00, OP00,CN00, KM00, DN00,EX00, ETC)
// �з��׸�(����, ������, �����, ����/�ܼ�Ʈ, ����, ����/�߷�, ����, ��Ÿ)

CREATE TABLE code_list(
     comm_cd      VARCHAR2(4)  UNIQUE   
    ,comm_nm      VARCHAR2(16) UNIQUE
    ,PRIMARY KEY (comm_cd, comm_nm)
);
drop table code_list;

INSERT INTO code_list
VALUES ('TH00','����');
INSERT INTO code_list
VALUES ('MU00','������');
INSERT INTO code_list
VALUES ('OP00','�����');
INSERT INTO code_list
VALUES ('CN00','����');
INSERT INTO code_list
VALUES ('CN00','�ܼ�Ʈ');
INSERT INTO code_list
VALUES ('KM00','����');
INSERT INTO code_list
VALUES ('DN00','����');
INSERT INTO code_list
VALUES ('DN00','�߷�');
INSERT INTO code_list
VALUES ('EX00','����');
INSERT INTO code_list
VALUES ('ETC','��Ÿ');

--    ,charge VARCHAR2(50)            --�ݾ�
--    ,description  CLOB            --����
-- ��ȭ���� api

CREATE TABLE culture(
     comm_nm      VARCHAR2(16)          
    ,title        VARCHAR2(1000)           
    ,poster       VARCHAR2(1000)         
    ,period_date  VARCHAR2(50)       
    ,loca         VARCHAR2(1000)            
    ,CONSTRAINT culture_fk FOREIGN KEY (comm_nm) REFERENCES code_list(comm_nm)
);
drop table culture;


-- ������ũ Ƽ�� ũ�Ѹ�
CREATE TABLE ip_ticket(
     comm_nm     VARCHAR2(16)         --�з��׸�
    ,title       VARCHAR2(1000)       --����
    ,poster      VARCHAR2(1000)       --�̹���(����� �ּ�)
    ,period_date VARCHAR2(50)         --�Ⱓ
    ,loca        VARCHAR2(1000)       --���
--    ,price_part VARCHAR2(50)        --����(���� ���� or ���ɺ� ����)
--    ,price NUMBER(100)              --����(������, ���ɺ� ����)
--    ,description CLOB            --������ �̹���
--    ,age_limit VARCHAR2(50)         --��������
--    ,running_time VARCHAR2(100)     --�����ð� 
    ,CONSTRAINT fk_ip_ticket FOREIGN KEY (comm_nm) REFERENCES code_list(comm_nm)
);
drop table ip_ticket;


-- ȸ�� ����
CREATE TABLE members (
     mem_id         VARCHAR2(50)    PRIMARY KEY         -- ȸ�� ID
    ,mem_pw         VARCHAR2(1000)  NOT NULL            -- ȸ�� ��й�ȣ
    ,mem_nm         VARCHAR2(30)   NOT NULL            -- ȸ�� �̸�
    ,mem_nick       VARCHAR2(100)   NOT NULL            -- ȸ�� �г���
    ,mem_em         VARCHAR2(1000)                      -- ȸ�� ���� �ּ�
    ,profile_img    VARCHAR2(1000)                      -- ������ �̹��� URL �Ǵ� ���
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'         -- ��� ����(Y �Ǵ� N)
    ,update_dt      DATE            DEFAULT SYSDATE     -- ���� ������
    ,create_dt      DATE            DEFAULT SYSDATE     -- ���� ������
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