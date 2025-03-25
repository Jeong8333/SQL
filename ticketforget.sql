-- 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER mijeong IDENTIFIED BY mijeong;
GRANT CONNECT, RESOURCE TO mijeong;
GRANT UNLIMITED TABLESPACE TO mijeong;

-- 문화포털 api
CREATE TABLE culture_api(
--     category_api  VARCHAR2(10),     --분류(연극, 뮤지컬, 오페라, 음악, 콘서트, 국악, 무용, 전시, 기타)
     title VARCHAR2(1000)           --공연명
    ,poster VARCHAR2(1000)          --공연 포스터 주소
    ,period_api DATE                --기간
    ,loca VARCHAR2(1000)            --장소
    ,price_part VARCHAR2(50)        --가격(구역 구분 or 연령별 구분)
    ,price NUMBER(100)              --가격(구역별, 연령별 가격)
    ,age_limit VARCHAR2(50)         --관람연령
    ,running_time VARCHAR2(100)     --관람시간
    ,description_api  --설명
);


-- 인터파크 티켓 크롤링
CREATE TABLE ip_ticket(
     category_ip VARCHAR2(10)       --분류(연극, 뮤지컬, 오페라, 음악, 콘서트, 국악, 무용, 전시, 기타)
    ,title_ip VARCHAR2(1000)           --공연명
    ,period_ip DATE                --기간
    ,loca VARCHAR2(1000)            --장소
    ,price_part VARCHAR2(50)        --가격(구역 구분 or 연령별 구분)
    ,price NUMBER(100)              --가격(구역별, 연령별 가격)
    ,age_limit VARCHAR2(50)         --관람연령
    ,running_time VARCHAR2(100)     --관람시간
    ,description_api  --설명
);
