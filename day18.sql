-- �������� ���丮 ����(dba���� �ʿ�) �� ���� �ο�
CREATE OR  REPLACE DIRECTORY dump_sql AS 'c:/dev/sql';
GRANT READ, WRITE ON DIRECTORY dump_sql TO jdbc;

-- import ��ɾ� (CMD ����)
-- impdp jdbc/jdbc DIRECTORY=dump_sql DUMPFILE=JDBC_MOVIE.DMP

-- export ��� (���� ��ü)
--expdp system/oracle@exe schemas=jdbc DIRECTORY=dump_sql DUMPFILE=spring_jdbc.dmp
-- export Ư�� ���̺�
--expdp jdbc/jdbc DIRECTORY=dump_sql DUMPFILE=jdbc_dir.dmp TABLES=movie_box_office


SELECT DISTINCT movie_nm, open_dt
FROM movie_box_office
ORDER BY open_dt DESC, movie_nm;

SELECT movie_nm
FROM movie_box_office
GROUP BY movie_nm
ORDER BY MAX(open_dt) DESC, movie_nm;

SELECT to_char(target_dt, 'YYYY-MM-DD') as target_dt
     , sales_acc
     , audi_acc
FROM movie_box_office
WHERE movie_nm = '�º�'
ORDER BY target_dt;