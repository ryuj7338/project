<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<c:set var="pageTitle" value="게시글 상세보기"></c:set>
<%@ include file="../common/head.jspf"%>

<!-- 변수 -->
<script>
	const params = {};
	params.id = parseInt('${param.id }');

	var isAlreadyAddLikeRp = ${isAlreadyAddLikeRp};

</script>

<!-- 댓글 수정 -->
<script>
function toggleModifybtn(commentId) {

	console.log(commentId);

	$('#modify-btn-'+commentId).hide();
	$('#save-btn-'+commentId).show();
	$('#reply-'+commentId).hide();
	$('#modify-form-'+commentId).show();
}

function doModifyComment(commentId) {
	 console.log(commentId); // 디버깅을 위해 replyId를 콘솔에 출력

	    // form 요소를 정확하게 선택
	    var form = $('#modify-form-' + commentId);
	    console.log(form); // 디버깅을 위해 form을 콘솔에 출력

	    // form 내의 input 요소의 값을 가져옵니다
	    var text = form.find('input[name="comment-text-' + commentId + '"]').val();
	    console.log(text); // 디버깅을 위해 text를 콘솔에 출력

	    // form의 action 속성 값을 가져옵니다
	    var action = form.attr('action');
	    console.log(action); // 디버깅을 위해 action을 콘솔에 출력

    $.post({
    	url: '/usr/comment/doModify', // 수정된 URL
        type: 'POST', // GET에서 POST로 변경
        data: { id: commentId, body: text }, // 서버에 전송할 데이터
        success: function(data) {
        	$('#modify-form-'+commentId).hide();
        	$('#comment-'+commentId).text(data);
        	$('#comment-'+commentId).show();
        	$('#save-btn-'+commentId).hide();
        	$('#modify-btn-'+commentId).show();
        },
        error: function(xhr, status, error) {
            alert('댓글 수정에 실패했습니다: ' + error);
        }
	})
}
</script>

<!-- 좋아요 / 싫어요 -->
<script>
	function checkRP() {
		if (isAlreadyAddLikeRp == true) {
			$('#likeButton').toggleClass('btn-outline');
		}else {
				return;
		}
	}

	function doLikeReaction(articleId) {

		$.ajax({
			url : '/usr/reaction/doLike',
			type : 'POST',
			data : {
				relTypeCode : 'post',
				relId : postId
			},
			dataType : 'json',
			success : function(data) {
				console.log(data);
				console.log('data.data1Name : ' + data.data1Name);
				console.log('data.data1 : ' + data.data1);
				console.log('data.data2Name : ' + data.data2Name);
				console.log('data.data2 : ' + data.data2);
				if (data.resultCode.startsWith('S-')) {
					var likeButton = $('#likeButton');
					var likeCount = $('#likeCount');
					var likeCountC = $('.likeCount');


					if (data.resultCode == 'S-1') {
						likeButton.toggleClass('btn-outline');
						likeCount.text(data.data1);
						likeCountC.text(data.data1);
					} else if (data.resultCode == 'S-2') {
						likeButton.toggleClass('btn-outline');
						likeCount.text(data.data1);
						likeCountC.text(data.data1);
					} else {
						likeButton.toggleClass('btn-outline');
						likeCount.text(data.data1);
						likeCountC.text(data.data1);
					}

				} else {
					alert(data.msg);
				}

			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert('좋아요 오류 발생 : ' + textStatus);

			}

		});


	}

	$(function() {
		checkRP();
	});
</script>

<script>
	function PostDetail__doIncreaseHitCount() {
		$.get('../post/doIncreaseHitCountRd', {
			id : params.id,
			ajaxMode : 'Y'
		}, function(data) {
			console.log(data);
			console.log(data.data1);
			console.log(data.msg);
			$('.post-detail__hit-count').html(data.data1);
		}, 'json');
	}

	$(function() {
		PostDetail__doIncreaseHitCount();
	})
</script>