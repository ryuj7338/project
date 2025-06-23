package com.example.demo.controller;


import com.example.demo.service.PostService;
import com.example.demo.service.ReactionService;
import com.example.demo.util.Ut;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UsrReactionController {

    @Autowired
    private Rq rq;

    @Autowired
    private ReactionService reactionService;

    @Autowired
    private PostService postService;

    @RequestMapping("/usr/reaction/doLike")
    @ResponseBody
    public ResultData<?> doLike(String relTypeCode, int relId) {
        if (!rq.isLogined()) {
            String redirectUrl = "/usr/member/login?redirectUrl=" + rq.getCurrentUri();
            return ResultData.from("F-L", "로그인이 필요합니다.", "redirectUrl", redirectUrl);
        }

        int memberId = rq.getLoginedMemberId();
        ResultData usersReactionRd = reactionService.usersReaction(memberId, relTypeCode, relId);
        int usersReaction = (int) usersReactionRd.getData1();

        if (usersReaction == 1) {
            ResultData<?> rd = reactionService.deleteLikeReaction(memberId, relTypeCode, relId);
            int like = postService.getLike(relId);
            // ✅ data1: like, data2: isLiked = false
            return ResultData.from(rd.getResultCode(), rd.getMsg(), "like", like, "isLiked", false);
        }

        ResultData<?> reactionRd = reactionService.addLikeReaction(memberId, relTypeCode, relId);
        if (reactionRd.isFail()) {
            return reactionRd;
        }

        int like = postService.getLike(relId);
        // ✅ data1: like, data2: isLiked = true
        return ResultData.from(reactionRd.getResultCode(), reactionRd.getMsg(), "like", like, "isLiked", true);
    }
}