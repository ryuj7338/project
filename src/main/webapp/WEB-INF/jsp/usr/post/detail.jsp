<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<!-- Toast UI Viewer CSS/JS -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"/>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<!-- FontAwesome & jQuery -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<c:set var="pageTitle" value="게시글 상세보기"/>




<c:url var="incUrl" value="/usr/post/doIncreaseHitCountRd"/>

<!-- 게시글, 좋아요, 조회수 증가 스크립트 -->
<script>
    $(function () {
        // 좋아요 버튼 초기화
        if (${isAlreadyAddLikeRp}) $('#likeButton').removeClass('btn-outline');
        $('#likeButton').click(function () {
            $.post('/usr/reaction/doLike',
                {relTypeCode: 'post', relId: currentPostId},
                function (d) {
                    if (d.resultCode === 'F-L') {
                        alert(d.msg);
                        location.href = d.data1 || '/usr/member/login';
                        return;
                    }
                    if (d.resultCode.startsWith('S-')) {
                        $('#likeButton').html(
                            (d.data2 ? '<i class="fas fa-heart text-red-500"></i>' : '<i class="far fa-heart"></i>')
                            + ' <span id="likeCount">' + d.data1 + '</span>'
                        );
                    } else alert(d.msg);
                }, 'json'
            );
        });

        // 조회수는 key가 같으면 증가 안 함
        const key = 'post__${post.id}__viewed';
        if (!localStorage.getItem(key)) {
            localStorage.setItem(key, '1');

            $.getJSON('${incUrl}', {
                id: ${post.id},
                ajaxMode: 'Y'
            }, function (data) {
                $('.post-detail__hit-count').text(data.data1);
            });
        }
    });
</script>

<!-- 댓글 수정 스크립트 -->
<script>
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
            form.hide();
            $('#save-btn-' + id).hide();
            $('#modify-btn-' + id).show();
        });
    }
</script>

<!-- 본문 영역 -->
<section class="mt-8 px-4">
    <table border="1" cellspacing="0" cellpadding="5" style="width:100%;border-collapse:collapse;">
        <tr>
            <th>게시판 번호</th>
            <td>${post.boardId}</td>
        </tr>
        <tr>
            <th>글 번호</th>
            <td>${post.id}</td>
        </tr>
        <tr>
            <th>작성일</th>
            <td>${post.regDate}</td>
        </tr>
        <tr>
            <th>수정일</th>
            <td>${post.updateDate}</td>
        </tr>
        <tr>
            <th>작성자</th>
            <td>${post.extra__writer}</td>
        </tr>
        <tr>
            <th>조회수</th>
            <td><span class="post-detail__hit-count">${post.hit}</span></td>
        </tr>
        <tr>
            <th>좋아요</th>
            <td>
                <button id="likeButton" class="btn btn-outline btn-success">
                    <c:choose>
                        <c:when test="${isAlreadyAddLikeRp}"><i class="fas fa-heart text-red-500"></i></c:when>
                        <c:otherwise><i class="far fa-heart"></i></c:otherwise>
                    </c:choose>
                    <span id="likeCount">${post.like}</span>
                </button>
            </td>
        </tr>
        <tr>
            <th>제목</th>
            <td>${post.title}</td>
        </tr>
        <tr>
            <th>내용</th>
            <td>
                <div id="viewer"></div>
                <textarea id="viewerContent" style="display:none;">
          <c:out value="${filteredBody}" escapeXml="false"/>
        </textarea>
            </td>
        </tr>
    </table>
    <div class="mt-4">
        <button onclick="history.back()">뒤로가기</button>
        <c:if test="${post.userCanModify}"><a href="/usr/post/modify?id=${post.id}">수정</a></c:if>
        <c:if test="${post.userCanDelete}"><a href="/usr/post/doDelete?id=${post.id}">삭제</a></c:if>
    </div>
</section>

<!-- 댓글 작성 폼 -->
<section class="mt-8 px-4">
    <c:if test="${rq.isLogined()}">
        <form action="/usr/comment/doWrite" method="POST" onsubmit="return (function(f){
      f.body.value=f.body.value.trim();
      if(f.body.value.length<3){alert('3글자 이상 입력하세요');f.body.focus();return false;}
      return true;
    })(this);">
            <input type="hidden" name="relTypeCode" value="post"/>
            <input type="hidden" name="relId" value="${post.id}"/>
            <table border="1" cellspacing="0" cellpadding="5" style="width:100%;border-collapse:collapse;">
                <tr>
                    <th>댓글 입력</th>
                    <td><textarea name="body" placeholder="내용을 입력하세요"></textarea></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button>작성</button>
                    </td>
                </tr>
            </table>
        </form>
    </c:if>
    <c:if test="${!rq.isLogined()}">댓글 작성을 위해 <a href="../member/login">로그인</a>이 필요합니다</c:if>
</section>

<!-- 댓글 리스트 -->
<section class="mt-8 px-4">
    <table border="1" cellspacing="0" cellpadding="5" style="width:100%;border-collapse:collapse;">
        <thead>
        <tr>
            <th>작성일</th>
            <th>작성자</th>
            <th>내용</th>
            <th>좋아요</th>
            <th>수정</th>
            <th>삭제/답글</th>
        </tr>
        </thead>
        <tbody id="comments-container">
        <c:forEach var="cmt" items="${comments}">
            <tr data-comment-id="${cmt.id}" data-parent-id="${cmt.parentId}" class="hover reply-row">
                <td>${cmt.regDate.substring(0,10)}</td>
                <td>${cmt.extra__writer}</td>
                <td class="comment-body-cell">
                    <c:if test="${cmt.parentId != 0}"><span style="color:gray;margin-right:6px;">↳</span></c:if>
                        ${cmt.body}
                    <!-- JS가 여기에 대댓글 폼 삽입 -->
                </td>
                <td>
                    <button class="comment-like-btn" data-rel-id="${cmt.id}">
              <span class="heart">
                <c:choose>
                    <c:when test="${cmt.alreadyLiked}"><i class="fas fa-heart text-red-500"></i></c:when>
                    <c:otherwise><i class="far fa-heart"></i></c:otherwise>
                </c:choose>
              </span>
                        <span class="like-count">${cmt.like}</span>
                    </button>
                </td>
                <td>
                    <c:if test="${cmt.userCanModify}">
                        <button onclick="toggleModifybtn('${cmt.id}')">수정</button>
                    </c:if>
                </td>
                <td>
                    <c:if test="${cmt.userCanDelete}">
                        <a href="/usr/comment/doDelete?id=${cmt.id}&postId=${post.id}"
                           onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                    </c:if>
                    <button type="button" class="reply-btn btn-xs btn-primary" data-parent-id="${cmt.id}">답글</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</section>

<!-- 대댓글 삽입 & 좋아요 스크립트 -->
<script>
    $(function () {
        // 댓글 좋아요
        $('.comment-like-btn').off('click').on('click', function () {
            const $b = $(this), id = $b.data('rel-id');
            const $cnt = $b.find('.like-count'), $hrt = $b.find('.heart');
            $.post('/usr/comment/toggleLike', {relId: id}, d => {
                if (d.resultCode.startsWith('S-')) {
                    $cnt.text(d.data1.likeCount);
                    $hrt.html(d.data1.liked ? '<i class="fas fa-heart text-red-500"></i>' : '<i class="far fa-heart"></i>');
                } else if (d.resultCode === 'F-1') {
                    alert(d.msg);
                    location.href = '/usr/member/login?redirectUrl=' + encodeURIComponent(location.href);
                } else alert(d.msg);
            }, 'json');
        });

        // 답글 폼 토글
        $(document).off('click.reply', '.reply-btn').on('click.reply', '.reply-btn', function (e) {
            e.preventDefault();
            const cid = $(this).data('parent-id');
            const $cell = $(this).closest('tr').find('td.comment-body-cell');
            const $ex = $cell.find('.reply-form-container');
            if ($ex.length) {
                $ex.slideUp(200, () => $ex.remove());
                return;
            }
            $('.reply-form-container').slideUp(200, () => $('.reply-form-container').remove());

            const html =
                '<div class="reply-form-container" style="display:none;margin-top:8px;">' +
                '  <form class="reply-form" data-parent-id="' + cid + '" style="display:flex;gap:8px;">' +
                '    <input type="hidden" name="relTypeCode" value="comment"/>' +
                '    <input type="hidden" name="relId"        value="' + cid + '"/>' +
                '    <input type="hidden" name="parentId"     value="' + cid + '"/>' +
                '    <textarea name="body" rows="2" class="input input-bordered input-sm w-full" placeholder="답글을 입력하세요"></textarea>' +
                '    <button type="submit" class="btn-xs btn-success">등록</button>' +
                '    <button type="button" class="btn-xs btn-secondary reply-cancel">취소</button>' +
                '  </form>' +
                '</div>';
            const $f = $(html);
            $cell.append($f);
            $f.slideDown(200);
        });

        const currentPostId = ${post.id}
        // 대댓글 등록
        $(document).on('submit', '.reply-form', function (e) {
            e.preventDefault();
            const $f = $(this), pid = $f.data('parent-id');
            const body = $f.find('[name="body"]').val().trim();


            if (body.length < 3) {
                alert('3글자 이상 입력하세요');
                return;
            }


            $.post('/usr/comment/doWrite', {
                relTypeCode: 'post',
                 relId: currentPostId,
                 parentId: parentId,
                 body: body
            }, res => {
                const nc = res.data1?.comment || res.data?.comment || res.comment || res;
                if (!nc || !nc.id) {
                    alert('등록된 댓글 정보를 불러올 수 없습니다.');
                    return;
                }
                const writer = nc.extra__writer || nc.writer || '익명';
                const isMine = nc.memberId ===${rq.getLoginedMemberId()};
                let row =
                    '<tr class="hover reply-row" data-comment-id="' + nc.id + '" data-parent-id="' + nc.parentId + '">' +
                    '<td>' + nc.regDate.substring(0, 10) + '</td>' +
                    '<td>' + writer + '</td>' +
                    '<td class="comment-body-cell" style="padding-left:20px;">' +
                    '<span style="color:gray;margin-right:6px;">↳</span>' + nc.body +
                    '</td>' +
                    '<td><button class="comment-like-btn" data-rel-id="' + nc.id + '">' +
                    '<i class="' + (nc.alreadyLiked ? 'fas fa-heart text-red-500' : 'far fa-heart') + '"></i> ' +
                    '<span class="like-count">' + nc.likeCount + '</span></button></td>' +
                    '<td>' + (isMine ? '<button onclick="toggleModifybtn(\'' + nc.id + '\')">수정</button>' : '') + '</td>' +
                    '<td>' + (isMine ?
                        '<a href="/usr/comment/doDelete?id=' + nc.id + '&postId=' + currentPostId +
                        '" onclick="return confirm(\'정말 삭제하시겠습니까?\');">삭제</a>' : '') +
                    ' <button type="button" class="reply-btn btn-xs btn-primary" data-parent-id="' + nc.id + '">답글</button>' +
                    '</td></tr>';
                $('tr[data-comment-id="' + pid + '"]').after(row);
                $f.closest('.reply-form-container').remove();
                // 재바인딩
                $('.comment-like-btn').off('click').on('click', function () {/*...*/
                });
            }, 'json').fail(() => alert('답글 등록 중 오류'));
        });

        // 취소
        $(document).off('click', '.reply-cancel').on('click', '.reply-cancel', function () {
            $(this).closest('.reply-form-container').slideUp(200, () => $(this).remove());
        });
    });
</script>

<style>
    .reply-row td {
        padding-left: 20px;
    }
</style>

<%@ include file="../common/foot.jspf" %>
