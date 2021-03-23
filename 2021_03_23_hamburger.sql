
-- 끊고 갈 타이밍, 지금까지 공부한 것들 종합적 정리


SELECT *
FROM BURGERSTORE
-- 카카오 주소찾기에서 또 다시 주소를 가공했다, 다른 api를 사용해서
WHERE SIDO = '대전';

SELECT STORECATEGORY
FROM BURGERSTORE
WHERE SIDO = '대전'
GROUP BY STORECATEGORY;


-- 대전 중구
도시 발전 지수 : (kfc + 맥도날드 + 버거킹) / 롯데리아
                 1       3        2         3       =   (1+3+2)/3 = 2; 
SELECT *
FROM BURGERSTORE
WHERE SIDO = '대전'
  AND SIGUNGU = '중구';

대전 중구   2

SELECT SIDO, SIGUNGU, 도시발전지수
FROM BURGERSTORE
WHERE SIDO = '대전'
  AND SIGUNGU = '중구';


-- 시작

SELECT SIDO, SIGUNGU, STORECATEGORY, COUNT(*) cnt -- SUM(STORECATEGORY IN ('KFC', 'MACDONALD', 'BURGER KING'))
FROM BURGERSTORE
GROUP BY SIDO, SIGUNGU, STORECATEGORY
HAVING SIDO='대전'
   AND SIGUNGU = '중구';

SELECT SIDO, SIGUNGU, STORECATEGORY, COUNT(*) cnt 
FROM BURGERSTORE
GROUP BY SIDO, SIGUNGU, STORECATEGORY
HAVING SIDO='대전'
   AND SIGUNGU = '중구'
--   AND STORECATEGORY IN ('BURGER KING', 'MACDONALD', 'KFC');
AND STORECATEGORY NOT IN ('LOTTERIA');

SELECT SIDO, SIGUNGU, STORECATEGORY, COUNT(*) cnt
FROM BURGERSTORE
GROUP BY SIDO, SIGUNGU, STORECATEGORY
HAVING SIDO='대전'
   AND SIGUNGU = '중구'
--   AND STORECATEGORY IN ('BURGER KING', 'MACDONALD', 'KFC');
AND STORECATEGORY NOT IN ('LOTTERIA');




-- 이해가 안 되더라도 정리해두면 나중에 꼭 쓸 수 있을 거다
-- 행을 컬럼으로 변경 PIVOT
SELECT sido, sigungu, storecategory, 
            storecategory가 burger king 이면 1, 아니면 0  ,
            storecategory가 kfc 이면 1, 아니면 0          ,
            storecategory가 macdonald 이면 1, 아니면 0    ,
            storecategory가 lotteria 이면 1, 아니면 0  
FROM burgerstore;

SELECT sido, sigungu, storecategory, 
        DECODE(storecategory, 'BURGER KING', 1, 0) bk   ,
/*        CASE
            WHEN storecategory = 'burger king' THEN 1
            ELSE 0
        END bk
*/
        DECODE(storecategory, 'KFC', 1, 0) kfc          ,
        DECODE(storecategory, 'MACDONALD', 1, 0) mac    ,
        DECODE(storecategory, 'LOTTERIA', 1, 0) l
FROM burgerstore;

SELECT sido, sigungu,
        SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) bk,
        SUM(DECODE(storecategory, 'KFC', 1, 0)) kfc          ,
        SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) mac    ,
        SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)) l
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY sido, sigungu;

-- 0으로 못 나눔
SELECT sido, sigungu,
        (SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) +
        SUM(DECODE(storecategory, 'KFC', 1, 0)) +
        SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) ) /
        SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)) idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY sido, sigungu;


SELECT sido, sigungu,
        ROUND(  (SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) +
        SUM(DECODE(storecategory, 'KFC', 1, 0)) +
        SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) ) /
        DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)), 0, 1, SUM(DECODE(storecategory, 'LOTTERIA', 1, 0))), 2) idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY sido, sigungu;

DESC emp;