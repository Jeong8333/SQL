
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

SELECT a.q_id
     , a.q_content
     , b.o_id, b.o_content
FROM questions a, q_options b
WHERE a.q_id = b.q_id
ORDER BY a.q_id, b.o_id;