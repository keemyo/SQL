# 04-1 | MySQL의 데이터 형식

## 04-1-1 | 데이터 형식 
-- 1) 정수형
USE market_db;
CREATE TABLE hongong4 (
	tinyint_col TINYINT,
    smallint_col SMALLINT,
    int_col INT,
    bigint_col BIGINT );

-- 범위가 된다.    
INSERT INTO hongong4 VALUES(127, 32767, 2147483647, 9000000000000000000);    
-- 범위를 초과한다.
INSERT INTO hongong4 VALUES(128, 32768, 2147483648, 90000000000000000000);

-- 앞에서 짠 member 테이블 (비효율VER)
CREATE TABLE member -- 회원 테이블 
	(mem_id CHAR(8) NOT NULL PRIMARY KEY, -- 회원 아이디(PK)
    mem_name VARCHAR(10) NOT NULL, -- 이름
    mem_number INT NOT NULL, -- 인원수(***** -21억 ~ +21억, 굳이?)
    addr CHAR(2) NOT NULL, -- 주소(경기, 서울, 경남 식으로 2글자만 입력)
    phone1 CHAR(3), -- 연락처의 국번(02, 031, 055 등) 
    phone2 CHAR(8), -- 연락처의 나머지 전화번호(하이픈 제외)
    height SMALLINT, -- 평균 키 (***** -32768 ~ +32767 굳이)
    debut_date DATE -- 데뷔 일자
    );
    
CREATE TABLE member -- 회원 테이블    
	( mem_id CHAR(8) NOT NULL PRIMARY KEY, -- 회원 아이디(PK)
	mem_name VARCHAR(10) NOT NULL,
    mem_number TINYINT NOT NULL,
    addr CHAR(2) NOT NULL,
    phone1 CHAR(3),
    phone2 CHAR(8),
    height TINYINT UNSIGNED, -- 평균 키
    debut_date DATE -- 데뷔 일자
);    
    
-- 2) 문자형
	-- CHAR는 문자를 의미하는 Character의 약자로, 고정길이 문자형이며 자릿수가 고정되어 있다.
	-- CHAR(10)에 '가나다' 3글자만 저장해도 10자리를 모두 확보한 후에 앞에 3자리를 사용하고 7자리는 낭비하게 됩니다.
	-- 이와 달리 VARCHAR(Variable Character)는 가변 길이 문자형으로 주어진 길이만 사용함(속도가 느림)

	-- 대량의 데이터 형식
		-- CHAR는 최대 255자까지, VARCHAR는 최대 16383까지 지정이 가능합니다. 
	CREATE TABLE big_table (
		data1 CHAR(256),
		data2 VARCHAR(16384) ); 
    
	-- 넷플릭스 테이블 만들기    
    CREATE DATABASE netflix_db;
    USE netflix_db;
    CREATE TABLE movie
		(movie_id INT,
        movie_title VARCHAR(30),
        movie_director VARCHAR(20),
        movie_star VARCHAR(20),
        movie_script LONGTEXT, -- 자막은 LONGTEXT(1~4294967295 바이트)
        movie_film LONGBLOB -- 동영상(LONGBLOB) 대용량의 텍스트와 이진 데이터를 저장할 수 있습니다.
        );

-- 3) 실수형
	-- FLOAT: 4 바이트 | 소수점 아래 7자리까지 표현
    -- DOUBLE: 8 바이트 | 소수점 아래 15자리까지 표현 
    
-- 4) 날짜	-- DATE: 3 바이트 | YYYY-MM-DD 형식으로 사용 
    -- TIME: 3 바이트 | 시간만 저장 HH:MM:SS 형식으로 사용 
    -- DATETIME: 8 바이트 | YYYY-MM-DD HH:MM:SS
    
## 04-1-2 | 변수의 사용
USE market_db;
SET @myVAR1 = 5 ;
SET @myVAR2 = 4.25 ;

SELECT @myVAR1 ;
SELECT @myVar1 + @myVar2 ;

SET @txt = '가수 이름 ==> ';
SET @height = 166 ;
SELECT @txt, mem_name FROM member WHERE height > @height;

-- LIMIT을 사용해보자(오류가 난다 LIMIT에는 변수를 사용할 수 없다.)
SET @count = 3;
SELECT mem_name, height FROm member ORDER BY height LIMIT @count;

-- 이를 해결하는 것이 PREPARE와 EXECUTE입니다. 
SET @count = 3; -- @count 변수에 3을 대입했습니다. 
PREPARE mySQL FROM 'SELECT mem_name, height FROM member ORDER BY height LIMIT ?';
-- PREPARE는 'SELECT ~ LIMIT ?' 문을 실행하지 않고 mySQL이라는 이름으로 준비만 해놓습니다.
-- 주의해서 볼 것은 LIMIT 다음에 오는 물음표(?)입니다. 
EXECUTE mySQL USING @count; 

## 04-1-3 | 데이터 형 변환 
	-- 문자형을 정수형으로 바꾸거나, 반대로 정수형을 문자형으로 바꾸는 것을 "데이터의 형 변환(type Conversion)이라고 부릅니다.
	-- 형 변환에는 직접 함수를 사용해서 변환하는 명시적인 변환(Explicit Conversion)
	-- 별도의 지시 없이 자연스럽게 변환되는 "암시적인 변환(Implicit Conversion)이 있다.
    
-- 1) 함수를 이용한 명시적인 변환 | CAST. (), CONVERT()이며 형식만 다를 뿐 동일한 기능 수행 
SELECT AVG(price) AS '평균 가격' FROM buy;
	-- a) 정수로 바꿔보자
	SELECT CAST(AVG(price) AS SIGNED) '평균 가격' FROM buy;
	-- 또는
	SELECT CONVERT(AVG(price) , SIGNED) '평균 가격' FROM buy;





