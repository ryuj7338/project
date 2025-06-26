<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<!-- Toast UI Viewer CSS/JS -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"/>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<!-- FontAwesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<c:set var="pageTitle" value="게시글 상세보기"/>

<!-- 게시글 상세 정보 스크립트 -->
<script>
    $(function () {
        checkRP();
        PostDetail__doIncreaseHitCount();
    });

    function checkRP() {
        if (${isAlreadyAddLikeRp}) {
            $('#likeButton').removeClass('btn-outline');
        }
    }

    function doLikeReaction(postId) {
        $.post('/usr/reaction/doLike', {relTypeCode: 'post', relId: postId}, function (data) {
            if (data.resultCode.startsWith('S-')) {
                const [likeCount, isLiked] = [data.data1, data.data2];
                $('#likeButton').html(
                    isLiked
                        ? '<i class="fas fa-heart text-red-500"></i> <span>' + likeCount + '</span>'
                        : '<i class="far fa-heart"></i> <span>' + likeCount + '</span>'
                );
            } else if (data.resultCode === 'F-L') {
                alert(data.msg);
                location.href = data.data1 || '/usr/member/login';
            } else {
                alert(data.msg);
            }
        }, 'json');
    }

    function PostDetail__doIncreaseHitCount() {
        const key = 'post__' + ${param.id} +'__viewed';
        if (localStorage.getItem(key)) return;
        localStorage.setItem(key, true);
        $.getJSON('../post/doIncreaseHitCountRd', {id: ${param.id}, ajaxMode: 'Y'}, function (data) {
            $('.post-detail__hit-count').text(data.data1);
        });
    }
</script>

<!-- 댓글 작성 스크립트 -->
<script>
    function CommentWrite__submit(form) {
        form.body.value = form.body.value.trim();
        if (form.body.value.length < 3) {
            alert('3글자 이상 입력하세요');
            form.body.focus();
            return false;
        }
        return true;
    }

    function toggleModifybtn(id) {
        $('#modify-btn-' + id).hide();
        $('#save-btn-' + id).show();
        $('#modify-form-' + id).show();
    }

    function doModifyReply(id) {
        const form = $('#modify-form-' + id);
        const body = form.find('input[name="reply-text-' + id + '"]').val();
        $.post('/usr/comment/doModify', {id, body}, function (data) {
            $('#comment-' + id).text(data);
            $('#modify-form-' + id).hide();
            $('#save-btn-' + id).hide();
            $('#modify-btn-' + id).show();
        });
    }
</script>

<!-- 게시글 정보 테이블 -->
<section class="mt-8 px-4">
    <table class="w-full border-collapse border border-gray-200">
        <tr>
            <th class="border p-2">게시판 번호</th>
            <td class="border p-2">${post.boardId}</td>
        </tr>
        <tr>
            <th class="border p-2">글 번호</th>
            <td class="border p-2">${post.id}</td>
        </tr>
        <tr>
            <th class="border p-2">작성일</th>
            <td class="border p-2">${post.regDate}</td>
        </tr>
        <tr>
            <th class="border p-2">수정일</th>
            <td class="border p-2">${post.updateDate}</td>
        </tr>
        <tr>
            <th class="border p-2">작성자</th>
            <td class="border p-2">${post.extra__writer}</td>
        </tr>
        <tr>
            <th class="border p-2">조회수</th>
            <td class="border p-2 post-detail__hit-count">${post.hit}</td>
        </tr>
        <tr>
            <th class="border p-2">좋아요</th>
            <td class="border p-2">
                <button id="likeButton" class="btn btn-outline" onclick="doLikeReaction(${post.id})">
                    <i class="${isAlreadyAddLikeRp ? 'fas' : 'far'} fa-heart"></i>
                    <span>${post.like}</span>
                </button>
            </td>
        </tr>
        <tr>
            <th class="border p-2">제목</th>
            <td class="border p-2">${post.title}</td>
        </tr>
        <tr>
            <th class="border p-2 align-top">내용</th>
            <td class="border p-2">
                <div id="viewer"></div>
                <textarea id="viewerContent" style="display:none;"><c:out value="${filteredBody}"
                                                                          escapeXml="false"/></textarea>
            </td>
        </tr>
    </table>
</section>

<!-- 댓글 입력 폼 -->
<section class="mt-8 px-4">
    <c:if test="${rq.isLogined()}">
        <form action="/usr/comment/doWrite" method="POST" onsubmit="return CommentWrite__submit(this);">
            <input type="hidden" name="relTypeCode" value="post"/>
            <input type="hidden" name="relId" value="${post.id}"/>
            <textarea name="body" class="w-full p-2 border" placeholder="댓글을 입력하세요"></textarea>
            <button type="submit" class="mt-2 btn btn-primary">작성</button>
        </form>
    </c:if>
    <c:if test="${!rq.isLogined()}">
        <a href="/usr/member/login" class="btn btn-outline">로그인 후 이용해주세요</a>
    </c:if>
</section>

<!-- 댓글 리스트 및 대댓글 폼 -->
<section class="mt-8 px-4">
    <table class="w-full border-collapse border border-gray-200">
        <thead>
        <tr>
            <th class="border p-2">작성일</th>
            <th class="border p-2">작성자</th>
            <th class="border p-2">내용</th>
            <th class="border p-2">좋아요</th>
            <th class="border p-2">수정</th>
            <th class="border p-2">삭제/답글</th>
        </tr>
        </thead>
        <tbody id="comments-container">
        <c:forEach var="comment" items="${comments}">
            <tr>
                <td class="border p-2 text-center">${comment.regDate.substring(0,10)}</td>
                <td class="border p-2 text-center">${comment.extra__writer}</td>
                <td class="border p-2">
                    <c:if test="${comment.parentId != null}">
                        <span class="text-gray-500">→</span>
                    </c:if>
                        ${comment.body}
                </td>
                <td class="border p-2 text-center">
                    <button class="comment-like-btn" data-rel-id="${comment.id}">
                        <i class="far fa-heart"></i>
                        <span class="like-count">${comment.like}</span>
                    </button>
                </td>
                <td class="border p-2 text-center">
                    <c:if test="${comment.userCanModify}">
                        <button onclick="toggleModifybtn('${comment.id}')" class="btn btn-xs btn-success">수정</button>
                    </c:if>
                </td>
                <td class="border p-2 text-center">
                    <c:if test="${comment.userCanDelete}">
                        <a href="/usr/comment/doDelete?id=${comment.id}&postId=${post.id}"
                           onclick="return confirm('정말 삭제하시겠습니까?');"
                           class="btn btn-xs btn-error">삭제</a>
                    </c:if>
                    <button type="button" class="btn btn-xs btn-primary reply-btn" data-parent-id="${comment.id}">답글
                    </button>
                </td>
            </tr>
            <!-- 숨겨진 대댓글 폼 -->
        </c:forEach>
        </tbody>
    </table>
</section>

<!-- 답글 토글 스크립트 -->
<!-- 답글 토글 스크립트 (맨 아래에 한 번만!) -->
<script>
    $(document).off('click', '.reply-btn');
    $(document).on('click.reply', '.reply-btn', function (e) {
        e.preventDefault();

        const $btn = $(this);
        const commentId = $btn.attr('data-parent-id');
        const $tr = $btn.closest('tr');
        const nextIsForm = $tr.next().hasClass('reply-form-row');

        // 이미 열려 있으면 닫기
        if (nextIsForm) {
            $tr.next().remove();
            return;
        }

        // 열려 있는 다른 폼이 있으면 모두 제거
        $('.reply-form-row').remove();

        // 대댓글 폼 행 HTML 생성
        const formRow = `
      <tr class="reply-form-row">
        <td colspan="6" style="padding:8px;">
          <form action="/usr/comment/doWrite" method="POST" style="display:flex; gap:8px;">
            <input type="hidden" name="relTypeCode" value="comment"/>
            <input type="hidden" name="relId"        value="${commentId}"/>
            <input type="hidden" name="parentId"     value="${commentId}"/>
            <textarea name="body" rows="1" class="input input-bordered input-sm w-full"
                      placeholder="답글을 입력하세요"></textarea>
            <button type="submit" class="btn btn-xs btn-success">등록</button>
          </form>
        </td>
      </tr>
    `;

        // 댓글 <tr> 바로 아래에 삽입
        $tr.after(formRow);
    });
</script>

<%@ include file="../common/foot.jspf" %>