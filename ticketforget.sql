-- ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER mijeong IDENTIFIED BY mijeong;
GRANT CONNECT, RESOURCE TO mijeong;
GRANT UNLIMITED TABLESPACE TO mijeong;

-- ��ȭ���� api
CREATE TABLE culture_api(
--     category_api  VARCHAR2(10),     --�з�(����, ������, �����, ����, �ܼ�Ʈ, ����, ����, ����, ��Ÿ)
     title VARCHAR2(1000)           --������
    ,poster VARCHAR2(1000)          --���� ������ �ּ�
    ,period_api DATE                --�Ⱓ
    ,loca VARCHAR2(1000)            --���
    ,price_part VARCHAR2(50)        --����(���� ���� or ���ɺ� ����)
    ,price NUMBER(100)              --����(������, ���ɺ� ����)
    ,age_limit VARCHAR2(50)         --��������
    ,running_time VARCHAR2(100)     --�����ð�
    ,description_api  --����
);


-- ������ũ Ƽ�� ũ�Ѹ�
CREATE TABLE ip_ticket(
     category_ip VARCHAR2(10)       --�з�(����, ������, �����, ����, �ܼ�Ʈ, ����, ����, ����, ��Ÿ)
    ,title_ip VARCHAR2(1000)           --������
    ,period_ip DATE                --�Ⱓ
    ,loca VARCHAR2(1000)            --���
    ,price_part VARCHAR2(50)        --����(���� ���� or ���ɺ� ����)
    ,price NUMBER(100)              --����(������, ���ɺ� ����)
    ,age_limit VARCHAR2(50)         --��������
    ,running_time VARCHAR2(100)     --�����ð�
    ,description_api  --����
);
