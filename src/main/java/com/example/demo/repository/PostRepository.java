package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.vo.Post;

import java.util.List;

@Mapper
public interface PostRepository {

    public int writePost(int memberId, String title, String body);

    public void deletePost(int id);

    public void modifyPost(int id, String title, String body);

    public Post getPostById(int id);

    public List<Post> getPosts();

    public int getLastInsertId();

    public Post getForPrintPost(int loginedMemberId);
}