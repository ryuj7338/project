package com.example.demo.controller;

import com.example.demo.vo.LikeResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ReactionService;
import com.example.demo.service.CommentService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

import java.util.HashMap;
import java.util.Map;

@Controller
public class UsrCommentController {

    @Autowired
    private Rq rq;

    @Autowired
    private ReactionService reactionService;

    @Autowired
    private CommentService commentService;

    @RequestMapping("usr/comment/doModify")
    @ResponseBody
    public String doModify(HttpServletRequest req, int id, String body) {

        System.err.println(id);
        System.err.println(body);
        Rq rq = (Rq) req.getAttribute("rq");

        Comment comment = commentService.getComment(id);

        if (comment == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 댓글은 존재하지 않습니다.", id));
        }

        ResultData loginedMemberCanModifyRd = commentService.userCanModify(rq.getLoginedMemberId(), comment);

        if (loginedMemberCanModifyRd.isSuccess()) {
            commentService.modifyComment(id, body);
        }

        comment = commentService.getComment(id);

        return comment.getBody();
    }


    @RequestMapping(value = "usr/comment/doWrite", method = RequestMethod.POST)
    @ResponseBody
    public ResultData<?> doWrite(HttpServletRequest req, String relTypeCode, int relId, String body, Integer parentId) {
        Rq rq = (Rq) req.getAttribute("rq");

        if (Ut.isEmptyOrNull(body)) {
            return ResultData.from("F-2", "내용을 입력해주세요");
        }

        ResultData writeCommentRd = commentService.writeComment(
                rq.getLoginedMemberId(),
                body,
                relTypeCode,
                relId,
                parentId
        );

        int id = (int) writeCommentRd.getData1();
        Comment comment = commentService.getComment(id); // 새로 추가된 댓글 가져오기

        Map<String, Object> data = new HashMap<>();
        data.put("comment", comment);

        return ResultData.from(writeCommentRd.getResultCode(), writeCommentRd.getMsg(), data);
    }

    @RequestMapping(value = "/usr/comment/doDelete", method = RequestMethod.GET)
    public String doDelete(@RequestParam int id, @RequestParam int postId, HttpServletRequest req) {
        Rq rq = (Rq) req.getAttribute("rq");
        Comment comment = commentService.getComment(id);

        if (comment == null) {
            // 댓글 없으면 글 상세페이지로
            return "redirect:/usr/post/detail?id=" + postId;
        }

        if (comment.getMemberId() != rq.getLoginedMemberId()) {
            return "redirect:/usr/post/detail?id=" + comment.getRelId();
        }

        commentService.deleteComment(id);

        return "redirect:/usr/post/detail?id=" + comment.getRelId();
    }

}