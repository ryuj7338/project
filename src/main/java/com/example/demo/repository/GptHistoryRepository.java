package com.example.demo.repository;


import com.example.demo.vo.GptHistory;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.data.repository.query.Param;

import java.util.List;

@Mapper
public interface GptHistoryRepository {
    List<GptHistory> getByMemberIdAndCategory(@Param("memberId") int memberId, @Param("category") String category);

    void save(GptHistory history);
}


