-- java ������ bbs��������Ʈ���� ��� TB_USER ���̺� ����

--1 .member �������� ��ȸ ���� �ο�
GRANT SELECT ON member.member TO java;

--2. java �������� ���̺� ����
CREATE TABLE TB_USER AS
SELECT mem_id   as USER_ID
     , mem_pass as USER_PW
     , mem_name as USER_NM
     , 'Y'      as USE_YN
FROM member.member;

--3. �������� �߰�
ALTER TABLE tb_user ADD CONSTRAINT user_tb_pk PRIMARY KEY (user_id);

SELECT user_id
     , user_pw
     , user_nm
FROM tb_user
WHERE use_yn = 'Y'
AND user_id = 'a001';

INSERT INTO tb_user
VALUES (?, ?, ?, 'Y');

SELECT *
FROM tb_user;


-- stock_bbs ���̺� ���� �ο� java
GRANT SELECT ON member.stock_bbs TO java;

SELECT discussion_id
     , item_code
     , title
     , writer_id
     , read_count
FROM member.stock_bbs;

UPDATE tb_user
SET user_nm = '�浿'
WHERE user_id = '0101';