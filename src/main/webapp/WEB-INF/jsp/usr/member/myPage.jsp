<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="마이페이지"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="white"/>
<%@ include file="../common/nav.jspf" %>

<body class="bg-gray-100 min-h-screen flex flex-col">
<main class="flex-grow flex items-center justify-center px-4 py-10">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg p-10 border border-gray-100">
        <h2 class="text-2xl font-bold mb-8 text-center text-gray-900">마이페이지</h2>
        <table class="w-full text-base">
            <tbody>
            <tr>
                <th class="py-3 text-left font-semibold w-32 text-gray-700">가입일</th>
                <td class="py-3 text-center">${rq.loginedMember.regDate}</td>
            </tr>
            <tr>
                <th class="py-3 text-left font-semibold text-gray-700">아이디</th>
                <td class="py-3 text-center">${rq.loginedMember.loginId}</td>
            </tr>
            <tr>
                <th class="py-3 text-left font-semibold text-gray-700">이름</th>
                <td class="py-3 text-center">${rq.loginedMember.name}</td>
            </tr>
            <tr>
                <th class="py-3 text-left font-semibold text-gray-700">닉네임</th>
                <td class="py-3 text-center">${rq.loginedMember.nickname}</td>
            </tr>
            <tr>
                <th class="py-3 text-left font-semibold text-gray-700">이메일</th>
                <td class="py-3 text-center">${rq.loginedMember.email}</td>
            </tr>
            <tr>
                <th class="py-3 text-left font-semibold text-gray-700">전화번호</th>
                <td class="py-3 text-center">${rq.loginedMember.cellphone}</td>
            </tr>
            <tr>
                <th class="py-3 text-left font-semibold text-gray-700">회원정보 수정</th>
                <td class="py-3 text-center">
                    <a href="../member/checkPw"
                       class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-xl font-semibold transition">수정</a>
                </td>
            </tr>
            </tbody>
        </table>
        <div class="flex justify-end mt-8">
            <button type="button" onclick="history.back()"
                    class="bg-gray-300 hover:bg-gray-400 text-gray-900 font-semibold py-2 px-6 rounded-xl transition">
                뒤로가기
            </button>
        </div>
    </div>
</main>

<%@ include file="../common/foot.jspf" %>
</body>
