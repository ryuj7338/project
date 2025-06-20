<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE WRITE"></c:set>
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/toastUiEditorLib.jspf"%>

<!-- Toast UI Editor CSS -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />

<!-- Toast UI Editor JS -->
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>


<script type="text/javascript">
	function PostWrite__submit(form) {
		form.title.value = form.title.value.trim();

		if (form.title.value.length == 0) {
			alert('제목을 입력하세요');
			return;
		}

		const editor = $(form).find('.toast-ui-editor').data(
				'data-toast-editor');
		const markdown = editor.getMarkdown().trim();

		if (markdown.length == 0) {
			alert('내용을 입력하세요');
			return;
		}

		form.body.value = markdown;
		form.submit();
	}
</script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const editorEl = document.querySelector('.toast-ui-editor');

    const editor = new toastui.Editor({
      el: editorEl,
      height: '500px',
      initialEditType: 'markdown',
      previewStyle: 'vertical'
    });

    // 나중에 submit 할 때 접근하기 위해 data로 저장
    $(editorEl).data('data-toast-editor', editor);
  });
</script>


<section class="mt-8 text-xl px-4">
	<div class="mx-auto">
		<form onsubmit="PostWrite__submit(this); return false;" action="../post/doWrite" method="POST">
			<input type="hidden" name="body" />
			<table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
				<tbody>

					<tr>
						<th style="text-align: center;">게시판</th>
						<td style="text-align: center;">
							<select name="boardId">
								<option value="" selected disabled>게시판을 선택해주세요</option>
								<option value="1">공지사항</option>
								<option value="2">자유</option>
								<option value="3">QnA</option>
							</select>
						</td>
					</tr>
					<tr>
						<th style="text-align: center;">제목</th>
						<td style="text-align: center;">
							<input class="input input-primary input-sm" required="required" name="title" type="text" autocomplete="off"
								placeholder="제목" />
						</td>
					</tr>
					<tr>
						<th style="text-align: center;">내용</th>
						<td style="text-align: center;">
							<!-- 							<input class="input input-bordered input-primary input-sm w-full max-w-xs" name="body" autocomplete="off" -->
							<!-- 								type="text" placeholder="내용" /> -->
							<div class="toast-ui-editor">
								<script type="text/x-template"></script>
							</div>
						</td>
					</tr>
					<tr>
						<th></th>
						<td style="text-align: center;">
							<button class="btn btn-primary">작성</button>
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



<%@ include file="../common/foot.jspf"%>