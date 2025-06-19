<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<!-- 폰트어썸 FREE 아이콘 리스트 : https://fontawesome.com/v5.15/icons?d=gallery&p=2&m=free -->

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
<!-- 테일윈드 치트시트 : https://nerdcave.com/tailwind-cheat-sheet -->
<html>
<head>

  <title>법령 정보</title>

</head>
<body>
<h1>법령 정보 목록</h1>

<script>
  function validateSearch() {
    const keywordInput = document.getElementById("keyword");
    const keyword = keywordInput.value.trim();

    if (keyword.length === 0) {
      alert("검색어를 입력하세요.");
      keywordInput.focus();
      return false; // 중요: 제출 막기
    }

    return true; // 제출 허용
  }
</script>

<c:if test="${not empty message}">
  <script>
    alert("${message}");
  </script>
</c:if>

<!--  검색창 -->
<form method="get" action="/usr/law/list" onsubmit="return validateSearch()">
  <input type="hidden" name="boardId" value="${board.id}" />
  <select name="searchType">
    <option value="title" ${searchType == 'title' ? 'selected' : ''}>법령명</option>
  </select>
  <input type="text" name="keyword" id="keyword" value="${keyword}" placeholder="검색어 입력" />
  <button type="submit">검색</button>
</form>

<!--  법령 목록 출력 -->
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
      <td><a href="${law["법령상세링크"]}" target="_blank" class="no-underline text-black hover:text-blue-400 transition-colors duration-150">${law["법령명"]}</a></td>
      <td>${law["공포번호"]}</td>
      <td>${law["공포일자"]}</td>
      <td>${law["법령구분명"]}</td>
      <td>${law["시행일자"]}</td>
      <td>${law["소관부처명"]}</td>
    </tr>
  </c:forEach>
  </tbody>

</table>

<!-- 페이징 처리 -->
<div style="margin-top: 20px;">

  <c:if test="${pageNo > 1}">
    <a href="?keyword=${keyword}&page=${pageNo - 1}&numOfRows=${numOfRows}">이전</a>
  </c:if>

  <c:forEach begin="1" end="${pagesCount}" var="i">
    <a href="?keyword=${keyword}&page=${i}&numOfRows=${numOfRows}"
       style="${i == pageNo ? 'font-weight: bold;' : ''}">${i}</a>
  </c:forEach>

  <c:if test="${pageNo < pagesCount}">
    <a href="?keyword=${keyword}&page=${pageNo + 1}&numOfRows=${numOfRows}">다음</a>
  </c:if>

</div>


</body>

</html>

