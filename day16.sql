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

commit;


-- 공통 코드 테이블
CREATE TABLe comm_code(
     comm_cd      VARCHAR2(4)      PRIMARY KEY
    ,comm_nm      VARCHAR2(100)
    ,comm_parent  VARCHAR2(4)
);


-- 직업 코드
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB00','직업',null);
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB01','주부','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB02','은행원','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB03','공무원','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB04','축산업','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB05','회사원','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB06','농업','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB07','자영업','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB08','학생','JB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('JB09','교사','JB00');
-- 취미 코드
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB00','취미',null);
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB01','서예','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB02','장기','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB03','수영','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB04','독서','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB05','당구','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB06','바둑','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB07','볼링','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB08','스키','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB09','만화','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB10','낚시','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB11','영화감상','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB12','등산','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB13','개그','HB00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('HB14','카레이싱','HB00');
-- 글 분류 코드
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC00','글분류',null);
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC01','프로그램','BC00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC02','웹','BC00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC03','사는 이야기','BC00');
Insert into COMM_CODE (COMM_CD,COMM_NM,COMM_PARENT) values ('BC04','취업','BC00');

commit;

-- 대분류
SELECT * 
FROM comm_code
WHERE comm_parent IS NULL;
-- 소분류
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

-- 프로그램 (BC01)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('자바 기초 강의', 'BC01', '홍길동', '1234', '자바 기초 문법을 설명합니다.', '192.168.1.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('스프링 부트 프로젝트 시작', 'BC01', '이몽룡', 'abcd', '스프링 부트 프로젝트 설정 방법.', '192.168.1.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Python 데이터 분석', 'BC01', '성춘향', 'qwer', 'Python으로 데이터 분석하기.', '192.168.1.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('React 상태 관리', 'BC01', '김철수', 'zxcv', 'React에서 상태를 효과적으로 관리하는 법.', '192.168.1.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Django 웹 개발', 'BC01', '박영희', '0987', 'Django를 활용한 웹 개발 튜토리얼.', '192.168.1.5');

-- 웹 (BC02)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('HTML/CSS 기본', 'BC02', '이순신', '5678', 'HTML과 CSS 기본 문법을 소개합니다.', '192.168.2.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('JavaScript 기초', 'BC02', '강감찬', 'abcd', '자바스크립트 변수, 함수, 이벤트 처리.', '192.168.2.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('웹 디자인 원칙', 'BC02', '이도령', 'efgh', '좋은 웹 디자인의 핵심 요소.', '192.168.2.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Node.js 백엔드 개발', 'BC02', '심청이', 'ijkl', 'Node.js로 간단한 API 서버 만들기.', '192.168.2.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('Vue.js 입문', 'BC02', '장길산', 'mnop', 'Vue.js 기초 문법과 컴포넌트 활용법.', '192.168.2.5');

-- 사는 이야기 (BC03)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('오늘의 날씨', 'BC03', '김영희', '3456', '오늘 서울 날씨가 참 좋네요.', '192.168.3.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('출근길 이야기', 'BC03', '최준호', '7890', '출근길에 겪은 에피소드입니다.', '192.168.3.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('맛집 추천', 'BC03', '박하나', 'mnop', '홍대에 있는 숨은 맛집을 소개합니다.', '192.168.3.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('영화 감상 후기', 'BC03', '정우성', 'qrst', '어제 본 영화 리뷰 남깁니다.', '192.168.3.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('취미 생활 공유', 'BC03', '손예진', 'uvwx', '요즘 즐기고 있는 취미는 이것입니다.', '192.168.3.5');

-- 취업 (BC04)
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('이력서 작성 팁', 'BC04', '이서진', 'abcd', '이력서를 어떻게 작성하면 좋을까요?', '192.168.4.1');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('면접 질문 정리', 'BC04', '박민수', 'efgh', '자주 나오는 면접 질문 정리.', '192.168.4.2');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('취업 준비 일정', 'BC04', '송혜교', 'ijkl', '취업 준비 일정 계획 세우기.', '192.168.4.3');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('취업 사이트 비교', 'BC04', '강호동', 'mnop', '어떤 취업 사이트가 유용할까요?', '192.168.4.4');
INSERT INTO FREE_BOARD (BO_TITLE, BO_CATEGORY, BO_WRITER, BO_PASS, BO_CONTENT, BO_IP)
VALUES ('취업 성공 후기', 'BC04', '유재석', 'qrst', '취업 성공 경험을 공유합니다.', '192.168.4.5');

-- 다음과 같이 출력 되도록 게시판 SELECT 쿼리를 작성해주세요 (정렬조건은 bo_no 내림차순), 검색조건은 rownum 1 ~ 10 행 
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
