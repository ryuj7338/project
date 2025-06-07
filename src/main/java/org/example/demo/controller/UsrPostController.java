package org.example.demo.controller;

import org.example.demo.service.PostService;
import org.example.demo.util.Ut;
import org.example.demo.vo.Post;
import org.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class UsrPostController {

    @Autowired
    private PostService postService;


    @RequestMapping("/usr/post/doModify")
    @ResponseBody
    public ResultData doModify(int id, String title, String body) {

        Post post = postService.getPostById(id);

        if(post == null) {
            return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        postService.modifyPost(id, title, body);

        return ResultData.from("S-1", Ut.f("%d번 글이 수정되었습니다.", id), post);
    }

    @RequestMapping("/usr/post/doDelete")
    @ResponseBody
    public ResultData doDelete(int id) {

        Post post = postService.getPostById(id);

        if(post == null) {
            return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다.", id));
        }

        postService.deletePost(id);

        return ResultData.from("S-1", Ut.f("%d번 글이 삭제되었습니다.", id));
    }

    @RequestMapping("/usr/post/doWrite")
    @ResponseBody
    public ResultData<List<Post>> doWrite(String title, String body) {

        if(Ut.isEmptyOrNull(title)){
            return ResultData.from("F-1", "제목을 입력하세요");
        }

        if(Ut.isEmptyOrNull(body)){
            return ResultData.from("F-2", "내용을 입력하세요");
        }

        ResultData doWriteRd = postService.writePost(title, body);

        int id = (int) doWriteRd.getData1();

        Post post = postService.getPostById(id);

        return ResultData.from(doWriteRd.getResultCode(), doWriteRd.getMsg(), post);
    }

    @RequestMapping("/usr/post/getPost")
    @ResponseBody
    public ResultData<List<Post>> getPost(int id) {

        Post post = postService.getPostById(id);

        if(post == null) {
            return ResultData.from("F-1", Ut.f("%d번 게시글은 없습니다."), id);
        }

        return ResultData.from("S-1", Ut.f("%d번 게시글입니다.", id));
    }

    @RequestMapping("/usr/post/getPosts")
    @ResponseBody
    public ResultData<List<Post>> getPosts() {

        List<Post> posts = postService.getPosts();

        return ResultData.from("S-1", "Post List", posts);
    }
}