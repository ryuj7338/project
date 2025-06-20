<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<!-- Toast UI Viewer CSS/JS -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/editor-plugin-code-syntax-highlight/latest/toastui-editor-plugin-code-syntax-highlight.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.23.0/prism.min.js"></script>
<script src="https://uicdn.toast.com/editor-plugin-code-syntax-highlight/latest/toastui-editor-plugin-code-syntax-highlight.min.js"></script>
<!-- Prism 및 Toast UI Syntax Highlight 플러그인 포함 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.23.0/prism.min.js"></script>
<script src="https://uicdn.toast.com/editor-plugin-code-syntax-highlight/latest/toastui-editor-plugin-code-syntax-highlight.min.js"></script>





<c:set var="pageTitle" value="게시글 상세보기" />



<script>
	const params = {};
	params.id = parseInt('${param.id}');
	var isAlreadyAddLikeRp = ${isAlreadyAddLikeRp};
</script>

<script>
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
				if (data.resultCode.startsWith('S-')) {
					var likeButton = $('#likeButton');
					var likeCount = $('#likeCount');
					var likeCountC = $('.likeCount');

					likeButton.toggleClass('btn-outline');
					likeCount.text(data.data1);
					likeCountC.text(data.data1);
				} else {
					alert(data.msg);
				}
			},
			error: function(jqXHR, textStatus) {
				alert('좋아요 오류 발생 : ' + textStatus);
			}
		});
	}

	$(function() {
		checkRP();
	});
</script>

<script>
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

	$(function() {
		PostDetail__doIncreaseHitCount();
	});
</script>

<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
			<tr><th style="text-align: center;">게시판 번호</th><td style="text-align: center;">${post.boardId}</td></tr>
			<tr><th style="text-align: center;">글 번호</th><td style="text-align: center;">${post.id}</td></tr>
			<tr><th style="text-align: center;">작성일</th><td style="text-align: center;">${post.regDate}</td></tr>
			<tr><th style="text-align: center;">수정일</th><td style="text-align: center;">${post.updateDate}</td></tr>
			<tr><th style="text-align: center;">작성자</th><td style="text-align: center;">${post.extra__writer}</td></tr>
			<tr><th style="text-align: center;">조회수</th><td style="text-align: center;"><span class="post-detail__hit-count">${post.hit}</span></td></tr>
			<tr>
				<th style="text-align: center;">좋아요</th>
				<td style="text-align: center;">
					<button id="likeButton" class="btn btn-outline btn-success" onclick="doLikeReaction(${param.id})">
						LIKE 👍 <span id="likeCount" class="likeCount">${post.like}</span>
					</button>
				</td>
			</tr>
			<tr><th style="text-align: center;">제목</th><td style="text-align: center;">${post.title}</td></tr>

			<tr>
				<th style="text-align: center;">내용</th>
				<td>
					<div class="toast-ui-viewer" id="viewer" style="display:none;"></div>

				</td>
			</tr>

			<tr>
				<th style="text-align: center;">다운로드 파일</th>

				<td style="text-align: center;">
    				<c:forEach var="file" items="${fileInfos}">
      					📎 ${file.name}
      					<a href="${file.path}" download class="text-blue-500 hover:underline">[다운로드]</a><br/>
    				</c:forEach>
 				</td>
			</tr>

		</table>
		<script type="text/template" id="viewerContent">${fn:escapeXml(post.body)}</script>
		<!-- 버튼 -->
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
    const viewerEl = document.querySelector('#viewer');
    const contentTemplate = document.querySelector('#viewerContent');
    if (!viewerEl || !contentTemplate) return;

    const markdown = contentTemplate.textContent.trim();

    // ✅ 여기에서 plugin을 따로 선언
    const codeSyntaxHighlight = toastui.EditorPlugin.codeSyntaxHighlight;

    new toastui.Editor({
      el: viewerEl,
      viewer: true,
      height: 'auto',
      initialValue: markdown,
      plugins: [codeSyntaxHighlight]
    });

    viewerEl.style.display = 'block';
  });
</script>





<%@ include file="../common/foot.jspf"%>
