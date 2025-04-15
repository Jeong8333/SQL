
CREATE TABLE questions(
    q_id NUMBER PRIMARY KEY
   ,q_content VARCHAR2(4000)
);
--drop table q_options;
CREATE TABLE q_options(
     o_id NUMBER
   , q_id NUMBER
   , o_content VARCHAR2(4000)
   ,FOREIGN KEY(q_id) REFERENCES questions(q_id)
   ,PRIMARY KEY(o_id, q_id)
);


SELECT a.q_id, a.q_content, b.o_id, b.o_content
FROM questions a
    ,q_options b
WHERE a.q_id = b.q_id
ORDER BY a.q_id, b.o_id;

CREATE TABLE q_result(
     user_id  VARCHAR2(1000)
    ,q_id     NUMBER
    ,o_id     NUMBER
    ,PRIMARY KEY(user_id, q_id)
);

INSERT INTO q_result(user_id, q_id, o_id) VALUES (:1, :2, :3);

DELETE FROM q_result WHERE user_id = :1;
