package org.example.demo.controller;

import org.example.demo.service.PostService;
import org.example.demo.vo.Post;
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
    public Object doModify(int id, String title, String body) {

        Post post = postService.getPostById(id);

        if(post == null) {
            return id + "번 글은 없습니다.";
        }

        postService.modifyPost(id, title, body);

        return post;
    }

    @RequestMapping("/usr/post/doDelete")
    @ResponseBody
    public String doDelete(int id) {

        Post post = postService.getPostById(id);

        if(post == null) {
            return id + "번 글은 없습니다.";
        }

        postService.deletePost(id);

        return id + "번 글이 삭제되었습니다.";
    }

    @RequestMapping("/usr/post/doWrite")
    @ResponseBody
    public Post doWrite(String title, String body) {
        return postService.writePost(title, body);
    }

    @RequestMapping("/usr/post/getPost")
    @ResponseBody
    public Object getPost(int id) {

        Post post = postService.getPostById(id);

        if(post == null) {
            return id + "번 글은 없습니다.";
        }

        return post;
    }

    @RequestMapping("/usr/post/getPosts")
    @ResponseBody
    public List<Post> getPosts() {

        return postService.getPosts();
    }
}