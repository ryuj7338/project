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
import org.springframework.web.bind.annotation.PostMapping;
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
    public ResultData doLike(String relTypeCode, int relId, String replaceUri){

        ResultData usersReactionRd = reactionService.usersReaction(rq.getLoginedMemberId(), relTypeCode, relId);

        int usersReaction = (int) usersReactionRd.getData1();

        if(usersReaction == 1){
            ResultData rd = reactionService.deleteLikeReaction(rq.getLoginedMemberId(), relTypeCode, relId);

            int like = postService.getLike(relId);

            return ResultData.from("S-1", "좋아요 취소", "like", like);
        }

        ResultData reactionRd = reactionService.addLikeReaction(rq.getLoginedMemberId(), relTypeCode, relId);

        if(reactionRd.isFail()){
            return ResultData.from(reactionRd.getResultCode(), reactionRd.getMsg());
        }

        int like = postService.getLike(relId);
        return ResultData.from(reactionRd.getResultCode(), reactionRd.getMsg(), "like", like);
    }

    @PostMapping("/toggle")
    @ResponseBody
    public ResultData<?> toggleReaction(HttpServletRequest req, String relTypeCode, int relId) {
        Rq rq = (Rq) req.getAttribute("rq");

        return reactionService.toggleReaction(rq.getLoginedMemberId(), relTypeCode, relId);
    }

}
