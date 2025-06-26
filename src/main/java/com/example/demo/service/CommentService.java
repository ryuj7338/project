package com.example.demo.service;


import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.MemberRepository;
import com.example.demo.repository.PostRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.Post;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CommentService {

    @Autowired
    private ReactionService reactionService;
    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private NotificationService notificationService;

    public List<Comment> getForPrintComments(int loginedMemberId, String relTypeCode, int id) {

        List<Comment> comments = commentRepository.getForPrintComments(loginedMemberId, relTypeCode, id);

        for (Comment comment : comments) {

            controlForPrintData(loginedMemberId, comment);

            boolean alreadyLiked = reactionService.isAlreadyAddLikeRp(loginedMemberId, comment.getId(), "comment");

            comment.setAlreadyLiked(alreadyLiked);

            // parentId 세팅: 대댓글인 경우 relTypeCode가 "comment" 이므로, relId를 부모 댓글 ID로 저장
            if ("comment".equals(comment.getRelTypeCode())) {
                comment.setParentId(comment.getRelId());
            } else {
                comment.setParentId(0);  // 일반 댓글은 부모 댓글 없음(null)
            }
        }

        return comments;
    }

    public ResultData writeComment(int loginedMemberId, String body, String relTypeCode, int relId, Integer parentId) {
        commentRepository.writeComment(loginedMemberId, body, relTypeCode, relId, parentId);
        int id = commentRepository.getLastInsertId();

        // 📌 일반 댓글 알림
        if (relTypeCode.equals("post")) {
            Post post = postRepository.getPostById(relId);
            if (post != null && post.getMemberId() != loginedMemberId) {
                String nickname = memberRepository.getNicknameById(loginedMemberId);
                String message = "💬 " + nickname + "님이 회원님의 글에 댓글을 달았습니다.";
                String link = "/usr/post/detail?id=" + relId + "#comment-" + id;
                notificationService.addNotification(
                        post.getMemberId(),
                        loginedMemberId,
                        "COMMENT",
                        message,
                        link
                );
            }
        }

        // 📌 대댓글 알림
        if (relTypeCode.equals("comment")) {
            Comment parentComment = commentRepository.findById(relId);
            if (parentComment != null && parentComment.getMemberId() != loginedMemberId) {
                String nickname = memberRepository.getNicknameById(loginedMemberId);
                int postId = findPostIdByComment(parentComment);
                String message = "🔁 " + nickname + "님이 회원님의 댓글에 답글을 남겼습니다.";
                String link = "/usr/post/detail?id=" + postId + "#comment-" + id;
                notificationService.addNotification(
                        parentComment.getMemberId(),
                        loginedMemberId,
                        "REPLY",
                        message,
                        link
                );
            }
        }

        return ResultData.from("S-1", Ut.f("%d번 댓글이 등록되었습니다.", id), "등록된 댓글의 id", id);
    }


    public int findPostIdByComment(Comment comment) {
        if (comment.getRelTypeCode().equals("post")) {
            return comment.getRelId();
        } else if (comment.getRelTypeCode().equals("comment")) {
            Comment parent = commentRepository.findById(comment.getRelId());
            return findPostIdByComment(parent); // 재귀 호출로 최종 글 ID 찾기
        }
        return -1; // 에러 케이스
    }



    private void controlForPrintData(int loginedMemberId, Comment comment) {

        if (comment == null) {
            return;
        }

        ResultData userCanModifyRd = userCanModify(loginedMemberId, comment);
        comment.setUserCanModify(userCanModifyRd.isSuccess());

        ResultData userCanDeleteRd = userCanDelete(loginedMemberId, comment);
        comment.setUserCanDelete(userCanDeleteRd.isSuccess());
    }

    public ResultData userCanDelete(int loginedMemberId, Comment comment) {

        if (comment.getMemberId() != loginedMemberId) {
            return ResultData.from("F-2", Ut.f("%d번 댓글에 대한 삭제 권한이 없습니다", comment.getId()));
        }

        return ResultData.from("S-1", Ut.f("%d번 댓글을 삭제했습니다", comment.getId()));
    }

    public ResultData userCanModify(int loginedMemberId, Comment comment) {

        if (comment.getMemberId() != loginedMemberId) {
            return ResultData.from("F-2", Ut.f("%d번 댓글에 대한 수정 권한이 없습니다", comment.getId()));
        }

        return ResultData.from("S-1", Ut.f("%d번 댓글을 수정했습니다", comment.getId()), "수정된 댓글", comment);
    }

    public Comment getComment(int id) {

        return commentRepository.getComment(id);
    }

    public void modifyComment(int id, String body) {

        commentRepository.modifyComment(id, body);
    }


    public ResultData deleteComment(int id) {
        Comment comment = commentRepository.getComment(id);
        if (comment == null) {
            return ResultData.from("F-1", "댓글이 존재하지 않습니다.");
        }

        commentRepository.deleteComment(id);
        return ResultData.from("S-1", id + "번 댓글이 삭제되었습니다.");
    }
}
