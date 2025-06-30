<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="flex flex-col min-h-screen bg-gray-50">
<main class="flex-grow bg-white">
    <div class="flex w-full max-w-7xl mx-auto mt-20 gap-6 px-4">

        <!-- 사이드 메뉴 -->
        <aside class="w-56 bg-gray-100 text-black p-6 rounded-xl shadow-md min-h-[800px]">
            <nav class="space-y-6 text-lg font-semibold mt-14">
                <a href="${ctx}/usr/post/introduce"
                   class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                    경호원이란?
                </a>
                <a href="${ctx}/usr/post/requirements"
                   class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                    자격요건
                </a>
                <a href="${ctx}/usr/qualification/list"
                   class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                    자격증
                </a>
            </nav>
        </aside>

        <!-- 콘텐츠 영역 -->
        <section class="flex-1 bg-gray-100 rounded-xl shadow-md px-8 py-6 flex flex-col">
            <!-- 페이지 제목 -->
            <h1 class="text-2xl font-bold mb-4">경호원이란?</h1>

            <!-- 상세 내용 -->
            <div class="text-gray-700 leading-relaxed space-y-4">
                <p>
                    <strong>경호원(護衛員, 보디가드)</strong>은
                    개인 또는 집단의 신변을 보호하기 위해
                    전문적인 교육과 훈련을 받은 보안 전문가입니다.
                    물리적 충돌, 범죄, 사고 등 모든 위험 상황에서
                    의뢰인의 안전을 책임집니다.
                </p>
                <h2 class="text-xl font-semibold">주요 역할</h2>
                <ul class="list-disc list-inside pl-4 space-y-1">
                    <li>VIP(정치인·기업인·연예인) 신변 보호</li>
                    <li>행사·이벤트 현장 경호 및 출입 통제</li>
                    <li>위험 요소 탐지 및 제거</li>
                    <li>위기 상황 긴급 대응 및 대피 유도</li>
                    <li>보안 컨설팅 및 리스크 분석</li>
                </ul>
                <h2 class="text-xl font-semibold">필수 역량</h2>
                <ul class="list-disc list-inside pl-4 space-y-1">
                    <li>강인한 체력·지구력·민첩성</li>
                    <li>스트레스 관리 및 침착함</li>
                    <li>제압술·응급처치 등 전문 기술</li>
                    <li>경비지도사·신변보호사 등 자격증</li>
                    <li>모의 위협 시나리오 훈련</li>
                </ul>
                <h2 class="text-xl font-semibold">활용 분야</h2>
                <p>
                    개인 경호, 대규모 행사 보안, 시설·건물 경비, 해외 단독 경호 등
                    다양한 분야에서 활동합니다.
                </p>
                <h2 class="text-xl font-semibold">문의</h2>
                <p>
                    <strong>전화:</strong> 02-1234-5678<br/>
                    <strong>이메일:</strong>
                    <a href="mailto:security@example.com" class="text-blue-600 hover:underline">
                        security@example.com
                    </a>
                </p>
            </div>
        </section>

    </div>
</main>
<%@ include file="../common/foot.jspf" %>
</body>
</html>
