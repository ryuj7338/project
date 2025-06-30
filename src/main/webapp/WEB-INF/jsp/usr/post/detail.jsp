<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageColor" value="dark"/>
<%@ include file="../common/head.jspf" %>
<%@ include file="../common/nav.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"/>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<c:set var="pageTitle" value="게시글 상세보기"/>
<c:url var="incUrl" value="/usr/post/doIncreaseHitCountRd"/>

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


<body class="bg-gray-100 text-black min-h-screen flex flex-col">

<main class="flex-grow px-4 py-8">
    <div class="max-w-4xl mx-auto bg-white shadow rounded-lg p-6">
        <h1 class="text-2xl font-bold mb-2">${post.title}</h1>
        <div class="text-sm text-gray-600 mb-4">
            작성자: ${post.extra__writer} | 등록일: ${post.regDate} |
            조회수: <span class="post-detail__hit-count">${post.hit}</span>
        </div>

        <div class="mb-4">
            <button id="likeButton" class="text-red-500 text-lg">
                <c:choose>
                    <c:when test="${isAlreadyAddLikeRp}">
                        <i class="fas fa-heart"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="far fa-heart"></i>
                    </c:otherwise>
                </c:choose>
                <span id="likeCount">${post.like}</span>
            </button>
        </div>

        <div id="viewer" class="border-t pt-4 mt-4"></div>
        <textarea id="viewerContent" style="display:none;">
<c:out value="${filteredBody}" escapeXml="false"/>
    </textarea>
        <c:if test="${not empty resourceList}">
            <div class="max-w-4xl mx-auto mt-6 bg-gray-100 p-4 rounded shadow">
                <h2 class="text-lg font-semibold mb-2">첨부파일</h2>
                <ul class="list-disc list-inside text-blue-700">
                    <c:forEach var="file" items="${resourceList}">
                        <li>
                            <a href="/file/download?path=${file.savedName}&original=${file.originalName}" download>
                                    ${file.originalName}
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <div class="mt-6 flex justify-between">
            <button onclick="history.back()" class="text-blue-600 hover:underline">뒤로가기</button>
            <div class="space-x-4">
                <c:if test="${post.userCanModify}">
                    <a href="/usr/post/modify?id=${post.id}" class="text-yellow-600 hover:underline">수정</a>
                </c:if>
                <c:if test="${post.userCanDelete}">
                    <a href="/usr/post/doDelete?id=${post.id}" class="text-red-600 hover:underline">삭제</a>
                </c:if>
            </div>
        </div>
    </div>

    <!-- 댓글 영역 -->
    <div class="max-w-4xl mx-auto mt-8 bg-white shadow rounded-lg p-6">
        <h2 class="text-lg font-semibold mb-4">댓글</h2>

        <c:if test="${rq.isLogined()}">
            <form id="commentForm" method="POST" class="space-y-2">
                <input type="hidden" name="relTypeCode" value="post"/>
                <input type="hidden" name="relId" value="${post.id}"/>
                <textarea name="body" class="w-full border p-2 rounded" placeholder="댓글을 입력하세요" required></textarea>
                <button class="bg-blue-500 text-white px-4 py-1 rounded">작성</button>
            </form>
        </c:if>
        <c:if test="${!rq.isLogined()}">
            <p>댓글 작성을 위해 <a href="/usr/member/login" class="text-blue-600 underline">로그인</a>이 필요합니다.</p>
        </c:if>

        <div id="comments-container" class="mt-6">
            <c:forEach var="c" items="${comments}">
                <div class="border-t pt-4 mt-4 ${c.parentId != 0 ? 'pl-6' : ''}">
                    <div class="text-sm text-gray-600 mb-1">
                            ${c.extra__writer} | ${c.regDate}
                    </div>
                    <div class="flex justify-between">
                        <div>
                            <c:if test="${c.parentId != 0}">
                                <span class="text-gray-400 mr-1">↳</span>
                            </c:if>
                            <span id="comment-${c.id}">${c.body}</span>
                        </div>
                        <div class="flex space-x-2 text-sm text-gray-500">
                            <button class="comment-like-btn" data-rel-id="${c.id}">
                                <c:choose>
                                    <c:when test="${c.alreadyLiked}">
                                        <i class="fas fa-heart text-red-500"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="far fa-heart"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span class="like-count">${c.like}</span>
                            </button>
                            <c:if test="${c.userCanModify}">
                                <button onclick="toggleModifybtn(${c.id})">수정</button>
                            </c:if>
                            <c:if test="${c.userCanDelete}">
                                <a href="/usr/comment/doDelete?id=${c.id}&postId=${post.id}"
                                   onclick="return confirm('삭제하시겠습니까?')">삭제</a>
                            </c:if>
                            <button class="reply-btn" data-parent-id="${c.id}">답글</button>
                        </div>
                    </div>
                    <form id="modify-form-${c.id}" style="display:none;" class="mt-2">
                        <input type="text" name="reply-text-${c.id}" value="${c.body}" class="border p-1 w-full"/>
                        <button type="button" onclick="doModifyReply(${c.id})" class="text-blue-600 mt-1">저장</button>
                    </form>
                </div>
            </c:forEach>
        </div>
    </div>
</main>

<%@ include file="../common/foot.jspf" %>

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
        const html =
            '<div class="reply-form-container" style="margin-top: 6px;">' +
            '<form class="reply-form" data-parent-id="' + parentId + '">' +
            '<textarea name="body" rows="2" placeholder="답글을 입력하세요" required></textarea>' +
            '<button type="submit">등록</button>' +
            '<button type="button" class="reply-cancel">취소</button>' +
            '</form>' +
            '</div>';

        // div 구조에 맞게 삽입
        $(this).closest('.border-t').append(html);
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

            // 새 대댓글 div를 생성하여 부모 댓글 아래에 삽입
            const $parentCommentDiv = $('#comment-' + parentId).closest('.border-t');
            $parentCommentDiv.after(
                '<div class="border-t pt-4 mt-4 pl-6">' +
                '<div class="text-sm text-gray-600 mb-1">' +
                writer + ' | ' + (c.regDate ? c.regDate : '') +
                '</div>' +
                '<div class="flex justify-between">' +
                '<div><span class="text-gray-400 mr-1">↳</span>' +
                '<span id="comment-' + c.id + '">' + c.body + '</span></div>' +
                '<div class="flex space-x-2 text-sm text-gray-500">' +
                // 좋아요/수정/삭제/답글 버튼들... (필요에 따라 추가)
                '</div>' +
                '</div>' +
                '</div>'
            );
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
</body>
