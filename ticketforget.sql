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

ALTER TABLE reviews
RENAME COLUMN comm_nm TO comm_name;


-- 인터파크 티켓 크롤링
CREATE TABLE ip_ticket(
     comm_cd     VARCHAR2(4)          --분류항목
    ,title       VARCHAR2(1000)       --제목
    ,poster      VARCHAR2(1000)       --이미지(썸네일 주소)
    ,period_date VARCHAR2(50)         --기간
    ,loc         VARCHAR2(1000)       --장소
    ,CONSTRAINT fk_ip_ticket_comm_cd FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);



-- 회원 정보
CREATE TABLE members (
     mem_id         VARCHAR2(1000)    PRIMARY KEY         -- 회원 ID
    ,mem_pw         VARCHAR2(1000)    NOT NULL            -- 회원 비밀번호
    ,mem_nm         VARCHAR2(1000)    NOT NULL            -- 회원 이름
    ,mem_nick       VARCHAR2(1000)    NOT NULL            -- 회원 닉네임
    ,mem_addr       VARCHAR2(1000)    NOT NULL            -- 회원 메일 주소
    ,profile_img    VARCHAR2(1000)                        -- 프로필 이미지 URL 또는 경로
    ,create_date    DATE              DEFAULT SYSDATE     -- 정보 생성일
    ,update_date    DATE              DEFAULT SYSDATE     -- 정보 수정일
    ,use_yn         VARCHAR2(1)       DEFAULT 'Y'         -- 사용 여부(Y 또는 N)
); 

-- ip_ticket, culture 테이블에 각각의 고유 id(PRIMARY KEY) 부여를 위한 새로운 테이블 생성
CREATE TABLE TB_TICKET AS 
SELECT rownum as ticket_no, COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC
FROM (
        SELECT COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC, substr(period_date,1,4) as yy
        FROM ip_ticket
        ORDER BY to_number(yy) ASC
     );


CREATE TABLE TB_CULTURE AS 
SELECT rownum as culture_no, COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC,CULTURE_DESCRIPTION
FROM (
        SELECT COMM_CD,TITLE,POSTER,PERIOD_DATE,LOC,CULTURE_DESCRIPTION, substr(period_date,1,4) as yy
        FROM culture
        ORDER BY to_number(yy) ASC
      );

ALTER TABLE TB_TICKET ADD CONSTRAINT pk_ip_ticket_id PRIMARY KEY (ticket_no);
ALTER TABLE TB_CULTURE ADD CONSTRAINT pk_culture_id PRIMARY KEY (culture_no);




-- 후기 작성 정보 저장 table
CREATE TABLE reviews(
      review_no     NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 NOCACHE)
     ,mem_id        VARCHAR2(1000)          -- 회원 id
     ,ticket_no     NUMBER                  -- 인터파크 티켓 테이블 id
     ,culture_no    NUMBER                  -- 문화 테이블 id
     ,comm_cd       VARCHAR2(4)             -- 분류코드
     ,comm_nm       VARCHAR2(16)            -- 분류 항목
     ,title         VARCHAR2(1000)          -- 공연명
     ,poster        VARCHAR2(1000)          -- 이미지(썸네일 주소)
     ,loc           VARCHAR2(1000)          -- 장소
     ,viewing_date  DATE                    -- 관람일
     ,review_date   DATE DEFAULT SYSDATE    -- 작성일
     ,update_date   DATE DEFAULT SYSDATE    -- 수정일
     ,friend        VARCHAR2(100)           -- 동행인
     ,rating        NUMBER                  -- 별점
     ,review        CLOB                    -- 관람평
     ,photo         CLOB                    -- 첨부 사진 경로
     ,del_yn         VARCHAR2(1)  DEFAULT 'N'   -- 삭제 여부(Y 또는 N)
     ,PRIMARY KEY (review_no)
     ,CONSTRAINT fk_review_mem_id       FOREIGN KEY (mem_id)        REFERENCES members(mem_id)   
     ,CONSTRAINT fk_review_ticket_no    FOREIGN KEY (ticket_no)     REFERENCES tb_ticket(ticket_no)   
     ,CONSTRAINT fk_review_culture_no   FOREIGN KEY (culture_no)    REFERENCES tb_culture(culture_no)   
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

SELECT mem_id
     , mem_pw
     , mem_nm
     , mem_nick
     , mem_addr
     , profile_img
FROM members
WHERE use_yn = 'Y'
AND mem_id = 'test1';

SELECT comm_cd      
      ,comm_nm     
      ,comm_parent 
FROM code_list;

-- 중복 데이터 제거
DELETE FROM culture
WHERE title IN (
                SELECT c.title
                FROM culture c
                JOIN ip_ticket i ON c.title = i.title
);



-- =================================================
SELECT c.comm_cd,
       c.comm_nm,
       a.ticket_no,
       a.title,
       a.poster,
       a.period_date,
       a.addr,
       a.culture_description
FROM (SELECT ticket_no, comm_cd, title, poster, period_date, addr,  NULL AS culture_description 
      FROM tb_ticket
      UNION ALL
      SELECT culture_no, comm_cd, title, poster, period_date, addr, culture_description
      FROM tb_culture
  ) a
JOIN code_list c ON c.comm_cd = a.comm_cd
WHERE c.comm_cd = 'TH00';


INSERT INTO reviews( mem_id , ticket_no, culture_no,comm_code, comm_name, title, poster, addr
                    , viewing_date, friend, rating, review, photo)
VALUES('testtest', 1660, null,'MU00','뮤지컬', '뮤지컬 〈명성황후〉 30주년 기념 공연 - 대전', 'https://ticketimage.interpark.com/Play/image/large/25/25004164_p.gif', '대전예술의전당 아트홀'
      , '25/04/06', '홍길동', '4.2', '리뷰 내용', '이미지 주소');
INSERT INTO reviews( mem_id , ticket_no, culture_no,comm_code, comm_name, title, poster, addr
                    , viewing_date, friend, rating, review, photo)
VALUES('testtest', 18, null,'CN03','클래식', '대학로 혜화 연극 비누향기', 'https://ticketimage.interpark.com/Play/image/large/21/21007446_p.gif', '대학로'
      , '25/04/01', '신미정', '5', '리뷰 내용', '이미지 주소');

UPDATE members
SET profile_img = 'test'
  , update_date = SYSDATE
WHERE mem_id = 'testtest';

SELECT *
			FROM(SELECT rownum as rnum
			          , a.*
			     FROM (SELECT r.review_no
			                 ,r.title
			                 ,r.comm_cd
			                 ,c.comm_nm as comm_nm
			                 ,r.ticket_no
			                 ,r.culture_no
			                 ,r.poster
			                 ,r.addr
			                 ,r.viewing_date
			                 ,r.review_date
			                 ,r.update_date
			                 ,r.friend
			                 ,r.rating
			                 ,r.review
			                 ,r.photo
			                 ,r.del_yn
			           FROM reviews r, code_list c
			           WHERE r.comm_cd = c.comm_cd
			           ORDER BY review_no DESC
			          ) a
			    ) b
			WHERE rnum BETWEEN 1 AND 5		;


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
FROM tb_culture;

-- 인터파크 티켓 크롤링
SELECT *
FROM ip_ticket;
SELECT COUNT(title)
FROM tb_ticket;

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
ORDER BY a.end_date desc;


SELECT b.comm_nm, a.title, a.poster, a.period_date, a.loc
FROM ip_ticket a, code_list b
WHERE a.comm_cd = b.comm_cd
ORDER BY a.comm_cd, a.title;





SELECT a.ticket_no
     , a.title
     , a.comm_code
     , b.comm_nm as comm_name
     , a.poster
     , a.addr
     , TO_CHAR(a.viewing_date,'YYYYMMDD') as viewing_date
     , a.review_date
     , a.update_date
     , a.friend
     , a.rating
     , a.review
     , a.photo
     , a.del_yn
FROM  reviews a, code_list b
WHERE a.comm_code = b.comm_cd
AND   a.review_no = 30
AND   a.del_yn ='N';


UPDATE reviews
SET friend = '누구'
   ,review = '후기'
   ,rating = 3.5
   ,update_date= SYSDATE
WHERE review_no = 30
AND mem_id = 'testtest';