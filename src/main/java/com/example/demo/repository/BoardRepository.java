package com.example.demo.repository;

import com.example.demo.vo.Board;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardRepository {

    public Board getBoardById(int id);
}
