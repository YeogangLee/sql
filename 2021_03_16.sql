WHERE 13]

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno BETWEEN 7800 AND 7899
OR empno BETWEEN 780 AND 789
OR empno = 78;


연산자 우선순위: 산술연산 >>> AND > OR
==> 헷갈리면 ()를 사용하여 우선순위를 조정하자

SQL - SUBSTR()
java - subString()
-- 리터럴 표기가 이렇게 언어마다 다른 것처럼, 코딩하다가 모르면 검색해보기 - 연산자 우선순위 등

SELECT *
FROM emp
WHERE ename = 'SMITH' OR ename = 'ALLEN' AND job = 'SALESMAN';
--          1         +         2         *       3
-- WHERE ename = 'SMITH' OR (ename = 'ALLEN' AND job = 'SALESMAN')

==> 직원의 이름이 ALLEN 이면서 job이 SALESMAN 이거나
    직원의 이름이 SMITH인 직원 정보를 조회
    
직원의 이름이 ALLEN 이거나 SMITH 이면서
job이 SALESMAN 인 직원을 조회

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND job = 'SALESMAN'; 


WHERE 14]
논리연산(AND, OR 실습 WHERE14)

- emp 테이블에서
1. job이 SALESMAN이거나
2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회하세요.
(1번 조건 또는 2번 조건을 만족하는 직원)

SELECT *
FROM emp
WHERE job = 'SALESMAN' 
   OR (empno BETWEEN 7800 AND 7899 OR empno BETWEEN 780 AND 789 OR empno = 78 
   AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));

-- 선생님 작성
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));


-- // 여기까지, WHERE 절의 기초 끝


#데이터 정렬                        #################
TABLE 객체에는 데이터를 저장/조회시 B@순서를 보장하지 않음@B
보편적으로 데이터가 입력된 순서대로 조회됨
항상 동일한 순서로 조회되는 것을 보장하지 않음
데이터가 삭제 되고 다른 데이터가 들어올 수도 있음

DESC user_tables;


-- 사이트 okky.kr

예전 이름 okjsp
jsp ==> java server page

개발자 커뮤니티 일 방문자수 1위
전반적으로 개발을 다루기 위해 도메인 변경
okjsp -> okky

개발자 포트폴리오 ...
구인 게시판
개발자의 분위기를 익혀보기를...

개발자 - 금업, 시기에 따라 내가 원하든 원치않든 그렇게 될 때가 있다
2009년 아이폰3 발명
국내 자바 개발자 시장 규모 => 웹 > 코틀린
자바 웹 개발자가 그 당시 안드로이드 코틀린으로 많이 넘어갔고,
웹 개발에 대한 수요는 있는데 공급이 부족한 상황이 만들어졌다.

꽃길? ... 국비지원과정학원 -> 인생이 원하는대로 흘러가진 않았을 거에요...
여러분들은 시기를 잘 만났어요.


#데이터 정렬 ORDER BY

ORDER BY
- ASC : 오름차순 (기본)
- DESC : 내림차순

필요한 이유 :
1. 테이블 객체는 순서를 보장하지 않는다.
=> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수 있다
2. 현실세계에서는 정렬된 데이터가 필요한 경우가 있다
=> 게시판의 게시글은 보편적으로 가장 최신글이 처음에 나오고, 가장 오래된 글이 맨 밑에 있다

SQL에서 정렬 : ORDER BY ==> SELECT -> FROM -> [WHERE] -> ORDER BY
정렬 방법 : ORDER BY 컬럼명 | 컬럼인덱스(순서) | 별칭 [정렬순서]
정렬 순서 : 기본 ASC(오름차순), DESC(내림차순)


SELECT *
FROM emp
ORDER BY ename;
-- A -> B -> C -> [D] -> F -> ... -> [Z]

1 -> 2 -> ... -> 100  : 오름차순 (ASC => DEFAULT 기본값)
100 -> 99 ... -> 1    : 내림차순 (DESC => 명시)

SELECT *
FROM emp
ORDER BY ename DESC;

SELECT *
FROM emp
ORDER BY job, sal; -- job을 기준으로 1번 정렬하고, sal을 기준으로 2번 정렬

SELECT *
FROM emp
ORDER BY job DESC, sal DESC;

SELECT *
FROM emp
ORDER BY job DESC, sal ASC, ename;


정렬 : 컬럼명이 아니라 select 절의 컬럼 순서 (index)

-- 컬럼 번호로 정렬 - INDEX로 정렬
SELECT *
FROM emp
ORDER BY 2; -- 2번째 컬럼을 기준으로 정렬해라, 2번째 컬럼 - ename 컬럼

SELECT empno, job, mgr
FROM emp
ORDER BY 2; -- 2번째 컬럼 - job 컬럼

-- ORDER BY를
-- 추천하지 않는 이유는, 아래처럼 컬럼을 추가하면 index 순서가 바뀌게 된다.
SELECT ename, empno, job, mgr
FROM emp
ORDER BY 2; -- 2번째 컬럼 - empno 컬럼

-- ALIAS 사용 가능
SELECT ename, empno, job, mgr AS m
FROM emp
ORDER BY m;


SQL 에서 정렬 : ORDER BY ==> SELECT -> FROM -> [WHERE] -> ORDER BY
정렬 방법 : ORDER BY 컬럼명 | 컬럼인덱스(순서) | 별칭 [정렬순서]
정렬 순서 : 기본 ASC(오름차순), DESC(내림차순)


ORDER BY 1]
데이터 정렬

- dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요
- dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요
* 컬럼명을 명시하지 않았습니다. 지난 수업시간에 배운 내용으로 올바른 컬럼을 찾아보세요.

DESC dept; 

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;


ORDER BY 2]
데이터 정렬

- emp 테이블에서 상여comm 정보가 있는 사람들만 조회하고,
상여를 많이 받는 사람이 먼저 조회되도록 정렬하고,
상여가 같을 경우 사번으로 내림차순 정렬하세요.
(상여가 0인 사람은 상여가 없는 것으로 간주)


SELECT *
FROM emp
WHERE comm IS NOT NULL
  AND comm != 0 
-- AND comm > 0
ORDER BY comm DESC, empno DESC;

ASC - 오름차순
DESC - 내림차순


ORDER BY 3]
데이터 정렬

- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군job 순으로 오름차순 정렬하고,
직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요.

SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- 지금 하는 내용들은 크게 어렵지 않은 것들이다.
ORDER BY 4]
데이터 정렬

- emp 테이블에서 10번 부서deptno 혹은 30번 부서에 속하는 사람 중
급여sal가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요.

SELECT *
FROM emp
WHERE deptno IN (10, 30) 
  AND sal > 1500
ORDER BY ename DESC;


#페이징처리(게시글) 
: 전체 데이터를 조회하는 게 아니라 페이지 사이즈가 정해졌을 때 원하는 페이지의 데이터만 가져오는 방법
 ==> 정렬 기준, 무엇을 기준으로? (일반적으로는 게시글의 작성일시 역순)
어려울 수도 있지만, 오라클을 쓰려면 꼭 알아야 하는 내용

(1. 400건을 다 조회하고 필요한 20건만 사용하는 방법 --> 전체 조회(400)
 2. 400건의 데이터 중 원하는 페이지의 20건만 조회 --> 페이징 처리(20) )
 
 페이징 처리시 고려할 변수 : 
 1. 페이지 번호 - 몇 번째 페이지를 보고 싶은지 
 2. 페이지 사이즈 - 몇 개의 항목을 보고 싶은지
 
ROWNUM: 행번호를 부여하는 특수 키워드 (오라클에서만 제공)
    * 제약사항
      ROWNUM 은 WHERE 절에서도 사용 가능하다
      단, ROWNUM의 사용을 1부터 사용하는 경우에만 사용 가능
      WHERE ROWNUM BETWEEN 1 AND 5 ==> O
      WHERE ROWNUM BETWEEN 6 AND 10 ==> X
      WHERE ROWNUM = 1; ==> O
      WHERE ROWNUM = 2; ==> X
      WHERE ROWNUM <[=] 10; ==> O -- 1부터 읽기 때문에 가능
      
      SQL절은,
      실행 순서: FROM => SELECT => ORDER BY
      ORDER BY와 ROWNUM 을 동시에 사용하면 정렬된 기준으로 ROWNUM 이 부여되지 않음
      SELECT 절이 먼저 실행되므로 ROWNUM 이 부여된 상태에서 ORDER BY 절에 의해 정렬됨
      -> 인라인 뷰가 필요한 이유
      
전체데이터 : 14건
페이지사이즈 : 5건
1번째 페이지 : 1~5
2번째 페이지 : 6~10
3번째 페이지 : 11~15(14)


인라인 뷰
ALIAS


SELECT empno, ename
FROM emp;

행번호를 각 행에 부여할 수 없을까?
-> ROWNUM 이라는 가상의 컬럼 이용

SELECT ROWNUM, empno, ename
FROM emp;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 5;


SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;
-- 행 번호가 이름에 의해 섞임

SQL의 실행 순서
FROM => SELECT => ORDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

(SELECT empno, ename
FROM emp); -- 이 자체로 테이블로 인식될 수 있다. 테이블은 어디? FROM 절에 온다.
==>
SELECT *
FROM (SELECT empno, ename 
      FROM emp); -- 인라인 뷰를 만들어 조회

SELECT deptno
FROM (SELECT empno, ename 
      FROM emp); -- 에러

순서를 역전시키기 위해 "인라인 뷰"를 사용
정렬을 먼저 하고, ROWNUM 을 부여하기 위해

SELECT *
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename);

SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename);

SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename)
WHERE ROWNUM BETWEEN 6 ADN 10; -- 1을 포함하지 않아 조회X


SELECT *
FROM 
(SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename));
-- 결과가 달라진 게 없음


SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename))
WHERE rn BETWEEN 1 AND 5;
WHERE rn BETWEEN 6 AND 10;
-- rn을 일반적인 컬럼으로 인식

-- // 오라클에서 사용하는 테이블 쿼리의 기본

FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename)
-- 정렬된 집합에
-- ROWNUM을 부여한 것
-- (SELECT ROWNUM rn, empno, ename
-- 이렇게 또 감싸준 이유는 WHERE ROWNUM을 사용할 수가 없기 때문


pageSize : 5건
1 page : rn BETWEEN 1 AND 5 ;
2 page : rn BETWEEN 6 AND 10 ;
3 page : rn BETWEEN 11 AND 15 ;
n page : rn BETWEEN n*5-4 AND n*5 ;
n page : rn BETWEEN n*pageSize-4 AND n*pageSize;
n page : rn BETWEEN (n-1)*pageSize+1 AND n*pageSize;
         
==>      rn BETWEEN (page-1)*pageSize + 1 AND page*pageSize ;         


SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename
FROM (SELECT empno, ename 
      FROM emp
      ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize ;
-- :page, :pageSize -> 바인딩 변수


-- 구글 검색 mysql paging
처음 배울 때는 mysql, maria DB가 쉽긴 하다
but 오라클은 DB랭킹에서 1위를 거의 놓친 적이 없다
예외적으로 카카오뱅크는 mysql 사용 - bc 훌륭한 DBA 보유 ...

유지 보수로 먹고 사는 회사가 많다.
우리가 무료로 만들어 드릴게요 
> 공짜X 유지보수료가 매달 발생하기 때문에

솔루션이란 그런 것, 내가 솔루션 깔아놓은 쪽은 그냥 돈길이죠.
ex. 도로명주소 - 한 번

연말정산 돈 받고 해주는 곳도 있다, 대기업은 손으로 하는 게 불가능
직원 1명당 1만원, 돈이 돈을 버는 구조

오늘을 기준으로 수업 태도가 갈릴 것
매 프로그래밍 언어, 수학 등
실력이 완만하게 늘지 않아요.
고비를 잘 넘기시길.


ROWNUM 1]
- emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요.
(정렬없이 진행하세요, 결과는 화면과 다를 수 있습니다.)
-- 정렬없이 진행하려면 뭘 없애야 하는 거지

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;


ROWNUM 2]
가상컬럼 ROWNUM

- ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요. -- emp 테이블은 행이 14개

SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 14;


ROWNUM 3]
가상컬럼 ROWNUM

- emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용했을 때의
11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요.

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename))
WHERE rn BETWEEN 11 AND 14;


-- 아까 받은 질문 내용

-- 모든 행에 ROWNUM을 부여하고 싶어요.
SELECT ROWNUM, * 
FROM emp;
-- 에러, * 외의 컬럼을 *와 같이 사용할 때는, *가 어디서 왔는지 명시해줘야 한다.
=>
SELECT ROWNUM, emp.*
FROM emp;


-- emp 테이블 이름을 ALIAS 해줄래요.
-- emp 테이블에 별칭을 쓸래요.

-- 에러
SELECT ROWNUM rn, emp.*
FROM emp e; 
-- 올바른 방법
SELECT ROWNUM rn, e.*
FROM emp e; 


SELECT ROWNUM rn, e.empno
FROM emp e, emp m, dept;


-- 앞의 쿼리문에 별칭 사용
SELECT a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename)) a
WHERE rn BETWEEN 11 AND 14;

