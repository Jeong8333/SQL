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