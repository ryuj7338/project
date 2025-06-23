<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<!-- 테일윈드 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.1.4/tailwind.min.css">

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>GPT 대화 기록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
</head>
<body class="bg-gray-50">

<!-- 상단 메뉴바 -->
<nav class="bg-gray-800 text-white p-4 flex items-center">
    <div class="mr-10">
        <img src="/resource/images/logo.png" alt="경호 로고" class="h-8" />
    </div>
    <ul class="flex space-x-6 text-sm">
        <li><a href="/home" class="hover:text-gray-300">경호할래</a></li>
        <li><a href="/qualification" class="hover:text-gray-300">자격</a></li>
        <li><a href="/guide" class="hover:text-gray-300">안내</a></li>
        <li><a href="/job" class="hover:text-gray-300">취업</a></li>
        <li><a href="/info" class="hover:text-gray-300">정보</a></li>
        <li><a href="/community" class="hover:text-gray-300">커뮤니티</a></li>
        <li><a href="/resources" class="hover:text-gray-300">자료실</a></li>
    </ul>
</nav>

<div class="flex min-h-screen">

    <!-- 좌측 메뉴 -->
    <aside class="w-40 border-r p-6 bg-white">
        <h2 class="font-bold mb-6">기록</h2>
        <ul class="space-y-4 text-gray-700">
            <li><a href="/usr/gpt/history" class="hover:text-gray-900 font-semibold">GPT 대화 기록</a></li>
            <li><a href="/usr/gpt/interview" class="hover:text-gray-900">GPT 면접</a></li>
            <li><a href="/usr/gpt/cover" class="hover:text-gray-900">GPT 자기소개서</a></li>
        </ul>
    </aside>

    <!-- 메인 컨텐츠 -->
    <main class="flex-1 p-10 bg-gray-100">

        <div class="bg-white rounded-2xl p-8 shadow-md max-w-5xl mx-auto">
            <div class="flex items-center justify-between mb-6">
                <h1 class="text-2xl font-bold">GPT 대화 기록</h1>
                <form method="get" action="/usr/gpt/history" class="flex space-x-4">
                    <select name="category" onchange="this.form.submit()" class="border rounded p-2">
                        <option value="all" ${selectedCategory == 'all' ? 'selected' : ''}>전체</option>
                        <option value="면접" ${selectedCategory == '면접' ? 'selected' : ''}>면접</option>
                        <option value="자소서" ${selectedCategory == '자소서' ? 'selected' : ''}>자기소개서</option>
                        <option value="기타" ${selectedCategory == '기타' ? 'selected' : ''}>기타</option>
                    </select>
                </form>
            </div>

            <c:choose>
                <c:when test="${isLogined}">
                    <table class="w-full text-left text-sm border rounded-xl overflow-hidden">
                        <thead class="bg-gray-200 text-gray-700">
                        <tr>
                            <th class="py-2 px-4">날짜</th>
                            <th class="py-2 px-4">카테고리</th>
                            <th class="py-2 px-4">질문</th>
                            <th class="py-2 px-4">답변</th>
                            <th class="py-2 px-4">삭제</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${answers}">
                            <c:choose>
                                <c:when test="${selectedCategory == 'all'}">
                                    <tr class="border-b hover:bg-gray-50">
                                        <td class="py-2 px-4">${fn:substring(item.regDate, 0, 10)}</td>
                                        <td class="py-2 px-4">${item.category}</td>
                                        <td class="py-2 px-4 whitespace-pre-wrap cursor-pointer"
                                            onclick="location.href='/usr/gpt/history/${item.id}'">
                                                ${fn:substring(item.question, 0, 40)}<c:if test="${fn:length(item.question) > 40}">...</c:if>
                                        </td>
                                        <td class="py-2 px-4 whitespace-pre-wrap">${fn:substring(item.answer, 0, 60)}<c:if test="${fn:length(item.answer) > 60}">...</c:if></td>
                                        <td class="py-2 px-4 text-center">
                                            <button class="delete-btn" data-id="${item.id}">삭제</button>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="cat" value="${item.category}" />
                                    <c:set var="isFeedback" value="${fn:contains(cat, '-피드백')}" />

                                    <c:if test="${cat == selectedCategory or (isFeedback and cat.startsWith(selectedCategory))}">
                                        <tr class="border-b hover:bg-gray-50">
                                            <td class="py-2 px-4">${fn:substring(item.regDate, 0, 10)}</td>
                                            <td class="py-2 px-4">${item.category}</td>
                                            <td class="py-2 px-4 whitespace-pre-wrap cursor-pointer"
                                                onclick="location.href='/usr/gpt/history/${item.id}'">
                                                    ${fn:substring(item.question, 0, 40)}<c:if test="${fn:length(item.question) > 40}">...</c:if>
                                            </td>
                                            <td class="py-2 px-4 whitespace-pre-wrap">${fn:substring(item.answer, 0, 60)}<c:if test="${fn:length(item.answer) > 60}">...</c:if></td>
                                            <td class="py-2 px-4 text-center">
                                                <button class="delete-btn" data-id="${item.id}">삭제</button>
                                            </td>
                                        </tr>
                                    </c:if>

                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        </tbody>
                    </table>
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
        </div>

    </main>
</div>

<script>
    $(document).on("click", ".delete-btn", function(event) {
        event.stopPropagation();

        const btn = event.currentTarget;

        const id = $(btn).data("id");
        if (!id) {
            alert("삭제할 ID가 없습니다.");
            return;
        }
        if (!confirm("정말 삭제하시겠습니까?")) {
            return;
        }

        fetch("/usr/gpt/delete", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "id=" + id
        })
            .then(res => res.json())
            .then(result => {
                if (result.resultCode === "S-1") {
                    alert("삭제되었습니다.");
                    $(btn).closest("tr").remove();
                } else if (result.resultCode === "F-L") {
                    alert("로그인이 필요합니다.");
                    window.setTimeout(() => {
                        location.href = "/usr/member/login?redirectUrl=" + encodeURIComponent(location.pathname + location.search);
                    }, 100);
                } else {
                    alert(result.msg || "삭제에 실패했습니다.");
                }
            })
            .catch(() => {
                alert("서버와 통신 중 오류가 발생했습니다.");
            });
    });
</script>

</body>
</html>
