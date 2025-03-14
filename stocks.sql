CREATE TABLE TB_STOCKS (
      item_code     VARCHAR(7)
    , close_price   NUMBER(20)
    , update_date   DATE DEFAULT SYSDATE
);
delete tb_stocks;
