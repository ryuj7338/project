<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="채용공고" />
<%@ include file="../common/head.jspf" %>

<!-- jQuery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script>
  // 검색 폼 검증
  function SearchForm__submit(form) {
    const keyword = form.keyword.value.trim();
    if (!keyword) {
      alert('검색어를 입력하세요.');
      form.keyword.focus();
      return false;
    }
    return true;
  }

  // 찜 토글 & 알림 삭제
  function toggleFavorite(jobPostingId) {
    const btn   = $('#favorite-btn-' + jobPostingId);
    const icon  = $('#favorite-icon-' + jobPostingId);
    const wasFav= btn.data('favorited');
    const title = btn.data('title');
    let link  = btn.data('link');
    if(link.startsWith('/')){
        link = link.substring(1);
    }
    console.log('▶ deleteByLink payload:', { link, title });
    const cp    = '${pageContext.request.contextPath}';

    $.post(cp + '/usr/job/favorite/toggle',
      { jobPostingId: jobPostingId },
      function(resp) {
        if (resp.resultCode === 'F-A') {
          alert(resp.msg);
          location.href = cp + '/usr/member/login?redirectUrl='
                         + encodeURIComponent(location.href);
          return;
        }
        const nowFav = !wasFav;
        btn.data('favorited', nowFav);
        if (nowFav) {
          icon.removeClass('fa-regular').addClass('fa-solid text-yellow-400');

          // 찜한 순간 바로 빨간 점 띄우기
          showAlertBadge();
        } else {
          icon.removeClass('fa-solid text-yellow-400').addClass('fa-regular');

          $.post(cp + '/usr/notifications/deleteByLink',
            { link: link, title: title },
            rd => console.log('deleteByLink:', rd),
            'json'
          ).fail(e => console.error('deleteByLink 실패:', e));
        }
        alert(resp.msg);
      },
      'json'
    ).fail(() => alert('찜 요청 실패'));
  }
</script>

<body>
  <!-- 검색 폼 -->
  <form method="get" action="/usr/job/list"
        onsubmit="return SearchForm__submit(this);"
        style="position:relative; max-width:400px;">
    <input type="hidden" name="boardId" value="11"/>
    <select name="searchType">
      <option value="title"       ${searchType=='title'?'selected':''}>공고 제목</option>
      <option value="companyName" ${searchType=='companyName'?'selected':''}>회사 이름</option>
    </select>
    <input type="text" name="keyword" id="keyword"
           value="${keyword}" placeholder="검색어 입력" autocomplete="off"/>
    <button type="submit">검색</button>

    <!-- 자동완성 결과 -->
    <ul id="autocompleteList"
        style="border:1px solid #ccc; display:none; position:absolute;
               background:#fff; max-height:150px; overflow-y:auto;
               width:250px; margin:0; padding:0; list-style:none;
               z-index:1000; top:100%; left:95px;
               box-shadow:0 2px 8px rgb(0 0 0 / 0.15);">
    </ul>
  </form>

  <script>
    $(function(){
      const $input = $('#keyword');
      const $list  = $('#autocompleteList');
      let timer;

      $input.on('input', function(){
        clearTimeout(timer);
        const kw = $(this).val().trim();
        if (!kw) {
          $list.hide().empty();
          return;
        }
        timer = setTimeout(() => {
          $.ajax({
            url: '/usr/autocomplete/job',
            data: { keyword: kw },
            dataType: 'json',
            success(data) {
              $list.empty();
              if (!data.length) {
                $list.hide();
                return;
              }
              data.forEach(item => {
                $('<li>')
                  .text(item)
                  .css({ cursor:'pointer', padding:'4px 8px', borderBottom:'1px solid #eee' })
                  .on('click', function(){
                    $input.val(item);
                    $list.hide().empty();
                  })
                  .appendTo($list);
              });
              $list.show();
            },
            error() {
              $list.hide().empty();
            }
          });
        }, 300);
      });

      $(document).on('click', function(e){
        if (!$(e.target).closest('#keyword, #autocompleteList').length) {
          $list.hide().empty();
        }
      });
    });
  </script>

  <hr/>

  <!-- 공고 테이블 -->
  <table border="1" width="100%" cellpadding="8" cellspacing="0" style="border-collapse:collapse;">
    <thead>
      <tr>
        <th>공고 제목</th>
        <th>회사명</th>
        <th>시작일</th>
        <th>마감일</th>
        <th>우대자격증</th>
        <th>찜</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="job" items="${jobPostings}">
        <c:set var="jobId" value="${job.id}"/>
        <tr>
          <td>
            <a href="${job.originalUrl}" target="_blank">${job.title}</a>
          </td>
          <td>${job.companyName}</td>
          <td>${job.startDate}</td>
          <td>${job.endDate}</td>
          <td>${job.certificate}</td>
          <td>
            <!-- 단일 찜 버튼 -->
            <button type="button"
                    id="favorite-btn-${jobId}"
                    class="icon-button"
                    data-favorited="${job.favorited}"
                    data-link="/usr/job/detail?id=${jobId}"
                    data-title="${fn:escapeXml(job.title)}"
                    onclick="toggleFavorite(${jobId})">
              <i id="favorite-icon-${jobId}"
                 class="fa-star ${job.favorited?'fa-solid text-yellow-400':'fa-regular'} text-xl"></i>
            </button>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- 페이징 -->
  <div style="margin-top:20px;">
    <c:if test="${hasPrev}">
      <a href="/usr/job/list?page=${prevPage}
             <c:if test='${not empty keyword}'>
               &amp;searchType=${searchType}&amp;keyword=${keyword}
             </c:if>">◀ 이전</a>&nbsp;
    </c:if>

    <c:forEach var="i" begin="${startPage}" end="${endPage}">
      <a href="/usr/job/list?page=${i}
             <c:if test='${not empty keyword}'>
               &amp;searchType=${searchType}&amp;keyword=${keyword}
             </c:if>"
         style="${i==page?'font-weight:bold;color:red;':''}">${i}</a>&nbsp;
    </c:forEach>

    <c:if test="${hasNext}">
      <a href="/usr/job/list?page=${nextPage}
             <c:if test='${not empty keyword}'>
               &amp;searchType=${searchType}&amp;keyword=${keyword}
             </c:if>">다음 ▶</a>
    </c:if>
  </div>

  <%@ include file="../common/foot.jspf" %>
</body>
</html>
