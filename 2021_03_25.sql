
sub6]
cycle 테이블을 이용하여 cid=1인 고객이 애음하는 제품 중 
cid=2인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요

SELECT *
FROM cycle;

SELECT *
FROM cycle
WHERE cid = 1
  AND pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2);


SELECT pid
FROM cycle
WHERE cid = 1;
-- 100, 400

2번 고객이 먹는 제품에 대해서만 1번 고객이 먹는 애음 정보조회

SELECT pid
FROM cycle
WHERE cid = 2;
-- 100, 200


sub7]
customer, cycle, product 테이블을 이용하여
cid = 1인 고객이 애음하는 제품 중
cid = 2인 고객도 애음하는 제품의 애음정보를 조회하고
고객명과 제품명까지 포함하는 쿼리 작성

+ pnm, cnm
SELECT *
FROM cycle, customer, product
WHERE cycle.cid = 1 -- 위에 3행만 실행 -> 조건 없는 크로스 조인 5 * 3 * 4 = 60
  AND cycle.cid = customer.cid -- 5 * 4 
  AND cycle.pid = product.pid
--AND product.pid IN (SELECT pid
  AND cycle.pid IN (SELECT pid
                FROM cycle
                WHERE cid = 2);

연습? => 스프레드 시트에 직접 그려보기, 행 색칠


EXISTS 서브쿼리 연산자 : 단항
IN : WHERE 컬럼 | EXPRESSION IN (값1,값2,값3...)
EXISTS : WHERE EXISTS(서브쿼리)
        ==> 서브쿼리의 실행결과로 조회되는 행이 **하나라도** 있으면 TRUE, 없으면 FALSE
            EXISTS 연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 서브쿼리 둘 다 사용 가능하지만,
            행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다
            
            서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면
            더 이상 진행하지 않고 효율적으로 일을 끊어 버린다
            서브쿼리가 1000건이라 하더라도 10번째 행에서 EXISTS 연산을 만족하는 행을 발견하면
            나머지 990건 정도의 데이터는 확인하지 않는다
            
연산자 : 몇 항

-- 매니저가 존재하는 직원
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT *
FROM emp e
WHERE EXISTS (SELECT empno
              FROM  emp m
              WHERE e.mgr = m.empno);
              -- WHERE 7902 = m.empno); 조회 가능 -> 참, 값에 상관없이 참, 거짓 판단
              
SELECT *
FROM emp e
WHERE EXISTS (SELECT *
              FROM  dual); -- 항상 참
              
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'   -- EXISTS의 서브쿼리의 SELECT 자리에는 관습적으로 'X'를 많이 사용한다
              FROM  dual); -- 연산이 값에 영향을 받지 않으므로, 무슨 값이 오든 상관이 없다
              

-- 존재여부를 효율적으로 따지기 -> EXISTS                             
SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);
-- 운이 좋으면 한 번에 실행이 끝날 수도 있다


sql 칠거지악
2번째 EXISTS 사용

sub8] x

sub9]
cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하는 제품을 조회하는 쿼리를
EXISTS 연산자를 이용하여 작성하세요

-- 문제의 테이블 모양을 보니
SELECT *
FROM product;

-- 1번 고객이 애음하는 제품 조회
SELECT *
FROM cycle
WHERE cid = 1;

-- 서브 쿼리 이용
SELECT *
FROM product
WHERE EXISTS (SELECT *
                FROM cycle
                WHERE cid = 1
                  AND product.pid = cycle.pid);

-- 애음하지 않는 제품? => NOT EXISTS
SELECT *
FROM product
WHERE NOT EXISTS (SELECT *
                    FROM cycle
                    WHERE cid = 1
                      AND product.pid = cycle.pid);

SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
                    FROM cycle
                    WHERE cid = 1
                      AND product.pid = cycle.pid);


집합연산
UNION(교집합 선이없다, 우리가 알고 있는 일반적인 합집합), 
UNION ALL(중복을 허용하는 집합), INTERSECT, MINUS
UNION ALL : {a, b} U {a, c} = {a, a, b, c}

집합연산
- 집합연산
  - 행을 확장 -> 위 아래
    위아래 집합의 col의 개수와 타입이 일치해야 한다
- join
  - 열을 확장 -> 양 옆
  
union
- 합집합, 중복을 제거
  
union all
- 합집합, 중복을 제거하지 않음 -> union에 비해 연산속도가 빠르다

intersect
- 교집합, 두 집합의 공통된 부분


UNION 
: 합집합, 두 개의 SELECT 결과를 하나로 합친다
단, 중복되는 데이터는 중복을 제거한다

-- SELECT 절의 컬럼이 일치해야 한다
-- 필요에 따라 가짜 컬럼으로 개수 맞춰주기
SELECT empno, ename, NULL
FROM emp
WHERE empno IN (7369, 7521)

UNION

SELECT empno, ename, deptno
FROM emp
WHERE empno IN (7369, 7521);


UNION ALL : 중복을 허용하는 합집합
            중복 제거 로직이 없기 때문에 속도가 빠르다
            합집합 하려는 집합 간 중복이 없다는 것을 알고 있을 경우
            UNION 연산자보다 UNION ALL 연산자가 유리하다
            
SELECT empno, ename, NULL
FROM emp
WHERE empno IN (7369, 7499)

UNION ALL

SELECT empno, ename, deptno
FROM emp
WHERE empno IN (7369, 7521);


INTERSECT : 두 개의 집합 중 중복되는 부분만 조회

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


MINUS : 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);


교환 법칙
A U B == B U A (UNION, UNION ALL)
A ^ B == B ^ A
A - B != B - A  집합 순서 !주의


집합연산의 특징
1. 집합연산의 결과로 조회되는 데이터의 //컬럼 이름은 첫 번째 집합//의 컬럼을 따른다
SELECT empno e, ename enm -- 얘의 이름을 따라간다
FROM emp
WHERE empno IN (7369, 7499)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521);

2. 집합연산의 결과를 정렬하고 싶으면 //가장 마지막 집합 뒤//에 ORDER BY를 기술한다
 - 개별 집합에 ORDER BY를 사용한 경우 에러
   단 ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능
    
SELECT empno e, ename enm -- 얘의 이름을 따라간다
FROM emp
WHERE empno IN (7369, 7499)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN (7369, 7521)
ORDER BY e;

3. 중복이 제거된다 (예외 UNION ALL)


[4. 9i 이전버전 : 그룹 연산을 하게 되면 기본적으로 오름차순 정렬되어 나온다
       이후버전 => 정렬 보장 X]
8i - Internet
-------------- 큰 변화
9i - Internet
10g - Grid
11g - Grid
12c - Cloud


DML
    . SELECT 
    . 데이터 신규 입력 INSERT
    . 기존 데이터 수정 UPDATE
    . 기존 데이터 삭제 DELETE
    
INSERT 문법
INSERT INTO 테이블명 [({column,})] VALUES ({value, })

INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3, ...)
            VALUES (값1, 값2, 값3, ...)
            
만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우,
컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다

INSERT INTO 테이블명 VALUES (값1, 값2, 값3);
INSERT INTO dept (deptno, dname, loc);
            VALUES (99, 'ddit', 'daejeon');

DESC dept; -- 이렇게 검색해서 컬럼 순서를 따라가는 게 좋다

SELECT *
FROM dept;

DESC dept;
INSERT INTO emp (empno, ename, job) 
        VALUES (9999, 'brown', 'RANGER');
        
SELECT *
FROM emp;

INSERT INTO emp (empno, ename, job, hiredate, sal, comm) 
        VALUES (9997, 'sally', 'RANGER', TO_DATE('2021-03-24', 'yyyy-mm-dd'), 1000, NULL);


여러 건을 한번에 입력하기
INSERT INTO 테이블명 
SELECT 쿼리

SELECT 90, 'DDIT', '대전' FROM dual UNION ALL 
SELECT 80, 'DDIT8', '대전' FROM dual
-- 지금 작성한 것 저기 위의 SELECT 쿼리

-- 데이터를 가공해서 다른 테이블에 넣을 때
-- 집합연산을 사용하면 간단하고 빨라서 좋다
INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL 
SELECT 80, 'DDIT8', '대전' FROM dual;

SELECT *
FROM dept;

-- 트랜잭션으로 묶인 COMMIT하지 않은 위의 쿼리들 취소
ROLLBACK;
SELECT *
FROM dept;

SELECT *
FROM emp;


UPDATE : 테이블에 존재하는 기존 데이터의 값 변경
문법
UPDATE 테이블명 SET 컬럼명1 = 값1, 컬럼명2 = 값2, 컬럼명3 = 값3 ...
WHERE ;


부서번호 99번 부서정보를 부서명 = 대덕IT로, loc = 영민빌딩

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
-- 부서번호 99번 정보 누락

WHERE 절이 누락이 되었는지 잘 확인
WHERE 절이 누락된 경우 테이블의 모든 행에 대해 업데이트를 진행

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;

SELECT *
FROM dept;






