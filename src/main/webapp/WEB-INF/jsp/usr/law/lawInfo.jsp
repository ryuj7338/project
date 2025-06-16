<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>법령 정보</title>
</head>
<body>
<h1>법령 정보 목록</h1>

<c:if test="${not empty lawList}">
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
</c:if>

<c:if test="${empty lawList}">
  <p>조회된 법령 정보가 없습니다.</p>
</c:if>
<div style="margin-top: 20px;">
  <c:if test="${pageNo > 1}">
    <a href="?query=${query}&pageNo=${pageNo - 1}&numOfRows=${numOfRows}">이전</a>
  </c:if>

  <c:forEach begin="1" end="${pagesCount}" var="i">
    <a href="?query=${query}&pageNo=${i}&numOfRows=${numOfRows}"
       style="${i == pageNo ? 'font-weight: bold; text-decoration: underline;' : ''}">${i}</a>
  </c:forEach>

  <c:if test="${pageNo < pagesCount}">
    <a href="?query=${query}&pageNo=${pageNo + 1}&numOfRows=${numOfRows}">다음</a>
  </c:if>
</div>

</body>
</html>
