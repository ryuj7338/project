<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="채용공고" ></c:set>
<%@ include file="../common/head.jspf"%>

<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<!-- 폰트어썸 FREE 아이콘 리스트 : https://fontawesome.com/v5.15/icons?d=gallery&p=2&m=free -->

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">
<!-- 테일윈드 치트시트 : https://nerdcave.com/tailwind-cheat-sheet -->



<body>



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

<script>
  function toggleFavorite(jobPostingId) {
	const btn = $('#favorite-btn-' + jobPostingId);
	const icon = $('#favorite-icon-' + jobPostingId);
	let isFavorited = btn.data('favorited'); // true or false

	$.ajax({
		url: "/usr/job/favorite/toggle",
		method: "POST",
		data: { jobPostingId },
		success: function(response) {
			isFavorited = !isFavorited;
			btn.data('favorited', isFavorited); // 상태 갱신

			if (isFavorited) {
				icon.removeClass('fa-regular').addClass('fa-solid text-yellow-400');
			} else {
				icon.removeClass('fa-solid text-yellow-400').addClass('fa-regular');
			}
		},
		error: function() {
			alert("찜 요청 실패");
		}
	});
}
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
        <td><a href="${job.originalUrl}" target="_blank" class="no-underline text-black">${job.title}</a>
          <c:choose>
            <c:when test="${favoriteId.contains(job.id)}">
              <button class="icon-button" data-favorited="true" id="favorite-btn-${job.id}" onclick="toggleFavorite(${job.id})">
                <i id="favorite-icon-${job.id}" class="fa-solid fa-star text-yellow-400 text-xl"></i>
              </button>
            </c:when>
          <c:otherwise>
            <button class="icon-button" data-favorited="false" id="favorite-btn-${job.id}" onclick="toggleFavorite(${job.id})">
              <i id="favorite-icon-${job.id}" class="fa-regular fa-star text-xl"></i>
            </button>
          </c:otherwise>
        </c:choose>
      </td>
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


<%@ include file="../common/foot.jspf"%>
