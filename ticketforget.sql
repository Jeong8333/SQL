-- 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER mijeong IDENTIFIED BY mijeong;
GRANT CONNECT, RESOURCE TO mijeong;
GRANT UNLIMITED TABLESPACE TO mijeong;



-- 분류 코드
CREATE TABLE code_list(
     comm_cd      VARCHAR2(4)      PRIMARY KEY   // 분류코드(TH00, MU00, OP00,CN00, KM00, DN00,EX00, ETC)
    ,comm_nm      VARCHAR2(50)                   // 분류명(연극, 뮤지컬, 오페라, 음악/콘서트, 국악, 무용/발레, 전시, 기타)
);

-- 문화포털 api
CREATE TABLE culture_api(
     comm_cd  VARCHAR2(4),          --분류코드
     title VARCHAR2(1000)           --제목
    ,poster VARCHAR2(1000)          --이미지(썸네일 주소)
    ,period_date VARCHAR2(50)       --기간
    ,loca VARCHAR2(1000)            --장소
    ,charge VARCHAR2(50)            --금액
    ,description_c  CLOB            --설명
    ,CONSTRAINT fk_chatlog_mem_id FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);


-- 인터파크 티켓 크롤링
CREATE TABLE ip_ticket(
     comm_cd  VARCHAR2(4)           --분류코드
    ,title_ip VARCHAR2(1000)        --제목
    ,poster VARCHAR2(1000)          --이미지(썸네일 주소)
    ,period_ip DATE                 --기간
    ,loca VARCHAR2(1000)            --장소
    ,price_part VARCHAR2(50)        --가격(구역 구분 or 연령별 구분)
    ,price NUMBER(100)              --가격(구역별, 연령별 가격)
    ,age_limit VARCHAR2(50)         --관람연령
    ,running_time VARCHAR2(100)     --관람시간
    ,description_ip CLOB            --공연상세 이미지
    ,CONSTRAINT fk_ip_ticket FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);
