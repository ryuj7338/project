package org.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;
import org.example.demo.vo.Post;

import java.util.List;

@Mapper
public interface PostRepository {

    public int writePost(String title, String body);

    public void deletePost(int id);

    public void modifyPost(int id, String title, String body);

    public Post getPostById(int id);

    public List<Post> getPosts();

}