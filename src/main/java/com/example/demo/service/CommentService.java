package com.example.demo.service;

import com.example.demo.repository.CommentRepository;
import com.example.demo.repository.MemberRepository;
import com.example.demo.repository.PostRepository;
import com.example.demo.repository.ReactionRepository;
import com.example.demo.vo.Comment;
import com.example.demo.vo.Post;
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
    private NotificationService notificationService;

    @Autowired
    private PostRepository postRepository;

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

        if (relTypeCode.equals("post")) {
            // 일반 댓글 (게시글에 대한 댓글)
            Post post = postRepository.getPostById(relId);
            if (post != null && post.getMemberId() != memberId) {
                String nickname = memberRepository.getNicknameById(memberId);
                String message = nickname + "님이 회원님의 게시글에 댓글을 남겼습니다.";
                String link = "/usr/post/detail?id=" + relId + "#comment-" + comment.getId();

                notificationService.addNotification(
                        post.getMemberId(),     // 알림 받을 사용자 (게시글 작성자)
                        memberId,               // 알림 보낸 사용자 (댓글 작성자)
                        "WRITE_COMMENT",        // 알림 타입
                        message,
                        link
                );
            }
        } else if (relTypeCode.equals("comment")) {
            // 대댓글 (댓글에 대한 댓글)
            Comment parentComment = commentRepository.getComment(relId);
            if (parentComment != null && parentComment.getMemberId() != memberId) {
                String nickname = memberRepository.getNicknameById(memberId);
                int postId = findPostIdByComment(parentComment); // 재귀적으로 게시글 ID 추적
                String message = nickname + "님이 회원님의 댓글에 답글을 남겼습니다.";
                String link = "/usr/post/detail?id=" + postId + "#comment-" + comment.getId();

                notificationService.addNotification(
                        parentComment.getMemberId(),  // 알림 받을 사람 (부모 댓글 작성자)
                        memberId,                     // 알림 보낸 사람 (답글 작성자)
                        "REPLY_COMMENT",
                        message,
                        link
                );

            }
        }
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

    private void addWithChildren(List<Comment> result, Comment
            parent, Map<Integer, List<Comment>> childMap) {
        result.add(parent);
        List<Comment> children = childMap.get(parent.getId());
        if (children != null) {
            for (Comment child : children) {
                addWithChildren(result, child, childMap); // 재귀로 자식 붙이기
            }
        }
    }

    private int findPostIdByComment(Comment comment) {
        if ("post".equals(comment.getRelTypeCode())) {
            return comment.getRelId();
        } else if ("comment".equals(comment.getRelTypeCode())) {
            Comment parent = commentRepository.getComment(comment.getRelId());
            if (parent == null) return -1;
            return findPostIdByComment(parent);
        }
        return -1;
    }


}


