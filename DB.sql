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
image VARCHAR(250) NOT NULL;

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
CREATE TABLE `member` (
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
    memberId INT(10) UNSIGNED NOT NULL,
    boardId INT(10) UNSIGNED NOT NULL,
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
CREATE TABLE qualifications
(
    id                INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name`            VARCHAR(100) NOT NULL COMMENT '자격증 이름',
    issuing_agency    VARCHAR(100) COMMENT '발급 기관',
    organizing_agency VARCHAR(100) COMMENT '주관 기관(시행/운영)',
    grade             VARCHAR(30) DEFAULT NULL COMMENT '급수 (해당 시에만 입력)',
    category_code     VARCHAR(50) DEFAULT NULL COMMENT '무도, 응급, 경호, 그 외 등 내부 분류용(UI에 표시 안함)',
    `type`            VARCHAR(50) DEFAULT NULL COMMENT '자격증 종류 (예: 국가기술, 민간, 국제 등)'
);

SELECT * FROM qualifications;

# 대학교 테이블

CREATE TABLE university
(
    id              INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name`          VARCHAR(100) NOT NULL, -- 대학교명
    region          VARCHAR(50)  NOT NULL, -- 지역
    major           VARCHAR(100) NOT NULL, -- 학과
    type            VARCHAR(20),           -- 국립/사립/공립
    tuition         INT UNSIGNED,          -- 연간 등록금 (원)
    admission_rate  FLOAT,                 -- 입학 경쟁률
    employment_rate FLOAT,                 -- 취업률
    ranking         INT UNSIGNED,          -- 대학 순위
    url             VARCHAR(500) NOT NULL, -- 학교 메인 사이트
    department_info VARCHAR(500),          -- 학과 전용 페이지
    campus          VARCHAR(50),           -- 캠퍼스 이름
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

# 채용정보 테이블
CREATE TABLE job_posting(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,	-- 공고 제목
    company_name VARCHAR(255) NOT NULL,	-- 기업명
    certificate TEXT NOT NULL,	-- 우대 자격
    start_date VARCHAR(50) NOT NULL,	-- 시작일
    end_date VARCHAR(50) NOT NULL,	-- 마감일
    original_url VARCHAR(255)   -- 개별 페이지
);


#찜 테이블
CREATE TABLE job_favorite(
id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
memberId INT(10) UNSIGNED NOT NULL,
jobPostingId INT(10) UNSIGNED NOT NULL,
regDate DATETIME NOT NULL,
updateDate DATETIME NOT NULL
);

SELECT * FROM job_favorite;

# 자소서/면접 저장 테이블
CREATE TABLE interview_answers (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    memberId INT UNSIGNED NOT NULL,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(50) COMMENT '면접 / 자소서 구분',
    FOREIGN KEY (memberId) REFERENCES MEMBER(id)
);


SELECT * FROM job_posting;

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
INSERT INTO post
SET regDate = NOW(),
updateDate = NOW(),
title = '제목1',
`body` = '내용1';

INSERT INTO post
SET regDate = NOW(),
updateDate = NOW(),
title = '제목2',
`body` = '내용2';

INSERT INTO post
SET regDate = NOW(),
updateDate = NOW(),
title = '제목3',
`body` = '내용3';


# 게시판 데이터 생성
insert into board
set regDate = now(),
updateDate = NOW(),
`code` = 'Q&A',
`name` = '질문 게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '공유',
`name` = '정보 공유';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '후기',
`name` = '합격 후기';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자유',
`name` = '자유게시판';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '기출',
`name` = '기출문제';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자료',
`name` = '요약/공유자료';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '뉴스',
`name` = '경호 뉴스';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '법률',
`name` = '관련 법률';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '면접',
`name` = '면접 코칭';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '자기소개서',
`name` = '자기소개서';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = '공고',
`name` = '채용 공고';


# 자격증 데이터 생성
insert into qualifications
set `name` = '경비지도사',
issuing_agency = '한국산업인력공단',
organizing_agency = '경찰청 생활안전과',
category_code = '경호',
`type` = '국가공인자격';

INSERT INTO qualifications
SET `name` = '신변보호사',
issuing_agency = '(사)한국경비협회',
organizing_agency = '(사)한국경비협회 ',
category_code = '경호',
`type` = ' 국가공인 민간자격';

INSERT INTO qualifications
SET `name` = '소방안전관리자',
issuing_agency = '한국소방안전원',
organizing_agency = '한국소방안전원',
grade = '특급, 1급, 2급, 3급',
category_code = '소방',
`type` = '국가전문자격';

INSERT INTO qualifications
SET `name` = '위험물기능사',
issuing_agency = '한국산업인력공단',
organizing_agency = '소방청',
category_code = '소방',
`type` = '국가기술자격';

INSERT INTO qualifications
SET `name` = '산업보안관리사',
issuing_agency = '(사)한국산업기술보호협회',
organizing_agency = '(사)한국산업기술보호협회',
category_code = '경호';

INSERT INTO qualifications
SET `name` = 'TOEIC',
issuing_agency = '한국TOEIC위원회',
organizing_agency = '한국TOEIC위원회',
category_code = '외국어',
`type` = '국가공인 민간 자격';

INSERT INTO qualifications
SET `name` = 'G-TELP',
issuing_agency = '지텔프코리아',
organizing_agency = '국제테스트 연구원(ITSC, International Testing Services Center)',
category_code = '외국어',
grade = 'Level 1 ~ 5',
`type` = '국가공인 민간 자격';

INSERT INTO qualifications
SET `name` = 'TEPS',
issuing_agency = '서울대학교 TEPS관리위원회',
organizing_agency = '서울대학교 TEPS관리위원회',
category_code = '외국어',
`type` = '민간 자격';


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
cellphone = '01012341234',
email = 'abc@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`name` = '회원1',
nickname = '회원1',
cellphone = '01012341234',
email = 'tanjiro@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = '회원2',
nickname = '회원2',
cellphone= '01056785678',
email = 'pikachyu@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test3',
loginPw = 'test3',
`name` = '회원3',
nickname = '회원3',
cellphone = '01078787878',
email = 'shinJJang@gmail.com';

INSERT INTO `member`
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test4',
loginPw = 'test4',
`name` = '회원4',
nickname = '회원4',
cellphone = '01022222222',
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

SELECT * FROM board;