package com.example.demo.repository;

import com.example.demo.vo.Qualification;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface QualificationRepository {
    List<Qualification> findAll();
    Qualification findById(int id);
}
