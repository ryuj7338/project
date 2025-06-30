<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="flex flex-col min-h-screen bg-gray-50">
<main class="flex-grow bg-white">
    <div class="flex w-full max-w-7xl mx-auto mt-20 gap-6 px-4">

        <!-- job 메뉴 사이드바 -->
        <aside class="w-56 bg-gray-100 text-black p-6 rounded-xl shadow-md min-h-[800px]">
            <nav class="space-y-6 text-lg font-semibold mt-14">
                <a href="${ctx}/usr/news/list"
                   class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
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

        <!-- 콘텐츠 영역 -->
        <section class="flex-1 bg-gray-100 rounded-xl shadow-md px-8 py-6 flex flex-col overflow-y-auto">

            <!-- 제목 -->
            <h1 class="text-2xl font-bold mb-6">대표 경호/보안업체 5선</h1>

            <!-- 업체 카드 그리드 -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">

                <div class="bg-white shadow rounded-lg p-4">
                    <h3 class="text-xl font-semibold mb-2">에스원 (S-1)</h3>
                    <p class="text-gray-700 mb-2">
                        국내 최대 규모의 종합 보안 서비스 기업으로, 개인·기업·시설 경비부터
                        ICT 보안 솔루션까지 제공합니다.
                    </p>
                    <a href="https://www.s1.co.kr" target="_blank"
                       class="text-blue-600 hover:underline text-sm">
                        www.s1.co.kr
                    </a>
                </div>

                <div class="bg-white shadow rounded-lg p-4">
                    <h3 class="text-xl font-semibold mb-2">ADT 캡스</h3>
                    <p class="text-gray-700 mb-2">
                        실시간 관제 시스템과 출동 서비스를 결합한 토털 보안 솔루션을 제공하며,
                        IoT 기반 스마트 보안 분야도 선도합니다.
                    </p>
                    <a href="https://www.adtcaps.co.kr" target="_blank"
                       class="text-blue-600 hover:underline text-sm">
                        www.adtcaps.co.kr
                    </a>
                </div>

                <div class="bg-white shadow rounded-lg p-4">
                    <h3 class="text-xl font-semibold mb-2">KT텔레캅</h3>
                    <p class="text-gray-700 mb-2">
                        KT 통신망을 활용한 스마트 보안 서비스를 제공하며, 영상관제·출동·IoT
                        통합 관제 플랫폼을 운영합니다.
                    </p>
                    <a href="https://www.kttelecop.co.kr" target="_blank"
                       class="text-blue-600 hover:underline text-sm">
                        www.kttelecop.co.kr
                    </a>
                </div>

                <div class="bg-white shadow rounded-lg p-4">
                    <h3 class="text-xl font-semibold mb-2">한화시큐어</h3>
                    <p class="text-gray-700 mb-2">
                        공공·금융·산업 시설 보안 컨설팅부터 물리보안·정보보안까지
                        종합 보안 서비스를 제공합니다.
                    </p>
                    <a href="https://www.hanwhasecure.com" target="_blank"
                       class="text-blue-600 hover:underline text-sm">
                        www.hanwhasecure.com
                    </a>
                </div>

                <div class="bg-white shadow rounded-lg p-4">
                    <h3 class="text-xl font-semibold mb-2">세콤 (Secom)</h3>
                    <p class="text-gray-700 mb-2">
                        일본 본사를 둔 글로벌 보안 기업으로, 한국에서는 출동·관제·방범 시스템을
                        기반으로 한 토털 보안 솔루션을 제공합니다.
                    </p>
                    <a href="https://www.secom.co.kr" target="_blank"
                       class="text-blue-600 hover:underline text-sm">
                        www.secom.co.kr
                    </a>
                </div>

            </div>
        </section>

    </div>
</main>
<%@ include file="../common/foot.jspf" %>
</body>
</html>
