<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<!-- Toast UI Viewer -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<c:set var="pageTitle" value="게시글 상세보기" />

<script>
	$(function() {
		checkRP();
		PostDetail__doIncreaseHitCount();
	});

	const params = {};
	params.id = parseInt('${param.id}');
	var isAlreadyAddLikeRp = ${isAlreadyAddLikeRp};

	function checkRP() {
		if (isAlreadyAddLikeRp == true) {
			$('#likeButton').toggleClass('btn-outline');
		}
	}

	function doLikeReaction(PostId) {
	$.ajax({
		url: '/usr/reaction/doLike',
		type: 'POST',
		data: {
			relTypeCode: 'post',
			relId: PostId
		},
		dataType: 'json',
		success: function(data) {
			if (data.resultCode === 'F-L') {
				// ✅ 1. 먼저 alert
				alert(data.msg);

				// ✅ 2. 그리고 로그인 페이지로 이동
				if (data.data1) {
					location.href = data.data1;
				} else {
					location.href = '/usr/member/login';
				}
				return;
			}

			if (data.resultCode.startsWith('S-')) {
				const $likeButton = $('#likeButton');
				const likeCount = data.data1;
				const isLiked = data.data2;

				if (isLiked) {
					$likeButton.html('❤️ <span id="likeCount" class="likeCount">' + likeCount + '</span>');
				} else {
					$likeButton.html('🤍 <span id="likeCount" class="likeCount">' + likeCount + '</span>');
				}
			} else {
				alert(data.msg);
			}
		}
	});
}





	function PostDetail__doIncreaseHitCount() {
		const localStorageKey = 'post__' + params.id + '__alreadyOnView';
		if (localStorage.getItem(localStorageKey)) return;
		localStorage.setItem(localStorageKey, true);

		$.get('../post/doIncreaseHitCountRd', {
			id: params.id,
			ajaxMode: 'Y'
		}, function(data) {
			$('.post-detail__hit-count').html(data.data1);
		}, 'json');
	}
</script>

<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
			<tr><th>게시판 번호</th><td>${post.boardId}</td></tr>
			<tr><th>글 번호</th><td>${post.id}</td></tr>
			<tr><th>작성일</th><td>${post.regDate}</td></tr>
			<tr><th>수정일</th><td>${post.updateDate}</td></tr>
			<tr><th>작성자</th><td>${post.extra__writer}</td></tr>
			<tr><th>조회수</th><td><span class="post-detail__hit-count">${post.hit}</span></td></tr>
			<tr>
				<th>좋아요</th>
				<td>
					<button id="likeButton" class="btn btn-outline btn-success" onclick="doLikeReaction(${post.id})">
    					<c:choose>
        					<c:when test="${isAlreadyAddLikeRp}">❤️</c:when>
        					<c:otherwise>🤍</c:otherwise>
    					</c:choose>
    					<span id="likeCount" class="likeCount">${post.like}</span>
					</button>

				</td>
			</tr>
			<tr><th>제목</th><td>${post.title}</td></tr>
			<tr>
				<th>내용</th>
				<td>
					<div id="viewer"></div>
					<textarea id="viewerContent" style="display:none;"><c:out value="${post.body}" /></textarea>
				</td>
			</tr>
			<tr>
    <th>다운로드 파일</th>
    <td>
        <c:forEach var="resource" items="${resourceList}">
            <c:if test="${not empty resource.image}">
                🖼 이미지:
                <a href="/file/download?path=${fn:substringAfter(resource.image, '/')}&original=이미지파일.gif" target="_blank">[다운로드]</a><br/>
            </c:if>
            <c:if test="${not empty resource.pdf}">
                📄 PDF:
                <a href="/file/download?path=${fn:substringAfter(resource.pdf, '/')}&original=문서.pdf" target="_blank">[다운로드]</a><br/>
            </c:if>
            <c:if test="${not empty resource.hwp}">
                📑 HWP:
                <a href="/file/download?path=${fn:substringAfter(resource.hwp, '/')}&original=한글문서.hwp" target="_blank">[다운로드]</a><br/>
            </c:if>
            <c:if test="${not empty resource.word}">
                📄 Word:
                <a href="/file/download?path=${fn:substringAfter(resource.word, '/')}&original=워드파일.docx" target="_blank">[다운로드]</a><br/>
            </c:if>
            <c:if test="${not empty resource.xlsx}">
                📊 Excel:
                <a href="/file/download?path=${fn:substringAfter(resource.xlsx, '/')}&original=엑셀.xlsx" target="_blank">[다운로드]</a><br/>
            </c:if>
            <c:if test="${not empty resource.pptx}">
                📽 PPTX:
                <a href="/file/download?path=${fn:substringAfter(resource.pptx, '/')}&original=발표자료.pptx" target="_blank">[다운로드]</a><br/>
            </c:if>
            <c:if test="${not empty resource.zip}">
                📦 ZIP:
                <a href="/file/download?path=${fn:substringAfter(resource.zip, '/')}&original=자료.zip" target="_blank">[다운로드]</a><br/>
            </c:if>
        </c:forEach>
    </td>
</tr>


		</table>

		<div class="btns mt-4">
			<button type="button" onclick="history.back();">뒤로가기</button>
			<c:if test="${post.userCanModify}">
				<a href="/usr/post/modify?id=${post.id}">수정</a>
			</c:if>
			<c:if test="${post.userCanDelete}">
				<a href="/usr/post/doDelete?id=${post.id}">삭제</a>
			</c:if>
		</div>
	</div>
</section>

<script>
	document.addEventListener('DOMContentLoaded', function () {
		const content = document.querySelector('#viewerContent').value.trim();
		toastui.Editor.factory({
			el: document.querySelector('#viewer'),
			viewer: true,
			initialValue: content,
		});
	});
</script>

<%@ include file="../common/foot.jspf"%>
