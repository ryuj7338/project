package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.vo.Post;

import java.util.List;

@Mapper
public interface PostRepository {

    int writePost(int memberId, String title, String body);

    void deletePost(int id);

    void modifyPost(int id, String title, String body);

    Post getPostById(int id);

    List<Post> getPosts();

    int getLastInsertId();

    Post getForPrintPost(int loginedMemberId);

    List<Post> getForPrintPosts(int boardId, int limitFrom, int limitTake);

    int getPostCount(int boardId, String searchKeyword, String searchType);

<<<<<<< HEAD
    List<Post> getForPosts(int boardId, int limitFrom, int limitTake, String searchKeyword, String searchType);
=======
    public List<Post> getForPosts(int boardId, int limitFrom, int limitTake, String searchKeyword, String searchType);
>>>>>>> 210cdef7314d3c6ed949a19fd8ed1f51df322a8c

    int increaseHitCount(int id);

    int getPostHitCount(int id);

    int increaseLikeReaction(int relId);
    int decreaseLikeReaction(int relId);

    int getLike(int relId);
}
