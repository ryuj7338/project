<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<c:set var="pageTitle" value="${board.code}"/>

<body class="flex flex-col min-h-screen">
<%@ include file="../common/nav.jspf" %>

<!-- 메인 영역 -->
<main class="flex-grow w-full py-16 px-4">
    <div class="flex w-full mt-20 gap-6 px-4">

        <c:if test="${boardId != 5}">
            <!-- 사이드 메뉴 -->
            <aside class="w-64 bg-gray-100 text-black p-6 rounded-xl shadow-md min-h-[800px]">
                <nav class="space-y-6 text-lg font-semibold mt-14">
                    <a href="<c:url value='/usr/post/list'><c:param name='boardId' value='1'/></c:url>"
                       class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                        질문 게시판
                    </a>
                    <a href="<c:url value='/usr/post/list'><c:param name='boardId' value='2'/></c:url>"
                       class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                        정보 공유
                    </a>
                    <a href="<c:url value='/usr/post/list'><c:param name='boardId' value='3'/></c:url>"
                       class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                        합격 후기
                    </a>
                    <a href="<c:url value='/usr/post/list'><c:param name='boardId' value='4'/></c:url>"
                       class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                        자유게시판
                    </a>
                </nav>
            </aside>
        </c:if>

        <!-- 게시판 본문 영역 -->
        <section class="flex-1 bg-gray-100 rounded-xl shadow-md px-8 py-6 flex flex-col min-h-[800px]">
            <div class="flex justify-end items-center mb-6 space-x-2">
                <!-- 검색 폼 -->
                <form class="flex items-center space-x-2" action="../post/list?boardId=${boardId}" method="POST">
                    <select name="searchType" class="border rounded h-10 px-3 text-sm">
                        <option disabled selected>선택</option>
                        <option value="title" <c:if test="${param.searchType == 'title'}">selected</c:if>>제목</option>
                        <option value="body" <c:if test="${param.searchType == 'body'}">selected</c:if>>내용</option>
                        <option value="nickname" <c:if test="${param.searchType == 'nickname'}">selected</c:if>>작성자
                        </option>
                    </select>

                    <div class="relative">
                        <input type="text" name="searchKeyword" id="searchKeyword"
                               class="border rounded h-10 px-3 w-64 text-sm"
                               placeholder="검색어 입력"
                               value="${param.searchKeyword}" autocomplete="off">
                        <ul id="autocompleteList"
                            style="display:none; position:absolute; top:100%; left:0; background:#fff;
                       border:1px solid #ccc; max-height:150px; overflow-y:auto;
                       width:100%; z-index:1000; list-style:none; padding:0; margin:0;">
                        </ul>
                    </div>

                    <button type="submit"
                            class="bg-blue-500 text-white h-10 px-4 rounded text-sm hover:bg-blue-600">
                        검색
                    </button>
                </form>

                <!-- 글쓰기 버튼 -->
                <c:if test="${rq.isLogined && boardId != 5}">
                    <a href="../post/write?boardId=${boardId}"
                       class="h-10 px-4 bg-black text-white rounded text-sm hover:bg-gray-800 flex items-center justify-center">
                        글쓰기
                    </a>
                </c:if>
            </div>

            <!-- 게시판 목록 -->
            <div class="overflow-x-auto">
                <table class="w-full text-center border-separate border-spacing-y-2">
                    <thead class="bg-gray-400 text-white text-sm h-12">
                    <tr>
                        <th class="w-20">번호</th>
                        <th>제목</th>
                        <th class="w-32">작성자</th>
                        <th class="w-40">작성일</th>
                        <th class="w-20">조회수</th>
                        <th class="w-20">좋아요</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white text-sm">
                    <c:choose>
                        <c:when test="${posts.size() > 0}">
                            <c:forEach var="post" items="${posts}">
                                <tr class="hover:bg-gray-200 h-12">
                                    <td>${post.id}</td>
                                    <td class="text-left pl-4">
                                        <a href="../post/detail?id=${post.id}" class="hover:underline">${post.title}</a>
                                    </td>
                                    <td>${post.extra__writer}</td>
                                    <td>${post.regDate}</td>
                                    <td>${post.hit}</td>
                                    <td>${post.like}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr class="h-24">
                                <td colspan="6" class="text-center text-gray-500">게시글이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 페이징 -->
            <div class="flex justify-center mt-10">
                <div class="btn-group join">
                    <c:set var="paginationLen" value="3"/>
                    <c:set var="startPage" value="${page - paginationLen >= 1 ? page - paginationLen : 1}"/>
                    <c:set var="endPage"
                           value="${page + paginationLen <= pagesCount ? page + paginationLen : pagesCount}"/>

                    <c:if test="${startPage > 1}">
                        <a class="join-item btn btn-sm" href="?page=1&boardId=${boardId}">1</a>
                    </c:if>

                    <c:if test="${startPage > 2}">
                        <button class="join-item btn btn-sm btn-disabled">...</button>
                    </c:if>

                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                        <a class="join-item btn btn-sm" href="?page=${i}&boardId=${boardId}"
                           style="${i == page ? 'font-weight:bold; color:red;' : ''}">${i}</a>
                    </c:forEach>

                    <c:if test="${endPage < pagesCount - 1}">
                        <button class="join-item btn btn-sm btn-disabled">...</button>
                    </c:if>

                    <c:if test="${endPage < pagesCount}">
                        <a class="join-item btn btn-sm" href="?page=${pagesCount}&boardId=${boardId}">${pagesCount}</a>
                    </c:if>
                </div>
            </div>
        </section>
    </div>
</main>

<!-- 자동완성 스크립트 -->
<script>
    $(function () {
        const $input = $('#searchKeyword');
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
                    url: '/usr/autocomplete/search',
                    method: 'GET',
                    data: {keyword: keyword},
                    dataType: 'json',
                    success: function (data) {
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
                            }).on('click', function () {
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

        $(document).on('click', function (e) {
            if (!$(e.target).closest('#searchKeyword, #autocompleteList').length) {
                $list.hide().empty();
            }
        });
    });
</script>

<%@ include file="../common/foot.jspf" %>
</body>
</html>
