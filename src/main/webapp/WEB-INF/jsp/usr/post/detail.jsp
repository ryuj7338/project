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
    const currentPostId = ${post.id}; // 반드시 맨 위에서 전역 선언

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
                        const $btn = $('#likeButton');
                        const $icon = $btn.find('i');
                        const likeCount = d.like || d.data1 || 0;

                        const isCurrentlyLiked = $icon.hasClass('fas');

                        // 아이콘/색상 토글
                        $btn.html(
                            (!isCurrentlyLiked
                                ? '<i class="fas fa-heart text-red-500"></i>'
                                : '<i class="far fa-heart"></i>') +
                            ' <span id="likeCount">' + likeCount + '</span>'
                        );
                    } else {
                        alert(d.msg);
                    }
                }, 'json');
        });

        // 조회수 증가
        const key = 'post__' + currentPostId + '__viewed';
        if (!localStorage.getItem(key)) {
            localStorage.setItem(key, '1');

            $.getJSON('<c:url value="/usr/post/doIncreaseHitCountRd"/>', {
                id: currentPostId,
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
        <form id="commentForm" action="/usr/comment/doWrite" method="POST" onsubmit="return (function(f){
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
        <c:forEach var="c" items="${comments}">
            <tr class="reply-row ${c.parentId != 0 ? 'reply-child' : ''}" data-comment-id="${c.id}"
                data-parent-id="${c.parentId}">
                <td>${c.regDate}</td>
                <td>${c.extra__writer}</td>
                <td class="comment-body-cell">
                    <c:if test="${fn:trim(c.parentId) ne '0'}">
                        <span class="reply-arrow">↳</span>
                    </c:if>
                    <span id="comment-${c.id}">${c.body}</span>
                    <form id="modify-form-${c.id}" style="display:none;">
                        <input type="text" name="reply-text-${c.id}" value="${c.body}"/>
                        <button type="button" onclick="doModifyReply(${c.id})">저장</button>
                    </form>
                </td>
                <td>
                    <button class="comment-like-btn" data-rel-id="${c.id}">
                <span class="heart">
                    <c:choose>
                        <c:when test="${c.alreadyLiked}">
                            <i class="fas fa-heart text-red-500"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="far fa-heart"></i>
                        </c:otherwise>
                    </c:choose>
                </span>
                        <span class="like-count">${c.like}</span>
                    </button>
                </td>
                <td>
                    <c:if test="${c.userCanModify}">
                        <button onclick="toggleModifybtn(${c.id})">수정</button>
                    </c:if>
                </td>
                <td>
                    <c:if test="${c.userCanDelete}">
                        <a href="/usr/comment/doDelete?id=${c.id}&postId=${post.id}"
                           onclick="return confirm('삭제하시겠습니까?')">삭제</a>
                    </c:if>
                    <button type="button" class="reply-btn" data-parent-id="${c.id}">답글</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</section>

<!-- 대댓글 삽입 & 좋아요 스크립트 -->
<script>
    const postId = ${post.id};
    const loginedMemberId = ${rq.getLoginedMemberId()};

    // 댓글 좋아요 토글
    $(document).on("click", ".comment-like-btn", function () {
        const $btn = $(this);
        const commentId = $btn.data("rel-id");

        $.post("/usr/comment/toggleLike", {relId: commentId}, function (res) {
            if (res.resultCode.startsWith("S-")) {
                const count = res.data1;
                const liked = res.data2;
                const iconHtml = liked
                    ? '<i class="fas fa-heart text-red-500"></i>'
                    : '<i class="far fa-heart"></i>';
                $btn.html('<span class="heart">' + iconHtml + '</span> <span class="like-count">' + count + '</span>');
            } else if (res.resultCode === "F-1") {
                alert(res.msg);
                location.href = "/usr/member/login?redirectUrl=" + encodeURIComponent(location.href);
            } else {
                alert(res.msg);
            }
        }, "json");
    });

    // 댓글 수정 폼 열기/닫기
    function toggleModifybtn(id) {
        $('#modify-form-' + id).toggle();
    }

    // 댓글 수정 저장
    function doModifyReply(id) {
        const newBody = $('#modify-form-' + id + ' input[name="reply-text-' + id + '"]').val();
        $.post("/usr/comment/doModify", {id: id, body: newBody}, function (res) {
            $('#comment-' + id).text(res);
            $('#modify-form-' + id).hide();
        });
    }

    // 답글 폼 열기
    $(document).on("click", ".reply-btn", function () {
        $(".reply-form-container").remove(); // 기존 폼 제거
        const parentId = $(this).data("parent-id");

        const html = '' +
            '<div class="reply-form-container" style="margin-top: 6px;">' +
            '<form class="reply-form" data-parent-id="' + parentId + '">' +
            '<textarea name="body" rows="2" placeholder="답글을 입력하세요" required></textarea>' +
            '<button type="submit">등록</button>' +
            '<button type="button" class="reply-cancel">취소</button>' +
            '</form>' +
            '</div>';

        // 댓글 내용(td.comment-body-cell) 안으로 삽입
        $(this).closest("tr").find("td.comment-body-cell").append(html);
    });

    // 답글 취소
    $(document).on("click", ".reply-cancel", function () {
        $(this).closest(".reply-form-container").remove();
    });

    // 대댓글 등록
    $(document).on("submit", ".reply-form", function (e) {
        e.preventDefault();

        const $f = $(this);
        const parentId = $f.data("parent-id");
        const body = $f.find("textarea[name='body']").val().trim();

        if (body.length < 3) {
            alert("3자 이상 입력해주세요");
            return;
        }

        $.post("/usr/comment/doWrite", {
            relTypeCode: "post",
            relId: postId,
            parentId: parentId,
            body: body
        }, function (res) {
            if (res.resultCode !== "S-1") {
                alert(res.msg || "등록 실패");
                return;
            }

            const c = res.data1;
            const writer = c.extra__writer || "익명";
            const isMine = (c.memberId === loginedMemberId);
            const likeCount = c.likeCount || 0;

            let modifyBtn = '';
            if (isMine) {
                modifyBtn = '<button onclick="toggleModifybtn(' + c.id + ')">수정</button>';
            }

            const row = '' +
                '<tr class="reply-row reply-child" data-comment-id="' + c.id + '" data-parent-id="' + c.parentId + '">' +
                '<td>' + (c.regDate ? c.regDate.substring(0, 10) : '') + '</td>' +
                '<td>' + writer + '</td>' +
                '<td class="comment-body-cell">' +
                '<span class="reply-arrow">↳</span>' +  // 화살표 추가
                '<span id="comment-' + c.id + '">' + c.body + '</span>' +
                '<form id="modify-form-' + c.id + '" style="display:none;">' +
                '<input type="text" name="reply-text-' + c.id + '" value="' + c.body + '" />' +
                '<button type="button" onclick="doModifyReply(' + c.id + ')">저장</button>' +
                '</form>' +
                '</td>' +
                '<td>' +
                '<button class="comment-like-btn" data-rel-id="' + c.id + '">' +
                '<span class="heart"><i class="far fa-heart"></i></span>' +
                '<span class="like-count">' + likeCount + '</span>' +
                '</button>' +
                '</td>' +
                '<td>' + modifyBtn + '</td>' +
                '<td>' +
                '<button class="reply-btn" data-parent-id="' + c.id + '">답글</button>' +
                '</td>' +
                '</tr>';


            $('tr[data-comment-id="' + parentId + '"]').after(row);
            $f.closest(".reply-form-container").remove();
        }, "json").fail(function () {
            alert("등록 중 오류");
        });
    });

    // 최상단 댓글 등록
    $("#commentForm").on("submit", function (e) {
        e.preventDefault();
        const body = $(this).find("textarea").val().trim();
        if (body.length < 3) {
            alert("3자 이상 입력하세요");
            return;
        }

        $.post("/usr/comment/doWrite", {
            relTypeCode: "post",
            relId: postId,
            body: body
        }, function () {
            location.reload(); // 새로고침으로 상단 댓글 반영
        });
    });
</script>

<style>
    .reply-child td.comment-body-cell {
        padding-left: 20px;
    }

    .reply-arrow {
        color: gray;
        margin-right: 6px;
    }

    .reply-form-container textarea {
        width: 100%;
        box-sizing: border-box;
        margin-top: 6px;
    }

    .reply-form-container button {
        margin-top: 4px;
        margin-right: 4px;
    }
</style>


<%@ include file="../common/foot.jspf" %>
