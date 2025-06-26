package com.example.demo.service;

import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.MemberRepository;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentService {


    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private MemberRepository memberRepository;


    public Comment writeComment(int memberId, String relTypeCode, int relId, Integer parentId, String body) {
        if (parentId == null) {
            parentId = 0;
        }

        // 1) DB에 INSERT (parentId 까지 전달)
        commentRepository.writeComment(memberId, body, relTypeCode, relId, parentId);

        // 2) 방금 생성된 댓글 ID 가져오기
        int newId = commentRepository.getLastInsertId();

        // 3) DB에서 조회해서 Comment 객체로 리턴
        Comment comment = commentRepository.getComment(newId);

        return comment;
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

    // 댓글 출력용 조회
    public List<Comment> getForPrintComments(int loginedMemberId, String relTypeCode, int relId) {
        List<Comment> comments = commentRepository.getForPrintComments(loginedMemberId, relTypeCode, relId);

        for (Comment comment : comments) {
            // parentId 설정 (DB에 parentId 컬럼이 있다면 이 블록은 생략 가능)
            if ("comment".equals(comment.getRelTypeCode())) {
                // 여기서 c.getRelId() 는 부모 댓글 ID
                comment.setParentId(comment.getRelId());
            } else {
                comment.setParentId(0);
            }
            // 닉네임 채우기
            comment.setExtra__writer(memberRepository.getNicknameById(comment.getMemberId()));
            // 로그인 정보에 따른 수정/삭제 권한은 컨트롤러에서 직접 설정하므로 여기선 생략
        }

        return comments;
    }
}
