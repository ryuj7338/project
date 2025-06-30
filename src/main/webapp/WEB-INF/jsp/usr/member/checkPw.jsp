<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="비밀번호 확인"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="white"/>
<%@ include file="../common/nav.jspf" %>

<body class="bg-gray-100 min-h-screen flex flex-col">
<main class="flex-grow flex items-center justify-center px-4 py-10">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md p-10 border border-gray-100">
        <h2 class="text-2xl font-bold mb-8 text-center text-gray-900">비밀번호 확인</h2>
        <form action="../member/doCheckPw" method="POST" autocomplete="off">
            <div class="mb-6">
                <label class="block mb-2 text-gray-700 font-semibold">아이디</label>
                <div class="border rounded px-3 py-2 bg-gray-100 text-center text-lg">
                    ${rq.loginedMember.loginId}
                </div>
            </div>
            <div class="mb-8">
                <label class="block mb-2 text-gray-700 font-semibold">비밀번호</label>
                <input
                        class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        name="loginPw"
                        type="password"
                        placeholder="비밀번호를 입력하세요"
                        required
                />
            </div>
            <div class="flex justify-between gap-4">
                <button type="submit"
                        class="flex-1 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 rounded-xl transition">
                    확인
                </button>
                <button type="button" onclick="history.back()"
                        class="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-900 font-semibold py-2 rounded-xl transition">
                    뒤로가기
                </button>
            </div>
        </form>
    </div>
</main>

<%@ include file="../common/foot.jspf" %>
</body>
