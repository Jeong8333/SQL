-- ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER mijeong IDENTIFIED BY mijeong;
GRANT CONNECT, RESOURCE TO mijeong;
GRANT UNLIMITED TABLESPACE TO mijeong;



-- �з� �ڵ�
CREATE TABLE code_list(
     comm_cd      VARCHAR2(4)      PRIMARY KEY   // �з��ڵ�(TH00, MU00, OP00,CN00, KM00, DN00,EX00, ETC)
    ,comm_nm      VARCHAR2(50)                   // �з���(����, ������, �����, ����/�ܼ�Ʈ, ����, ����/�߷�, ����, ��Ÿ)
);

-- ��ȭ���� api
CREATE TABLE culture_api(
     comm_cd  VARCHAR2(4),          --�з��ڵ�
     title VARCHAR2(1000)           --����
    ,poster VARCHAR2(1000)          --�̹���(����� �ּ�)
    ,period_date VARCHAR2(50)       --�Ⱓ
    ,loca VARCHAR2(1000)            --���
    ,charge VARCHAR2(50)            --�ݾ�
    ,description_c  CLOB            --����
    ,CONSTRAINT fk_chatlog_mem_id FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);


-- ������ũ Ƽ�� ũ�Ѹ�
CREATE TABLE ip_ticket(
     comm_cd  VARCHAR2(4)           --�з��ڵ�
    ,title_ip VARCHAR2(1000)        --����
    ,poster VARCHAR2(1000)          --�̹���(����� �ּ�)
    ,period_ip DATE                 --�Ⱓ
    ,loca VARCHAR2(1000)            --���
    ,price_part VARCHAR2(50)        --����(���� ���� or ���ɺ� ����)
    ,price NUMBER(100)              --����(������, ���ɺ� ����)
    ,age_limit VARCHAR2(50)         --��������
    ,running_time VARCHAR2(100)     --�����ð�
    ,description_ip CLOB            --������ �̹���
    ,CONSTRAINT fk_ip_ticket FOREIGN KEY (comm_cd) REFERENCES code_list(comm_cd)
);
