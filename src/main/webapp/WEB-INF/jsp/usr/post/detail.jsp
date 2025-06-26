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
            $('#likeButton').removeClass('btn-outline');
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
                        $likeButton.html('<i class="fas fa-heart text-red-500"></i> <span id="likeCount" class="likeCount">' + likeCount + '</span>');
                    } else {
                        $likeButton.html('<i class="far fa-heart"></i> <span id="likeCount" class="likeCount">' + likeCount + '</span>');
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
                            <c:when test="${isAlreadyAddLikeRp}">
                                <i class="fas fa-heart text-red-500"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="far fa-heart"></i>
                            </c:otherwise>
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
                            <c:choose>
                                <c:when test="${file.auto}">
                                    <a href="#" class="download-link"
                                       data-path="auto/${file.savedName}"
                                       data-original="${file.originalName}">[다운로드]</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="#" class="download-link"
                                       data-path="${file.savedName}"
                                       data-original="${file.originalName}">[다운로드]</a>
                                </c:otherwise>
                            </c:choose>
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
                <th style="text-align: center;">삭제/답글</th>
            </tr>
            </thead>
            <tbody id="comments-container">
            <c:forEach var="comment" items="${comments}">
                <!-- 댓글 or 대댓글 구분: 대댓글은 parentId가 있을 것 -->
                <tr class="hover ${comment.parentId != null ? 'reply-row' : ''}" data-comment-id="${comment.id}"
                    data-parent-id="${comment.parentId}">
                    <td style="text-align: center;">${comment.regDate.substring(0,10)}</td>
                    <td style="text-align: center;">${comment.extra__writer}</td>
                    <td style="text-align: left;">
                        <!-- 대댓글이면 앞에 화살표 표시 -->
                        <c:if test="${comment.parentId != 0}">
                            <span style="color:gray; margin-right: 6px;">→</span>
                        </c:if>
                        <span id="comment-${comment.id}">${comment.body}</span>

                        <!-- 답글 작성 폼 숨김 -->
                        <div class="reply-form-container" id="reply-form-container-${comment.id}"
                             style="display:none; margin-top: 8px;">
                            <form class="reply-form" data-parent-id="${parentId}" style="display: block;">
                                <div style="display: flex; gap: 8px;">
                                    <input type="hidden" name="relTypeCode" value="comment"/>
                                    <input type="hidden" name="relId" value="${parentId}"/>
                                    <input type="hidden" name="parentId" value="${parentId}"/>
                                    <textarea name="body" class="input input-bordered input-sm w-full" rows="1"
                                              placeholder="답글을 입력하세요"></textarea>
                                    <button type="submit" class="btn btn-xs btn-success">등록</button>
                                </div>
                            </form>
                        </div>
                    </td>
                    <td style="text-align: center;">
                        <button class="comment-like-btn" data-rel-id="${comment.id}"
                                data-liked="${comment.alreadyLiked}">
                                <span class="heart">
                                    <c:choose>
                                        <c:when test="${comment.alreadyLiked}">
                                            <i class="fas fa-heart text-red-500"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-heart"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
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
                            <a class="btn btn-outline btn-xs btn-error"
                               onclick="if(!confirm('정말 삭제하시겠습니까?')) return false;"
                               href="/usr/comment/doDelete?id=${comment.id}&postId=${post.id}">삭제</a>
                        </c:if>
                        <button type="button" class="btn btn-outline btn-xs btn-primary reply-btn"
                                data-parent-id="${comment.id}">답글
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</section>

<style>
    /* 대댓글 들여쓰기 스타일 */
    .reply-row td:first-child,
    .reply-row td:nth-child(2),
    .reply-row td:nth-child(3) {
        padding-left: 20px;
    }
</style>

<script>
    $(document).ready(function () {
        // 댓글 좋아요 토글 (기존 코드)
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
                    $heart.html(result.liked ? '<i class="fas fa-heart text-red-500"></i>' : '<i class="far fa-heart"></i>');
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

        // 답글 버튼 클릭 → 폼 토글
        $(document).on("click", ".reply-btn", function () {
            const parentId = $(this).data("parent-id");
            $("#reply-form-" + parentId).remove();

            const formHtml = `
            <tr id="reply-form-${parentId}">
                <td colspan="6">
                    <form class="reply-form" data-parent-id="${parentId}" style="display: flex; gap: 8px;">
                        <input type="hidden" name="relTypeCode" value="comment" />
                        <input type="hidden" name="relId" value="${parentId}" />
                        <input type="hidden" name="parentId" value="${parentId}" />
                        <textarea name="body" class="input input-bordered input-sm w-full" rows="1" placeholder="답글을 입력하세요"></textarea>
                        <button type="submit" class="btn btn-xs btn-success">등록</button>
                    </form>
                </td>
            </tr>
        `;

            // 부모 댓글 바로 뒤에 폼 삽입
            $(`tr[data-comment-id="${parentId}"]`).after(formHtml);
        });

        // 대댓글 폼 제출
        $(document).on("submit", ".reply-form", function (e) {
            e.preventDefault();
            alert("답글 등록 이벤트가 정상 작동합니다.");
            const $form = $(this);
            const relId = $form.find('[name="relId"]').val();
            const body = $form.find('[name="body"]').val().trim();

            if (body.length < 3) {
                alert('3글자 이상 입력하세요');
                $form.find('[name="body"]').focus();
                return false;
            }

            $.post("/usr/comment/doWrite", {
                relTypeCode: "comment",
                relId: relId,
                body: body
            }, function (res) {
                if (res.resultCode.startsWith("S-")) {
                    const newComment = res.data.comment;

                    const $newRow = $(`
                    <tr class="hover reply-row" data-comment-id="${newComment.id}" data-parent-id="${newComment.parentId}">
                        <td style="text-align: center;">${newComment.regDate.substring(0,10)}</td>
                        <td style="text-align: center;">${newComment.extra__writer || newComment.writer}</td>
                        <td style="text-align: left;">
                            <span style="color:gray; margin-right: 6px;">→</span>
                            <span id="comment-${newComment.id}">${newComment.body}</span>
                        </td>
                        <td style="text-align: center;">
                            <button class="comment-like-btn" data-rel-id="${newComment.id}" data-liked="false">
                                <span class="heart"><i class="far fa-heart"></i></span>
                                <span class="like-count">0</span>
                            </button>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                `);

                    $(`#comments-container tr[data-comment-id="${newComment.parentId}"]`).after($newRow);

                    // 답글 폼 숨김 및 초기화
                    $form.find('[name="body"]').val('');
                    $form.closest('tr').remove(); // 답글 입력 폼 행 삭제
                } else {
                    alert(res.msg);
                }
            });
        });
    });
</script>

<%@ include file="../common/foot.jspf" %>
