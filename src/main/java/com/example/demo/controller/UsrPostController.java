package com.example.demo.controller;

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


    @RequestMapping("/usr/post/doModify")
    @ResponseBody
    public ResultData doModify(HttpSession session, int id, String title, String body) {

        boolean isLogined = false;
        int loginedMemberId = 0;

        if (session.getAttribute("loginedMemberId") != null) {
            isLogined = true;
            loginedMemberId = (int) session.getAttribute("loginedMemberId");
        }

        Post post = postService.getPostById(id);

        if (post == null) {
            return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        ResultData loginedMemberCanModifyRd = postService.loginedMemberCanModify(loginedMemberId, post);

        postService.modifyPost(id, title, body);

        post = postService.getPostById(id);

        return ResultData.from(loginedMemberCanModifyRd.getResultCode(), loginedMemberCanModifyRd.getMsg(), "수정된 글", post);
    }

    @RequestMapping("/usr/post/doDelete")
    @ResponseBody
    public ResultData doDelete(HttpSession session, int id) {

        boolean isLogined = false;
        int loginedMemberId = 0;

        if (session.getAttribute("loginedMemberId") != null) {
            isLogined = true;
            loginedMemberId = (int) session.getAttribute("loginedMemberId");
        }

        Post post = postService.getPostById(id);

        if (post == null) {
            return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        if (post.getMemberId() != loginedMemberId) {
            return ResultData.from("F-A", "권한이 없습니다.");
        }

        postService.deletePost(id);

        return ResultData.from("S-1", Ut.f("%d번 글이 삭제되었습니다.", id));
    }

    @RequestMapping("/usr/post/doWrite")
    @ResponseBody
    public ResultData doWrite(HttpSession session, String title, String body) {

        boolean isLogined = false;
        int loginedMemberId = 0;

        if (session.getAttribute("loginedMemberId") != null) {
            isLogined = true;
            loginedMemberId = (int) session.getAttribute("loginedMemberId");
        }

        if (isLogined == false) {
            return ResultData.from("F-A", "로그인이 필요합니다.");
        }

        if (Ut.isEmptyOrNull(title)) {
            return ResultData.from("F-1", "제목을 입력하세요");
        }

        if (Ut.isEmptyOrNull(body)) {
            return ResultData.from("F-2", "내용을 입력하세요");
        }

        ResultData doWriteRd = postService.writePost(loginedMemberId, title, body);

        int id = (int) doWriteRd.getData1();

        Post post = postService.getPostById(id);

        return ResultData.newData(doWriteRd, "새로 작성된 게시글", post);
    }

    @RequestMapping("/usr/post/detail")
    @ResponseBody
    public String showDetail(Model model, int id) {

        Post post = postService.getPostById(id);

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