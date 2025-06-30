<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>GPT 대화 상세 보기</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">

<div class="flex flex-1 max-w-7xl w-full mx-auto py-16 px-8">

    <!-- 좌측 메뉴(통일된 스타일) -->
    <aside class="w-64 flex-shrink-0 bg-white rounded-xl shadow-md p-8 mr-8 min-h-[600px] h-fit">
        <h2 class="font-bold text-xl mb-8 mt-12">기록 메뉴</h2>
        <nav class="space-y-2">
            <a href="${ctx}/usr/gpt/history"
               class="block px-4 py-3 rounded-lg font-semibold text-lg transition
         ${pageTitle eq '대화 기록 상세' ? 'bg-blue-500 text-white' : 'hover:bg-blue-100 text-gray-900'}">
                GPT 대화 기록
            </a>
            <a href="${ctx}/usr/gpt/interview"
               class="block px-4 py-3 rounded-lg font-semibold text-lg transition hover:bg-blue-100 text-gray-900">
                GPT 면접
            </a>
            <a href="${ctx}/usr/gpt/resume"
               class="block px-4 py-3 rounded-lg font-semibold text-lg transition hover:bg-blue-100 text-gray-900">
                GPT 자기소개서
            </a>
        </nav>
    </aside>

    <!-- 메인 컨텐츠 -->
    <main class="flex-1 bg-white rounded-xl shadow-md p-12 min-h-[600px] flex flex-col">
        <h1 class="text-3xl font-bold mb-8 text-gray-900">${answer.category} 대화 기록 상세보기</h1>
        <div class="space-y-8">

            <div>
                <h3 class="font-semibold mb-2 text-lg">질문</h3>
                <div class="p-5 bg-gray-50 rounded-xl whitespace-pre-wrap border border-gray-200 text-base">${answer.question}</div>
            </div>

            <div>
                <h3 class="font-semibold mb-2 text-lg">답변</h3>
                <div class="p-5 bg-gray-50 rounded-xl whitespace-pre-wrap border border-gray-200 text-base">${answer.answer}</div>
            </div>

            <div class="text-gray-500 text-base mt-2 space-x-4">
                <span>번호: ${answer.id}</span>
                <span>날짜: ${fn:substring(answer.regDate, 0, 10)}</span>
                <span>카테고리: ${answer.category}</span>
            </div>

            <div class="mt-8">
                <a href="${ctx}/usr/gpt/history"
                   class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-semibold px-8 py-3 rounded-lg transition">
                    목록으로 돌아가기
                </a>
            </div>
        </div>
    </main>
</div>
<%@ include file="../common/foot.jspf" %>
</body>
</html>
