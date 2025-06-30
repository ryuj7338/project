<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="회원정보 수정"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="white"/>
<%@ include file="../common/nav.jspf" %>

<script type="text/javascript">
    function MemberModify__submit(form) {
        form.loginPw.value = form.loginPw.value.trim();

        if (form.loginPw.value.length > 0) {
            form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
            if (form.loginPwConfirm.value.length == 0) {
                alert('비밀번호 확인을 입력하세요.');
                form.loginPwConfirm.focus();
                return false;
            }

            if (form.loginPwConfirm.value != form.loginPw.value) {
                alert('비밀번호가 일치하지 않습니다.');
                form.loginPwConfirm.focus();
                return false;
            }
        }

        form.submit();
    }
</script>

<body class="bg-gray-100 min-h-screen flex flex-col">
<main class="flex-grow flex items-center justify-center px-4 py-10">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg p-10 border border-gray-100">
        <h2 class="text-2xl font-bold mb-8 text-center text-gray-900">회원정보 수정</h2>
        <form onsubmit="MemberModify__submit(this); return false;" action="../member/doModify" method="POST"
              autocomplete="off">
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">가입일</label>
                <div class="border rounded px-3 py-2 bg-gray-100 text-center text-base">${rq.loginedMember.regDate}</div>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">아이디</label>
                <div class="border rounded px-3 py-2 bg-gray-100 text-center text-base">${rq.loginedMember.loginId}</div>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">새 비밀번호</label>
                <input class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       name="loginPw" type="password" placeholder="새 비밀번호를 입력하세요"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">새 비밀번호 확인</label>
                <input class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       name="loginPwConfirm" type="password" placeholder="비밀번호 확인"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">이름</label>
                <input class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       name="name" type="text" placeholder="이름을 입력하세요" value="${rq.loginedMember.name}"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">닉네임</label>
                <input class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       name="nickname" type="text" placeholder="닉네임을 입력하세요" value="${rq.loginedMember.nickname}"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">이메일</label>
                <input class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       name="email" type="email" placeholder="이메일을 입력하세요" value="${rq.loginedMember.email}"/>
            </div>
            <div class="mb-8">
                <label class="block mb-1 text-gray-700 font-semibold">전화번호</label>
                <input class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       name="cellphone" type="text" placeholder="전화번호를 입력하세요" value="${rq.loginedMember.cellphone}"/>
            </div>
            <div class="flex justify-between gap-4">
                <button type="submit"
                        class="flex-1 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 rounded-xl transition">
                    수정
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
