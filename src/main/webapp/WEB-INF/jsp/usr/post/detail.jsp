<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ include file="../common/head.jspf" %>
<%@ include file="../common/toastUiEditorLib.jspf" %>

<!-- Toast UI Viewer -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css"/>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

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
                    // ✅ 1. 먼저 alert
                    alert(data.msg);

                    // ✅ 2. 그리고 로그인 페이지로 이동
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

<!-- 댓글 수정 -->
<script>
    function toggleModifybtn(commentId) {

        console.log(commentId);

        $('#modify-btn-' + commentId).hide();
        $('#save-btn-' + commentId).show();
        $('#reply-' + commentId).hide();
        $('#modify-form-' + commentId).show();
    }

    function doModifyReply(commentId) {
        console.log(commentId); // 디버깅을 위해 commentId 콘솔에 출력

        // form 요소를 정확하게 선택
        var form = $('#modify-form-' + commentId);
        console.log(form); // 디버깅을 위해 form을 콘솔에 출력

        // form 내의 input 요소의 값을 가져옵니다
        var text = form.find('input[name="reply-text-' + commentId + '"]').val();
        console.log(text); // 디버깅을 위해 text를 콘솔에 출력

        // form의 action 속성 값을 가져옵니다
        var action = form.attr('action');
        console.log(action); // 디버깅을 위해 action을 콘솔에 출력

        $.post({
            url: '/usr/comment/doModify', // 수정된 URL
            type: 'POST', // GET에서 POST로 변경
            data: {id: commentId, body: text}, // 서버에 전송할 데이터
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
        })
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
                <td style="text-align: center"><span class="post-detail_comment-count">${post.commentsCount}</span></td>
            </tr>
            <tr>
                <th>제목</th>
                <td>${post.title}</td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <div id="viewer"></div>
                    <textarea id="viewerContent" style="display:none;"><c:out value="${post.body}"/></textarea>
                </td>
            </tr>
            <tr>
                <th>다운로드 파일</th>

                <td>
                    <c:forEach var="resource" items="${resourceList}">
                        <c:if test="${not empty resource.image}">
                            <c:set var="fileName" value="${fn:substringAfter(resource.image, '_')}"/>
                            🖼 이미지:
                            <a class="download-link"
                               href="/file/download?path=${resource.zip}&amp;original=${fileName}">
                                    ${fileName} [다운로드]
                            </a><br/>
                        </c:if>
                        <c:if test="${not empty resource.pdf}">
                            <c:set var="fileName" value="${fn:substringAfter(resource.pdf, '_')}"/>
                            📄 PDF:
                            <a class="download-link"
                               href="/file/download?path=${resource.zip}&amp;original=${fileName}">
                                    ${fileName} [다운로드]
                            </a><br/>
                        </c:if>
                        <c:if test="${not empty resource.hwp}">
                            <c:set var="fileName" value="${fn:substringAfter(resource.hwp, '_')}"/>
                            📑 HWP:
                            <a class="download-link"
                               href="/file/download?path=${resource.zip}&amp;original=${fileName}">
                                    ${fileName} [다운로드]
                            </a><br/>
                        </c:if>

                        <c:if test="${not empty resource.docx}">
                            <c:set var="fileName" value="${fn:substringAfter(resource.docx, '_')}"/>
                            📄 Word:
                            <a class="download-link"
                               href="/file/download?path=${resource.zip}&amp;original=${fileName}">
                                    ${fileName} [다운로드]
                            </a><br/>
                        </c:if>

                        <c:if test="${not empty resource.xlsx}">
                            <c:set var="fileName" value="${fn:substringAfter(resource.xlsx, '_')}"/>
                            📊 Excel:
                            <a class="download-link"
                               href="/file/download?path=${resource.zip}&amp;original=${fileName}">
                                    ${fileName} [다운로드]
                            </a><br/>
                        </c:if>

                        <c:if test="${not empty resource.pptx}">
                            <c:set var="fileName" value="${fn:substringAfter(resource.pptx, '_')}"/>
                            📽 PPTX:
                            <a class="download-link"
                               href="/file/download?path=${resource.zip}&amp;original=${fileName}">
                                    ${fileName} [다운로드]
                            </a><br/>
                        </c:if>

                        <c:if test="${not empty resource.zip}">
                            <c:set var="fileName" value="${fn:substringAfter(resource.zip, '_')}"/>
                            📦 ZIP:
                            <a class="download-link"
                               href="/file/download?path=${resource.zip}&amp;original=${fileName}">
                                    ${fileName} [다운로드]
                            </a><br/>
                        </c:if>

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
        console.log(form.body.value);

        form.body.value = form.body.value.trim();

        if (form.body.value.length < 3) {
            alert('3글자 이상 입력하세요');
            form.body.focus();
            return;
        }

        form.submit();
    }
</script>

<!-- 댓글 -->
<section class="mt-24 text-xl px-4">
    <c:if test="${rq.isLogined() }">
        <form action="/usr/comment/doWrite" method="POST" onsubmit="CommentWrite__submit(this); return false;" )>
            <table class="table" border="1" cellspacing="0" cellpadding="5"
                   style="width: 100%; border-collapse: collapse;">
                <input type="hidden" name="relTypeCode" value="post"/>
                <input type="hidden" name="relId" value="${post.id }"/>
                <tbody>

                <tr>
                    <th>댓글 내용 입력</th>
                    <td style="text-align: center;"><textarea class="input input-bordered input-sm w-full max-w-xs"
                                                              name="body"
                                                              autocomplete="off" type="text"
                                                              placeholder="내용을 입력하세요"></textarea></td>

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

    <c:if test="${!rq.isLogined() }">
        댓글 작성을 위해 <a class="btn btn-outline btn-primary" href="../member/login">로그인</a>이 필요합니다
    </c:if>
    <!-- 댓글 리스트 -->
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

                    <!-- ✅ 좋아요 버튼 영역 -->
                    <td style="text-align: center;">
                        <button class="comment-like-btn"
                                data-rel-id="${comment.id}"
                                data-liked="${comment.alreadyLiked}">
              <span class="heart">
                      ${comment.alreadyLiked ? '❤️' : '🤍'}
              </span>
                            <span class="like-count">${comment.like}</span>
                        </button>
                    </td>

                    <!-- 수정 버튼 -->
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

                    <!-- 삭제 버튼 -->
                    <td style="text-align: center;">
                        <c:if test="${comment.userCanDelete}">
                            <a class="btn btn-outline btn-xs btn-error"
                               onclick="if(confirm('정말 삭제?') == false) return false;"
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
            const $likeCount = $btn.find(".like-count"); // ← 여기 위치를 위로 올려야 함

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
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.download-link').forEach(link => {
            const path = link.getAttribute('data-path');

            if (!path) return;

            // 🔽 파일명 추출 (마지막 슬래시 이후)
            const fileName = path.substring(path.lastIndexOf('/') + 1);

            // 🔽 인코딩 처리
            const encodedPath = encodeURIComponent(path);
            const encodedName = encodeURIComponent(fileName);

            // 🔽 href 설정
            link.href = `/file/download?path=${encodedPath}&original=${encodedName}`;

            // 🔽 텍스트도 보기 좋게 설정
            link.textContent = `${fileName} [다운로드]`;

            // 디버깅용 로그
            console.log("추출된 파일명:", fileName);
            console.log("encodedPath:", encodedPath);
            console.log("encodedName:", encodedName);
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
