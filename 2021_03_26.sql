INSERT INTO 단건, 여러건

INSERT INTO 테이블명
SELECT ....

-- SUB QUERY를 이용해서도 UPDATE 가능, 근데 이것보다 편리한 게 MERGE
UPDATE 테이블명 SET 컬럼명1 = (스칼라 서브쿼리),
                   컬럼명2 = (스칼라 서브쿼리),
                   컬럼명3 = 'TEST';

연습1]                   
9999 사번;empno을 갖는 brown 직원;ename을 입력

DESC emp; -- 컬럼정보 확인

INSERT INTO emp (empno, ename) VALUES (9999, 'brown');
-- = INSERT INTO emp (ename, empno) VALUES ('brown', 9999);

-- 테이블 확인
SELECT *
FROM emp;

연습2]
9999번 직원의 deptno와 job 정보를 SMITH 사원의 deptno, job 정보로 업데이트

-- 시작
UPDATE emp SET deptno = '',
               job = ''
WHERE empno = 9999;               

-- 요구사항
SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';

-- ->
UPDATE emp SET deptno = (SELECT deptno
                         FROM emp
                         WHERE ename = 'SMITH'),
               job = (SELECT job
                      FROM emp
                      WHERE ename = 'SMITH')
WHERE empno = 9999;   

SELECT *
FROM emp
WHERE empno = 9999;

-- UPDATE 보다 편리한 MERGE 는 추후에...

DELETE : 기존에 존재하는 데이터를 삭제
DELETE 테이블명
WHERE 조건;

DELETE 테이블명;


삭제 테스트를 위한 데이터 입력
INSERT INTO emp (empno, ename) VALUES (9999, 'brown');

-- 삭제
DELETE emp
WHERE empno = 9999;


연습3]
mgr가 7698사번(BLAKE)인 직원들을 모두 삭제

SELECT *
FROM emp
WHERE empno IN (SELECT empno 
                FROM emp
                WHERE mgr = 7698);
-- 서브쿼리 먼저 확인하는 습관
-- 쿼리 실행 전에, 최종 결과를 예측할 수 있게 한다

DELETE emp
WHERE empno IN (SELECT empno 
                FROM emp
                WHERE mgr = 7698);

-- 삭제 후 ROLLBACK; 하면 삭제가 취소된다


DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다
이것을 UNDO 혹은 REDO LOG 라고 한다

오라클 공식문서 사진 DBMS 구조

!지금하는 것은 DML 이 아니기 때문에 주의해서 사용해야 한다.
=> DDL
   ROLLBACK 불가능 = 복구 불가
   주로 테스트 환경에서 사용

TRUNCATE
: 로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법

TRUNCATE TABLE 테이블명;
테이블에 있는 모든 데이터를 삭제할 때 사용


CREATE TABLE emp_test AS
SELECT *
FROM emp;

ROLLBACK;

SELECT *
FROM emp_test;

TRUNCATE TABLE emp_test;

ROLLBACK;

SELECT *
FROM emp_test;


트랜잭션
: 논리적인 일의 단위
ORACLE - DML 문장 시작할 때 트랜잭션 시작

COMMIT 트랜잭션 종료, 데이터 확정
ROLLBACK 트랜잭션에서 실행한 DML문 취소 트랜잭션 종료
==> 트랜잭션을 종료시키는 2가지 방법


트랜잭션 예시
- 게시글 입력시 (제목, 내용, 복수 개의 첨부파일) -- 첨부파일은 여러 개
- 게시글 테이블, 게시글 첨부파일 테이블
- 1. DML : 게시글 입력
- 2. DML : 게시글 첨부파일 입력
- 1번 DML 은 정상적으로 실행 후 2번 DML 실행시 에러가 발생한다면?
- 그냥 ROLLBACK 하는 게 편하다

ROLLBACK;


읽기 일관성 - 어렵다. SQL 작성에 영향이 있지는 않다
DAP 자격증 카페 - 심평원 채용 공고, 가산점 자격증 종류

읽기 일관성 레벨 ISOLATION LEVEL (0~3)
트랜잭션에서 실핸한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지 정의한 레벨(단계)

LEVEL 0 : READ UNCOMMITIED
- dirty read ; dirty 변경이 가해졌다, 변경되었다
  커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
  ORACLE에서는 지원을 하지 않음
  
LEVEL 1 : READ COMMITED
- 대부분의 DBMS 읽기 일관성 설정 레벨
- 커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다
  커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다
  
LEVEL 2 : REPEATABLE READ
- 선행 트랜잭션에서 읽은 데이터를
  후행 트랜잭션에서 수정하지 못하도록 방지
- 선행 트랜잭션에서 읽었던 데이터를
  트랜잭션의 마지막에서 다시 조회를 해도 동일한 결과가 나오게끔 유지
  
- 단, 신규 입력 데이터에 대해서는 막을 수 없음 -- 이걸 해결한 게 LEVEL3
  => Phantom Read (유령 읽기) - 없던 데이터가 조회되는 현상
  기존 데이터에 대해서는 동일한 데이터가 조회되도록 유지
  
- ORACLE 에서는 LEVEL2에 대해 공식적으로 지원하지 않으나
  FOR UPDATE 구문을 이용하여 효과를 만들어 낼 수 있다
  
LEVEL 3 : SERIALIZABLE READ 직렬화 읽기
- 후행 트랜잭션에서 수정, 입력 데이터 ...
- 신규 입력 데이터까지 처리
- 동일한 데이터에 대해 수정을 할 수 없게 만듦

다음주에 DB책 추천 ... 




이제까지 DML 배웠고, 이제 DDL
인덱스 INDEX
- 눈에 안 보여.
- 테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
  => 원하는 데이터를 빠르게 찾을 수 있다
  일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID 가 같이 저장됨

- ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념
          주소를 통해서 해당 행의 위치에 빠르게 접근 가능
          데이터가 입력될 때 생성

인덱스를 만든다는 건, 어떤 테이블과 함께 만든다는 것, 혼자 생성X
  
SELECT ROWNUM, emp.* -- 한정자를 사용하지 않고 *만 사용할 경우 오류
FROM emp;

SELECT ROWID, emp.*
FROM emp;

SELECT emp.*
FROM emp
WHERE ROWID = 'AAAE5dAAFAAAACPAAA';

SELECT emp.*
FROM emp
WHERE empno = 7369; -- 테이블의 행을 다 읽고 결과 반환

SELECT empno, ROWID
FROM emp
WHERE empno = 7782; -- 정렬된 테이블에서 목표 행을 찾으면 그 위치에서 남은 행을 신경쓰지 않고 결과 반환


예제]
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
-- DBMS_XPLAN = PACKAGE
-- TABLE 형태로 만들어준다

  
Rows 는 예측값 ...
Name 열까지만 해석해보기

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
-- TABLE ACCESS FULL이 나오면 테이블을 다 읽었다는 뜻 -> 비효율적
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7782)


인덱스 생성
그 전에 오라클 객체 생성 먼저 설명하자면,

오라클 객체 생성
CREATE 객체 타입 (INDEX, TABLE, ...) 객체명
-- ex. int 변수명

인덱스 생성
CREATE INDEX [UNIQUE] 인덱스이름 ON 테이블명(컬럼1, 컬럼2, ...);
-- UNIQUE : 유일해야 한다

CREATE UNIQUE INDEX PK_emp ON emp(empno);

-- 인덱스 생성 후 실행계획 다시 보기
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)

-- access는 접근을 했다는 뜻 -> 빠르다
-- 불필요한 데이터는 읽지 않았다는 뜻

-- empno 컬럼만 조회
-- 실행계획 생성
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;
-- 실행계획 조회
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 -- 테이블을 읽는 로직이 없음
 -- 사용자 요구 : empno 컬럼 -> index에 이미 존재, 테이블 접근 불필요
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)


-- 인덱스 삭제
DROP INDEX PK_EMP;

-- 다른 인덱스 생성
-- 비교 : UNIQUE INDEX vs 일반 INDEX
=> 인덱스를 한 번 읽었냐 여러 번 읽었냐의 차이

CREATE INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP     |     1 |       |     0   (0)| 00:00:01 | -- 위의 행
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)


중복을 허용
같은 값이 나오지 않을 때까지 조회
정렬이 보장되어 있으므로 추가적인 조회가 불필요


INDEX 하나 더 생성
job 컬럼을 기준으로

CREATE INDEX idx_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER BY job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')


-- 조건 하나 더 추가
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

   1 - filter("ENAME" LIKE 'C%')    -- 3개 읽고서 버린 것
   2 - access("JOB"='MANAGER')


-- 인덱스 추가, job과 ename
CREATE INDEX IDX_EMP_03 ON emp (job, ename);

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename; -- 지금 이런 형태의 인덱스를 만든 것

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
필터 조건이 액세스 조건에서 해결되는 것
filter : 읽고 나서 버렸다
access : 그 값을 읽고 찾아갔다


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE '%C'; -- 정렬의 의미가 없는 것
                       -- 4건의 인덱스를 읽음 
-- EXPLAIN 줄을 제외하고 쿼리문을 실행해보면 출력행이 없다                    
-- => 테이블에 접근할 데이터가 없음
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);




-->
2021.03.29.

SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

job, ename으로 구성된 IDX_03 인덱스 삭제

객체 생성
CREATE 객체타입, 객체명;

객체 삭제
DROP 객체타입, 객체명;

DROP INDEX idx_emp_03;

column_position - 컬럼 순서 중요, 이 순서에 따라 결과가 달라질 수 있다

CREATE INDEX idx_emp_04 ON emp (ename, job);


- 지난주와 동일하게 실행계획 만들기
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

- TABLE() 함수 이용해서 실행계획 조회
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
-- RANGE SCAN : 유니크 옵션을 사용하지 않아서, 중복이 가능하기 때문, 원하는 게 나올 때까지 찾아 가야 한다
-- 지금 데이터 2건을 읽음
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')


-- 지금까지 FROM 절에 테이블이 1개만 오는 경우만 공부했다

SELECT ROWID, dept.*
FROM dept;

-- 부서번호를 기준으로
CREATE INDEX idx_dept_01 ON dept (deptno);

SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;
-- 테이블을 동시에 읽지는 못 함
-- 테이블 하나를 먼저 읽고 나머지 하나를 읽는 방식

각 테이블의 데이터에 접근하는 방법
- emp
1. table full access
2. idx_emp_01 -- 아마 오라클은 이걸 사용할 것이다 ... 논유니크 ... 상수조건이 어쩌구
3. idx_emp_02
4. idx_emp_04

- dept
1. table full access
2. idx_emp_01

emp(4) => dept(2) : 방법 8가지 존재
dept(2) => emp(4) : 방법 8가지 존재
=> 총 16가지

시스템에 따라 중요시하는 성능이 다르다
- 응답성 : OLTP (Online Transaction Processing) - 네이버, 우리가 ORACLE을 사용하는 목적
- 퍼포먼스 : OLAP (Online Analysis Processing) 
            ex. 은행이자 계산 - 실시간으로 결과를 보여주지 않아도 되는 경우

접근방법 * 테이블 ^ 개수

오라클이 언제나 정답인 방법을 찾을 수 있는 건 아니다
응답성과 퍼포먼스 둘 다 고려하기 때문


EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
-- WHERE emp.deptno = dept.deptno
-- emp 테이블을 읽고나면 emp.deptno은 상수조건이 된다.
WHERE 20 = dept.deptno
  AND emp.empno = 7788;
  
--SELECT dname, loc
--FROM dept
--WHERE dept.deptno = 20;
  
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

7788이 위치를 바로 찾을 수 있는 이유 **
-> 정렬된 데이터들 **
인덱스는 트리형태로 구성되어 있다

Index Access
- 인덱스의 장점
인덱스는 언제 유리 ? 
소수의 데이터에 접근할 때 -> 응답 속도가 필요할 때
   
   DBMS의 매커니즘이 그렇다
   Index를 사용하는 Input/Output Single Block I/O
   
- 인덱스의 단점
1. 저장 공간 : 인덱스가 추가된 테이블을 저장할 공간이 필요하다.
2. 많은 데이터는 느린 속도 : 다량의 데이터를 인덱스로 접근할 경우 속도가 느리다(2~3000건)

웹 시스템에서 인덱스는 필수 -> 웹에서는 모든 데이터를 보여주는 경우는 없기 때문


Table Access
테이블의 모든 데이터를 읽고서 처리를 해야 하는 경우,
인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
- I/O 기준이 multi block 


DDL (테이블에 인덱스가 많다면)
1. 테이블의 빈 공간을 찾아 데이터를 입력한다
2. 인덱스의 구성 컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장
3. 인덱스는 B*트리(Balanced Tree) 구조
  : root node부터 leaf node까지의 depth가 항상 같도록 밸런스를 유지한다
4. 데이터 입력으로 밸런스가 무너질 경우 밸런스를 맞추는 추가 작업이 필요
 
5. 2~4까지의 과정을 각 인덱스 별로 반복한다

인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터 변경시에 부하가 생긴다 
+ 인덱스가 많아질 경우 인덱스 개수만큼 위의 과정이 반복된다

하나의 쿼리를 위한 인덱스 설계는 쉽다.
BUT 시스템에서 실행되는 모든 쿼리를 분석해서 적절한 개수의 최적의 인덱스를 설계하는 것이 어렵다.


전 직장, 테이블은 'TB_'라는 접두어 사용
FROM 절에 올 수 있는 2가지 - 테이블, 뷰
즉각 구분할 수 있게 해줌


주문/상담 일자 인덱스
: 작아질 수가 없는 숫자 -> 우하향 트리로 성장 -> B* 트리, 밸런스 조정

실습 idx3] - 해보고 싶은 사람만 해봐라 ..


- 달력 만들기 쿼리
응용기술이 많은 문제 ..
알면 나중에 쿼리로 문제 생기지는 않을 것

- 데이터의 행을 열로 바꾸는 방법
- 레포트 쿼리에서 활용할 수 있는 예제 연습

주어진 상황 - 년월 : 201905

달력만들기]
주어진것 : 년월 6자리 문자열 ex. 202103
만들것 : 해당 년월에 해당하는 달력 (7칸 테이블 = 7컬럼 테이블)

20210301 - 날짜, 문자열
20210302
20210303
...
20210331

-- LEVEL은 1부터 시작
SELECT *
FROM dual
CONNECT BY LEVEL <= 10;

SELECT dummy, LEVEL -- CONNECT BY LEVEL 을 사용하면 사용할 수 있는 LEVEL 컬럼
FROM dual
CONNECT BY LEVEL <= 10;

-- 마지막 날짜 출력해보기
'202103' ==> 31;

-- 틀린 내 답
SELECT LAST_DAY(TO_CHAR('202103','YYYYMM'), DD)
FROM dual;

-- 답
SELECT TO_CHAR(LAST_DAY(TO_DATE('202103','YYYYMM')), 'DD')
FROM dual;

-- 바인딩 변수, 매월 다른 값 입력 받기 가능
SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD')
FROM dual;

-- 위의 LEVEL 이용 쿼리에 적용
SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD');

SELECT SYSDATE, LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD');

SELECT SYSDATE + LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD');

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) DT -- 1을 빼주지 않으면 다음달 1일까지 출력
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD');

날짜 포맷팅
주차 : IW
주간 요일 : D

SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) DT,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') D,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') IW
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD');


-- 인라인뷰 사용
SELECT DT, D, IW
FROM (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) DT,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') D,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') IW
        FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD'));


SELECT dt, d
    일요일이면 dt-아니면 null, 월요일이면 dt-아니면 null, 
    화요일이면 dt-아니면 null, 수요일이면 dt-아니면 null,
    목요일이면 dt-아니면 null, 금요일이면 dt-아니면 null,
    토요일이면 dt-아니면 null

-- CASE END로 하면 너무 길어져서 DECODE로 작성
SELECT dt, d
    DECODE(d, 1, dt) sun, DECODE(d, 2, dt) mon,
    DECODE(d, 3, dt) tue, DECODE(d, 4, dt) wed,
    DECODE(d, 5, dt) thr, DECODE(d, 6, dt) fri,
    DECODE(d, 7, dt) sat
FROM dual;


MAX, MIN 중 민 함수가 조금 더 빠르다. 그래서 민 함수 사용
SELECT iw,
    MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,
    MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
    MIN(DECODE(d, 5, dt)) thr, MIN(DECODE(d, 6, dt)) fri,
    MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) DT,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') D,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD'))
GROUP BY iw
ORDER BY iw;

-- 일요일이 한 주씩 당겨져 있는 것 해결, 일요일에 1 더해주기
SELECT DECODE(d, 1, iw+1, iw), -- alias 별칭 사용하면 오류
    MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,
    MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
    MIN(DECODE(d, 5, dt)) thr, MIN(DECODE(d, 6, dt)) fri,
    MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) DT,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') D,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


SELECT --DECODE(d, 1, iw+1, iw), -- 주석처리해도 결과는 동일
    MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,
    MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
    MIN(DECODE(d, 5, dt)) thr, MIN(DECODE(d, 6, dt)) fri,
    MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) DT,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') D,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


201912
이상한 결과
GROUP BY 때문 .. 주차 정보에 문제 발생 -> iw로 GROUP BY 를 하면 안 된다 

SELECT DECODE(d, 1, iw+1, iw), -- 주차 정보 조회를 위해 주석 해제, 1주차로 잘못 표기돼 있음
    MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,
    MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
    MIN(DECODE(d, 5, dt)) thr, MIN(DECODE(d, 6, dt)) fri,
    MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1) DT,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'D') D,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL - 1), 'IW') IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


CONNECT BY LEVEL
계층쿼리의 일종

계층쿼리
SELECT empno, ename, mgr
FROM emp;

                                KING
                BLAKE           JONES           CLARK
    JAMES ALLEN WARD TURNER MARTIN              MILLER
                            FORD    SCOTT

KING

 BLAKE           JONES           CLARK

  JAMES ALLEN WARD TURNER MARTIN              

                  FORD    SCOTT
                                  MILLER
                   SMITH   ADAMS
                   
KING

_BLAKE           _JONES           _CLARK

__JAMES __ALLEN __WARD __TURNER __MARTIN              

                 __FORD    __SCOTT
                                  __MILLER
                                  
                 ___SMITH  ___ADAMS
                   
                   
BOM : Bill of Material, 그냥 설명서
오라클을 사용하는 큰 이유 중 하나 - 계층쿼리

계층쿼리 
- 조직도, 게시판(답변형 게시글, 대댓글)
- 데이터의 상하 관계를 나타내는 쿼리
        
사용 방법
1. 시작 위치를 설정
2. 행과 행의 연결 조건을 기술

-- 시작 조건 기술
SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839

PRIOR
-- PRIOR in 사전 : 이전의, 사전의 이란 의미
-- 오라클에서는 '이미 읽은 데이터'로 해석
-- 컬럼에 붙는 것, 내가 이미 읽은 행이다
이미 읽은 데이터   앞으로 읽어야 할 데이터
KING의 사번 = mgr 컬럼의 값이 KING의 사번인 녀석
empno = mgr

CONNECT BY 내가 읽은 행의 사번 = 앞으로 읽을 행의 MGR 칼럼
CONNECT BY PRIOR empno = mgr; -- 매니저 녀석과 연결을 하겠다


SELECT empno, ename, mgr
FROM emp
START WITH empno = 7839 -- KING, 제일 위의 ROUTE
CONNECT BY PRIOR empno = mgr;

-- 존스 밑에 있는 직원들 조회
--> 시작 위치만 바꿔주기
SELECT empno, ename, mgr
FROM emp
START WITH empno = 7566 -- JONES
CONNECT BY PRIOR empno = mgr;

- LEVEL 키워드 사용 가능
SELECT empno, ename, mgr, LEVEL -- LEVEL 은 depth를 의미
FROM emp
START WITH empno = 7566 -- JONES
CONNECT BY PRIOR empno = mgr;


함수 배울 때 L 패드 배웠었죠.
SELECT LPAD('TEST', 1*10, '*')
FROM dual;
-- ******TEST

-- LPAD 함수를 이용해 계층구조로 표현
SELECT empno, LPAD(' ', LEVEL*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;

-- KING 앞의 공백 삭제 - ORACLE의 INDEX는 1부터 시작하기 때문
-- 이렇게 LPAD 함수 이용해서 꾸미는 예제가 많다
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
--CONNECT BY mgr = PRIOR empno AND deptno = PRIOR deptno;
CONNECT BY mgr = PRIOR empno;
-- AND deptno = PRIOR deptno;
CONNECT BY PRIOR 은 분리해서 사용할 수도 있다, 무조건 붙어서 사용하는 키워드가 X


계층쿼리 방향
좋고 나쁨은 없고 용도에 따라 구분하여 사용

상향식 : 최하위 노드LEAF NODE에서 자신의 부모를 방문하는 형태
하향식 : 최상위 노드ROOT NODE에서 모든 자식 노드를 방문하는 형태

상향식 쿼리
SMITH(7369)부터 시작하여 노드의 부모를 따라가는 계층형 쿼리 작성
--> 잎사귀 노드의 레벨이 1, 루트 노드의 레벨이 4

SELECT empno, ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
--CONNECT BY
--;
--조건 => 내가 읽은 행의 매니저 번호를 사번으로 하는 직원을 찾아가는 방식
-->
CONNECT BY PRIOR mgr = empno;
-- CONNECT BY SMITH의 mgr 컬럼값 = 앞으로 읽을 행의 empno

-> SMITH - FORD - JONES - KING






