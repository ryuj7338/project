package org.example.demo.service;

import org.example.demo.repository.PostRepository;
import org.example.demo.util.Ut;
import org.example.demo.vo.Post;
import org.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    public PostService (PostRepository postRepository) {
        this.postRepository = postRepository;

    }


    public void modifyPost(int id, String title, String body) {
        postRepository.modifyPost(id, title, body);
    }

    public void deletePost(int id) {
        postRepository.deletePost(id);
    }

    public ResultData writePost(int memberId, String title, String body) {

        postRepository.writePost(memberId, title, body);

        int id = postRepository.getLastInsertId();

        return ResultData.from("S-1", Ut.f("%d번 글이 등록되었습니다.", id), "등록된 게시글 id",  id);
    }

    public Post getPostById(int id) {
        return postRepository.getPostById(id);
    }

    public List<Post> getPosts() {
        return postRepository.getPosts();
    }

    public ResultData loginedMemberCanModify(int loginedMemberId, Post post) {

        if(post.getMemberId() != loginedMemberId) {
            return ResultData.from("F-A", Ut.f("%d번 게시글에 대한 권한이 없습니다.", post.getId()));
        }
        return ResultData.from("S-1", Ut.f("%d번 게시글을 수정하였습니다.", post.getId()));
    }
}

