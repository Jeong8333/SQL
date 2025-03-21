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
