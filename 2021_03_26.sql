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



