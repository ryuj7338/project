package com.example.demo.controller;

import com.example.demo.repository.MemberRepository;
import com.example.demo.service.CommentService;
import com.example.demo.service.ReactionService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
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
    private ReactionService reactionService;


    @RequestMapping("/usr/comment/doWrite")
    @ResponseBody
    public Object doWrite(
            HttpServletRequest req,
            @RequestParam String relTypeCode,
            @RequestParam int relId,
            @RequestParam(required = false, defaultValue = "0") int parentId,
            @RequestParam String body
    ) {
        Rq rq = (Rq) req.getAttribute("rq");

        if (Ut.isEmptyOrNull(body)) {

            if (parentId != 0) {
                return ResultData.from("F-1", "내용을 입력해주세요");
            }

            return Ut.jsHistoryBack("F-1", "내용을 입력해주세요");
        }

        int loginedMemberId = rq.getLoginedMemberId();
        Comment comment = commentService.writeComment(loginedMemberId, relTypeCode, relId, parentId, body);

        if (parentId != 0) {
            return ResultData.from("S-1", "댓글 등록 성공", "data1", comment);
        }


        return Ut.jsReplace("S-1", "댓글 등록 성공", "/usr/post/detail?id=" + relId);

    }


    // 댓글 삭제
    @GetMapping("/usr/comment/doDelete")
    public String doDelete(@RequestParam int id, @RequestParam int postId) {
        Comment comment = commentService.getComment(id);


        if (comment == null) {
            return "redirect:/usr/post/detail?id=" + postId;
        }


        if (comment.getMemberId() != rq.getLoginedMemberId()) {
            return "redirect:/usr/post/detail?id=" + postId;
        }

        commentService.deleteComment(id);

        return "redirect:/usr/post/detail?id=" + postId;
    }



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


    @RequestMapping("/usr/comment/toggleLike")
    @ResponseBody
    public ResultData<?> toggleLike(@RequestParam int relId) {
        int loginedMemberId = rq.getLoginedMemberId();

        if (loginedMemberId == 0) {
            return ResultData.from("F-1", "로그인이 필요합니다.");
        }

        return reactionService.toggleLike(loginedMemberId, "comment", relId);
    }

}
