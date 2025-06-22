<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="글 작성" />
<%@ include file="../common/head.jspf" %>

<!-- Toast UI Editor -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script>
  let editor;

  document.addEventListener('DOMContentLoaded', function () {
    const editorEl = document.querySelector('.toast-ui-editor');

    editor = new toastui.Editor({
      el: editorEl,
      height: '500px',
      initialEditType: 'markdown',
      previewStyle: 'vertical',
      hooks: {
        addImageBlobHook: async (blob, callback) => {
          const formData = new FormData();
          formData.append('file', blob);

          const res = await fetch('/usr/file/uploadImage', {
            method: 'POST',
            body: formData
          });

          const result = await res.json();
          callback(result.url, '이미지');
        }
      }
    });

    // 기본 submit 동작 직전에 body 값 설정
    const form = document.querySelector('#postForm');
    form.addEventListener('submit', function () {
      form.body.value = editor.getMarkdown().trim();
    });
  });
</script>

<section class="mt-8 text-xl px-4">
  <div class="mx-auto">
    <form id="postForm" method="POST" enctype="multipart/form-data" action="/usr/post/doWrite">
      <input type="hidden" name="body" />
      <table class="table" border="1" style="width: 100%; border-collapse: collapse;">
        <tr>
          <th>게시판</th>
          <td>
            <select name="boardId" required>
              <option value="" disabled selected>게시판을 선택해주세요</option>
              <option value="1">질문게시판</option>
              <option value="2">정보공유</option>
              <option value="3">후기</option>
              <option value="4">자유게시판</option>
            </select>
          </td>
        </tr>
        <tr>
          <th>제목</th>
          <td><input name="title" type="text" required placeholder="제목" /></td>
        </tr>
        <tr>
          <th>내용</th>
          <td><div class="toast-ui-editor"></div></td>
        </tr>
        <tr>
          <th>첨부파일</th>
          <td>
            <input type="file" name="files" multiple
                   accept=".pdf,.hwp,.ppt,.pptx,.xls,.xlsx,.jpg,.jpeg,.png,.gif,.zip" />
            <br/><small>(PDF, HWP, PPTX, XLSX, 이미지 등 여러 파일 가능)</small>
          </td>
        </tr>
        <tr>
          <td colspan="2" style="text-align:right;">
            <button class="btn btn-primary" type="submit">작성</button>
            <button type="button" onclick="history.back();">뒤로가기</button>
          </td>
        </tr>
      </table>
    </form>
  </div>
</section>
