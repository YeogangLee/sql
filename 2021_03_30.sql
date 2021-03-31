SELECT
FROM
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY

순서 : FROM -> [START WITH] -> WHERE -> GROUP BY -> SELECT -> ORDER BY

가지치기 : Pruning branch

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename ename, mgr
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


조건을 줄 수 있는 부분 2가지
1. WHERE - 위 순서를 보면, 계층 구조(쿼리)가 다 완성된 후 행을 제한
2. CONNECT BY

-- 1. WHERE 
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename ename, mgr, deptno, job
FROM emp
WHERE job != 'ANALYST' -- 아담스의 mgr, 스미스의 mgr 조회X
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

KING                PRESIDENT
    JONES           MANAGER
--        SCOTT       ANALYST 
            ADAMS   CLERK
--        FORD        ANALYST
            SMITH   CLERK

-- 2. CONNECT BY
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename ename, mgr, deptno, job
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr AND job != 'ANALYST';
-- 직원을 찾아가는데, 애널리스트가 아닌 직원을 찾아가는 것
-- 그러면 애널리스트 직원과, 그 직원의 하위에 있는 직원까지 조회X

KING                PRESIDENT
    JONES           MANAGER
--        SCOTT       ANALYST 
--            ADAMS   CLERK
--        FORD        ANALYST
--            SMITH   CLERK


계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값

SELECT LPAD(' ', (LEVEL-1)*4) || ename ename, CONNECT_BY_ROOT(ename) root_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

-- 하향식 구조에서 루트가 1개가 아닌 경우가 있다
-- 게시판 같은 경우는 루트가 많다
글1
    답글1
글2
    답글1
 
계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
-- 이 함수를 인터넷에서 찾아보면
-- LTRIM 함수를 같이 사용하는 경우가 많다, 최상위 노드 앞에 붙는 - 문자를 지우기 위해

SELECT LPAD(' ', (LEVEL-1)*4) || ename ename,
        CONNECT_BY_ROOT(ename) root_ename,
--        SYS_CONNECT_BY_PATH(ename, '-') path_ename
        LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


SELECT LPAD(' ', (LEVEL-1)*4) || ename ename,
        CONNECT_BY_ROOT(ename) root_ename,
--        SYS_CONNECT_BY_PATH(ename, '-') path_ename
        LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename,
        INSTR('TEST', 'T'),
        INSTR('TEST', 'T', 2)
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;


마이크로소프트 API 문서 MSDN
자바 API 문서는 불친절하다
이런 거 해석 못하면, 기관총 놔두고 칼 사용하는 모양
]
regex 정규식을 의미
String str = "KING-JONES-SCOTT-ADAMS";
str.split("-");

개발자들은 되는지 안되는지 
알고 접근하는 것과 모르고 접근하는 것은 다르다
심리적으로나 ...


계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
3. CONNECT_BY_ISLEAF : CHILD가 없는 LEAF NODE 여부 0 - FALSE (NO LEAF node) / 1 - TRUE(LEAF node)
   IS 를 포함하는 키워드 -> 반환형이 Boolean 논리형인 경우가 많다 -> ORACLE에는 Boolean 자료형이 없다 -> 0, 1을 반환
-- 메탈리카 no leaf clover의 생각나는 ..

계층이 있는 데이터들이 생각보다 많다, 대략 15% 정도
계층쿼리를 배웠으니, 끝을 본다는 생각으로 저 함수 3개 외워둘것


-- 실습 시작
-- 실습파일에서 '게시글 계층형쿼리 샘플 자료' 테이블 추가

SELECT *
FROM board_test;

parent_seq가 null 값이면 자식이 없는, 일반 노드
        
SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
-- START WITH SEQ IN (1, 2, 4) -- 게시글은 언제든 추가, 삭제될 수 있으므로 값이 고정되어 있는 이런 표현은 좋지 않다
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq;
-- ORACLE이 아닌 다른 DB에서는 이런 계층쿼리를 만들 때 제약이 많다

SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
-- START WITH SEQ IN (1, 2, 4) -- 게시글은 언제든 추가, 삭제될 수 있으므로 값이 고정되어 있는 이런 표현은 좋지 않다
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
--ORDER BY SEQ DESC; -- 이렇게 하면 계층 구조가 깨진다, 답글의 순서가 엉망
ORDER SIBLINGS BY SEQ DESC;
-- SIBLINGS : 계층 구조 유지 키워드

-- 여기까지 지금의 문제
-- : SEQ가 DESC이라 나중에 달린 답글(열 번째 글)이 기존 답글(다섯 번째 글)보다 상위에 위치하게 된다.
네번째 글입니다
    열번째 글은 네번째 글의 답글입니다
        열한번째 글은 열번째 글의 답글입니다
    다섯번째 글은 네번째 글의 답글입니다
        여덟번째 글은 다섯번째 글의 답글입니다
        
계층쿼리 (생각해볼거리)
게시판의 댓글, 대댓글 -> 시간순으로 정리

시작(ROOT)글은 작성 순서의 역순으로
답글은 작성 순서대로 정렬
: 2개의 기준이 필요
=> 첫 번째 정렬조건으로 정렬 후, 두 번째 정렬조건으로 넘어가기

-- 리프노드가 최상위노드를 만나기 전까지 하위조회
-- 인라인뷰?


SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY () DESC, seq ASC;
: 2개의 기준이 필요
=> 첫 번째 정렬조건으로 정렬 후, 두 번째 정렬조건으로 넘어가기
루트 노드의 seq번호를 각 루트 노드의 모든 하위 노드에 부여하여, seq번호 공통점을 가지고 있는 한 그룹, 컬럼으로서 취급하기


- 시작 글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가
ALTER TABLE board_test ADD (gn NUMBER);
DESC board_test;

UPDATE board_test SET gn = 1
WHERE seq IN (1, 9);

UPDATE board_test SET gn = 2
WHERE seq IN (2, 3);

UPDATE board_test SET gn = 4
WHERE seq IN (1, 2, 3, 9);
commit;


SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq;
-- ORDER SIBLINGS BY () DESC, seq ASC;

SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

-- 인터넷에 '게시판 모델링'을 검색하면
-- 수업시간에 했던 방식이랑 다른 것들이 되게 많을 거다.

SELECT gn, CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

gn 대신 CONNECT_BY_ROOT(seq)를 이용해서 가능?
order by에 CONNECT_BY_ROOT() 사용 불가능 -> 함수가 리턴한 값을 알리아스 처리 후 인라인 뷰로 밖에서 조회

-- 정렬 전
SELECT *
FROM  
(SELECT CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq);

-- 정렬 후
SELECT *
FROM  
(SELECT CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq)
ORDER BY root_seq DESC, seq ASC;


최종 비교
-- GN 컬럼 생성 및 사용
SELECT gn, CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

-- CONNECT_BY_ROOT(컬럼명) 사용
SELECT *
FROM  
    (SELECT CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
    FROM board_test
    START WITH PARENT_SEQ IS NULL
    CONNECT BY PRIOR seq = parent_seq)
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY root_seq DESC, seq ASC;


SELECT a.*
FROM
    (SELECT ROWNUM rn, empno, ename
     FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename) ) a
WHERE rn BETWEEN 11 AND 14;


SELECT *
FROM
    (SELECT ROWNUM rn, a.*
     FROM
        (SELECT empno, ename
        FROM emp
        ORDER BY ename) a)
WHERE rn BETWEEN 11 AND 14;


-- 페이징 처리로 응용, 3월 16일 sql 파일 참고
pageSize : 5
page : 2

SELECT *
FROM
    (SELECT ROWNUM rn, a.*
     FROM
        (SELECT gn, CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
            FROM board_test
            START WITH PARENT_SEQ IS NULL
            CONNECT BY PRIOR seq = parent_seq
            ORDER SIBLINGS BY gn DESC, seq ASC) a)
WHERE rn BETWEEN 6 AND 10;


-- 다음 수업시간 3교시 예습
SELECT MAX(sal)
FROM emp
WHERE deptno = 10;

그 사람이 누군데? - 서브쿼리 이용

SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal)
            FROM emp
            WHERE deptno = 10);

--
주식
전일대비 : 현재행의 종가 - 이전 행의 종가

SQL은 행 연산을 지원하지 않는다
=> 분석함수를 이용

분석함수(WINDOW 함수)
SQL에서 행간 연산을 지원하는 함수
-- 실무에 있는 사람도 분석 함수를 모르는 경우가 많다.
-- 알면 쉬운데, 모르면 코드가 길어진다.

해당 행의 범위를 넘어서 다른 행과 연산이 가능
- SQL의 약점 보완
- 이전 행의 특정 컬럼을 참조
- 특정 범위 행들의 컬럼의 합
- 특정 범위의 행들 중 특정 컬럼을 기준으로 순위, 행번호 부여

-- 그룹함수
- SUM, COUNT, AVG, MAX, MIN
- RANK, LEAD, LAG, ...


분석, window 함수 도전해보기 실습 0]
사원의 부서별 급여sql별 순위 구하기
emp 테이블 사용

SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC;

SELECT ename, sal, deptno, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sel_rank
FROM emp
ORDER BY deptno, sal DESC;

SELECT ename, sal, deptno, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sel_rank
FROM emp;


RANK() OVER(PARTITION BY deptno ORDER BY  sal DESC) sal_rank
PARTITION BY 그룹
ORDER BY 그룹 내 순서
DESC 그룹 내 정렬

SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC;

SELECT a.*, ROWNUM rn
FROM
    (SELECT ename, sal, deptno
    FROM emp
    ORDER BY
    deptno, sal DESC) a;


SELECT ROWNUM rn
FROM emp;

SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno;

어떤 조건을 사용해서 ...
BETWEEN 사용



SELECT a.rn
FROM 
    (SELECT ROWNUM rn
    FROM emp) a,
    
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno
    ORDER BY deptno) b
  WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn;
-- 이 상태-정렬된 상태에서 1~14번호만 부여 -> 인라인 뷰 사용

SELECT ROWNUM rn, rank
FROM
(SELECT a.rn rank
FROM 
    (SELECT ROWNUM rn
    FROM emp) a,
    
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno
    ORDER BY deptno) b
  WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn);

-- 놓침

SELECT a.ename, a.sal, a.deptno, b.rank
FROM 
(SELECT a.*, ROWNUM rn
FROM 
(SELECT ename, sal, deptno, rank

SELECT ROWNUM rn, rank
FROM
(SELECT a.rn rank
FROM 
    (SELECT ROWNUM rn
    FROM emp) a,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno
    ORDER BY deptno) b
  WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn) b
WHERE a.rn = b.rn;


-- 자격증
순위 관련 함수
1. RANK : 동일 값에 대해 동일 순위를 부여하고, 후순위는 동일 값만 건너뛴다
       ex. 1등이 2명이면 그 다음 순위는 3위
2. DENSE_RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 이어서 부여한다
             ex. 1등이 2명이면 그 다음 순위는 2위
dense - 밀집한, 건너뛰지 않는다는 의미로 이런 네이밍
density - 
3. ROW_NUMBER : 행의 중복 없이 행에 순차적인 번호를 부여(ROWNUM) 
-- SQLD 시험에 차이점 자주 출제
=> 중복 값을 어떻게 처리하는가

-- 4~8행 주목
SELECT ename, sal, deptno, 
       RANK() OVER(PARTITION BY deptno ORDER BY  sal DESC) sal_rank,
       DENSE_RANK() OVER(PARTITION BY deptno ORDER BY  sal DESC) sal_dense_rank,
       ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY  sal DESC) sal_row_number
FROM emp;

-- 올림픽은 메달을 어떻게 처리하지? RANK VS DENSE_RANK ?


SELECT WINDOW_FUNCTION([인자]) OVER ( [PARTITION BY 컬럼] [ORDER BY 컬럼] )
FROM ....

PARTITION BY : 영역 설정
ORDER BY (ASC/DESC) : 영역 안에서의 순서 정하기


실습 ana1]
- 사원의 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요
- 단 급여가 동일할 경우 사번이 빠른 사람이 높은 순위가 되도록 작성하세요
;
SELECT ename, sal, deptno, sal,
       RANK() OVER(ORDER BY sal DESC) sal_rank,
       DENSE_RANK() OVER(ORDER BY sal DESC) sal_dense_rank,
       ROW_NUMBER() OVER(ORDER BY sal DESC) sal_row_number
FROM emp
GROUP BY sal;

-- not a GROUP BY expression
-- GROUP BY만 쓰면 보이는 에러 문구

ana1]
SELECT dpetno, COUNT(*)
FROM emp
GROUP BY deptno;

-- 전체직원의 수
SELECT COUNT(*)
FROM emp;

이것과 비슷한 형태

SELECT ename, sal, deptno, sal,
       RANK() OVER(ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER(ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER(ORDER BY sal DESC, empno) sal_row_number
FROM emp;

-- 사번은 중복이 안 되고, 그래서 동순위가 나올 수 없는 형태


실습 no_ana2]
기존의 배운 내용을 활용하여, 모든 사원에 대해 
사원번호, 사원이름, 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리를 작성하세요

SELECT empno, ename, deptno, COUNT(*) cnt
FROM emp
ORDER BY deptno;
-- 부서번호 안에 있는 사람을 어떻게 세냐


SELECT empno, ename, deptno
FROM emp;

SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

SELECT empno, ename, deptno,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- 오늘 계층쿼리 3시간, 분석함수 1시간
-- 오라클을 사용하는 회사에서는 많이 사용하는 내용이니까 잘 공부해둬라.
-- 어려울 수 있어도 반복하며 풀면 잘 될 거다.

