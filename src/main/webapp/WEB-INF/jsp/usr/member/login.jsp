<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="MEMBER LOGIN"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<body class="bg-gray-100 flex flex-col min-h-screen">
<main class="flex-1 flex items-center justify-center px-4">
    <section class="w-full max-w-md bg-white p-10 mt-12 rounded-2xl shadow-xl border border-gray-200">
        <h2 class="text-2xl font-bold text-center mb-8 text-gray-900">로그인</h2>
        <form action="../member/doLogin" method="POST">
            <input type="hidden" name="redirectUrl" value="${param.redirectUrl}"/>

            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">아이디</label>
                <input name="loginId" autocomplete="on" type="text"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="아이디 입력"/>
            </div>

            <div class="mb-6">
                <label class="block mb-1 text-gray-700 font-semibold">비밀번호</label>
                <input name="loginPw" autocomplete="off" type="password"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="비밀번호 입력"/>
            </div>

            <div class="flex justify-between items-center mb-6 text-sm">
                <a href="${rq.findLoginIdUri}" class="text-blue-600 hover:underline">아이디 찾기</a>
                <a href="${rq.findLoginPwUri}" class="text-green-600 hover:underline">비밀번호 찾기</a>
            </div>

            <button type="submit"
                    class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 rounded-xl transition">
                로그인
            </button>
        </form>

        <div class="mt-6 text-center">
            <button type="button" onclick="history.back();"
                    class="text-sm text-gray-600 hover:underline">
                뒤로가기
            </button>
        </div>
    </section>
</main>

<%@ include file="../common/foot.jspf" %>
</body>
</html>
