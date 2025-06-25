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

    public CommentService(CommentRepository commentRepository) {
        this.commentRepository = commentRepository;
    }

    public List<Comment> getForPrintComments(int loginedMemberId, String relTypeCode, int id) {

        List<Comment> comments = commentRepository.getForPrintComments(loginedMemberId, relTypeCode, id);

        for (Comment comment : comments) {

            controlForPrintData(loginedMemberId, comment);

            boolean alreadyLiked = reactionService.isAlreadyAddLikeRp(loginedMemberId, comment.getId(), "comment");

            comment.setAlreadyLiked(alreadyLiked);
        }

        return comments;
    }

    public ResultData writeComment(int loginedMemberId, String body, String relTypeCode, int relId) {
        // 1. 댓글 저장
        commentRepository.writeComment(loginedMemberId, body, relTypeCode, relId);
        int id = commentRepository.getLastInsertId();

        // 2. relTypeCode가 post인 경우, 게시글 작성자에게 알림
        if (relTypeCode.equals("post")) {
            Post post = postRepository.getPostById(relId);
            if (post != null && post.getMemberId() != loginedMemberId) { // 자기 댓글은 알림 X
                String nickname = memberRepository.getNicknameById(loginedMemberId);
                String message = "💬 " + nickname + "님이 회원님의 글에 댓글을 달았습니다.";
                String link = "/usr/post/detail?id=" + relId + "#comment-" + id;

                notificationService.notifyMember(post.getMemberId(), message, link);
            }
        }

        return ResultData.from("S-1", Ut.f("%d번 댓글이 등록되었습니다.", id), "등록된 댓글의 id", id);
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


}
