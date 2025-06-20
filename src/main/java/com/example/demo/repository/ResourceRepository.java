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
}
