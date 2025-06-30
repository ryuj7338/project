<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="flex flex-col min-h-screen bg-gray-50">
<main class="flex-grow w-full py-16 px-4">
    <div class="flex w-full max-w-7xl mx-auto mt-20 gap-6">

        <!-- 사이드바 -->
        <aside class="w-56 bg-gray-100 text-black p-6 rounded-xl shadow-md min-h-[800px]">
            <nav class="space-y-6 text-lg font-semibold mt-14">
                <a href="${ctx}/usr/post/introduce"
                   class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                    경호원이란?
                </a>
                <a href="${ctx}/usr/post/requirements"
                   class="block bg-blue-500 text-white px-2 py-1 rounded">
                    자격요건
                </a>
                <a href="${ctx}/usr/qualification/list"
                   class="block hover:bg-blue-500 hover:text-white px-2 py-1 rounded">
                    자격증
                </a>
            </nav>
        </aside>

        <!-- 본문: 자격요건 -->
        <section class="flex-1 bg-white rounded-xl shadow-md p-8 overflow-y-auto">
            <h1 class="text-2xl font-bold mb-6">자격요건</h1>
            <ul class="list-disc list-inside text-gray-700 space-y-3">
                <li>
                    <strong>신체적 조건:</strong>
                    강인한 체력, 지구력, 민첩성 확보가 필수적입니다. 장시간 대기 및
                    비상 상황에서 신속히 대응해야 합니다.
                </li>
                <li>
                    <strong>정신적 강인함:</strong>
                    스트레스 관리 능력과 위기 상황에서도 침착함을 유지할 수 있는
                    정신적 안정성이 요구됩니다.
                </li>
                <li>
                    <strong>전문 기술:</strong>
                    제압술, 무술, 호신술 등의 신체 제어 기술과
                    응급처치(CPR 등) 자격증이 있으면 우대됩니다.
                </li>
                <li>
                    <strong>자격증:</strong>
                    국가공인 자격인 경비지도사, 신변보호사,
                    위험물기능사 등 관련 자격증 소지자 우대
                </li>
                <li>
                    <strong>모의 훈련 경험:</strong>
                    위협 시나리오에 따른 모의훈련,
                    차량 호송 연습, 다중 출동 훈련 등을 통해
                    현장 대응 능력을 향상시켜야 합니다.
                </li>
                <li>
                    <strong>기타 역량:</strong>
                    우수한 관찰력, 상황 판단력, 대인 관계 능력 및
                    외국어(영어 등) 소통 능력 보유 시 가산점
                </li>
            </ul>
        </section>

    </div>
</main>

<%@ include file="../common/foot.jspf" %>
</body>
</html>
