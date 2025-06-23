
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="MEMBER LOGIN"></c:set>
<%@ include file="../common/head.jspf"%>


<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<form action="../member/doLogin" method="POST">
			<input type="hidden" name="redirectUrl" value="${param.redirectUrl}" />
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>
					<tr>
						<th>아이디</th>
						<td style="text-align: center;"><input class="input input-primary" name="loginId" autocomplete="on"
							type="text" placeholder="아이디 입력" /></td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td style="text-align: center;"><input class="input input-primary" type="hidden" name="loginPw" autocomplete="off"
							type="text" placeholder="비밀번호 입력" /></td>
					</tr>

					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-ghost">로그인</button>
						</td>
					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;"><a class="btn btn-outline btn-primary" href="${rq.findLoginIdUri }">아이디
								찾기</a> <a class="btn btn-outline btn-success" href="${rq.findLoginPwUri }">비밀번호찾기</a></td>
					</tr>
					<tr>
					<td>
					<a href="javascript:kakaoLogin()"><img src="<c:url value="/image/kakao_login_medium_narrow.png"/>" style="width: 200px"></a>
</td>
</tr>
				</tbody>
			</table>
		</form>
		<div class="btns">
			<button class="btn btn-ghost" type="button" onclick="history.back();">뒤로가기</button>

		</div>
	</div>
</section>

<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript">
    Kakao.init('9c30d628ff4b5f6e101179faa1f4867b');
    function kakaoLogin() {
        Kakao.Auth.login({
            success: function (response) {
                Kakao.API.request({
                    url: '/v2/user/me',
                    success: function (response) {
                        alert(JSON.stringify(response))
                    },
                    fail: function (error) {
                        alert(JSON.stringify(error))
                    },
                })
            },
            fail: function (error) {
                alert(JSON.stringify(error))
            },
        })
    }
</script>

<%@ include file="../common/foot.jspf"%>

