package com.example.demo.controller;

import com.example.demo.repository.MemberRepository;
import com.example.demo.service.CommentService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
public class UsrCommentController {

    @Autowired
    private Rq rq;

    @Autowired
    private CommentService commentService;

    @Autowired
    private MemberRepository memberRepository;

    // 댓글 작성 (일반 댓글, 대댓글 모두 처리)
    @PostMapping("/usr/comment/doWrite")
    @ResponseBody
    public ResultData<?> doWrite(
            @RequestParam String relTypeCode,
            @RequestParam int relId,
            @RequestParam(required = false, defaultValue = "0") int parentId,
            @RequestParam String body
    ) {
        int loginedMemberId = rq.getLoginedMemberId();

        // Service 단에서 parentId 까지 전달
        Comment comment = commentService.writeComment(loginedMemberId, relTypeCode, relId, parentId, body);

        // extra__writer, userCanModify, userCanDelete 세팅
        String nickname = memberRepository.getNicknameById(comment.getMemberId());
        comment.setExtra__writer(nickname);
        comment.setUserCanModify(comment.getMemberId() == loginedMemberId);
        comment.setUserCanDelete(comment.getMemberId() == loginedMemberId);

        Map<String, Object> data = new HashMap<>();
        data.put("comment", comment);

        // ✏️ 여기서 new 없이 호출합니다!
        return ResultData.from(
                "S-1",
                comment.getId() + "번 댓글이 등록되었습니다.",
                data
        );
    }

    // 댓글 삭제
    @GetMapping("/usr/comment/doDelete")
    public String doDelete(@RequestParam int id, @RequestParam int postId) {
        Comment comment = commentService.getComment(id);

        if (comment == null) {
            return "redirect:/usr/post/detail?id=" + postId;
        }

        if (comment.getMemberId() != rq.getLoginedMemberId()) {
            return "redirect:/usr/post/detail?id=" + comment.getRelId();
        }

        commentService.deleteComment(id);

        return "redirect:/usr/post/detail?id=" + comment.getRelId();
    }

    // 댓글 수정 (Ajax)
    @PostMapping("/usr/comment/doModify")
    @ResponseBody
    public String doModify(
            @RequestParam int id,
            @RequestParam String body
    ) {
        Comment comment = commentService.getComment(id);

        if (comment == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 댓글은 존재하지 않습니다.", id));
        }

        ResultData canModifyRd = commentService.userCanModify(rq.getLoginedMemberId(), comment);

        if (canModifyRd.isSuccess()) {
            commentService.modifyComment(id, body);
        }

        comment = commentService.getComment(id);

        return comment.getBody();
    }
}
