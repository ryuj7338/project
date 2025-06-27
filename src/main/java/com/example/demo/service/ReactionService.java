package com.example.demo.service;


import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.MemberRepository;
import com.example.demo.repository.PostRepository;
import com.example.demo.repository.ReactionRepository;
import com.example.demo.vo.Comment;
import com.example.demo.vo.Post;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReactionService {

    @Autowired
    private ReactionRepository reactionRepository;
    @Autowired
    private PostService postService;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private CommentRepository commentRepository;

    // 댓글/게시글 좋아요 수 조회
    public int getReactionPoint(int memberId, String relTypeCode, int relId) {
        return reactionRepository.getSumReaction(memberId, relTypeCode, relId);
    }

    public int getReactionPoint(String relTypeCode, int relId) {
        return reactionRepository.getSumReactionTotal(relTypeCode, relId);
    }


    public boolean isAlreadyAddLikeRp(int memberId, int relId, String relTypeCode) {
        return reactionRepository.getSumReaction(memberId, relTypeCode, relId) > 0;
    }

    public ResultData usersReaction(int loginedMemberId, String relTypeCode, int relId) {
        if (loginedMemberId == 0) {
            return ResultData.from("F-L", "로그인이 필요합니다.");
        }

        int sum = reactionRepository.getSumReaction(loginedMemberId, relTypeCode, relId);
        if (sum != 0) {
            return ResultData.from("F-1", "이미 좋아요 함", "sumReactionByMemberId", sum);
        }

        return ResultData.from("S-1", "좋아요 가능", "sumReactionByMemberId", sum);
    }


    public ResultData deleteLikeReaction(int loginedMemberId, String relTypeCode, int relId) {
        reactionRepository.deleteLikeReaction(loginedMemberId, relTypeCode, relId);

        if ("post".equals(relTypeCode)) {
            postService.decreaseLikeReaction(relId);
        }

        return ResultData.from("S-1", "좋아요 취소");
    }


    public ResultData<?> toggleReaction(int memberId, String relTypeCode, int relId) {
        boolean isReacted = reactionRepository.existsByMemberIdAndRelTypeCodeAndRelId(memberId, relTypeCode, relId);

        if (isReacted) {
            reactionRepository.delete(memberId, relTypeCode, relId);
            return ResultData.from("S-2", "좋아요 취소");
        }

        reactionRepository.insert(memberId, relTypeCode, relId);

        // ✅ 알림 처리
        if (relTypeCode.equals("post")) {
            Post post = postRepository.getPostById(relId);
            if (post != null && post.getMemberId() != memberId) {
                String nickname = memberRepository.getNicknameById(memberId);
                String message = "❤️ " + nickname + "님이 회원님의 글에 좋아요를 눌렀습니다.";
                String link = "/usr/post/detail?id=" + relId;

                notificationService.notifyMember(post.getMemberId(), message, link);
            }
        }

        return ResultData.from("S-1", "좋아요 성공");
    }

    public ResultData addLikeReaction(int loginedMemberId, String relTypeCode, int relId) {
        int affectedRow = reactionRepository.addLikeReaction(loginedMemberId, relTypeCode, relId);

        if (affectedRow == -1) {
            return ResultData.from("F-1", "좋아요 실패");
        }

        if ("post".equals(relTypeCode)) {
            postService.increaseLikeReaction(relId);

            // 🔔 게시글 좋아요 알림 추가
            Post post = postRepository.getPostById(relId);
            if (post != null && post.getMemberId() != loginedMemberId) {
                String nickname = memberRepository.getNicknameById(loginedMemberId);
                String message = "❤️ " + nickname + "님이 회원님의 글을 좋아합니다.";
                String link = "/usr/post/detail?id=" + relId;
                notificationService.addNotification(
                        post.getMemberId(),         // 알림 받을 사람
                        loginedMemberId,            // 알림 발생자
                        "LIKE_POST",                // 알림 유형
                        message,
                        link
                );
            }
        } else if ("comment".equals(relTypeCode)) {
            // 🔔 댓글 좋아요 알림 추가
            Comment comment = commentRepository.getComment(relId);
            if (comment != null && comment.getMemberId() != loginedMemberId) {
                String nickname = memberRepository.getNicknameById(loginedMemberId);
                int postId = comment.getRelTypeCode().equals("post") ? comment.getRelId() : findPostIdByComment(comment);
                String message = "❤️ " + nickname + "님이 회원님의 댓글을 좋아합니다.";
                String link = "/usr/post/detail?id=" + postId + "#comment-" + relId;
                notificationService.addNotification(
                        comment.getMemberId(),      // 알림 받을 사람
                        loginedMemberId,            // 알림 발생자
                        "LIKE_COMMENT",             // 알림 유형
                        message,
                        link
                );
            }
        }

        return ResultData.from("S-1", "좋아요 성공");
    }

    private int findPostIdByComment(Comment comment) {
        // relTypeCode가 post면 이 댓글이 바로 게시글에 달린 것!
        if ("post".equals(comment.getRelTypeCode())) {
            return comment.getRelId();
        }
        // 아니면 상위 댓글을 찾아감
        else if ("comment".equals(comment.getRelTypeCode())) {
            Comment parent = commentRepository.getComment(comment.getRelId());
            if (parent == null) return -1; // 예외/에러 처리
            return findPostIdByComment(parent);
        }

        return -1;
    }

    public ResultData toggleLike(int loginedMemberId, String relTypeCode, int relId) {
        boolean alreadyLiked = reactionRepository.existsByMemberIdAndRelTypeCodeAndRelId(loginedMemberId, relTypeCode, relId);

        if (alreadyLiked) {
            reactionRepository.delete(loginedMemberId, relTypeCode, relId);

            if (relTypeCode.equals("comment")) {
                commentRepository.decreaseCommentLike(relId);
            } else if (relTypeCode.equals("post")) {
                postRepository.decreaseLikeReaction(relId);
            }

        } else {
            reactionRepository.insert(loginedMemberId, relTypeCode, relId);

            if (relTypeCode.equals("comment")) {
                commentRepository.increaseCommentLike(relId);
            } else if (relTypeCode.equals("post")) {
                postRepository.increaseLikeReaction(relId);
            }
        }

        // ✅ 여기에서 직접 comment/post 테이블에서 likeCount 가져오기
        int likeCount = 0;
        if (relTypeCode.equals("comment")) {
            likeCount = commentRepository.getLikeCount(relId);
        } else if (relTypeCode.equals("post")) {
            likeCount = postRepository.getLikeCount(relId);
        }

        return ResultData.from(
                alreadyLiked ? "S-2" : "S-1",
                alreadyLiked ? "좋아요 취소" : "좋아요 성공",
                "likeCount", likeCount,
                "liked", !alreadyLiked
        );
    }


}
