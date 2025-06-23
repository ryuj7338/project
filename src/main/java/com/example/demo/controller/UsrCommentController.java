package com.example.demo.controller;

import com.example.demo.vo.LikeResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ReactionService;
import com.example.demo.service.CommentService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Comment;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

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


    @RequestMapping("usr/comment/doWrite")
    @ResponseBody
    public String doWrite(HttpServletRequest req, String relTypeCode, int relId, String body) {

        Rq re = (Rq) req.getAttribute("rq");

        if (Ut.isEmptyOrNull(body)) {
            return Ut.jsHistoryBack("F-2", "내용을 입력해주세요");
        }

        ResultData writeCommentRd = commentService.writeComment(rq.getLoginedMemberId(), body, relTypeCode, relId);

        int id = (int) writeCommentRd.getData1();

        return Ut.jsReplace(writeCommentRd.getResultCode(), writeCommentRd.getMsg(), "../post/detail?id=" + relId);
    }

    @RequestMapping("/usr/comment/toggleLike")
    @ResponseBody
    public ResultData<?> toggleCommentLike(HttpServletRequest req, @RequestParam int relId) {
        Rq rq = (Rq) req.getAttribute("rq");

        if (rq.isLogout()) {
            return ResultData.from("F-1", "로그인이 필요합니다.");
        }

        int memberId = rq.getLoginedMemberId();
        String relTypeCode = "comment";

        boolean alreadyLiked = reactionService.isAlreadyAddLikeRp(memberId, relId, relTypeCode);

        if (alreadyLiked) {
            reactionService.deleteLikeReaction(memberId, relTypeCode, relId);
            int likeCount = reactionService.getReactionPoint(relTypeCode, relId); // 변경된 like 수
            return ResultData.from("S-2", "좋아요 취소됨", "data1", new LikeResult(likeCount, false));
        }

        reactionService.addLikeReaction(memberId, relTypeCode, relId);
        int likeCount = reactionService.getReactionPoint(relTypeCode, relId); // 변경된 like 수
        return ResultData.from("S-1", "좋아요 됨", "data1", new LikeResult(likeCount, true));
    }

}