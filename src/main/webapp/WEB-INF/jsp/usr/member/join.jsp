<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="회원가입"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="white"/>
<%@ include file="../common/nav.jspf" %>

<!-- lodash debounce -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>
<script>
    let validLoginId = "";

    function JoinForm__submit(form) {
        form.loginId.value = form.loginId.value.trim();
        if (form.loginId.value == 0) {
            alert('아이디를 입력해주세요');
            return;
        }
        if (form.loginId.value != validLoginId) {
            alert('사용할 수 없는 아이디입니다.');
            form.loginId.focus();
            return;
        }
        form.loginPw.value = form.loginPw.value.trim();
        if (form.loginPw.value == 0) {
            alert('비밀번호를 입력해주세요');
            return;
        }
        form.loginPwConfirm.value = form.loginPwConfirm.value.trim();
        if (form.loginPwConfirm.value == 0) {
            alert('비밀번호 확인을 입력해주세요');
            return;
        }
        if (form.loginPwConfirm.value != form.loginPw.value) {
            alert('비밀번호가 일치하지 않습니다');
            form.loginPw.focus();
            return;
        }
        form.name.value = form.name.value.trim();
        if (form.name.value == 0) {
            alert('이름을 입력해주세요');
            return;
        }
        form.nickname.value = form.nickname.value.trim();
        if (form.nickname.value == 0) {
            alert('닉네임을 입력해주세요');
            return;
        }
        form.email.value = form.email.value.trim();
        if (form.email.value == 0) {
            alert('이메일을 입력해주세요');
            return;
        }
        form.cellphone.value = form.cellphone.value.trim();
        if (form.cellphone.value == 0) {
            alert('전화번호를 입력해주세요');
            return;
        }
        form.submit();
    }

    function checkLoginIdDup(el) {
        $('.checkDup-msg').empty();
        const form = $(el).closest('form').get(0);
        if (form.loginId.value.length == 0) {
            validLoginId = '';
            return;
        }
        $.get('../member/getLoginIdDup', {
            isAjax: 'Y',
            loginId: form.loginId.value
        }, function (data) {
            $('.checkDup-msg').html('<div class="">' + data.msg + '</div>')
            if (data.success) {
                validLoginId = data.data1;
            } else {
                validLoginId = '';
            }
        }, 'json');
    }

    const checkLoginIdDupDebounced = _.debounce(checkLoginIdDup, 600);
</script>

<body class="bg-gray-100 min-h-screen flex flex-col">
<main class="flex-grow flex items-center justify-center px-4 py-10">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md p-10 border border-gray-100">
        <h2 class="text-2xl font-bold mb-8 text-center text-gray-900">회원가입</h2>
        <form action="../member/doJoin" method="POST" onsubmit="JoinForm__submit(this); return false;"
              autocomplete="off">
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">아이디</label>
                <input onkeyup="checkLoginIdDupDebounced(this);" name="loginId" autocomplete="off" type="text"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="아이디를 입력하세요"/>
                <div class="checkDup-msg mt-2 text-sm text-gray-500"></div>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">비밀번호</label>
                <input name="loginPw" autocomplete="off" type="password"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="비밀번호"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">비밀번호 확인</label>
                <input name="loginPwConfirm" autocomplete="off" type="password"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="비밀번호 확인"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">이메일</label>
                <input name="email" autocomplete="off" type="email"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="이메일"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">이름</label>
                <input name="name" autocomplete="off" type="text"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="이름"/>
            </div>
            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">닉네임</label>
                <input name="nickname" autocomplete="off" type="text"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="닉네임"/>
            </div>
            <div class="mb-8">
                <label class="block mb-1 text-gray-700 font-semibold">전화번호</label>
                <input name="cellphone" autocomplete="off" type="text"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="010-1234-1234"/>
            </div>
            <div class="flex justify-between gap-4">
                <button type="submit"
                        class="flex-1 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 rounded-xl transition">
                    가입
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
