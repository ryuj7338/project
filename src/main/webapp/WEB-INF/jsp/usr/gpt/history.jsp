<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>GPT 대화 기록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
    const isNotificationPopupAllowed = false;
</script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

<!-- 컨텐츠: 좌측 메뉴 + 메인 -->
<div class="flex flex-1 w-full max-w-7xl mx-auto py-16 px-8">
    <!-- 좌측 메뉴 -->
    <aside class="w-64 flex-shrink-0">
        <div class="bg-white rounded-2xl shadow-md h-full py-10 flex flex-col justify-start items-stretch">
            <nav class="flex flex-col gap-3 px-6">
                <a href="${ctx}/usr/gpt/interview"
                   class="py-3 px-4 rounded-lg font-semibold text-lg text-left
                       ${category == '면접' ? 'bg-blue-500 text-white' : 'hover:bg-blue-100 text-gray-900'}">
                    면접 GPT
                </a>
                <a href="${ctx}/usr/gpt/resume"
                   class="py-3 px-4 rounded-lg font-semibold text-lg text-left
                       ${category == '자기소개서' ? 'bg-blue-500 text-white' : 'hover:bg-blue-100 text-gray-900'}">
                    자기소개서 GPT
                </a>
                <a href="${ctx}/usr/gpt/history"
                   class="py-3 px-4 rounded-lg font-semibold text-lg text-left
                       ${category == '대화 기록' ? 'bg-blue-500 text-white' : 'hover:bg-blue-100 text-gray-900'}">
                    대화 기록
                </a>
            </nav>
        </div>
    </aside>

    <!-- 메인 컨텐츠 -->
    <main class="flex-1 p-10">
        <div class="flex items-center justify-between mb-6">
            <h1 class="text-2xl font-bold">GPT 대화 기록</h1>
            <form method="get" action="/usr/gpt/history" class="flex space-x-4">
                <select name="category" onchange="this.form.submit()" class="border rounded p-2">
                    <option value="all" ${selectedCategory == 'all' ? 'selected' : ''}>전체</option>
                    <option value="면접" ${selectedCategory == '면접' ? 'selected' : ''}>면접</option>
                    <option value="자기소개서" ${selectedCategory == '자기소개서' ? 'selected' : ''}>자기소개서</option>
                    <option value="기타" ${selectedCategory == '기타' ? 'selected' : ''}>기타</option>
                </select>
            </form>
        </div>

        <c:choose>
            <c:when test="${isLogined}">
                <div class="grid grid-cols-1 gap-6">
                    <c:forEach var="item" items="${answers}">
                        <c:if test="${selectedCategory == 'all' || item.category == selectedCategory}">
                            <div class="bg-white shadow-md rounded-xl p-6 hover:shadow-lg transition">
                                <div class="flex justify-between items-center mb-2">
                                    <span class="text-sm text-gray-500">${fn:substring(item.regDate, 0, 10)}</span>
                                    <span class="text-xs bg-blue-100 text-blue-600 font-semibold px-2 py-1 rounded">${item.category}</span>
                                </div>
                                <div class="text-gray-800 font-semibold mb-2">
                                    Q. ${fn:substring(item.question, 0, 60)}
                                    <c:if test="${fn:length(item.question) > 60}">...</c:if>
                                </div>
                                <div class="text-gray-600 text-sm mb-4">
                                    A. ${fn:substring(item.answer, 0, 80)}
                                    <c:if test="${fn:length(item.answer) > 80}">...</c:if>
                                </div>
                                <div class="flex justify-end space-x-4 text-sm">
                                    <a href="/usr/gpt/history/${item.id}" class="text-blue-600 hover:underline">자세히
                                        보기</a>
                                    <button type="button" class="text-red-500 hover:underline delete-btn"
                                            data-id="${item.id}">삭제
                                    </button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center text-gray-600 py-20">
                    <p class="mb-4 text-lg font-semibold">로그인이 필요합니다.</p>
                    <a href="/usr/member/login?redirectUrl=${pageContext.request.requestURI}"
                       class="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition">
                        로그인 하러 가기
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<!-- 삭제 스크립트 -->
<script>
    $(document).on("click", ".delete-btn", function (event) {
        event.stopPropagation();
        const btn = $(this);
        const id = btn.data("id");

        if (!confirm("정말 삭제하시겠습니까?")) return;

        fetch("/usr/gpt/delete", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: "id=" + id
        }).then(res => res.json())
            .then(result => {
                if (result.resultCode === "S-1") {
                    alert("삭제되었습니다.");
                    btn.closest(".bg-white").remove();
                } else {
                    alert(result.msg || "삭제에 실패했습니다.");
                }
            }).catch(() => {
            alert("서버 오류가 발생했습니다.");
        });
    });
</script>

<!-- 푸터: body 맨 아래에, 가로 전체! -->
<footer class="w-full bg-gray-800 text-gray-200 py-8 mt-auto">
    <div class="max-w-7xl mx-auto px-6 flex flex-col md:flex-row md:items-center md:justify-between text-center md:text-left">
        <div>
            <div class="text-xs mb-1">고객지원: ryuji7338@gmail.com</div>
            <div class="text-xs mb-1">문의전화: 010-8353-7338</div>
            <div class="text-xs">운영시간: 평일 10:00 ~ 18:00</div>
        </div>
        <div class="mt-2 md:mt-0 text-xs text-gray-400">&copy; 2025 Guardium. All rights reserved.</div>
    </div>
</footer>
</body>
</html>
