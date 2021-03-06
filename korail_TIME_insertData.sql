INSERT INTO TRAIN VALUES('1117','K1117','K');
INSERT INTO LINE VALUES('K1117');
COMMIT;

INSERT INTO LINE_ROUTE VALUES('K1117', '002', '001', 1, 9);
INSERT INTO LINE_ROUTE VALUES('K1117', '003', '002', 2, 10);
INSERT INTO LINE_ROUTE VALUES('K1117', '004', '003', 3, 11);

SELECT *
  FROM LINE_ROUTE
 WHERE LINE_NO = 'K1117';
 
DELETE FROM LINE_ROUTE WHERE LINE_NO = 'K1117';

--초 데이터 안 넣어도, 알아서 0으로 넣어준다
INSERT INTO LINE_TIME VALUES(TO_DATE('2021/04/20 07:11', 'YYYY/MM/DD HH24:MI:SS'), TO_DATE('2021/04/20 07:02', 'YYYY/MM/DD HH24:MI:SS'), 'K1117');

DELETE FROM LINE_TIME WHERE LINE_NO = 'K1117' AND START_TIME = TO_DATE('2021/04/20 07:12', 'YYYY/MM/DD HH24:MI:SS');

DELETE FROM LINE_TIME WHERE LINE_NO = 'K1117' AND END_TIME = TO_DATE('2021/04/20 07:32', 'YYYY/MM/DD HH24:MI:SS');

INSERT INTO LINE_TIME VALUES(TO_DATE('2021/04/20 07:21', 'YYYY/MM/DD HH24:MI:SS'), TO_DATE('2021/04/20 07:11', 'YYYY/MM/DD HH24:MI:SS'), 'K1117');
INSERT INTO LINE_TIME VALUES(TO_DATE('2021/04/20 07:32', 'YYYY/MM/DD HH24:MI:SS'), TO_DATE('2021/04/20 07:21', 'YYYY/MM/DD HH24:MI:SS'), 'K1117');

