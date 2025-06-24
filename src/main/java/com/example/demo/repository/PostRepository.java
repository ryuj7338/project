package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;
import com.example.demo.vo.Post;

import java.util.List;

@Mapper
public interface PostRepository {

    int writePost(int memberId, int boardId, String title, String body);

    void deletePost(int id);

    void modifyPost(int id, String title, String body);

    Post getPostById(int id);

    List<Post> getPosts();

    int getLastInsertId();

    Post getForPrintPost(int loginedMemberId);

    List<Post> getForPrintPosts(int boardId, int limitFrom, int limitTake);

    int getPostCount(int boardId, String searchKeyword, String searchType);

    List<Post> getForPosts(int boardId, int limitFrom, int limitTake, String searchKeyword, String searchType);

    int increaseHitCount(int id);

    int getPostHitCount(int id);

    int increaseLikeReaction(int relId);
    int decreaseLikeReaction(int relId);

    int getLike(int relId);

    boolean existsByTitle(String title);

    void savePost(Post post);

    List<Post> getPostsByBoardId(int boardId);

    void write(Post post);

    void update(Post post);


    List<String> findTitlesByKeyword(String keyword);

    List<Post> findByTitleContainingAndBoardId(String keyword, Integer boardId);

    List<Post> findByTitleContaining(String keyword);
}

