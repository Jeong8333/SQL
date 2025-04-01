-- ticktet 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER ticktet IDENTIFIED BY ticktet;
GRANT CONNECT, RESOURCE TO ticktet;
GRANT UNLIMITED TABLESPACE TO ticktet;


-- 분류 코드
// 분류코드(TH00, MU00, OP00,CN00, KM00, DN00,EX00, ETC)
// 분류항목(연극, 뮤지컬, 오페라, 음악/콘서트, 국악, 무용/발레, 전시, 기타)

CREATE TABLE code_list(
     comm_cd      VARCHAR2(4)  UNIQUE   
    ,comm_nm      VARCHAR2(16) UNIQUE
    ,PRIMARY KEY (comm_cd, comm_nm)
);
drop table code_list;

INSERT INTO code_list
VALUES ('TH00','연극');
INSERT INTO code_list
VALUES ('MU00','뮤지컬');
INSERT INTO code_list
VALUES ('OP00','오페라');
INSERT INTO code_list
VALUES ('CN00','음악');
INSERT INTO code_list
VALUES ('CN00','콘서트');
INSERT INTO code_list
VALUES ('KM00','국악');
INSERT INTO code_list
VALUES ('DN00','무용');
INSERT INTO code_list
VALUES ('DN00','발레');
INSERT INTO code_list
VALUES ('EX00','전시');
INSERT INTO code_list
VALUES ('ETC','기타');

--    ,charge VARCHAR2(50)            --금액
--    ,description  CLOB            --설명
-- 문화포털 api

CREATE TABLE culture(
     comm_nm      VARCHAR2(16)          
    ,title        VARCHAR2(1000)           
    ,poster       VARCHAR2(1000)         
    ,period_date  VARCHAR2(50)       
    ,loca         VARCHAR2(1000)            
    ,CONSTRAINT culture_fk FOREIGN KEY (comm_nm) REFERENCES code_list(comm_nm)
);
drop table culture;


-- 인터파크 티켓 크롤링
CREATE TABLE ip_ticket(
     comm_nm     VARCHAR2(16)         --분류항목
    ,title       VARCHAR2(1000)       --제목
    ,poster      VARCHAR2(1000)       --이미지(썸네일 주소)
    ,period_date VARCHAR2(50)         --기간
    ,loca        VARCHAR2(1000)       --장소
--    ,price_part VARCHAR2(50)        --가격(구역 구분 or 연령별 구분)
--    ,price NUMBER(100)              --가격(구역별, 연령별 가격)
--    ,description CLOB            --공연상세 이미지
--    ,age_limit VARCHAR2(50)         --관람연령
--    ,running_time VARCHAR2(100)     --관람시간 
    ,CONSTRAINT fk_ip_ticket FOREIGN KEY (comm_nm) REFERENCES code_list(comm_nm)
);
drop table ip_ticket;


-- 회원 정보
CREATE TABLE members (
     mem_id         VARCHAR2(50)    PRIMARY KEY         -- 회원 ID
    ,mem_pw         VARCHAR2(1000)  NOT NULL            -- 회원 비밀번호
    ,mem_nm         VARCHAR2(30)   NOT NULL            -- 회원 이름
    ,mem_nick       VARCHAR2(100)   NOT NULL            -- 회원 닉네임
    ,mem_em         VARCHAR2(1000)                      -- 회원 메일 주소
    ,profile_img    VARCHAR2(1000)                      -- 프로필 이미지 URL 또는 경로
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'         -- 사용 여부(Y 또는 N)
    ,update_dt      DATE            DEFAULT SYSDATE     -- 정보 수정일
    ,create_dt      DATE            DEFAULT SYSDATE     -- 정보 생성일
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