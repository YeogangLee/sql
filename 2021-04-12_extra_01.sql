2021-04-12 EXTRA-LECTURE_01)

1. ROLLUP
  - GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
  - 명시한 표현식의 수와 순서(오른쪽에서 왼쪽 순)에 따라 레벨 별로 집계한 결과를 반환함
  - 표현식이 n개 사용된 경우 n+1 가지의 집계 반환

(사용형식)
SELECT 컬럼LIST
  FROM 테이블명
 WHERE 조건
 GROUP BY [컬럼명] ROLLUP(컬럼명1, 컬럼명2, ... ,컬럼명N)
 - ROLLUP 안에 기술된 컬럼명1, 컬럼명2,...컬럼명N을 
   오른쪽부터 왼쪽순으로 레벨화 시키고 그것을 기준으로한 집계결과 반환

사용예);
우리나라 광역시도의 대출 현황 테이블에서 기간별, 지역별, 구분별, 잔액합계를 조회하시오.

SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
  FROM KOR_LOAN_STATUS
 GROUP BY SUBSTR(PERIOD,1,4), REGION, GUBUN
 ORDER BY 1;  -- 102행
 -- 그룹바이절에는 집계 함수 외의 일반 컬럼명을 반드시 적는다.

(ROLLUP 사용)
 SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
  FROM KOR_LOAN_STATUS
 GROUP BY ROLLUP(SUBSTR(PERIOD,1,4), REGION, GUBUN)
 ORDER BY 1; -- 157행
 -- 결과를 보니, null값이 나올 때까지 각 컬럼 안에서 더해주기
/* ex.
기간  지역  구분          잔액
2011  강원  기타대출       4
2011  강원  주택담보대출   12
           (null)       16     
2011  경기  기타대출       4
2011  경기  주택담보대출   12
           (null)       16                
2011 (null)(null)       32
          ...
2012 (null)(null)       99                       
          ...
2013 (null)(null)       17                       
(null(null)(null)       148(32 + 99 + 17)
*/
-- 컬럼에 null이 있는 건, 그 컬럼을, 그 조건을 신경 안 쓰고 더한다는 뜻

-- 공공데이터를 이용한 프로젝트 많이 할 거다.

(부분 ROLLUP) -- 잘 사용하지는 않음
 SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
  FROM KOR_LOAN_STATUS
 GROUP BY SUBSTR(PERIOD,1,4), ROLLUP(REGION, GUBUN)
 ORDER BY 1; -- 156행, 전체 ROLLUP에서 제일 마지막행 전체합계가 빠졌다.


(CUBE)
- GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
- CUBE 절 안에 사용된 컬럼의 조합 가능한 가지수(모든 경우의 수) 만큼의 종류별 집계 반환 (2의 제곱)

(CUBE 사용)
 SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
       REGION AS 지역,
       GUBUN AS 구분,
       SUM(LOAN_JAN_AMT) AS 잔액합계
  FROM KOR_LOAN_STATUS
 GROUP BY CUBE(SUBSTR(PERIOD,1,4), REGION, GUBUN)
 ORDER BY 1; -- 216행