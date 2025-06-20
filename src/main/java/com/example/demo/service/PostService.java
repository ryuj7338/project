package com.example.demo.service;

import com.example.demo.repository.PostRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Post;
import com.example.demo.vo.ResultData;
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

    public ResultData writePost(int memberId, int boardId, String title, String body) {

        postRepository.writePost(memberId, boardId, title, body);

        int id = postRepository.getLastInsertId();

        return ResultData.from("S-1", Ut.f("%d번 글이 등록되었습니다.", id), "등록된 게시글 id",  id);
    }

    public Post getPostById(int id) {
        return postRepository.getPostById(id);
    }

    public List<Post> getPosts() {
        return postRepository.getPosts();
    }

    public List<Post> getForPosts(int boardId, int itemsInAPage, int page, String searchKeyword, String searchType) {

        int limitFrom = (page - 1) * itemsInAPage;
        int limitTake = itemsInAPage;

        return postRepository.getForPosts(boardId, limitFrom, limitTake, searchKeyword, searchType);
    }

    public int getPostCount(int boardId, String searchKeyword, String searchType) {
        return postRepository.getPostCount(boardId, searchKeyword, searchType);
    }

    public ResultData userCanModify(int loginedMemberId, Post post) {

        if(post.getMemberId() != loginedMemberId) {
            return ResultData.from("F-A", Ut.f("%d번 게시글에 대한 권한이 없습니다.", post.getId()));
        }

        return ResultData.from("S-1", Ut.f("%d번 게시글을 수정하였습니다.", post.getId()));
    }

    public ResultData userCanDelete(int loginedMemberId, Post post) {

        if(post.getMemberId() != loginedMemberId) {
            return ResultData.from("F-A", Ut.f("%d번 게시글에 대한 삭제 권한이 없습니다.", post.getId()));
        }

        return ResultData.from("S-1", Ut.f("%d번 게시글이 삭제되었습니다.", post.getId()));
    }

    public Post getForPrintPost(int loginedMemberId, int id) {

        Post post = postRepository.getForPrintPost(id);

        controlForPrintData(loginedMemberId, post);

        return post;
    }

    private void controlForPrintData(int loginedMemberId, Post post) {

        if(post == null) {
            return;
        }

        ResultData userCanModifyRd = userCanModify(loginedMemberId, post);
        post.setUserCanModify(userCanModifyRd.isSuccess());
        ResultData userDeleteRd = userCanDelete(loginedMemberId, post);
        post.setUserCanDelete(userDeleteRd.isSuccess());
    }

    public ResultData increaseHitCount(int id) {

        int affectedRow = postRepository.increaseHitCount(id);

        System.out.println(affectedRow);
        if(affectedRow == 0) {
            return ResultData.from("F-1", "해당 게시글은 없습니다.", "id", id);
        }

        return ResultData.from("S-1", "조회수 증가", "id", id);
    }

    public Object getPostHitCount(int id) {

        return postRepository.getPostHitCount(id);
    }

    public ResultData increaseLikeReaction(int relId) {

        int affectedRow = postRepository.increaseLikeReaction(relId);

        if(affectedRow == 0) {
            return ResultData.from("F-1", "없는 게시물입니다.");
        }

        return ResultData.from("S-1", "좋아요 증가", "affectedRow", affectedRow);
    }

    public ResultData decreaseLikeReaction(int relId) {

        int affectedRow = postRepository.decreaseLikeReaction(relId);

        if(affectedRow == 0) {
            return ResultData.from("F-1", "없는 게시물입니다.");
        }

        return ResultData.from("S-1", "좋아요 감소", "affectedRow", affectedRow);
    }

    public int getLike(int relId) {
        return postRepository.getLike(relId);
    }

    public boolean existsByTitle(String title) {
        return postRepository.existsByTitle(title);
    }

    public void write(int boardId, String nickname, int memberId, String title, String body) {
        Post post = new Post();
        post.setBoardId(boardId);
        post.setExtra__writer(nickname);
        post.setMemberId(memberId);
        post.setTitle(title);
        post.setBody(body);
        postRepository.savePost(post);
    }

    public List<Post> getPostsByBoardId(int boardId) {
        return postRepository.getPostsByBoardId(boardId);
    }
}

