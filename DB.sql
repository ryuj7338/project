DROP DATABASE IF EXISTS project;
CREATE DATABASE project;
USE project;


# 커뮤니티 테이블 생성
CREATE TABLE post (
                      id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                      regDate DATETIME NOT NULL,
                      updateDate DATETIME NOT NULL,
                      title CHAR(100) NOT NULL,
                      `body` TEXT NOT NULL
);

# 나중에 추가할 것
user_id INT(10) UNSIGNED NOT NULL,
board_id INT(10) UNSIGNED NOT NULL,
image VARCHAR(250) NOT NULL

SELECT * FROM post;

# 게시판 테이블 생성
CREATE TABLE board (
                       id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                       parent_id INT(10) UNSIGNED DEFAULT NULL COMMENT '부모 게시판 ID (NULL이면 1차 메뉴)',
                       regDate DATETIME NOT NULL,
                       updateDate DATETIME NOT NULL,
                       `code` CHAR(100) NOT NULL UNIQUE COMMENT '게시판 코드(ex. Q&A, 안내, 후기 등)',
                       `name` CHAR(100) NOT NULL UNIQUE COMMENT '게시판 이름',
                       delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제 여부 (0=삭제 전, 1=삭제 후)',
                       delDate DATETIME COMMENT '삭제 날짜'
);

# 회원 테이블 생성
CREATE TABLE users (
                       id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                       regDate DATETIME NOT NULL,
                       updateDate DATETIME NOT NULL,
                       loginId CHAR(100) NOT NULL,
                       loginPw CHAR(200) NOT NULL,
                       `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반, 7=관리자)',
                       `name` CHAR(20) NOT NULL,
                       nickname CHAR(20) NOT NULL,
                       cellphone CHAR(20) NOT NULL,
                       email CHAR(50) NOT NULL,
                       delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
                       delDate DATETIME COMMENT '탈퇴 날짜'
);


# 자료실 테이블 생성
CREATE TABLE resources (
                           id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                           user_id INT(10) UNSIGNED NOT NULL,
                           board_id INT(10) UNSIGNED NOT NULL,
                           regDate DATETIME NOT NULL,
                           updateDate DATETIME NOT NULL,
                           title VARCHAR(50) NOT NULL,
                           `body` TEXT NOT NULL,
                           image VARCHAR(250) NOT NULL,
                           pdf VARCHAR(250) NOT NULL,
                           zip VARCHAR(250) NOT NULL
);


# 좋아요 테이블 생성
CREATE TABLE `like` (
                        id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                        regDate DATETIME NOT NULL,
                        updateDate DATETIME NOT NULL,
                        memberId INT(10) UNSIGNED NOT NULL,
                        relTypeCode CHAR(100) NOT NULL COMMENT '관련 데이터 타입 코드',
                        relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
                        `like` INT(10) NOT NULL
);


# 댓글 테이블 생성
CREATE TABLE `comment` (
                           id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                           regDate DATETIME NOT NULL,
                           updateDate DATETIME NOT NULL,
                           memberId INT(10) UNSIGNED NOT NULL,
                           relTypeCode CHAR(100) NOT NULL COMMENT '관련 데이터 타입 코드',
                           relId INT(10) NOT NULL COMMENT '관련 데이터 번호',
                           `body` TEXT NOT NULL
);


# 자격증 테이블
CREATE TABLE qualifications(
                               id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                               `name` VARCHAR(50) NOT NULL,
                               category_code VARCHAR(50) NOT NULL COMMENT '무도, 경비, 응급 등'
);


# 대학교 테이블
CREATE TABLE university(
                           id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                           `name` VARCHAR(50) NOT NULL,
                           region VARCHAR(50) NOT NULL,
                           major VARCHAR(50) NOT NULL,
                           url VARCHAR(500) NOT NULL
);


<<<<<<< HEAD
# 채용공고 테이블
CREATE TABLE jobs(
                     id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                     title VARCHAR(200) NOT NULL,
                     `body` TEXT NOT NULL,
                     category CHAR(50) NOT NULL COMMENT '경찰, 경호, 소방, 군인',
                     url VARCHAR(500) NOT NULL,
                     regDate DATETIME NOT NULL,
                     deadline DATE NOT NULL
);

=======
# 채용정보 테이블
CREATE TABLE job_posting(
                            id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
                            title VARCHAR(255) NOT NULL,
                            company_name VARCHAR(255) NOT NULL,
                            certificate TEXT NOT NULL,
                            start_date VARCHAR(50) NOT NULL,
                            end_date VARCHAR(50) NOT NULL
);

SELECT * FROM job_posting;

>>>>>>> 57fceb85066ec89ea7c6794ef28c734fec7a417d
SELECT * FROM board;

# post 테이블에 좋아요 컬럼 추가
ALTER TABLE post ADD COLUMN `like` INT(10) UNSIGNED NOT NULL DEFAULT 0;

# post 테이블에 댓글 수 컬럼 추가
ALTER TABLE post ADD COLUMN CommentCnt INT(10) UNSIGNED NOT NULL DEFAULT 0;

## 멤버 아이디 추가
ALTER TABLE post ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER updateDate;

## 게시판 번호 추가
ALTER TABLE post ADD COLUMN boardId INT(10) NOT NULL AFTER `memberId`;

# 게시글 테스트 데이터 생성
INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO article
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';

# 게시판 데이터 생성

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자격요건',
`name` = '자격요건';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자격증',
`name` = '자격증';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '대학교',
`name` = '대학교';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '경호업체',
`name` = '경호업체';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '면접',
`name` = '면접';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자기소개서',
`name` = '자기소개서';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '채용공고',
`name` = '채용공고';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '뉴스',
`name` = '뉴스';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '법률',
`name` = '법률';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'Q&A',
`name` = 'Q&A';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '정보공유',
`name` = '정보공유';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '후기',
`name` = '후기';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '기출문제',
`name` = '기출문제';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자료공유',
`name` = '자료공유';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '면접자료',
`name` = '면접자료';

# 회원 테스트 데이터 생성

#관리자
INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = 'admin',
`authLevel` = 7,
`name` = '관리자',
nickname = '관리자_닉네임',
cellphoneNum = '01012341234',
email = 'abc@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`name` = '회원1',
nickname = '회원1',
cellphoneNum = '01012341234',
email = 'tanjiro@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = '회원2',
nickname = '회원2',
cellphoneNum = '01056785678',
email = 'pikachyu@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test3',
loginPw = 'test3',
`name` = '회원3',
nickname = '회원3',
cellphoneNum = '01078787878',
email = 'shinJJang@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test4',
loginPw = 'test4',
`name` = '회원4',
nickname = '회원4',
cellphoneNum = '01022222222',
email = 'maenggu@gmail.com';

# 회원 번호 설정
UPDATE post
SET memberId = 2
WHERE id = 1;

UPDATE post
SET memberId = 3
WHERE id = 2;

UPDATE post
SET memberId = 4
WHERE id  = 3;

UPDATE post
SET memberId = 5
WHERE id = 4;
<<<<<<< HEAD
=======

SELECT * FROM board;
>>>>>>> 57fceb85066ec89ea7c6794ef28c734fec7a417d
