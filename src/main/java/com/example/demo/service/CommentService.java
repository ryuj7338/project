package com.example.demo.service;


import com.example.demo.repository.CommentRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CommentService {

    @Autowired
    private CommentRepository commentRepository;

    public CommentService(CommentRepository commentRepository) {
        this.commentRepository = commentRepository;
    }

    public List<Comment> getForPrintComments(int loginedMemberId, String relTypeCode, int id) {

        List<Comment> comments = commentRepository.getForPrintComments(loginedMemberId, relTypeCode, id);

        for (Comment comment : comments) {
            controlForPrintData(loginedMemberId, comment);
        }

        return comments;
    }

    public ResultData writeComment(int loginedMemberId, String body, String relTypeCode, int relId) {

        commentRepository.writeComment(loginedMemberId, body, relTypeCode, relId);

        int id = commentRepository.getLastInsertId();

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
