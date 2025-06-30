<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="LOGIN"/>
<%@ include file="../common/head.jspf" %>
<c:set var="pageColor" value="dark"/>
<%@ include file="../common/nav.jspf" %>

<script type="text/javascript">
    function MemberFindLoginId__submit(form) {
        form.name.value = form.name.value.trim();
        form.email.value = form.email.value.trim();

        if (form.name.value.length === 0) {
            alert('이름을 적으세요');
            form.name.focus();
            return false;
        }
        if (form.email.value.length === 0) {
            alert('이메일을 작성하세요');
            form.email.focus();
            return false;
        }

        return true;
    }
</script>

<body class="bg-gray-100 flex flex-col min-h-screen">
<main class="flex-1 flex items-center justify-center px-4">
    <section class="w-full max-w-md bg-white p-10 mt-12 rounded-2xl shadow-xl border border-gray-200">
        <h2 class="text-2xl font-bold text-center mb-8 text-gray-900">아이디 찾기</h2>

        <form action="../member/doFindLoginId" method="POST" onsubmit="return MemberFindLoginId__submit(this);">
            <input type="hidden" name="afterFindLoginIdUri" value="${param.afterFindLoginIdUri}"/>

            <div class="mb-5">
                <label class="block mb-1 text-gray-700 font-semibold">이름</label>
                <input name="name" autocomplete="off" type="text"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="이름을 입력해주세요"/>
            </div>

            <div class="mb-8">
                <label class="block mb-1 text-gray-700 font-semibold">이메일</label>
                <input name="email" autocomplete="off" type="text"
                       class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                       placeholder="이메일을 입력해주세요"/>
            </div>

            <button type="submit"
                    class="w-full bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 rounded-xl transition">
                아이디 찾기
            </button>

            <div class="flex justify-between mt-6 text-sm">
                <a href="../member/login" class="text-blue-600 hover:underline">로그인</a>
                <a href="${rq.findLoginPwUri}" class="text-green-600 hover:underline">비밀번호 찾기</a>
            </div>

            <div class="mt-6 text-center">
                <button type="button" onclick="history.back();"
                        class="text-sm text-gray-600 hover:underline">
                    뒤로가기
                </button>
            </div>
        </form>
    </section>
</main>

<%@ include file="../common/foot.jspf" %>
</body>
