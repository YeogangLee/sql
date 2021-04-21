CREATE USER korail IDENTIFIED BY JAVA;

GRANT CONNECT, RESOURCE, DBA TO korail;

ALTER USER korail IDENTIFIED BY java REPLACE JAVA;
--ALTER USER USER IDENTIFIED BY "새비밀번호"  REPLACE  "이전비밀번호" ;
--출처: https://devzeroty.tistory.com/entry/ORACLE-비밀번호-변경-방법 [Dev Story..]

CREATE USER korail2 IDENTIFIED BY java;

GRANT CONNECT, RESOURCE, DBA TO korail2;