<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="법령 정보"/>

<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="flex flex-col min-h-screen bg-gray-50">
<main class="flex-grow w-full py-16 px-4">
    <div class="flex w-full max-w-7xl mx-auto mt-20 gap-6">

        <!-- 사이드바 -->
        <aside class="w-56 bg-gray-100 text-black p-6 rounded-xl shadow-md">
            <nav class="space-y-6 text-lg font-semibold mt-14">
                <a href="${ctx}/usr/news/list" class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                    뉴스
                </a>
                <a href="${ctx}/usr/law/list" class="block bg-blue-500 text-white px-2 py-1 rounded">
                    법률
                </a>
                <a href="${ctx}/usr/company/introduce"
                   class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                    경호업체
                </a>
            </nav>
        </aside>

        <!-- 본문: 법령 목록 + 검색 폼 -->
        <section class="flex-1 bg-white rounded-xl shadow-md p-6 overflow-y-auto">
            <h1 class="text-2xl font-bold mb-4">법령 정보 목록</h1>

            <!-- ▶ 이 부분을 테이블 카드 안으로 옮겼습니다 -->
            <div class="flex justify-end mb-4">
                <form method="get"
                      action="${ctx}/usr/law/list"
                      onsubmit="return validateSearch();"
                      class="flex items-center space-x-2">
                    <select name="searchType" class="border rounded h-10 px-3 text-sm">
                        <option value="title" ${searchType=='title'?'selected':''}>법령명</option>
                    </select>
                    <div class="relative">
                        <input type="text" id="keyword" name="keyword"
                               value="${keyword}"
                               placeholder="검색어 입력"
                               autocomplete="off"
                               class="border rounded h-10 px-3 text-sm"/>
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

            <!-- 테이블 -->
            <div class="overflow-x-auto">
                <table class="min-w-full bg-white divide-y divide-gray-200 text-sm">
                    <thead class="bg-gray-100">
                    <tr>
                        <th class="px-4 py-2 text-left">법령명</th>
                        <th class="px-4 py-2">공포번호</th>
                        <th class="px-4 py-2">공포일자</th>
                        <th class="px-4 py-2">법령구분명</th>
                        <th class="px-4 py-2">시행일자</th>
                        <th class="px-4 py-2">소관부처명</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                    <c:forEach var="law" items="${lawList}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-4 py-2">
                                <a href="${law['법령상세링크']}" target="_blank"
                                   class="text-blue-600 hover:underline">
                                        ${law['법령명']}
                                </a>
                            </td>
                            <td class="px-4 py-2">${law['공포번호']}</td>
                            <td class="px-4 py-2">${law['공포일자']}</td>
                            <td class="px-4 py-2">${law['법령구분명']}</td>
                            <td class="px-4 py-2">${law['시행일자']}</td>
                            <td class="px-4 py-2">${law['소관부처명']}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 페이징 -->
            <div class="flex justify-center space-x-2 mt-6">
                <c:if test="${startPage > 1}">
                    <a href="${ctx}/usr/law/list?page=1"
                       class="text-black">1</a>
                    <span>…</span>
                </c:if>
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <a href="${ctx}/usr/law/list?page=${i}"
                       class="${pageNo == i ? 'text-red-500' : 'text-black'}">
                            ${i}
                    </a>
                </c:forEach>
                <c:if test="${endPage < pagesCount}">
                    <span>…</span>
                    <a href="${ctx}/usr/law/list?page=${pagesCount}"
                       class="text-black">${pagesCount}</a>
                </c:if>
            </div>
        </section>
    </div>
</main>

<!-- 스크립트 (검색 검증 + 자동완성) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    function validateSearch() {
        const kw = $('#keyword').val().trim();
        if (!kw) {
            alert('검색어를 입력하세요.');
            $('#keyword').focus();
            return false;
        }
        return true;
    }

    $(function () {
        const $input = $('#keyword'), $list = $('#autocompleteList');
        let timer;
        $input.on('input', function () {
            clearTimeout(timer);
            const v = $(this).val().trim();
            if (!v) {
                $list.hide().empty();
                return;
            }
            timer = setTimeout(() => {
                $.getJSON('${ctx}/usr/autocomplete/law', {keyword: v})
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
</script>

<%@ include file="../common/foot.jspf" %>
</body>
</html>
