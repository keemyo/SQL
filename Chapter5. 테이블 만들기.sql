# 05-1 | 테이블 만들기 

## 05-1-1 | 데이터베이스와 테이블 설계하기 

## 05-1-2 | GUI 환경에서 테이블 만들기
-- 1) 데이터베이스 생성하기
CREATE DATABASE naver_db; 

-- 2) 테이블 생성하기 

-- 3) 데이터 입력하기 

# 05-2 | SQL로 테이블 만들기 
CREATE TABLE sample_table (num INT); 

-- 1) 데이터베이스 생성하기 
DROP DATABASE IF EXISTS naver_db; 
CREATE DATABASE naver_db; 

-- 2)테이블 생성하기 
USE naver_db;
DROP TABLE IF EXISTS member;
CREATE TABLE member -- 회원테이블 
	(mem_id CHAR(8), -- 회원 아이디(PK)
    mem_name VARCHAR(10), -- 이름 
    mem_number TINYINT, -- 인원수 
    addr CHAR(2), -- 주소(경기, 서울, 경남 식으로 2글자만 입력) 
    phone1 CHAR(3), -- 연락처의 국번(02, 031, 055 등) 
    phone2 CHAR(8), -- 연락처의 나머지 전화번호(하이픈 제외) 
    height TINYINT UNSIGNED, -- 평균 키 
    debut_date DATE -- 데뷔 일자 
    ); 


-- 3) NULL/NOT NULL을 고려한다.    
DROP TABLE IF EXISTS member; -- 기존에 있으면 삭제 
CREATE TABLE member 
( mem_id CHAR(8) NOT NULL,
mem_name VARCHAR(10) NOT NULL, 
mem_number TINYINT NOT NULL, 
addr CHAR(2) NOT NULL,
phone1 CHAR(3) NULL,
phone2 CHAR(8) NULL,
height TINYINT UNSIGNED NULL,
debut_date DATE NULL
);

-- 4) PRIMARY KEY 설정 
DROP TABLE IF EXISTS member ; 
CREATE TABLE member
(mem_id CHAR(8) NOT NULL PRIMARY KEY,
mem_name VARCHAR(10) NOT NULL,
mem_number TINYINT NOT NULL,
addr CHAR(2) NOT NULL, 
phone1 CHAR(3) NULL,
phone2 CHAR(8) NULL,
height TINYINT UNSIGNED NULL,
debut_date DATE NULL
);

-- 5) buy 테이블 만들기 
DROP TABLE IF EXISTS buy; -- 기존에 있으면 삭제 
CREATE TABLE buy -- 구매 테이블 
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK) 
mem_id CHAR(8) NOT NULL, -- 아이디(FK)
prod_name CHAR(6) NOT NULL, -- 제품 이름 
group_name CHAR(4) NULL, -- 분류
price INT UNSIGNED NOT NULL, -- 가격 
amount  SMALLINT UNSIGNED NOT NULL -- 수량 
); 

-- 6) buy: Foeign target 
DROP TABLE IF EXISTS buy; -- 기존에 있으면 삭제 
CREATE TABLE buy 
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
mem_id CHAR(8) NOT NULL,
prod_name CHAR(6) NOT NULL, 
group_name CHAR(4) NULL, 
price INT UNSIGNED NOT NULL,
amount SMALLINT UNSIGNED NOT NULL, 
FOREIGN KEY(mem_id) REFERENCES member(mem_id)
) ; 

-- 7) 데이터 입력하기 
INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015-10-19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055','22222222', 173, '2016-8-8');
INSERT INTO member VALUES('WMW', '여자친구', '경기', '031', '33333333', 166, '2015-1-15');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로','디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);

