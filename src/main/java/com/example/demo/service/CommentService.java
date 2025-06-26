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
    private CommentRepository commentRepository;

    @Autowired
    private MemberRepository memberRepository;

    // 댓글 작성 (대댓글 포함)
    public ResultData writeComment(int memberId, String body, String relTypeCode, int relId, Integer parentId) {
        if (parentId == null) {
            parentId = 0; // 일반 댓글일 경우 0으로 처리
        }

        commentRepository.writeComment(memberId, body, relTypeCode, relId, parentId);

        int id = commentRepository.getLastInsertId();

        return ResultData.from("S-1", id + "번 댓글이 등록되었습니다.", "id", id);
    }

    public Comment getComment(int id) {
        return commentRepository.getComment(id);
    }

    public ResultData userCanModify(int loginedMemberId, Comment comment) {
        if (comment == null) {
            return ResultData.from("F-1", "댓글이 존재하지 않습니다.");
        }

        if (comment.getMemberId() != loginedMemberId) {
            return ResultData.from("F-2", "권한이 없습니다.");
        }

        return ResultData.from("S-1", "수정 가능합니다.");
    }

    public void modifyComment(int id, String body) {
        commentRepository.modifyComment(id, body);
    }

    public void deleteComment(int id) {
        commentRepository.deleteComment(id);
    }

    // 댓글 리스트 가져오기 (출력용)
    public List<Comment> getForPrintComments(int loginedMemberId, String relTypeCode, int relId) {
        List<Comment> comments = commentRepository.getForPrintComments(loginedMemberId, relTypeCode, relId);

        for (Comment comment : comments) {
            // parentId 세팅: 대댓글인 경우 relTypeCode가 "comment"이면 relId가 부모 댓글 ID
            if ("comment".equals(comment.getRelTypeCode())) {
                comment.setParentId(comment.getRelId());
            } else {
                comment.setParentId(0);  // 일반 댓글은 0 (null 대신 0으로)
            }

            // 작성자 닉네임 셋팅 (DB join에서 extra__writer도 가능)
            comment.setExtra__writer(memberRepository.getNicknameById(comment.getMemberId()));

            // 기타 필요한 필드들 셋팅 가능
        }

        return comments;
    }

}

