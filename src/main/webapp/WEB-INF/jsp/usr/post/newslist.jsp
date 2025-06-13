<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>뉴스 게시판</title>
</head>
<body>
<h2>뉴스 목록</h2>
<c:forEach var="news" items="${newsList}">
  <div>
  <a href="${news.link}" target="_blank">${news.title}</a><br/>
  <span>${news.summary}</span><br/>
  <c:if test="${not empty news.image}">
    <img src="${news.image}" width="200"/>
  </c:if>
  <hr/>
  </div>
</c:forEach>
</body>
</html>
