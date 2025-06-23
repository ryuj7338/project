package com.example.demo.service;

import com.example.demo.repository.PostRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.FileInfo;
import com.example.demo.vo.Post;
import com.example.demo.vo.ResultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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

    public List<FileInfo> extractFileInfos(String body) {
        List<FileInfo> list = new ArrayList<>();
        if (body == null || body.isBlank()) return list;

        String[] lines = body.split("<br\\s*?>");
        for (String line : lines) {
            if (!line.contains("/uploadFiles/") || !line.contains("href='")) continue;

            try {
                int hrefStart = line.indexOf("href='") + 6;
                int hrefEnd = line.indexOf("'", hrefStart);
                if (hrefEnd <= hrefStart) continue;

                String path = line.substring(hrefStart, hrefEnd);
                String name = path.substring(path.lastIndexOf("/") + 1);

                System.out.println(">>>> href 추출: " + path);
                System.out.println(">>>> 파일명 추출 전: " + path.substring(path.lastIndexOf("/") + 1));
                // 허용 확장자
                String ext = name.substring(name.lastIndexOf(".") + 1).toLowerCase();
                List<String> allowed = List.of("pdf", "hwp", "pptx", "xlsx", "jpg", "jpeg", "png", "gif");

                if (!allowed.contains(ext)) continue;

                list.add(new FileInfo(name, path));
            } catch (Exception e) {

            }
        }
        return list;
    }

    public void write(Post post) {
        postRepository.write(post);
    }

    public void update(Post post) {
        postRepository.update(post);
    }


    public List<String> getAutocompleteSuggestions(String keyword) {
        // DB 쿼리 호출해서 title 컬럼에서 부분 일치하는 제목 최대 10개 반환
        return postRepository.findTitlesByKeyword(keyword);
    }

}

