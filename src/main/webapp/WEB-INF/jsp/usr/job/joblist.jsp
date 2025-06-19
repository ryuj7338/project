<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>

  <title>채용공고</title>
</head>
<body>

<h1>채용공고 목록</h1>

<script>
  function SearchForm__submit(form) {
    const keyword = form.keyword.value.trim();

    //  검색어 입력 유효성 검사
    if (keyword.length === 0) {
      alert('검색어를 입력하세요.');
      form.keyword.focus();
      return;
    }

    form.submit();
  }

  //  서버에서 전달된 메시지가 있으면 alert
  <c:if test="${not empty message}">
  alert("${message}");
  </c:if>
</script>

<!-- 검색 폼 -->
<form method="get" action="/usr/job/list" onsubmit="SearchForm__submit(this); return false;">
  <input type="hidden" name="boardId" value="11" />

  <select name="searchType">
    <option value="title" ${searchType == 'title' ? 'selected' : ''}>공고 제목</option>
    <option value="companyName" ${searchType == 'companyName' ? 'selected' : ''}>회사 이름</option>
  </select>

  <input type="text" name="keyword" value="${keyword}" placeholder="검색어 입력" />
  <button type="submit">검색</button>
</form>

<hr/>

<!--  채용공고 목록 테이블 -->
<table border="1" width="100%">

  <thead>
  <tr>
    <th>공고 제목</th>
    <th>회사명</th>
    <th>시작일</th>
    <th>마감일</th>
    <th>우대자격증</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach var="job" items="${jobPostings}">
    <tr>
      <td><a href="${job.original_url}" target="_blank">${job.title}</a></td>
      <td>${job.companyName}</td>
      <td>${job.startDate}</td>
      <td>${job.endDate}</td>
      <td>${job.certificate}</td>
    </tr>
  </c:forEach>
  </tbody>
</table>

<!-- 페이징 처리 -->
<div style="margin-top: 20px;">


  <!-- ◀ 이전 -->
  <c:if test="${hasPrev}">
    <a href="/usr/job/list?page=${prevPage}
        <c:if test='${not empty keyword}'> &amp;searchType=${searchType}&amp;keyword=${keyword} </c:if>">
      ◀ 이전
    </a>
    &nbsp;
  </c:if>

  <!-- 페이지 숫자 -->
  <c:forEach var="i" begin="${startPage}" end="${endPage}">
    <a href="/usr/job/list?page=${i}
        <c:if test='${not empty keyword}'> &amp;searchType=${searchType}&amp;keyword=${keyword} </c:if>"
       style="${i == page ? 'font-weight:bold; color:red;' : ''}">
        ${i}
    </a>
    &nbsp;
  </c:forEach>

  <!-- 다음 ▶ -->
  <c:if test="${hasNext}">
    <a href="/usr/job/list?page=${nextPage}
        <c:if test='${not empty keyword}'> &amp;searchType=${searchType}&amp;keyword=${keyword} </c:if>">
      다음 ▶
    </a>
  </c:if>

</div>
</body>
</html>



