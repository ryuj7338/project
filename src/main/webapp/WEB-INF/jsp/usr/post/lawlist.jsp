<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>법령 정보</title>
</head>
<body>
<h1>법령 정보 목록</h1>

<!-- ✅ 검색창 -->
<form method="get" action="/usr/post/list">
    <input type="hidden" name="boardId" value="7" />
    <input type="text" name="keyword" value="${keyword}" placeholder="법령명을 입력하세요" />
    <button type="submit">검색</button>
</form>

<!-- ✅ 법령 목록 출력 -->
<table border="1">
    <thead>
    <tr>
        <th>법령명</th>
        <th>공포번호</th>
        <th>공포일자</th>
        <th>법령구분명</th>
        <th>시행일자</th>
        <th>소관부처명</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="law" items="${lawList}">
        <tr>
            <td><a href="${law["법령상세링크"]}" target="_blank">${law["법령명"]}</a></td>
            <td>${law["공포번호"]}</td>
            <td>${law["공포일자"]}</td>
            <td>${law["법령구분명"]}</td>
            <td>${law["시행일자"]}</td>
            <td>${law["소관부처명"]}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<!-- ✅ 페이징 처리 -->
<div style="margin-top: 20px;">
    <c:if test="${pageNo > 1}">
        <a href="?boardId=7&keyword=${keyword}&page=${pageNo - 1}&numOfRows=${numOfRows}">이전</a>
    </c:if>

    <c:forEach begin="1" end="${pagesCount}" var="i">
        <a href="?boardId=7&keyword=${keyword}&page=${i}&numOfRows=${numOfRows}"
           style="${i == pageNo ? 'font-weight: bold;' : ''}">${i}</a>
    </c:forEach>

    <c:if test="${pageNo < pagesCount}">
        <a href="?boardId=7&keyword=${keyword}&page=${pageNo + 1}&numOfRows=${numOfRows}">다음</a>
    </c:if>
</div>


</body>
</html>
