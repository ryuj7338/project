<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<!-- Toast UI Viewer CSS/JS -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"/>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<c:set var="pageTitle" value="게시글 상세보기"/>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(function () {
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
            success: function (data) {
                if (data.resultCode === 'F-L') {
                    alert(data.msg);
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
        }, function (data) {
            $('.post-detail__hit-count').html(data.data1);
        }, 'json');
    }
</script>

<!-- 댓글 수정 스크립트 -->
<script>
    function toggleModifybtn(commentId) {
        $('#modify-btn-' + commentId).hide();
        $('#save-btn-' + commentId).show();
        $('#reply-' + commentId).hide();
        $('#modify-form-' + commentId).show();
    }

    function doModifyReply(commentId) {
        var form = $('#modify-form-' + commentId);
        var text = form.find('input[name="reply-text-' + commentId + '"]').val();

        $.post({
            url: '/usr/comment/doModify',
            type: 'POST',
            data: {id: commentId, body: text},
            success: function (data) {
                $('#modify-form-' + commentId).hide();
                $('#comment-' + commentId).text(data);
                $('#comment-' + commentId).show();
                $('#save-btn-' + commentId).hide();
                $('#modify-btn-' + commentId).show();
            },
            error: function (xhr, status, error) {
                alert('댓글 수정에 실패했습니다: ' + error);
            }
        });
    }
</script>

<section class="mt-8 text-xl px-4">
    <div class="mx-auto">
        <table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
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
                            <c:when test="${isAlreadyAddLikeRp}">❤️</c:when>
                            <c:otherwise>🤍</c:otherwise>
                        </c:choose>
                        <span id="likeCount" class="likeCount">${post.like}</span>
                    </button>
                </td>
            </tr>
            <tr>
                <th style="text-align: center">댓글수</th>
                <td style="text-align: center">${commentsCount}</td>
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
            <tr>
                <th>첨부파일</th>
                <td>
                    <c:forEach var="file" items="${resourceList}">
                        <div>
                            📁 ${file.originalName}
                            <a href="#" class="download-link"
                               data-path="${file.savedName}"
                               data-original="${file.originalName}">[다운로드]</a>
                        </div>
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
    function CommentWrite__submit(form) {
        form.body.value = form.body.value.trim();
        if (form.body.value.length < 3) {
            alert('3글자 이상 입력하세요');
            form.body.focus();
            return;
        }
        form.submit();
    }
</script>

<!-- 댓글 작성 폼 -->
<section class="mt-24 text-xl px-4">
    <c:if test="${rq.isLogined()}">
        <form action="/usr/comment/doWrite" method="POST" onsubmit="CommentWrite__submit(this); return false;">
            <table class="table" border="1" cellspacing="0" cellpadding="5"
                   style="width: 100%; border-collapse: collapse;">
                <input type="hidden" name="relTypeCode" value="post"/>
                <input type="hidden" name="relId" value="${post.id}"/>
                <tbody>
                <tr>
                    <th>댓글 내용 입력</th>
                    <td style="text-align: center;">
                        <textarea class="input input-bordered input-sm w-full max-w-xs" name="body" autocomplete="off"
                                  placeholder="내용을 입력하세요"></textarea>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td style="text-align: center;">
                        <button class="btn btn-outline">작성</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </c:if>
    <c:if test="${!rq.isLogined()}">
        댓글 작성을 위해 <a class="btn btn-outline btn-primary" href="../member/login">로그인</a>이 필요합니다
    </c:if>
</section>

<!-- 댓글 리스트 -->
<section class="mt-8 text-xl px-4">
    <div class="mx-auto">
        <table class="table" border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse;">
            <thead>
            <tr>
                <th style="text-align: center;">작성일</th>
                <th style="text-align: center;">작성자</th>
                <th style="text-align: center;">내용</th>
                <th style="text-align: center;">좋아요</th>
                <th style="text-align: center;">수정</th>
                <th style="text-align: center;">삭제</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="comment" items="${comments}">
                <tr class="hover">
                    <td style="text-align: center;">${comment.regDate.substring(0,10)}</td>
                    <td style="text-align: center;">${comment.extra__writer}</td>
                    <td style="text-align: center;">
                        <span id="comment-${comment.id}">${comment.body}</span>
                        <form method="POST" id="modify-form-${comment.id}" style="display: none;"
                              action="/usr/comment/doModify">
                            <input type="text" value="${comment.body}" name="reply-text-${comment.id}"/>
                        </form>
                    </td>
                    <td style="text-align: center;">
                        <button class="comment-like-btn" data-rel-id="${comment.id}"
                                data-liked="${comment.alreadyLiked}">
                            <span class="heart">${comment.alreadyLiked ? '❤️' : '🤍'}</span>
                            <span class="like-count">${comment.like}</span>
                        </button>
                    </td>
                    <td style="text-align: center;">
                        <c:if test="${comment.userCanModify}">
                            <button onclick="toggleModifybtn('${comment.id}');" id="modify-btn-${comment.id}"
                                    class="btn btn-outline btn-xs btn-success">수정
                            </button>
                            <button onclick="doModifyReply('${comment.id}');" style="display: none;"
                                    id="save-btn-${comment.id}" class="btn btn-outline btn-xs">저장
                            </button>
                        </c:if>
                    </td>
                    <td style="text-align: center;">
                        <c:if test="${comment.userCanDelete}">
                            <a class="btn btn-outline btn-xs btn-error" onclick="if(!confirm('정말 삭제?')) return false;"
                               href="/usr/comment/doDelete?id=${comment.id}">삭제</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty comments}">
                <tr>
                    <td colspan="6" style="text-align: center;">댓글이 없습니다</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</section>

<script>
    $(document).ready(function () {
        $(".comment-like-btn").click(function () {
            const $btn = $(this);
            const relId = $btn.data("rel-id");
            const $heart = $btn.find(".heart");
            const $likeCount = $btn.find(".like-count");

            $.post("/usr/comment/toggleLike", {relId}, function (data) {
                if (data.resultCode?.startsWith("S-")) {
                    const result = data.data1;
                    $likeCount.text(result.likeCount);
                    $btn.data("liked", result.liked);
                    $heart.text(result.liked ? "❤️" : "🤍");
                } else {
                    if (data.resultCode === 'F-1') {
                        alert(data.msg);
                        const currentUrl = location.href;
                        location.href = `/usr/member/login?redirectUrl=` + encodeURIComponent(currentUrl);
                    } else {
                        alert(data.msg);
                    }
                }
            });
        });
    });
</script>

<script>
    document.querySelectorAll('.download-link').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();

            const path = this.dataset.path;
            const original = this.dataset.original;

            const url = "/file/download?path=" + encodeURIComponent(path)
                + "&original=" + encodeURIComponent(original);

            window.location.href = url;
        });
    });
</script>


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

<%@ include file="../common/foot.jspf" %>
