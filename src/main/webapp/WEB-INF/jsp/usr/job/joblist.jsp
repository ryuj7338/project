<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="채용공고"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="flex flex-col min-h-screen bg-gray-50">

<!-- 검색 + 자동완성 -->
<div class="flex justify-center p-6 bg-white shadow">
    <form method="get"
          action="<c:url value='/usr/job/list'/>"
          onsubmit="return SearchForm__submit(this);"
          class="flex items-center space-x-2 w-full max-w-md">
        <input type="hidden" name="boardId" value="11"/>
        <select name="searchType" class="border rounded h-10 px-3 text-sm">
            <option value="title"       ${searchType=='title'       ? 'selected':''}>공고 제목</option>
            <option value="companyName" ${searchType=='companyName' ? 'selected':''}>회사 이름</option>
        </select>
        <div class="relative flex-1">
            <input type="text" name="keyword" id="keyword"
                   value="${keyword}" placeholder="검색어 입력" autocomplete="off"
                   class="w-full border rounded h-10 px-3 text-sm"/>
            <ul id="autocompleteList"
                class="absolute top-full left-0 w-full bg-white border max-h-40 overflow-y-auto z-20 hidden shadow-md">
            </ul>
        </div>
        <button type="submit"
                class="bg-blue-500 text-white h-10 px-4 rounded text-sm hover:bg-blue-600">
            검색
        </button>
    </form>
</div>

<!-- jQuery & 스크립트 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    function SearchForm__submit(form) {
        if (!form.keyword.value.trim()) {
            alert('검색어를 입력하세요.');
            form.keyword.focus();
            return false;
        }
        return true;
    }

    $(function () {
        const $input = $('#keyword'), $list = $('#autocompleteList');
        let timer;
        $input.on('input', () => {
            clearTimeout(timer);
            const v = $input.val().trim();
            if (!v) {
                $list.hide().empty();
                return;
            }
            timer = setTimeout(() => {
                $.getJSON('<c:url value="/usr/autocomplete/job"/>', {keyword: v})
                    .done(data => {
                        $list.empty();
                        if (!data.length) {
                            $list.hide();
                            return;
                        }
                        data.forEach(item => {
                            $('<li>')
                                .text(item)
                                .addClass('cursor-pointer px-2 py-1 hover:bg-gray-100')
                                .on('click', () => {
                                    $input.val(item);
                                    $list.hide().empty();
                                })
                                .appendTo($list);
                        });
                        $list.show();
                    })
                    .fail(() => $list.hide().empty());
            }, 300);
        });
        $(document).on('click', e => {
            if (!$(e.target).closest('#keyword,#autocompleteList').length) {
                $list.hide().empty();
            }
        });
    });

    // 찜 토글 & 알림 삭제
    function toggleFavorite(jobPostingId) {
        const btn = $('#favorite-btn-' + jobPostingId);
        const icon = $('#favorite-icon-' + jobPostingId);
        const wasFav = btn.data('favorited');
        const title = btn.data('title');
        let link = btn.data('link');
        if (link.startsWith('/')) link = link.substring(1);

        $.post(
            '<c:url value="/usr/job/favorite/toggle"/>',
            {jobPostingId: jobPostingId},
            function (resp) {
                if (resp.resultCode === 'F-A') {
                    alert(resp.msg);
                    location.href = '<c:url value="/usr/member/login"/>'
                        + '?redirectUrl=' + encodeURIComponent(location.href);
                    return;
                }
                const nowFav = !wasFav;
                btn.data('favorited', nowFav);
                if (nowFav) {
                    icon.removeClass('fa-regular').addClass('fa-solid text-yellow-400');
                    // showAlertBadge(); // 필요 시 빨간점 띄우기
                } else {
                    icon.removeClass('fa-solid text-yellow-400').addClass('fa-regular');
                    $.post(
                        '<c:url value="/usr/notifications/deleteByLink"/>',
                        {link: link, title: title},
                        () => {
                        }, 'json'
                    );
                }
                alert(resp.msg);
            },
            'json'
        ).fail(() => alert('찜 요청 실패'));
    }
</script>

<!-- 공고 테이블 -->
<div class="overflow-x-auto mt-6 px-6">
    <table class="min-w-full bg-white divide-y divide-gray-200 text-sm">
        <thead class="bg-gray-100">
        <tr>
            <th class="px-4 py-2 text-left">공고 제목</th>
            <th class="px-4 py-2">회사명</th>
            <th class="px-4 py-2">시작일</th>
            <th class="px-4 py-2">마감일</th>
            <th class="px-4 py-2">우대자격증</th>
            <th class="px-4 py-2">찜</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
        <c:forEach var="job" items="${jobPostings}">
            <tr class="hover:bg-gray-50">
                <td class="px-4 py-2">
                    <a href="${job.originalUrl}" target="_blank"
                       class="text-blue-600 hover:underline">${job.title}</a>
                </td>
                <td class="px-4 py-2">${job.companyName}</td>
                <td class="px-4 py-2">${job.startDate}</td>
                <td class="px-4 py-2">${job.endDate}</td>
                <td class="px-4 py-2">${job.certificate}</td>
                <td class="px-4 py-2 text-center">
                    <button type="button"
                            id="favorite-btn-${job.id}"
                            data-favorited="${job.favorited}"
                            data-link="/usr/job/detail?id=${job.id}"
                            data-title="${fn:escapeXml(job.title)}"
                            onclick="toggleFavorite(${job.id})">
                        <i id="favorite-icon-${job.id}"
                           class="fa-star ${job.favorited?'fa-solid text-yellow-400':'fa-regular'} text-xl"></i>
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- 페이징 (가운데 정렬) -->
<div class="w-full">
    <div class="flex justify-center items-center space-x-2 mt-6">
        <!-- 1페이지 링크 -->
        <c:if test="${startPage > 1}">
            <a href="<c:url value='/usr/job/list'>
                  <c:param name='page' value='1'/>
                  <c:if test='${not empty keyword}'>
                    <c:param name='searchType' value='${searchType}'/>
                    <c:param name='keyword'    value='${keyword}'/>
                  </c:if>
                </c:url>"
               class="${page == 1 ? 'text-red-500' : 'text-black'}">
                1
            </a>
        </c:if>

        <!-- 앞쪽 생략 부호 -->
        <c:if test="${startPage > 2}">
            <span class="text-black">…</span>
        </c:if>

        <!-- 현재 블록 페이지 -->
        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <a href="<c:url value='/usr/job/list'>
                  <c:param name='page' value='${i}'/>
                  <c:if test='${not empty keyword}'>
                    <c:param name='searchType' value='${searchType}'/>
                    <c:param name='keyword'    value='${keyword}'/>
                  </c:if>
                </c:url>"
               class="${page == i ? 'text-red-500' : 'text-black'}">
                    ${i}
            </a>
        </c:forEach>

        <!-- 뒤쪽 생략 부호 -->
        <c:if test="${endPage < pagesCount - 1}">
            <span class="text-black">…</span>
        </c:if>

        <!-- 마지막 페이지 링크 -->
        <c:if test="${endPage < pagesCount}">
            <a href="<c:url value='/usr/job/list'>
                  <c:param name='page' value='${pagesCount}'/>
                  <c:if test='${not empty keyword}'>
                    <c:param name='searchType' value='${searchType}'/>
                    <c:param name='keyword'    value='${keyword}'/>
                  </c:if>
                </c:url>"
               class="${page == pagesCount ? 'text-red-500' : 'text-black'}">
                    ${pagesCount}
            </a>
        </c:if>
    </div>
</div>

<footer class="mt-auto">
    <%@ include file="../common/foot.jspf" %>
</footer>
</body>
</html>
