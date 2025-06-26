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

<!-- 게시글, 좋아요, 조회수 증가 스크립트 -->
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
            if (data.resultCode === 'F-L') {
                alert(data.msg);
                location.href = data.data1 || '/usr/member/login';
                return;
            }
            if (data.resultCode.startsWith('S-')) {
                $('#likeButton').html(
                    (data.data2 ? '<i class="fas fa-heart text-red-500"></i>' : '<i class="far fa-heart"></i>')
                    + ' <span id="likeCount">' + data.data1 + '</span>'
                );
            } else {
                alert(data.msg);
            }
        }, 'json');
    }

    function PostDetail__doIncreaseHitCount() {
        var key = 'post__' + ${param.id} +'__viewed';
        if (localStorage.getItem(key)) return;
        localStorage.setItem(key, true);
        $.getJSON('../post/doIncreaseHitCountRd', {id: ${param.id}, ajaxMode: 'Y'}, function (data) {
            $('.post-detail__hit-count').text(data.data1);
        });
    }
</script>

<!-- 댓글 수정 스크립트 -->
<script>
    function toggleModifybtn(id) {
        $('#modify-btn-' + id).hide();
        $('#save-btn-' + id).show();
        $('#modify-form-' + id).show();
    }

    function doModifyReply(id) {
        var form = $('#modify-form-' + id);
        var body = form.find('input[name="reply-text-' + id + '"]').val();
        $.post('/usr/comment/doModify', {id: id, body: body}, function (data) {
            $('#comment-' + id).text(data);
            $('#modify-form-' + id).hide();
            $('#save-btn-' + id).hide();
            $('#modify-btn-' + id).show();
        });
    }
</script>

<section class="mt-8 text-xl px-4">
    <div class="mx-auto">
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
                    <button id="likeButton" class="btn btn-outline btn-success" onclick="doLikeReaction(${post.id})">
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
                    <textarea id="viewerContent" style="display:none;"><c:out value="${filteredBody}"
                                                                              escapeXml="false"/></textarea>
                </td>
            </tr>
        </table>
        <div class="btns mt-4">
            <button onclick="history.back();">뒤로가기</button>
            <c:if test="${post.userCanModify}"><a href="/usr/post/modify?id=${post.id}">수정</a></c:if>
            <c:if test="${post.userCanDelete}"><a href="/usr/post/doDelete?id=${post.id}">삭제</a></c:if>
        </div>
    </div>
</section>

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
</script>

<section class="mt-24 text-xl px-4">
    <c:if test="${rq.isLogined()}">
        <form action="/usr/comment/doWrite" method="POST" onsubmit="return CommentWrite__submit(this);">
            <input type="hidden" name="relTypeCode" value="post"/>
            <input type="hidden" name="relId" value="${post.id}"/>
            <table class="table" border="1" cellspacing="0" cellpadding="5"
                   style="width:100%;border-collapse:collapse;">
                <tbody>
                <tr>
                    <th>댓글 입력</th>
                    <td><textarea name="body" placeholder="내용을 입력하세요"></textarea></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <button>작성</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </c:if>
    <c:if test="${!rq.isLogined()}">댓글 작성을 위해 <a href="../member/login">로그인</a>이 필요합니다</c:if>
</section>

<section class="mt-8 text-xl px-4">
    <div class="mx-auto">
        <table class="table" border="1" cellspacing="0" cellpadding="5" style="width:100%;border-collapse:collapse;">
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
            <c:forEach var="comment" items="${comments}">
                <tr data-comment-id="${comment.id}" data-parent-id="${comment.parentId}"
                    class="hover ${comment.parentId != null ? 'reply-row' : ''}">
                    <td>${comment.regDate.substring(0,10)}</td>
                    <td>${comment.extra__writer}</td>
                    <td>
                        <c:if test="${comment.parentId != 0}"><span style="color:gray;">→</span></c:if>
                            ${comment.body}
                    </td>
                    <td>
                        <button class="comment-like-btn" data-rel-id="${comment.id}"><i class="far fa-heart"></i> <span
                                class="like-count">${comment.like}</span></button>
                    </td>
                    <td>
                        <c:if test="${comment.userCanModify}">
                            <button onclick="toggleModifybtn('${comment.id}')">수정</button>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${comment.userCanDelete}"><a
                                href="/usr/comment/doDelete?id=${comment.id}&postId=${post.id}"
                                onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></c:if>
                        <button type="button" class="reply-btn" data-parent-id="${comment.id}">답글</button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</section>

<script>
    $(document).ready(function () {
        // 댓글 좋아요 토글
        $('.comment-like-btn').click(function () {
            var $btn = $(this);
            var relId = $btn.data('rel-id');
            var $heart = $btn.find('.heart');
            var $count = $btn.find('.like-count');
            $.post('/usr/comment/toggleLike', {relId: relId}, function (data) {
                if (data.resultCode.startsWith('S-')) {
                    $count.text(data.data1.likeCount);
                    $heart.html(data.data1.liked ? '<i class="fas fa-heart text-red-500"></i>' : '<i class="far fa-heart"></i>');
                } else if (data.resultCode === 'F-1') {
                    alert(data.msg);
                    location.href = '/usr/member/login?redirectUrl=' + encodeURIComponent(location.href);
                } else {
                    alert(data.msg);
                }
            }, 'json');
        });
    });

    // Dynamic reply form injection
    $(document).off('click', '.reply-btn');
    $(document).on('click.reply', '.reply-btn', function (e) {
        e.preventDefault();
        var $btn = $(this);
        var cid = $btn.attr('data-parent-id');
        var $tr = $btn.closest('tr');
        var $next = $tr.next();
        if ($next.hasClass('reply-form-row')) {
            $next.slideUp(200, function () {
                $(this).remove();
            });
            return;
        }
        $('tr.reply-form-row').remove();
        var formRow = '\
<tr class="reply-form-row">\
  <td colspan="6" style="padding:8px;">\
    <form action="/usr/comment/doWrite" method="POST" style="display:flex;gap:8px;">\
      <input type="hidden" name="relTypeCode" value="comment"/>\
      <input type="hidden" name="relId" value="' + cid + '"/>\
      <input type="hidden" name="parentId" value="' + cid + '"/>\
      <textarea name="body" rows="1" placeholder="답글을 입력하세요"></textarea>\
      <button type="submit" class="btn-xs btn-success">등록</button>\
      <button type="button" class="btn-xs btn-secondary reply-cancel">취소</button>\
    </form>\
  </td>\
</tr>';
        $tr.after(formRow);
        $tr.next().hide().slideDown(200);
    });

    // 취소 버튼
    $(document).on('click', '.reply-cancel', function (e) {
        e.preventDefault();
        $(this).closest('tr.reply-form-row').slideUp(200, function () {
            $(this).remove();
        });
    });
</script>

<style>
    .reply-row td {
        padding-left: 20px;
    }
</style>

<%@ include file="../common/foot.jspf" %>
