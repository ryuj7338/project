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
        testData();
    }

    private void testData() {

        for(int i = 1; i <= 10; i++) {
            String title = "제목" + i;
            String body = "내용" + i;

            postRepository.writePost(title, body);
        }
    }

    public void modifyPost(int id, String title, String body) {
        postRepository.modifyPost(id, title, body);
    }

    public void deletePost(int id) {
        postRepository.deletePost(id);
    }

    public ResultData writePost(String title, String body) {

        postRepository.writePost(title, body);

        int id = postRepository.getLastInsertId();

        return ResultData.from("S-1", Ut.f("%d번 글이 등록되었습니다.", id), id);
    }

    public Post getPostById(int id) {
        return postRepository.getPostById(id);
    }

    public List<Post> getPosts() {
        return postRepository.getPosts();
    }
}

