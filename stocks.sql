CREATE TABLE TB_STOCKS (
      item_code     VARCHAR(7)
    , close_price   NUMBER(20)
    , update_date   DATE DEFAULT SYSDATE
);
delete tb_stocks;


CREATE TABLE tb_krx(

     krx_code   VARCHAR2(7) PRIMARY KEY
    ,krx_name   VARCHAR2(100)
    ,krx_market VARCHAR2(100)
    ,krx_volume NUMBER
    ,krx_yn     VARCHAR2(1) DEFAULT 'N'

);

SELECT *
FROM tb_krx;
drop table stock_bbs;

CREATE TABLE stock_bbs (
    rsno           NUMBER,              -- 고유 식별자(음수 가능하므로 NUMBER)
    discussion_id  NUMBER NOT NULL,     -- 토론 ID
    item_code      VARCHAR2(20),        -- 종목 코드 (ex: 005930)
    title          VARCHAR2(500),       -- 제목
    bbs_contents   VARCHAR2(4000),      -- 내용
    writer_id      VARCHAR2(50),        -- 작성자 ID
    read_count     NUMBER  DEFAULT 0,   -- 조회수
    good_count     NUMBER  DEFAULT 0,   -- 추천 수
    bad_count      NUMBER  DEFAULT 0,   -- 비추천 수
    comment_count  NUMBER  DEFAULT 0,   -- 댓글 수
    end_path       VARCHAR2(500),        -- URL 경로
    update_date   DATE
    ,CONSTRAINT pk_bbs PRIMARY KEY(rsno, discussion_id, item_code)
    ,CONSTRAINT fk_stock FOREIGN KEY(item_code) REFERENCES tb_krx(krx_code)
);
-- MERGE
MERGE INTO stock_bbs a
USING DUAL
ON(    a.rsno = :rsno
   AND a.discussion_id = :discussion_id
   AND a.item_code = :item_code)
WHEN MATCHED THEN
    UPDATE SET a.read_count = :read_count
             , a.good_count = :good_count
             , a.bad_count = :bad_count
             , a.comment_count = :comment_count
             , a.update_date = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (a.rsno, a.discussion_id, a.item_code, a.title, a.bbs_contents
          , a.writer_id, a.read_count, a.good_count, a.bad_count, a.comment_count
          , a.end_path, a.update_date)
    VALUES (:rsno, :discussion_id, :item_code, :title, :bbs_contents
          , :writer_id, :read_count, :good_count, :bad_count, :comment_count
            , :end_path ,:update_date);
            
-- 
SELECT krx_code
     , krx_name
     , krx_market
FROM tb_krx
WHERE krx_yn = 'Y';