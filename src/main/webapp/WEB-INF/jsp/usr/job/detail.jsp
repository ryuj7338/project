<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<head>
    <title>채용공고 상세</title>
</head>
<body>
<h1>채용공고 상세</h1>
<c:if test="${not empty jobPosting}">
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>제목</th>
            <td>${jobPosting.title}</td>
        </tr>
        <tr>
            <th>회사명</th>
            <td>${jobPosting.companyName}</td>
        </tr>
        <tr>
            <th>자격증</th>
            <td>${jobPosting.certificate}</td>
        </tr>
        <tr>
            <th>시작일</th>
            <td>${jobPosting.startDate}</td>
        </tr>
        <tr>
            <th>마감일</th>
            <td>${jobPosting.endDate}</td>
        </tr>
        <tr>
            <th>상세 페이지</th>
            <td><a href="${jobPosting.originalUrl}" target="_blank">링크 열기</a></td>
        </tr>
        <tr>
            <th>D-Day</th>
            <td>${jobPosting.dday}</td>
        </tr>
        <tr>
            <th>D-Day 문자</th>
            <td>${jobPosting.ddayStr}</td>
        </tr>
    </table>
</c:if>
<c:if test="${empty jobPosting}">
    <p>해당 채용공고 정보를 찾을 수 없습니다.</p>
</c:if>

<p><a href="/usr/job/list">목록으로 돌아가기</a></p>
</body>
</html>
