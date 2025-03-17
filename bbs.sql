-- java 계정에 bbs웹프로젝트에서 사용 TB_USER 테이블 생성

--1 .member 계정에서 조회 권한 부여
GRANT SELECT ON member.member TO java;

--2. java 계정에서 테이블 생성
CREATE TABLE TB_USER AS
SELECT mem_id   as USER_ID
     , mem_pass as USER_PW
     , mem_name as USER_NM
     , 'Y'      as USE_YN
FROM member.member;

--3. 제약조건 추가
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


-- stock_bbs 테이블 권한 부여 java
GRANT SELECT ON member.stock_bbs TO java;

SELECT discussion_id
     , item_code
     , title
     , writer_id
     , read_count
FROM member.stock_bbs;

UPDATE tb_user
SET user_nm = '길동'
WHERE user_id = '0101';