<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="채용공고"></c:set>
<%@ include file="../common/head.jspf" %>

<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">

<body>

<script>
    function SearchForm__submit(form) {
        const keyword = form.keyword.value.trim();

        if (keyword.length === 0) {
            alert('검색어를 입력하세요.');
            form.keyword.focus();
            return;
        }

        form.submit();
    }

    <c:if test="${not empty message}">
    alert("${message}");
    </c:if>
</script>

<script>
    function toggleFavorite(jobPostingId) {
        const btn = $('#favorite-btn-' + jobPostingId);
        const icon = $('#favorite-icon-' + jobPostingId);
        let isFavorited = btn.data('favorited');

        $.ajax({
            url: "/usr/job/favorite/toggle",
            method: "POST",
            data: {jobPostingId},
            headers: {Accept: "application/json"},
            success: function (response) {
                // 로그인 필요 응답 처리
                if (response.resultCode === 'F-A') {
                    alert(response.msg);
                    location.href = "/usr/member/login?redirectUrl=" + encodeURIComponent(location.href);
                    return;
                }

                // 토글 후 상태 반영
                isFavorited = !isFavorited;
                btn.data('favorited', isFavorited);

                if (isFavorited) {
                    icon.removeClass('fa-regular').addClass('fa-solid text-yellow-400');
                } else {
                    icon.removeClass('fa-solid text-yellow-400').addClass('fa-regular');
                }

                alert(response.msg);
            },
            error: function () {
                alert("찜 요청 실패");
            }
        });
    }
</script>


<!-- 검색 폼 -->
<form method="get" action="/usr/job/list" onsubmit="SearchForm__submit(this); return false;"
      style="position: relative; max-width: 400px;">
    <input type="hidden" name="boardId" value="11"/>

    <select name="searchType" style="vertical-align: middle;">
        <option value="title" ${searchType == 'title' ? 'selected' : ''}>공고 제목</option>
        <option value="companyName" ${searchType == 'companyName' ? 'selected' : ''}>회사 이름</option>
    </select>

    <input
            type="text"
            name="keyword"
            id="keyword"
            value="${keyword}"
            placeholder="검색어 입력"
            autocomplete="off"
            style="vertical-align: middle; width: 250px; padding: 4px 8px;"
    />

    <!-- 자동완성 결과 리스트 -->
    <ul id="autocompleteList" style="
    border:1px solid #ccc;
    display:none;
    position:absolute;
    background:#fff;
    max-height:150px;
    overflow-y:auto;
    width: 250px;
    padding: 0;
    margin: 0;
    list-style: none;
    z-index: 1000;
    top: 100%;
    left: 95px;
    box-shadow: 0 2px 8px rgb(0 0 0 / 0.15);
  "></ul>

    <button type="submit" style="vertical-align: middle;">검색</button>
</form>

<hr/>

<table border="1" width="100%" cellpadding="8" cellspacing="0" style="border-collapse: collapse;">
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
            <td>
                <c:set var="jobId" value="${job.id.intValue()}"/>
                <a href="${job.originalUrl}" target="_blank" class="no-underline text-black">${job.title}</a>
                <c:choose>
                    <c:when test="${job.favorited}">
                        <button class="icon-button" data-favorited="true" id="favorite-btn-${job.id}"
                                onclick="toggleFavorite(${job.id})" type="button">
                            <i id="favorite-icon-${job.id}" class="fa-solid fa-star text-yellow-400 text-xl"></i>
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="icon-button" data-favorited="false" id="favorite-btn-${job.id}"
                                onclick="toggleFavorite(${job.id})" type="button">
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
    <c:if test="${hasPrev}">
        <a href="/usr/job/list?page=${prevPage}
        <c:if test='${not empty keyword}'> &amp;searchType=${searchType}&amp;keyword=${keyword} </c:if>">
            ◀ 이전
        </a>
        &nbsp;
    </c:if>

    <c:forEach var="i" begin="${startPage}" end="${endPage}">
        <a href="/usr/job/list?page=${i}
        <c:if test='${not empty keyword}'> &amp;searchType=${searchType}&amp;keyword=${keyword} </c:if>"
           style="${i == page ? 'font-weight:bold; color:red;' : ''}">
                ${i}
        </a>
        &nbsp;
    </c:forEach>

    <c:if test="${hasNext}">
        <a href="/usr/job/list?page=${nextPage}
        <c:if test='${not empty keyword}'> &amp;searchType=${searchType}&amp;keyword=${keyword} </c:if>">
            다음 ▶
        </a>
    </c:if>
</div>

<script>
    $(function () {
        const $input = $('#keyword');
        const $list = $('#autocompleteList');

        let timer;

        $input.on('input', function () {
            clearTimeout(timer);
            const keyword = $(this).val().trim();

            if (keyword.length === 0) {
                $list.hide().empty();
                return;
            }

            timer = setTimeout(() => {
                $.ajax({
                    url: '/usr/autocomplete/job',  // 서버 API 경로 확인 필요
                    method: 'GET',
                    data: {keyword: keyword},
                    dataType: 'json',
                    success: function (data) {
                        console.log("자동완성 결과:", data);

                        $list.empty();

                        if (data.length === 0) {
                            $list.hide();
                            return;
                        }

                        data.forEach(item => {
                            const $li = $('<li>').text(item).css({
                                cursor: 'pointer',
                                padding: '4px 8px',
                                borderBottom: '1px solid #eee'
                            });

                            $li.on('click', function () {
                                $input.val(item);
                                $list.hide().empty();
                            });

                            $list.append($li);
                        });

                        $list.show();
                    },
                    error: function () {
                        $list.hide().empty();
                    }
                });
            }, 300);
        });

        // 외부 클릭 시 자동완성 숨기기
        $(document).on('click', function (e) {
            if (!$(e.target).closest('#keyword, #autocompleteList').length) {
                $list.hide().empty();
            }
        });
    });
</script>

</body>

<%@ include file="../common/foot.jspf" %>
