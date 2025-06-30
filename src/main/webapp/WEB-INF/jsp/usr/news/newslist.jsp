<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="pageTitle" value="뉴스 게시판"/>

<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="flex flex-col min-h-screen bg-gray-50">
<div class="flex flex-1 max-w-7xl mx-auto py-8 px-4 gap-6">
    <!-- 사이드바 -->
    <aside class="w-56 bg-gray-100 text-black p-6 rounded-xl shadow-md">
        <nav class="space-y-6 text-lg font-semibold">
            <a href="${ctx}/usr/news/list"
               class="block bg-blue-500 text-white px-2 py-1 rounded">
                뉴스
            </a>
            <a href="${ctx}/usr/law/list"
               class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                법률
            </a>
            <a href="${ctx}/usr/company/introduce"
               class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                경호업체
            </a>
        </nav>
    </aside>

    <!-- 메인 콘텐츠 -->
    <main class="flex-1">
        <!-- 뉴스 카드 반복 -->
        <c:forEach var="news" items="${newsList}">
            <div class="bg-white shadow rounded-lg p-6 mb-6 flex flex-col sm:flex-row sm:space-x-6">
                <c:if test="${not empty news.image}">
                    <img src="${news.image}"
                         alt="뉴스 이미지"
                         class="w-full sm:w-48 h-auto object-contain rounded-md mb-4 sm:mb-0"/>
                </c:if>
                <div class="flex-1">
                    <a href="${news.link}" target="_blank"
                       class="text-xl font-semibold text-blue-600 hover:underline">
                            ${news.title}
                    </a>
                    <div class="text-sm text-gray-500 mt-1">
                            ${news.press} &middot; ${news.date}
                    </div>
                    <p class="mt-3 text-gray-700">
                            ${news.summary}
                    </p>
                </div>
            </div>
        </c:forEach>

        <!-- 페이징 -->
        <div class="w-full">
            <div class="flex justify-center items-center space-x-2 mt-6 mb-8">
                <c:if test="${hasPrev}">
                    <a href="<c:url value='/usr/news/list'><c:param name='page' value='${prevPage}'/></c:url>"
                       class="text-black">…</a>
                </c:if>

                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <a href="<c:url value='/usr/news/list'><c:param name='page' value='${i}'/></c:url>"
                       class="${page == i ? 'text-red-500' : 'text-black'}">
                            ${i}
                    </a>
                </c:forEach>

                <c:if test="${hasNext}">
                    <a href="<c:url value='/usr/news/list'><c:param name='page' value='${nextPage}'/></c:url>"
                       class="text-black">…</a>
                </c:if>
            </div>
        </div>
    </main>
</div>

<%@ include file="../common/foot.jspf" %>
</body>
</html>
