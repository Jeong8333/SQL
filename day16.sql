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
    board_no NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 NOCACHE), -- 1�� ���� (NOCACHE ����)
    board_title VARCHAR2(1000),
    mem_id VARCHAR2(100) NOT NULL,
    board_content VARCHAR2(2000),
    create_dt DATE DEFAULT SYSDATE,
    update_dt DATE DEFAULT SYSDATE,
    use_yn VARCHAR2(1) DEFAULT 'Y',
    PRIMARY KEY (board_no), -- PRIMARY KEY ����
    CONSTRAINT member_fk FOREIGN KEY(mem_id) REFERENCES members(mem_id) -- FOREIGN KEY ���� ����
);

-- boards ���̺� ����
CREATE TABLE replys (
    reply_no NUMBER, -- �ڵ� ���� ����, ���� �� �Է� �ʿ�
    board_no NUMBER(10),
    mem_id VARCHAR2(100),
    reply_content VARCHAR2(1000),
    reply_date DATE DEFAULT SYSDATE,
    del_yn VARCHAR2(1) DEFAULT 'N',
    PRIMARY KEY (board_no, reply_no),
    CONSTRAINT fk_mem_id FOREIGN KEY (mem_id) REFERENCES members(mem_id) ON DELETE CASCADE, -- ȸ�� ���� �� ���� ��۵� ����
    CONSTRAINT fk_board_no FOREIGN KEY (board_no) REFERENCES boards(board_no) ON DELETE CASCADE -- �Խñ� ���� �� ���� ��۵� ����
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
AND a.board_no = 1;

UPDATE boards
SET board_title = 'bbbbbbb'
   ,board_content='bbbbbb'
WHERE board_no = '2';


-- ��� ����
INSERT INTO replys(board_no, reply_no, mem_id, reply_content)
VALUES ('4','123456','1234','��� �׽�Ʈ');
INSERT INTO replys(board_no, reply_no, mem_id, reply_content)
VALUES ('12','123457','aa','��� �׽�Ʈ2');
INSERT INTO replys(board_no, reply_no, mem_id, reply_content)
VALUES ('4','123458','1234','��� �׽�Ʈ3');

-- ��� 1�� ��ȸ
SELECT a.reply_no
     , a.board_no
     , b.mem_id
     , b.mem_nm
     , a.reply_content
     ,TO_CHAR(a.reply_date, 'MM/DD HH24:MI') as reply_date
FROM replys a, members b
WHERE a.mem_id = b.mem_id
AND a.del_yn = 'N'
AND a.reply_no ='123457';

-- ��� ������ ��ȸ
SELECT a.reply_no
     , a.board_no
     , b.mem_id
     , b.mem_nm
     , a.reply_content
     ,TO_CHAR(a.reply_date, 'MM/DD HH24:MI') as reply_date
FROM replys a, members b
WHERE a.mem_id = b.mem_id
AND a.del_yn = 'N'
AND a.board_no ='4'
ORDER BY reply_date DESC;

UPDATE boards
SET use_yn = 'Y'
WHERE board_no = 2;

SELECT *
FROM replys;

UPDATE replys
SET del_yn = 'Y'
WHERE reply_no = '250321113433079';

commit;


-- ���� �ڵ� ���̺�
CREATE TABLe comm_code(
     comm_cd      VARCHAR2(4)      PRIMARY KEY
    ,comm_nm      VARCHAR2(100)
    ,comm_parent  VARCHAR2(4)
);


-- ���� �ڵ�
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB00','����',null);
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB01','�ֺ�','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB02','�����','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB03','������','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB04','����','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB05','ȸ���','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB06','���','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB07','�ڿ���','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB08','�л�','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB09','����','JB00');
-- ��� �ڵ�
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB00','���',null);
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB01','����','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB02','���','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB03','����','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB04','����','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB05','�籸','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB06','�ٵ�','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB07','����','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB08','��Ű','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB09','��ȭ','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB10','����','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB11','��ȭ����','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB12','���','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB13','����','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB14','ī���̽�','HB00');
-- �� �з� �ڵ�
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC00','�ۺз�',null);
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC01','���α׷�','BC00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC02','��','BC00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC03','��� �̾߱�','BC00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC04','���','BC00');

commit;

-- ��з�
SELECT * 
FROM comm_code
WHERE comm_parent IS NULL;
-- �Һз�
SELECT * 
FROM comm_code
WHERE comm_parent = 'JB00';

CREATE TABLE free_board(
    bo_no           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    bo_title        VARCHAR2(250)  NOT NULL,
    bo_category     VARCHAR2(4),
    bo_writer       VARCHAR2(100)  NOT NULL,
    bo_pass         VARCHAR2(60)   NOT NULL,
    bo_content      CLOB,
    bo_ip           VARCHAR2(30),
    bo_hit          NUMBER,
    bo_reg_date     DATE DEFAULT SYSDATE,
    bo_mod_date     DATE DEFAULT SYSDATE,
    bo_del_yn       CHAR(1) DEFAULT 'N',
    CONSTRAINT fk_free_board FOREIGN KEY (bo_category) REFERENCES comm_code(comm_cd)
);

drop table free_board;
commit;

-- ���α׷� (BC01)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('�ڹ� ���� ����', 'BC01', 'ȫ�浿', '1234', '�ڹ� ���� ������ �����մϴ�.', '192.168.1.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('������ ��Ʈ ������Ʈ ����', 'BC01', '�̸���', 'abcd', '������ ��Ʈ ������Ʈ ���� ���.', '192.168.1.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Python ������ �м�', 'BC01', '������', 'qwer', 'Python���� ������ �м��ϱ�.', '192.168.1.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('React ���� ����', 'BC01', '��ö��', 'zxcv', 'React���� ���¸� ȿ�������� �����ϴ� ��.', '192.168.1.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Django �� ����', 'BC01', '�ڿ���', '0987', 'Django�� Ȱ���� �� ���� Ʃ�丮��.', '192.168.1.5');

-- �� (BC02)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('HTML/CSS �⺻', 'BC02', '�̼���', '5678', 'HTML�� CSS �⺻ ������ �Ұ��մϴ�.', '192.168.2.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('JavaScript ����', 'BC02', '������', 'abcd', '�ڹٽ�ũ��Ʈ ����, �Լ�, �̺�Ʈ ó��.', '192.168.2.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('�� ������ ��Ģ', 'BC02', '�̵���', 'efgh', '���� �� �������� �ٽ� ���.', '192.168.2.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Node.js �鿣�� ����', 'BC02', '��û��', 'ijkl', 'Node.js�� ������ API ���� �����.', '192.168.2.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Vue.js �Թ�', 'BC02', '����', 'mnop', 'Vue.js ���� ������ ������Ʈ Ȱ���.', '192.168.2.5');

-- ��� �̾߱� (BC03)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('������ ����', 'BC03', '�迵��', '3456', '���� ���� ������ �� ���׿�.', '192.168.3.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('��ٱ� �̾߱�', 'BC03', '����ȣ', '7890', '��ٱ濡 ���� ���Ǽҵ��Դϴ�.', '192.168.3.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('���� ��õ', 'BC03', '���ϳ�', 'mnop', 'ȫ�뿡 �ִ� ���� ������ �Ұ��մϴ�.', '192.168.3.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('��ȭ ���� �ı�', 'BC03', '���켺', 'qrst', '���� �� ��ȭ ���� ����ϴ�.', '192.168.3.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('��� ��Ȱ ����', 'BC03', '�տ���', 'uvwx', '���� ���� �ִ� ��̴� �̰��Դϴ�.', '192.168.3.5');

-- ��� (BC04)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('�̷¼� �ۼ� ��', 'BC04', '�̼���', 'abcd', '�̷¼��� ��� �ۼ��ϸ� �������?', '192.168.4.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('���� ���� ����', 'BC04', '�ڹμ�', 'efgh', '���� ������ ���� ���� ����.', '192.168.4.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('��� �غ� ����', 'BC04', '������', 'ijkl', '��� �غ� ���� ��ȹ �����.', '192.168.4.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('��� ����Ʈ ��', 'BC04', '��ȣ��', 'mnop', '� ��� ����Ʈ�� �����ұ��?', '192.168.4.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('��� ���� �ı�', 'BC04', '���缮', 'qrst', '��� ���� ������ �����մϴ�.', '192.168.4.5');

-- ������ ���� ��� �ǵ��� �Խ��� SELECT ������ �ۼ����ּ��� (���������� bo_no ��������), �˻������� rownum 1 ~ 10 �� 
SELECT *
FROM (
        SELECT f.bo_no
             , f.bo_title
             , f.bo_category
             , c.comm_nm
             , f.bo_writer
             , f.bo_pass
             , f.bo_content
             , f.bo_ip
             , f.bo_hit
             , f.bo_del_yn
             , f.bo_reg_date
        FROM FREE_BOARD f, COMM_CODE c
        WHERE f.bo_category = c.comm_cd
        ORDER BY bo_no DESC
        );
