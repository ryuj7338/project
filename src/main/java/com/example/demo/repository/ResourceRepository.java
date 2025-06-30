package com.example.demo.repository;

import com.example.demo.vo.Resource;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.data.repository.query.Param;

import java.util.List;

@Mapper
public interface ResourceRepository {

    void insertResource(Resource resource);

    void updateResource(Resource resource);

    void deleteResource(int id);

    Resource getById(int id);

    List<Resource> getListByPostId(int postId);

    boolean existsBySavedNameContains(String savedName);

    List<Resource> getByPostId(int postId); // postId로 첨부파일 조회 (상세페이지용)

    List<Resource> findByPostIdAndAuto(@Param("postId") int postId, @Param("auto") boolean auto);

    boolean existsBySavedNameAndAuto(String savedName, boolean auto);

    List<Resource> findRecent(int limit);
}