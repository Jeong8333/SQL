CREATE SEQUENCE posts_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE TABLE posts (
    post_id NUMBER,
    author VARCHAR2(100),
    content VARCHAR2(1000),
    post_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id)
);

delete POSTS;
-- ��� ��
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL, '�ؼ�', 'This is a recent post.', SYSDATE);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'�浿', 'This is a recent post.', SYSDATE);
-- 5�� ��
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'¯��', 'This post was made 5 minutes ago.', SYSDATE - INTERVAL '5' MINUTE);
-- 1�ð� ��
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'¯��', 'This post was made 1 hour ago.', SYSDATE - INTERVAL '1' HOUR);

-- 1�� ��
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'��ī��', 'This post was made 1 day ago.', SYSDATE - INTERVAL '1' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'���', 'This post was made 1 day ago.', SYSDATE - INTERVAL '1' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'±', 'This post was made 1 day ago.', SYSDATE - INTERVAL '1' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'����', 'This post was made 1 day ago.', SYSDATE - INTERVAL '2' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'���', 'This post was made 1 day ago.', SYSDATE - INTERVAL '3' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'�б�', 'This post was made 1 day ago.', SYSDATE - INTERVAL '4' DAY);
commit;

select *
from posts;

-- EXTRACT �Լ� ���
-- �ð� ���� ��Ҹ� �����ϴµ� ���
SELECT EXTRACT(MINUTE FROM post_time)
FROM posts;


SELECT post_id, EXTRACT(DAY FROM(CURRENT_TIMESTAMP- post_time))
              , EXTRACT(HOUR FROM(CURRENT_TIMESTAMP- post_time))
              , EXTRACT(MINUTE FROM(CURRENT_TIMESTAMP- post_time))
              , EXTRACT(DAY FROM(CURRENT_TIMESTAMP- post_time)) * 24 * 60 +
                EXTRACT(HOUR FROM(CURRENT_TIMESTAMP- post_time)) * 60 + 
                EXTRACT(MINUTE FROM(CURRENT_TIMESTAMP- post_time)) as minutes_ago
FROM posts;

SELECT a.*
     , CASE WHEN minutes_ago < 2 THEN '���� ��...'
            WHEN minutes_ago < 6 THEN '5�� ��...'
            WHEN minutes_ago < 16 THEN '15�� ��...'
            WHEN minutes_ago < 31 THEN '30�� ��...'
            WHEN minutes_ago < 61 THEN '1�ð�...'
            WHEN minutes_ago < 60 * 24 THEN FLOOR(minutes_ago/60) || '�ð� ��...'
        ELSE FLOOR(minutes_ago / (60*24)) || '�� ��...'
        END as relative_time
FROM (
        SELECT post_id, author, content
                      , EXTRACT(DAY FROM(CURRENT_TIMESTAMP- post_time)) * 24 * 60 +
                        EXTRACT(HOUR FROM(CURRENT_TIMESTAMP- post_time)) * 60 + 
                        EXTRACT(MINUTE FROM(CURRENT_TIMESTAMP- post_time)) as minutes_ago
        FROM posts
      ) a;