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
-- 방금 전
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL, '팽수', 'This is a recent post.', SYSDATE);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'길동', 'This is a recent post.', SYSDATE);
-- 5분 전
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'짱구', 'This post was made 5 minutes ago.', SYSDATE - INTERVAL '5' MINUTE);
-- 1시간 전
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'짱미', 'This post was made 1 hour ago.', SYSDATE - INTERVAL '1' HOUR);

-- 1일 전
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'아카네', 'This post was made 1 day ago.', SYSDATE - INTERVAL '1' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'쥬디', 'This post was made 1 day ago.', SYSDATE - INTERVAL '1' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'짹', 'This post was made 1 day ago.', SYSDATE - INTERVAL '1' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'동길', 'This post was made 1 day ago.', SYSDATE - INTERVAL '2' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'길수', 'This post was made 1 day ago.', SYSDATE - INTERVAL '3' DAY);
INSERT INTO POSTS (post_id, author, content, post_time) VALUES (posts_seq.NEXTVAL,'학길', 'This post was made 1 day ago.', SYSDATE - INTERVAL '4' DAY);
commit;

select *
from posts;

-- EXTRACT 함수 사용
-- 시간 구성 요소를 추출하는데 사용
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
     , CASE WHEN minutes_ago < 2 THEN '조금 전...'
            WHEN minutes_ago < 6 THEN '5분 전...'
            WHEN minutes_ago < 16 THEN '15분 전...'
            WHEN minutes_ago < 31 THEN '30분 전...'
            WHEN minutes_ago < 61 THEN '1시간...'
            WHEN minutes_ago < 60 * 24 THEN FLOOR(minutes_ago/60) || '시간 전...'
        ELSE FLOOR(minutes_ago / (60*24)) || '일 전...'
        END as relative_time
FROM (
        SELECT post_id, author, content
                      , EXTRACT(DAY FROM(CURRENT_TIMESTAMP- post_time)) * 24 * 60 +
                        EXTRACT(HOUR FROM(CURRENT_TIMESTAMP- post_time)) * 60 + 
                        EXTRACT(MINUTE FROM(CURRENT_TIMESTAMP- post_time)) as minutes_ago
        FROM posts
      ) a;