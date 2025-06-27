package com.example.demo.service;

import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.MemberRepository;
import com.example.demo.repository.ReactionRepository;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import jakarta.persistence.criteria.CriteriaBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CommentService {


    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private ReactionRepository reactionRepository;


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
            // 덮어쓰기 로직 제거 ✅
            comment.setExtra__writer(memberRepository.getNicknameById(comment.getMemberId()));

            comment.setUserCanModify(comment.getMemberId() == loginedMemberId);
            comment.setUserCanDelete(comment.getMemberId() == loginedMemberId);

            boolean alreadyLiked = reactionRepository.existsByMemberIdAndRelTypeCodeAndRelId(
                    loginedMemberId, "comment", comment.getId()
            );
            comment.setAlreadyLiked(alreadyLiked);
        }

        return sortCommentsByParent(comments);
    }


    private List<Comment> sortCommentsByParent(List<Comment> comments) {

        Map<Integer, List<Comment>> childMap = new HashMap<>();
        List<Comment> roots = new ArrayList<>();

        for (Comment comment : comments) {
            Integer parentId = comment.getParentId();

            if (parentId == null || parentId == 0) {
                roots.add(comment);
            } else {
                childMap.computeIfAbsent(parentId, k -> new ArrayList<>()).add(comment);
            }
        }

        List<Comment> sorted = new ArrayList<>();
        for (Comment root : roots) {
            addWithChildren(sorted, root, childMap);
        }
        return sorted;
    }

    private void addWithChildren(List<Comment> result, Comment parent, Map<Integer, List<Comment>> childMap) {
        result.add(parent);
        List<Comment> children = childMap.get(parent.getId());
        if (children != null) {
            for (Comment child : children) {
                addWithChildren(result, child, childMap); // 재귀로 자식 붙이기
            }
        }
    }
}
