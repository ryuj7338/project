package com.example.demo.controller;

import com.example.demo.vo.Rq;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import com.example.demo.service.PostService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Post;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class UsrPostController {

    @Autowired
    private PostService postService;


    @RequestMapping("/usr/post/modify")
    public String showModify(){
        return "/usr/post/modify";
    }

    @RequestMapping("/usr/post/doModify")
    @ResponseBody
    public ResultData doModify(HttpServletRequest req, int id, String title, String body) {

        Rq rq = (Rq) req.getAttribute("rq");

        Post post = postService.getPostById(id);

        if (post == null) {
            return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다.", id), "없는 글의 id", id);
        }

        ResultData userCanModifyRd = postService.userCanModify(rq.getLoginedMemberId(), post);

        if(userCanModifyRd.isFail()){
            return userCanModifyRd;
        }
        if(userCanModifyRd.isSuccess()){
            postService.modifyPost(id, title, body);
        }

        post = postService.getPostById(id);

        return ResultData.from(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg(), "수정된 글", post);
    }

    @RequestMapping("/usr/post/doDelete")
    @ResponseBody
    public String doDelete(HttpServletRequest req, int id) {

        Rq rq = (Rq) req.getAttribute("rq");

        Post post = postService.getPostById(id);

        if (post == null) {
            return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        ResultData userCanDeleteRd = postService.userCanDelete(rq.getLoginedMemberId(), post);

        if(userCanDeleteRd.isFail()){
            return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
        }

        if(userCanDeleteRd.isSuccess()){
            postService.deletePost(id);
        }

        postService.deletePost(id);

        return Ut.jsReplace(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg(), "../post/list");
    }

    @RequestMapping("/usr/post/doWrite")
    @ResponseBody
    public ResultData doWrite(HttpServletRequest req, String title, String body) {

        Rq rq = (Rq) req.getAttribute("rq");

        if (Ut.isEmptyOrNull(title)) {
            return ResultData.from("F-1", "제목을 입력하세요");
        }

        if (Ut.isEmptyOrNull(body)) {
            return ResultData.from("F-2", "내용을 입력하세요");
        }

        ResultData doWriteRd = postService.writePost(rq.getLoginedMemberId(), title, body);

        int id = (int) doWriteRd.getData1();

        Post post = postService.getPostById(id);

        return ResultData.newData(doWriteRd, "새로 작성된 게시글", post);
    }


    @RequestMapping("/usr/post/detail")
    @ResponseBody
    public String showDetail(HttpServletRequest req, Model model, int id) {

        Rq rq = (Rq) req.getAttribute("rq");

        Post post = postService.getForPrintPost(rq.getLoginedMemberId(), id);

        model.addAttribute("post", post);

        return "/usr/post/detail";
    }

    @RequestMapping("/usr/post/list")
    @ResponseBody
    public String showList(Model model) {

        List<Post> posts = postService.getPosts();

        model.addAttribute("posts", posts);

        return "/usr/post/list";
    }
}