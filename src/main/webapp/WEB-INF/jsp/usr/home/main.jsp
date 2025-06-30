<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="메인"/>
<c:set var="pageColor" value="white"/>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="mainImage" value="${ctx}/image/security.png"/>

<%@ include file="../common/head.jspf" %>

<body class="bg-gray-900 text-gray-50 min-h-screen flex flex-col">
<%@ include file="../common/nav.jspf" %>

<main class="flex-grow">
    <div class="w-full mt-12 overflow-hidden rounded-lg shadow-lg bg-center bg-no-repeat bg-cover"
         style="background-image: url('${mainImage}'); height: 33vw; max-height: 400px;">
    </div>

    <section class="w-full min-h-screen bg-gray-900 p-64">
  <div class="grid grid-cols-2 gap-x-24 gap-y-48">
            <!-- 1행: 자료실 / 최신 뉴스 -->
            <div>
                <h3 class="font-semibold mb-2 text-white">자료실</h3>
                <div class="bg-gray-700 rounded-lg h-48 p-4 overflow-auto">
                    <ul class="space-y-2"> <!-- 줄 간격만 주고, flex/grid 없음! -->
                        <c:forEach var="res" items="${resourceList}">
                            <li class="block">
                                <a href="/resource/detail?id=${res.id}"
                                   class="hover:underline text-blue-200">${res.title}</a>
                                <span class="text-xs text-gray-300 ml-1">(${res.regDate})</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
            <div>
                <h3 class="font-semibold mb-2 text-white">최신 뉴스</h3>
                <div class="bg-gray-700 rounded-lg h-48 p-4 overflow-auto">
                    <ul class="space-y-2">
                        <c:forEach var="news" items="${newsList}">
                            <li class="block">
                                <a href="${news.link}" target="_blank"
                                   class="block font-semibold hover:underline text-blue-100">
                                        ${news.title}
                                </a>
                                <span class="text-xs text-gray-400">${news.press} - ${news.date}</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
            <!-- 2행: 자격증 정보 / 채용공고 -->
            <div>
                <h3 class="font-semibold mb-2 text-white">자격증 정보</h3>
                <div class="bg-gray-700 rounded-lg h-48 p-4 overflow-auto">
                    <ul>
                        <c:forEach var="qual" items="${qualList}">
                            <li class="block">
                                <span class="font-semibold text-white">${qual.name}</span>
                                <span class="text-gray-400">(${qual.type})</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
            <div>
                <h3 class="font-semibold mb-2 text-white">채용공고</h3>
                <div class="bg-gray-700 rounded-lg h-48 p-4 overflow-auto">
                    <ul>
                        <c:forEach var="job" items="${jobList}">
                            <li class="block">
                                <a href="/post/detail?id=${job.id}"
                                   class="block font-semibold hover:underline text-blue-200">
                                        ${job.title}
                                </a>
                                <span class="text-gray-400 text-xs">${job.startDate}</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
    </section>

</main>

</body>
<%@ include file="../common/foot.jspf" %>
</html>
