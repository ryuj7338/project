<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/head.jspf" %>


<html>
<head>
    <title>채용공고 상세</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">
<main class="flex-1 flex items-center justify-center py-12 px-4">
    <div class="w-full max-w-2xl bg-white rounded-2xl shadow-xl p-10">
        <h1 class="text-2xl font-bold mb-8 text-gray-900 text-center">채용공고 상세</h1>
        <c:if test="${not empty jobPosting}">
            <div class="space-y-7">
                <div>
                    <div class="text-gray-500 text-xs mb-1">제목</div>
                    <div class="font-bold text-lg text-gray-900">${jobPosting.title}</div>
                </div>
                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <div class="text-gray-500 text-xs mb-1">회사명</div>
                        <div class="text-base">${jobPosting.companyName}</div>
                    </div>
                    <div>
                        <div class="text-gray-500 text-xs mb-1">자격증</div>
                        <div class="text-base">${jobPosting.certificate}</div>
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <div class="text-gray-500 text-xs mb-1">시작일</div>
                        <div class="text-base">${jobPosting.startDate}</div>
                    </div>
                    <div>
                        <div class="text-gray-500 text-xs mb-1">마감일</div>
                        <div class="text-base">${jobPosting.endDate}</div>
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <div class="text-gray-500 text-xs mb-1">D-Day</div>
                        <div class="text-base font-bold text-red-500">${jobPosting.dday}</div>
                    </div>
                    <div>
                        <div class="text-gray-500 text-xs mb-1 ">상세 페이지</div>
                        <a href="${jobPosting.originalUrl}" target="_blank"
                           class="inline-block mt-1 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition font-bold">
                            공고 원문 열기
                        </a>
                    </div>
                </div>
            </div>
        </c:if>
        <c:if test="${empty jobPosting}">
            <div class="text-center text-gray-500 py-12">
                해당 채용공고 정보를 찾을 수 없습니다.
            </div>
        </c:if>
        <!-- 닫기 버튼 -->
        <div class="mt-10 text-center">
            <button onclick="window.close()"
                    class="inline-block px-6 py-2 bg-gray-700 text-white rounded hover:bg-gray-900 transition font-semibold">
                닫기
            </button>
        </div>
    </div>
</main>

</body>
</html>
