ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- ���� ���� ������:jdbc, ���:jdbc
CREATE USER jdbc IDENTIFIED BY jdbc;
-- ���� �ο�(����&���ҽ� ���� �� ����)
GRANT CONNECT, RESOURCE TO jdbc;
-- ���̺� �����̽� ���� ����(�������� ���� ����)
GRANT UNLIMITED TABLESPACE TO jdbc;

CREATE TABLE members (
     mem_id         VARCHAR2(50)    PRIMARY KEY         -- ȸ�� ID(�⺻ Ű)
    ,mem_pw         VARCHAR2(1000)  NOT NULL            -- ȸ�� ��й�ȣ
    ,mem_nm         VARCHAR2(100)                       -- ȸ�� �̸�
    ,mem_addr       VARCHAR2(1000)                      -- ȸ�� �ּ�
    ,profile_img    VARCHAR2(1000)                      -- ������ �̹��� URL �Ǵ� ���
    ,use_yn         VARCHAR2(1)     DEFAULT 'Y'         -- ��� ����(Y �Ǵ� N)
    ,update_dt      DATE            DEFAULT SYSDATE     -- ���� ������
    ,create_dt      DATE            DEFAULT SYSDATE     -- ���� ������
);