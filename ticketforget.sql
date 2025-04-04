-- ticket 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER ticket IDENTIFIED BY ticket;
GRANT CONNECT, RESOURCE TO ticket;
GRANT UNLIMITED TABLESPACE TO ticket;


-- 분류 코드
// 분류코드(TH00, MU00, OP00,CN00, KM00, DN00,EX00, ETC)
// 분류항목(연극, 뮤지컬, 오페라, 음악/콘서트, 국악, 무용/발레, 전시, 기타)

CREATE TABLE code_list(
     comm_cd      VARCHAR2(4)   PRIMARY KEY  
    ,comm_nm      VARCHAR2(16) 
    ,comm_parent  VARCHAR2(4)  
);
drop table code_list;



-- 문화포털 api
CREATE TABLE culture(
     comm_cd              VARCHAR2(4)                  
    ,title                VARCHAR2(1000)             
    ,poster               VARCHAR2(1000)         
    ,period_date          VARCHAR2(50)           
    ,loc                  VARCHAR2(1000)    
    ,culture_description  CLOB
    ,CONSTRAINT fk_culture_comm_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);



-- 인터파크 티켓 크롤링
CREATE TABLE ip_ticket(
     comm_cd     VARCHAR2(4)          --분류항목
    ,title       VARCHAR2(1000)       --제목
    ,poster      VARCHAR2(1000)       --이미지(썸네일 주소)
    ,period_date VARCHAR2(50)         --기간
    ,loc         VARCHAR2(1000)       --장소
    ,CONSTRAINT fk_ip_ticket_comm_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);


drop table members;

-- 회원 정보
CREATE TABLE members (
     mem_id         VARCHAR2(1000)    PRIMARY KEY         -- 회원 ID
    ,mem_pw         VARCHAR2(1000)    NOT NULL            -- 회원 비밀번호
    ,mem_nm         VARCHAR2(1000)    NOT NULL            -- 회원 이름
    ,mem_nick       VARCHAR2(1000)   NOT NULL            -- 회원 닉네임
    ,mem_addr       VARCHAR2(1000)  NOT NULL            -- 회원 메일 주소
    ,profile_img    VARCHAR2(1000)                      -- 프로필 이미지 URL 또는 경로
    ,create_date    DATE            DEFAULT SYSDATE     -- 정보 생성일
    ,update_date    DATE            DEFAULT SYSDATE     -- 정보 수정일
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'         -- 사용 여부(Y 또는 N)
);


-- 기록
CREATE TABLE post(
      mem_id        VARCHAR2(50)            -- 회원 id
     ,comm_cd       VARCHAR2(4)             -- 분류코드
     ,comm_nm       VARCHAR2(16)            -- 분류 항목
     ,title         VARCHAR2(1000)          -- 공연명
     ,loca          VARCHAR2(1000)          -- 장소
     ,viewing_date  DATE                    -- 관람일
     ,post_date     DATE DEFAULT SYSDATE    -- 작성일
     ,friend        VARCHAR2(30)            -- 동행인
     ,rating        NUMBER                  -- 별점
     ,review        CLOB                    -- 관람평
     ,image_url     VARCHAR2(1000)          -- 첨부 사진 경로
     ,CONSTRAINT fk_post_id FOREIGN KEY (mem_id) REFERENCES members(mem_id)
     ,CONSTRAINT fk_post_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
     ,CONSTRAINT fk_post_cdnm FOREIGN KEY (comm_nm) REFERENCES code_list(comm_nm)
     ,CONSTRAINT fk_post_title FOREIGN KEY (title) REFERENCES            (title)
     ,CONSTRAINT fk_post_loca FOREIGN KEY (loca) REFERENCES            (loca)
);

-- ===INSERT==========================================
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('TH00','연극', null);         -- 연극
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('MU00','뮤지컬', null);       -- 뮤지컬
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN00','음악', null);         -- 음악
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN01','콘서트', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN02','음악', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN03','클래식', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN04','오페라', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('CN05','국악', 'CN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('DN00','무용/발레', null);    -- 무용/발레
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('DN01','무용', 'DN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('DN02','발레', 'DN00');
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('EX00','전시', null);         -- 전시회
INSERT INTO code_list (comm_cd,comm_nm,comm_parent) VALUES ('ETC','기타', null);          -- 기타

INSERT INTO members (
           mem_id
         , mem_pw
         , mem_nm
         , mem_nick
         , mem_addr)
VALUES ('test1', 1234, '테스트', '테스트계정', 'aa');

-- ===조회==============================================================

-- code 대분류
SELECT * 
FROM code_list
WHERE comm_parent IS NULL;
-- code 소분류
SELECT * 
FROM code_list
WHERE comm_parent = 'DN00';

-- 문화포털 api
SELECT *
FROM culture;

-- 인터파크 티켓 크롤링
SELECT *
FROM ip_ticket;
SELECT COUNT(title)
FROM ip_ticket;

-- 회원 조회
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
                  ,TO_DATE(SUBSTR(period_date,1,8)) as start_date    -- 공연 시작일
                  ,TO_DATE(SUBSTR(period_date,12,8)) as end_date     -- 공연 종료일
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


-- culture테이블과 ip_ticket 테이블을 comm_cd로 조인






