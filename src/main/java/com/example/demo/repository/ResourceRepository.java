package com.example.demo.repository;

import com.example.demo.vo.Resource;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ResourceRepository {

    void insertResource(Resource resource);

    void updateResource(Resource resource);

    void deleteResource(int id);

    Resource getById(int id);

    List<Resource> getListByBoardId(int boardId);

    List<Resource> getListByPostId(int postId);

    Resource getByPostId(int postId); // postId로 첨부파일 조회 (상세페이지용)

    int countBySavedName(String savedName);

    void save(Resource resource);
}
