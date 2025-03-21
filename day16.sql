ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정 생성 계정명:jdbc, 비번:jdbc
CREATE USER jdbc IDENTIFIED BY jdbc;
-- 권한 부여(접속&리소스 생성 및 접근)
GRANT CONNECT, RESOURCE TO jdbc;
-- 테이블 스페이스 접근 권한(물리적인 저장 파일)
GRANT UNLIMITED TABLESPACE TO jdbc;

-- members 테이블 생성
CREATE TABLE members (
     mem_id         VARCHAR2(50)    PRIMARY KEY         -- 회원 ID(기본 키)
    ,mem_pw         VARCHAR2(1000)  NOT NULL            -- 회원 비밀번호
    ,mem_nm         VARCHAR2(100)                       -- 회원 이름
    ,mem_addr       VARCHAR2(1000)                      -- 회원 주소
    ,profile_img    VARCHAR2(1000)                      -- 프로필 이미지 URL 또는 경로
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'         -- 사용 여부(Y 또는 N)
    ,update_dt      DATE            DEFAULT SYSDATE     -- 정보 수정일
    ,create_dt      DATE            DEFAULT SYSDATE     -- 정보 생성일
);

select *
from members;

INSERT INTO members (mem_id, mem_pw, mem_nm)
VALUES ('a001','1234','닉');
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

-- boards 테이블 생성
CREATE TABLE boards (
    board_no NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 NOCACHE), -- 1씩 증가 (NOCACHE 설정)
    board_title VARCHAR2(1000),
    mem_id VARCHAR2(100) NOT NULL,
    board_content VARCHAR2(2000),
    create_dt DATE DEFAULT SYSDATE,
    update_dt DATE DEFAULT SYSDATE,
    use_yn VARCHAR2(1) DEFAULT 'Y',
    PRIMARY KEY (board_no), -- PRIMARY KEY 지정
    CONSTRAINT member_fk FOREIGN KEY(mem_id) REFERENCES members(mem_id) -- FOREIGN KEY 직접 적용
);

-- boards 테이블 생성
CREATE TABLE replys (
    reply_no NUMBER, -- 자동 증가 없음, 직접 값 입력 필요
    board_no NUMBER(10),
    mem_id VARCHAR2(100),
    reply_content VARCHAR2(1000),
    reply_date DATE DEFAULT SYSDATE,
    del_yn VARCHAR2(1) DEFAULT 'N',
    PRIMARY KEY (board_no, reply_no),
    CONSTRAINT fk_mem_id FOREIGN KEY (mem_id) REFERENCES members(mem_id) ON DELETE CASCADE, -- 회원 삭제 시 관련 댓글도 삭제
    CONSTRAINT fk_board_no FOREIGN KEY (board_no) REFERENCES boards(board_no) ON DELETE CASCADE -- 게시글 삭제 시 관련 댓글도 삭제
);


commit;
delete boards;
drop table boards;
drop table replys;


INSERT INTO boards(board_title,mem_id,board_content) VALUES ('test2','aa','내용입니다.');
INSERT INTO boards(board_title,mem_id,board_content) VALUES ('test','aa','내용입니다.');

SELECT a.board_no
     , a.board_title
     , b.mem_id
     , b.mem_nm
     ,TO_CHAR(a.update_dt,'YYYY/MM/DD HH24:MI:SS') as update_dt
FROM boards a, members b
WHERE a.mem_id = b.mem_id
AND a.use_yn='Y'
ORDER BY a.update_dt DESC;

-- 상세 조회
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


-- 댓글 저장
INSERT INTO replys(board_no, reply_no, mem_id, reply_content)
VALUES ('4','123456','1234','댓글 테스트');
INSERT INTO replys(board_no, reply_no, mem_id, reply_content)
VALUES ('12','123457','aa','댓글 테스트2');
INSERT INTO replys(board_no, reply_no, mem_id, reply_content)
VALUES ('4','123458','1234','댓글 테스트3');

-- 댓글 1건 조회
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

-- 댓글 여러건 조회
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
